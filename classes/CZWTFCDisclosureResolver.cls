global inherited sharing class CZWTFCDisclosureResolver extends tffa.DisclosureResolver {
  static Map<String, String> documentMap {
    get {
      if (documentMap == null) {
        documentMap = new Map<String, String>();
        documentMap.put('TISD', 'Disclosures_TISD');
      }
      return documentMap;
    }
    private set;
  }

  /***
   *
   */
  global override List<tffa__Disclosure__c> resolve(Map<String, Object> facts) {
    tffa.Interaction.begin(CZWTFCDisclosureResolver.class, 'resolve');
    List<tffa__Disclosure__c> retStip = new List<tffa__Disclosure__c>();
    List<tffa__Disclosure__c> sortedDisclosure = new List<tffa__Disclosure__c>();
    try {
      String submissionId = (String) facts.get('Submission__c');
      String eventName = '';
      Boolean isApptracker = true;

      if (tffa.Context.get().eventName != null) {
        eventName = tffa.Context.get().eventName;
      }

      if (!facts.containsKey('Source') || facts.get('Source') == null || facts.get('Source') == '') {
        isApptracker = false;
      }
      if (String.isNotBlank(eventName) && eventName.equalsIgnoreCase('Submission_ReviewAndSubmit') && !isApptracker) {
        List<tffa__Disclosure__c> deleteDisclsoure = CZWTFCSubmissionRepository.getReviewSubmitDisclosures(submissionId);
        CZWTFCSubmissionRepository.deleteRecords(deleteDisclsoure);
      }

      if (String.isNotBlank(eventName) && eventName.equalsIgnoreCase('AccountDetails_OD') && !isApptracker) {
        List<tffa__Disclosure__c> deleteDisclsoure = CZWTFCSubmissionRepository.getAccountDetailsOdDisclosures(submissionId);
        CZWTFCSubmissionRepository.deleteRecords(deleteDisclsoure);
      }

      facts.put('EventName__c', tffa.Context.get().eventName);

      return doResolve(facts);
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
    return retStip;
  }

  /**
   * Resolves Disclosure(s) for the current submission. Additional filter criterias can be passed
   * to resolve list of add on services in case of custom implementation.
   */
  public List<tffa__Disclosure__c> doResolve(Map<String, Object> facts) {
    tffa.Interaction.begin(CZWTFCDisclosureResolver.class, 'doResolve');
    try {
      List<tffa__Disclosure__c> disclosures = new List<tffa__Disclosure__c>();
      String partyId;
      String eventName = tffa.Context.get().eventName;
      String subId = (String) facts.get('Submission__c');
      if (facts.containsKey('Party__c')) {
        partyId = (String) facts.get('Party__c');
      } else {
        partyId = tffa.Context.get().partyId;
      }

      if (partyId != null && !String.isEmpty(partyId) && subId != null) {
        tffa__SubmissionPartyXref__c xref = CZWTFCSubmissionRepository.findbySubmissionAndParty(subId, partyId);
        if (xref == null) {
          throw new tffa.ApplicationException('SUBMISSION_NOT_FOUND');
        }
        if (!xref.tffa__IsPresent__c && !xref.tffa__Primary__c) {
          disclosures = resolveForParty(subId, partyId, facts);
        } else {
          disclosures = resolveForSubmission(subId, facts);
        }
      } else if (subId != null) {
        disclosures = resolveForSubmission(subId, facts);
      }
      return disclosures;
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Attempts to resolve disclosures for submission party pair, based on current data including any event.
   * All resolved disclosures are persisted.
   */
  public static List<tffa__Disclosure__c> resolveForSubmission(String subId, Map<String, Object> facts) {
    List<tffa__Disclosure__c> disclosures = new List<tffa__Disclosure__c>();
    String appId = (String) facts.get('Application__c');
    String partyId = (String) facts.get('Party__c');
    String entityType = (String) facts.get('EntityType__c');

    Map<String, Object> queryParams = new Map<String, Object>();
    queryParams.put('Submission__c', subId);
    queryParams.put('EventName__c', tffa.Context.get().eventName);
    if (partyId != null) {
      queryParams.put('Party__c', partyId);
    }
    if (appId != null) {
      queryParams.put('LinkedApplication__c', appId);
    }
    if (entityType != null) {
      queryParams.put('EntityType__c', entityType);
    }

    disclosures = CZWTFCHelperRepository.findAll(new tffa.QueryContext(queryParams));
    if (!disclosures.isEmpty()) {
      tffa.Logger.fine('pre resolved disclosures ::::', disclosures.size());
      return disclosures;
    }

    tffa__Submission__c sub = CZWTFCHelperRepository.fetchDataForDisclosures(subId);
    if (sub == null) {
      throw new tffa.ApplicationException('SUBMISSION_NOT_FOUND');
    }

    if (!sub.tffa__Applications__r.isEmpty() && sub.tffa__NumberOfParties__c > 0) {
      if (appId != null) {
        tffa__Application__c app = tffa.ApplicationService.readWithParties(appId);
        for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
          disclosures.addAll(resolveFor(sub, apx.tffa__Party__r, app, facts));
        }
      } else {
        if (partyId != null) {
          tffa__Party__c party = CZWTFCPartyRepository.findByIdWithChildObjects(partyId);
          for (tffa__Application__c app : sub.tffa__Applications__r) {
            disclosures.addAll(resolveFor(sub, party, app, facts));
          }
        } else {
          for (tffa__Application__c app : sub.tffa__Applications__r) {
            app = tffa.ApplicationService.readWithParties(app.Id);
            for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
              disclosures.addAll(resolveFor(sub, apx.tffa__Party__r, app, apx, facts));
            }
          }
        }
      }
    } else {
      disclosures.addAll(resolveFor(sub, facts));
    }
    if (!disclosures.isEmpty()) {
      disclosures = CZWTFCHelperRepository.save(mergeDisclosures(disclosures));
    }

    return sort(disclosures);
  }

  /**
   * Merges all disclosure records resolved based on different facts and returns a unique list of disclosures
     based on distinct Code__c value
   * @param disclosureList
   * @returns List
   */
  public static List<tffa__Disclosure__c> mergeDisclosures(List<tffa__Disclosure__c> disclosureList) {
    Map<String, tffa__Disclosure__c> discMap = new Map<String, tffa__Disclosure__c>();
    for (tffa__Disclosure__c d : disclosureList) {
      if (discMap.get(d.tffa__Code__c) == null) {
        discMap.put(d.tffa__Code__c, d);
      }
    }
    return discMap.values();
  }

  /**
   * Resolves disclosures for sub and application party xref
   */
  public static List<tffa__Disclosure__c> resolveFor(
    tffa__Submission__c sub,
    tffa__Party__c p,
    tffa__Application__c app,
    tffa__ApplicationPartyXref__c apx,
    Map<String, Object> inputFacts
  ) {
    String eventName = tffa.Context.get().eventName;
    String roleCode = apx.tffa__RoleCode__c;

    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();

    // build facts
    Map<String, Object> facts = new Map<String, Object>{
      'Channel__c' => sub.tffa__CreatedChannel__c,
      'EventName__c' => eventName,
      'PartyType__c' => p.tffa__Type__c,
      'ProductCategory__c' => app.tffa__ProductCategory__c,
      'Product__c' => app.tffa__Product__c,
      'AccountPurpose__c' => app.tffa__AccountPurpose__c,
      'EntityType__c' => (String) inputFacts.get('EntityType__c') != null ? (String) inputFacts.get('EntityType__c') : 'NA',
      'OrganizationType__c' => p.tffa__OrganizationType__c,
      'PromotionCode__c' => app.tffa__PromotionCode__c,
      'BundleCode__c' => sub.tffa__BundleCode__c,
      'PromotionCodeIs__c' => app.tffa__PromotionCode__c != null ? 'TRUE' : 'NULL',
      'PrequalIs__c' => app.tffa__Prequal__c ? 'TRUE' : 'NULL'
    };
    addFacts(facts, sub);
    addFacts(facts, p);
    tffa.Logger.fine('facts', facts);

    List<tffa__Disclosure__c> resolvedDisclosures = resolveForFacts(facts);

    if (resolvedDisclosures != null && !resolvedDisclosures.isEmpty()) {
      for (tffa__Disclosure__c d : resolvedDisclosures) {
        if (d.tffa__ApplicantRoleSet__c != null && roleCode != null) {
          if (!d.tffa__ApplicantRoleSet__c.contains(roleCode)) {
            continue;
          }
        }

        d.tffa__Submission__c = sub.Id;
        d.tffa__Party__c = fetchPrimaryParty(p, sub);
        d.tffa__LinkedApplication__c = app.Id;
        dl.add(d);
      }
    }

    return dl;
  }

  /**
   * Resolves disclosures for submission-party-application
   */
  public static List<tffa__Disclosure__c> resolveFor(
    tffa__Submission__c sub,
    tffa__Party__c p,
    tffa__Application__c app,
    Map<String, Object> inputFacts
  ) {
    String eventName = tffa.Context.get().eventName;

    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();

    // build facts
    Map<String, Object> facts = new Map<String, Object>{
      'Channel__c' => sub.tffa__CreatedChannel__c,
      'EventName__c' => eventName,
      'PartyType__c' => p.tffa__Type__c,
      'ProductCategory__c' => app.tffa__ProductCategory__c,
      'Product__c' => app.tffa__Product__c,
      'EntityType__c' => (String) inputFacts.get('EntityType__c') != null ? (String) inputFacts.get('EntityType__c') : 'NA',
      'OrganizationType__c' => p.tffa__OrganizationType__c,
      'PromotionCode__c' => app.tffa__PromotionCode__c,
      'BundleCode__c' => sub.tffa__BundleCode__c,
      'PromotionCodeIs__c' => app.tffa__PromotionCode__c != null ? 'TRUE' : 'NULL'
    };
    addFacts(facts, sub);
    addFacts(facts, p);
    tffa.Logger.fine('facts', facts);

    List<tffa__Disclosure__c> resolvedDisclosures = resolveForFacts(facts);

    if (resolvedDisclosures != null && !resolvedDisclosures.isEmpty()) {
      for (tffa__Disclosure__c d : resolvedDisclosures) {
        d.tffa__Submission__c = sub.Id;
        d.tffa__Party__c = fetchPrimaryParty(p, sub);
        d.tffa__LinkedApplication__c = app.Id;
        dl.add(d);
      }
    }

    return dl;
  }

  /**
   * Resolves disclosures for submission-facts
   */
  public static List<tffa__Disclosure__c> resolveFor(tffa__Submission__c sub, Map<String, Object> facts) {
    String eventName = tffa.Context.get().eventName;

    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();

    facts.put('Channel__c', sub.tffa__CreatedChannel__c);
    facts.put('Locale__c', sub.tffa__Locale__c);
    facts.put('EventName__c', eventName);
    addFacts(facts, sub);
    tffa.Logger.fine('facts', facts);

    dl = resolveForFacts(facts);

    if (dl != null && !dl.isEmpty()) {
      for (tffa__Disclosure__c d : dl) {
        d.tffa__Submission__c = sub.Id;
      }
    }

    return dl;
  }

  /**
   * Resolves disclosures for submission-facts
   */
  public static List<tffa__Disclosure__c> resolveForParty(String subId, String partyId, Map<String, Object> facts) {
    List<tffa__Disclosure__c> disclosures = new List<tffa__Disclosure__c>();
    String eventName = tffa.Context.get().eventName;
    tffa__Submission__c sub = CZWTFCHelperRepository.fetchDataForDisclosures(subId);
    if (sub == null) {
      throw new tffa.ApplicationException('SUBMISSION_NOT_FOUND');
    }

    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();

    facts.put('Channel__c', sub.tffa__CreatedChannel__c);
    facts.put('EventName__c', eventName);
    facts.put('PartyType__c', 'INDIVIDUAL');
    facts.put('EntityType__c', 'PARTY');
    facts.put('ApplicationPartyRole__c', 'JOINT_OWNER');
    addFacts(facts, sub);
    tffa.Logger.fine('facts', facts);

    if (!sub.tffa__Applications__r.isEmpty()) {
      for (tffa__Application__c app : sub.tffa__Applications__r) {
        dl = resolveForFacts(facts);
        if (dl != null && !dl.isEmpty()) {
          for (tffa__Disclosure__c d : dl) {
            d.tffa__Submission__c = sub.Id;
            d.tffa__Party__c = partyId;
            d.tffa__LinkedApplication__c = app.Id;
          }
          disclosures.addAll(dl);
        }
      }
      if (!disclosures.isEmpty()) {
        disclosures = CZWTFCHelperRepository.save(mergeDisclosures(disclosures));
      }
    }

    return sort(disclosures);
  }

  /**
   * Resolves disclosures for submission-facts
   */
  public static List<tffa__Disclosure__c> resolveForFacts(Map<String, Object> facts) {
    String entityType = (String) facts.get('EntityType__c');
    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();

    // resolve disclosure checklists
    tffa.Logger.fine('facts', facts);
    List<tffa__DisclosureChecklist__c> checklists = tffa.DisclosureChecklistService.resolveByFacts('Facts', facts);
    tffa.Logger.fine('checklist size', checklists.size());
    if (checklists.isEmpty()) {
      return dl;
    }

    for (tffa__DisclosureChecklist__c disclosureChecklist : checklists) {
      if (entityType != null && entityType == 'PARTY' && disclosureChecklist.tffa__EntityType__c != 'PARTY') {
        tffa.Logger.fine('skipping from checklist ::', disclosureChecklist.Name);
        continue;
      }
      tffa.Logger.fine('populating from checklist ::', disclosureChecklist.Name);
      for (tffa__DisclosureItem__c di : disclosureChecklist.tffa__Items__r) {
        tffa__Disclosure__c d = new tffa__Disclosure__c();
        d.Name = di.Name;
        d.tffa__Label__c = di.tffa__Label__c;
        d.tffa__ActionText__c = di.tffa__ActionText__c;
        d.tffa__Required__c = di.tffa__Required__c;
        d.tffa__EventName__c = (String) facts.get('EventName__c');
        d.tffa__SortOrder__c = di.tffa__SortOrder__c;
        d.tffa__Locale__c = disclosureChecklist.tffa__Locale__c;
        d.tffa__GroupCode__c = di.tffa__GroupCode__c;
        if (di.tffa__Template__r != null) {
          d.tffa__Type__c = di.tffa__Template__r.tffa__Type__c == null
            ? tffa.DisclosureType.TEXT.name()
            : di.tffa__Template__r.tffa__Type__c;
          d.tffa__Code__c = di.tffa__Template__r.tffa__Code__c;
          d.tffa__ExecutionRequired__c = di.tffa__Template__r.tffa__Type__c == tffa.DisclosureType.DOCUSIGN.name() ? true : false;
          d.tffa__Template__c = di.tffa__Template__r.tffa__Type__c == tffa.DisclosureType.DOCUSIGN.name()
            ? di.tffa__Template__r.tffa__Template__c
            : null;

          if (di.tffa__Template__r.tffa__DocumentName__c != null) {
            //update document name
            d.tffa__DocumentName__c = di.tffa__Template__r.tffa__DocumentName__c;
            if (di.tffa__Template__r.tffa__Type__c == tffa.DisclosureType.INTERNAL_CONTENT.name() && tffa.UserService.isGuestUser()) {
              d.tffa__DocumentUrl__c = fetchDocumentUrl(di.tffa__Template__r.tffa__DocumentName__c);
            }
          } else if (di.tffa__Template__r.tffa__Url__c != null) {
            d.tffa__DocumentUrl__c = di.tffa__Template__r.tffa__Url__c;
          }
          if (di.tffa__Template__r.tffa__ApplicantRoleSet__c != null) {
            d.tffa__ApplicantRoleSet__c = di.tffa__Template__r.tffa__ApplicantRoleSet__c;
          }
          if (di.tffa__Template__r.tffa__EntityType__c != null) {
            d.tffa__EntityType__c = di.tffa__Template__r.tffa__EntityType__c;
          }
        } else {
          d.tffa__Type__c = tffa.DisclosureType.TEXT.name();
          d.tffa__Code__c = di.Name;
        }
        dl.add(d);
      }
    }
    return dl;
  }

  /**
   * Fetches document url as identified in salesforce system
   *
   * @param Name of the document
   * @returns `String`
   */
  public static String fetchDocumentUrl(String documentName) {
    String disclosureUrl;
    Document d = tffa.DocumentService.readByName(documentName);
    if (documentMap.get(documentName) != null) {
      disclosureUrl = tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c + '/servlet/servlet.FileDownload?file=' + d.Id;
    }
    return disclosureUrl;
  }

  /**
   * Method to sort disclosures based on sort order
   * @param disclosures
   * @returns `List`
   */
  public static List<tffa__Disclosure__c> sort(List<tffa__Disclosure__c> disclosures) {
    if (disclosures != null && !disclosures.isEmpty()) {
      List<DisclosureWrapper> wrapperList = new List<DisclosureWrapper>();
      for (tffa__Disclosure__c d : disclosures) {
        wrapperList.add(new DisclosureWrapper(d));
      }
      wrapperList.sort();
      List<tffa__Disclosure__c> sortedDisclosures = new List<tffa__Disclosure__c>();
      for (DisclosureWrapper wrapper : wrapperList) {
        sortedDisclosures.add(wrapper.disclosure);
      }
      return sortedDisclosures;
    }
    return disclosures;
  }

  /**
   * Adds facts about the submission
   */
  public static void addFacts(Map<String, Object> facts, tffa__Submission__c sub) {
    if (sub.tffa__Brand__c != null) {
      facts.put('BrandCode__c', sub.tffa__Brand__c);
    }
  }

  /**
   * Wrapper class which implements comparable interface to process sorting of the records
   */
  public class DisclosureWrapper implements Comparable {
    public tffa__Disclosure__c disclosure;

    public DisclosureWrapper(tffa__Disclosure__c d) {
      disclosure = d;
    }

    public Integer compareTo(Object compareTo) {
      DisclosureWrapper compareToDisclosure = (DisclosureWrapper) compareTo;
      // The return value of 0 indicates that both elements are equal.
      Integer returnValue = 0;
      if (disclosure.tffa__SortOrder__c > compareToDisclosure.disclosure.tffa__SortOrder__c) {
        returnValue = 1;
      } else if (disclosure.tffa__SortOrder__c < compareToDisclosure.disclosure.tffa__SortOrder__c) {
        returnValue = -1;
      }
      return returnValue;
    }
  }

  /**
   * Fetch id of the primary party
   * @param party
   * @param sub
   * @returns `String`
   */
  public static String fetchPrimaryParty(tffa__Party__c party, tffa__Submission__c sub) {
    if (party.tffa__Type__c == 'INDIVIDUAL') {
      return party.Id;
    }
    String primaryPartyId;
    for (tffa__SubmissionPartyXref__c spx : sub.tffa__PartyXrefs__r) {
      if (spx.tffa__PrimaryContact__c) {
        primaryPartyId = spx.tffa__Party__c;
      }
    }
    return primaryPartyId;
  }

  /**
   * Adds facts about the party
   * @param facts
   * @param party
   */
  public static void addFacts(Map<String, Object> facts, tffa__Party__c party) {
    if (
      !party.tffa__AddressXrefs__r.isEmpty() &&
      party.tffa__AddressXrefs__r[0] != null &&
      party.tffa__AddressXrefs__r[0].tffa__Address__r != null
    ) {
      tffa__Address__c address = party.tffa__AddressXrefs__r[0].tffa__Address__r;
      facts.put('State__c', address.tffa__State__c);
    }
  }
}