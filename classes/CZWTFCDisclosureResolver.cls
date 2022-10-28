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

  public static Integer sortOrder = 1;
  public static Map<String, List<tffa__Disclosure__c>> addendumDiscMap = new Map<String, List<tffa__Disclosure__c>>();
  public static Map<String, tffa__DisclosureItem__c> discItemMap = new Map<String, tffa__DisclosureItem__c>();
  public static Map<String, Object> factsMap;
  public static List<tffa__Party__c> partyList;
  public static Map<Id, tffa__Party__c> partyMap;
  public static List<tffa__Application__c> appList;
  public static Boolean isDebitCardProduct = false;
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

      if (subId != null && eventName == 'Application_DocumentGeneration') {
        disclosures = resolveForBranchDocusign(subId, eventName, facts);
      } else if (partyId != null && !String.isEmpty(partyId) && subId != null) {
        tffa__SubmissionPartyXref__c xref = CZWTFCSubmissionRepository.findbySubmissionAndParty(subId, partyId);
        if (xref == null) {
          throw new tffa.ApplicationException('SUBMISSION_NOT_FOUND');
        }
        // if (!xref.tffa__IsPresent__c && !xref.tffa__Primary__c) {
        //   disclosures = resolveForParty(subId, partyId, facts);
        // } else {
        disclosures = resolveForSubmission(subId, facts);
        //}
      } else if (subId != null) {
        disclosures = resolveForSubmission(subId, facts);
      }
      return disclosures;
    } finally {
      tffa.Interaction.close();
    }
  }

  public static List<tffa__Disclosure__c> resolveForBranchDocusign(String subId, String eventName, Map<String, Object> facts) {
    tffa.Logger.debug('In resolveForBranchDocusign');

    tffa__Submission__c sub = CZWTFCSubmissionRepository.findSubmissionByIdForDocusign(subId);
    List<tffa__Disclosure__c> disclosures = new List<tffa__Disclosure__c>();
    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();
    List<tffa__Disclosure__c> addendumDisc = new List<tffa__Disclosure__c>();
    factsMap = facts;
    tffa__Party__c debitCardParty = new tffa__Party__c();
    isDebitCardProduct = false;
    try {
      if (String.isNotBlank(eventName) && eventName.equalsIgnoreCase('Application_DocumentGeneration')) {
        List<tffa__Disclosure__c> deleteDisclsoure = CZWTFCSubmissionRepository.getAppAccOpenedDisclosures(sub.Id);
        CZWTFCSubmissionRepository.deleteRecords(deleteDisclsoure);
        List<tffa__DisclosureEnvelope__c> discEnvList = CZDocusignRepository.fetchDisclosureEnvBySubId(sub.Id);
        if (discEnvList != null && !discEnvList.isEmpty()) {
          for (tffa__DisclosureEnvelope__c discEnvVoidObjs : discEnvList) {
            discEnvVoidObjs.tffa__Status__c = 'VOIDED';
          }
          WTFCObjectManagerRepository.doUpsertObjects(discEnvList);
        }
      }

      appList = CZWTFCApplicationRepository.findApplicationsByIdsForDocusign(sub.Id);
      partyList = CZWTFCPartyRepository.findAllPartiesbySubId(sub);
      partyMap = CZWTFCDisclosureHelper.generatePartyMap(partyList);

      facts.put('Channel__c', sub.tffa__Channel__c);
      facts.put('EventName__c', eventName);

      Map<String, Object> dicsFactsMap = new Map<String, Object>();
      dicsFactsMap.put('EventName__c', eventName);
      dicsFactsMap.put('Channel__c', sub.tffa__Channel__c);
      dicsFactsMap.put('BrandCode__c', sub.tffa__Brand__c);

      dicsFactsMap = fetchFacts(dicsFactsMap, appList);

      if (appList[0].tffa__AccountPurpose__c == 'DEBIT_CARD') {
        isDebitCardProduct = true;
        for (tffa__SubmissionPartyXref__c submissionParty : sub.tffa__PartyXrefs__r) {
          if (submissionParty.tffa__Type__c == 'INDIVIDUAL')
            debitCardParty = submissionParty.tffa__party__r;
        }
      }

      /**
       * Fetch Disclosures for Event Application_DocumentGeneration
       */
      List<tffa__DisclosureMatrix__c> discMatrix = CZWTFCHelperRepository.findDiscMatrixByFacts('Docusign_Fact', dicsFactsMap);
      Map<Id, tffa__DisclosureChecklist__c> checklistMap = CZWTFCHelperRepository.fetchDiscMapUsingMatrix(discMatrix);
      List<tffa__DisclosureChecklist__c> addendumChecklists = CZWTFCHelperRepository.findByEventName('Addendum');

      List<String> checkids = new List<String>();
      for (tffa__DisclosureChecklist__c dc : addendumChecklists) {
        for (tffa__DisclosureItem__c di : dc.tffa__Items__r) {
          //checkids.add(di.id);
          discItemMap.put(di.tffa__Template__r.tffa__Code__c, di);
        }
      }

      /**
       * Fetch CZDisclosureParticipantConfig__c
       *
      List<tffa__DisclosureItem__c> checklistitems = CZWTFCHelperRepository.findParticipants(checkids);
      Map<id, List<CZDisclosureParticipantConfig__c>> participantmap = new Map<id, List<CZDisclosureParticipantConfig__c>>();
      for (tffa__DisclosureItem__c items : checklistitems) {
        if (items.CZDisclosureParticipantsConfig__r != null && !items.CZDisclosureParticipantsConfig__r.isEmpty()) {
          participantmap.put(items.Id, items.CZDisclosureParticipantsConfig__r);
        }
      }*/
      List<tffa__DisclosureParticipant__c> disclosureParticipantLst;
      Integer indx = -1;
      for (tffa__DisclosureMatrix__c dm : discMatrix) {
        tffa__DisclosureChecklist__c dc = checklistMap.get(dm.tffa__Checklist__c);
        for (tffa__DisclosureItem__c di : dc.tffa__Items__r) {
          tffa__Disclosure__c d;
          boolean disclosureAdded = false;
          if (dm.tffa__EntityType__c == 'APPLICATION' || dm.tffa__EntityType__c == 'NA') {
            for (tffa__Application__c app : appList) {
              if (CZWTFCDisclosureHelper.isAppEligible(app, dm, di)) {
                if (di.tffa__Template__r.tffa__Code__c == 'BUSSIGNCARD') {
                  List<List<tffa__Application__c>> applicationBuckets = CZWTFCDisclosureHelper.getApplicationBucketsForParty(
                    dm.tffa__ProductCategorySet__c.split(';'),
                    partyMap,
                    appList
                  );
                  Integer signCardCount = 0;
                  for (List<tffa__Application__c> appBucket : applicationBuckets) {
                    indx++;
                    signCardCount++;
                    d = createDisclosureObj(di, appBucket.get(0), null);
                    if (applicationBuckets.size() > 0) {
                      d.Name =
                        di.Name +
                        '-' +
                        CZWTFCDisclosureHelper.getPrimaryParty(appBucket.get(0)).tffa__Party__r.Name +
                        '-' +
                        signCardCount;
                      if (d.Name.length() > 80)
                        d.Name = d.Name.subString(0, 80);
                    }
                    d.CZRelatedApplication__c = '';

                    for (tffa__Application__c app2 : appBucket) {
                      if (String.isEmpty(d.CZRelatedApplication__c))
                        d.CZRelatedApplication__c = app2.Id;
                      else
                        d.CZRelatedApplication__c = d.CZRelatedApplication__c + ',' + app2.Id;
                    }
                    tffa__Party__c primaryPartyObj = CZWTFCDisclosureHelper.getPrimaryParty(appBucket.get(0)).tffa__Party__r;
                    if (primaryPartyObj.tffa__OrganizationType__c != 'TRUST') {
                      createAccountResolution(primaryPartyObj, appBucket, signCardCount, d.CZRelatedApplication__c);
                    }

                    if (appBucket.size() > 1) {
                      if (String.isBlank(d.CZAddendumsAttached__c)) {
                        d.CZAddendumsAttached__c = 'SCHD1BBUSINESACC';
                      } else {
                        d.CZAddendumsAttached__c = d.CZAddendumsAttached__c + ';SCHD1BBUSINESACC';
                      }
                      createMultipleAccountsAddendum(
                        primaryPartyObj,
                        d.CZRelatedApplication__c,
                        d.tffa__Code__c,
                        signCardCount,
                        appBucket.get(0)
                      );
                    }
                    dl.add(d);
                    //Create Disclosure Participant
                    if (String.isNotBlank(di.tffa__Template__r.CZParticipantRoles__c)) {
                      d = addDisclosureParticipants(d, di, appBucket.get(0), primaryPartyObj);
                      dl.set(indx, d);
                    }
                  }
                  break;
                } else if (di.tffa__Template__r.tffa__Code__c == 'MXSAFECUSDAGMNTPERSNL') {
                  List<List<tffa__Application__c>> applicationBuckets = CZWTFCDisclosureHelper.getEligibleApplicationBucketsByPrimaryParty(
                    appList,
                    dm,
                    di
                  );
                  Integer count = 0;
                  for (List<tffa__Application__c> appBucket : applicationBuckets) {
                    indx++;
                    count++;
                    d = createDisclosureObj(di, appBucket.get(0), null);
                    if (applicationBuckets.size() > 0)
                      d.Name = d.Name + '-' + count;
                    d.CZRelatedApplication__c = '';

                    for (tffa__Application__c appl : appBucket) {
                      if (String.isEmpty(d.CZRelatedApplication__c))
                        d.CZRelatedApplication__c = appl.Id;
                      else
                        d.CZRelatedApplication__c = d.CZRelatedApplication__c + ',' + appl.Id;
                    }
                    dl.add(d);
                    //Create Disclosure Participant
                    if (String.isNotBlank(di.tffa__Template__r.CZParticipantRoles__c)) {
                      d = addDisclosureParticipants(d, di, appBucket.get(0), null);
                      dl.set(indx, d);
                    }
                  }
                  break; // added already for all eligible accounts.
                } else {
                  if (!disclosureAdded || di.CZMultipleRequired__c) {
                    //Create Disclosure Record

                    indx++;
                    d = isDebitCardProduct ? createDisclosureObj(di, app, debitCardParty) : createDisclosureObj(di, app, null);

                    dl.add(d);
                    disclosureAdded = true;
                  } else {
                    dl.get(indx).CZRelatedApplication__c = dl.get(indx).CZRelatedApplication__c + ',' + String.valueOf(app.Id);
                  }

                  //Create Disclosure Participant Record
                  if (String.isNotBlank(di.tffa__Template__r.CZParticipantRoles__c)) {
                    if (!isDebitCardProduct) {
                      d = addDisclosureParticipants(d, di, app, null);
                    } else {
                      d = addDisclosureParticipants(d, di, null, debitCardParty);
                    }
                    dl.set(indx, d);
                  }

                  if (
                    (di.tffa__Template__r.tffa__Code__c == 'HSAAPPLICATION' ||
                    di.tffa__Template__r.tffa__Code__c == 'INHERITIRAAPPLICATION' ||
                    di.tffa__Template__r.tffa__Code__c == 'IRAAPPLICATION') &&
                    app.tffa__Beneficiaries__r != null &&
                    app.tffa__Beneficiaries__r.size() > 4
                  ) {
                    tffa__Disclosure__c addendumDisclosure = createDisclosureObj(
                      discItemMap.get(di.tffa__Template__r.CZSubTemplateCode__c),
                      app,
                      null
                    );
                    d = addDisclosureParticipants(addendumDisclosure, di, app, null);
                    indx++;
                    dl.add(d);
                    dl.set(indx, d);
                  }
                }
              }
            }
          } else if (dm.tffa__EntityType__c == 'PARTY') {
            for (tffa__party__c partyObj : partyList) {
              if (CZWTFCDisclosureHelper.isPartyEligible(partyObj, dm, dc, di, sub)) {
                if (di.tffa__Template__r.tffa__Code__c == 'POAAGENTCERTIFICATION') {
                  if (partyObj.tffa__PartyXrefs__r != null) {
                    for (tffa__PartyPartyXref__c partyPartyXref : partyObj.tffa__PartyXrefs__r) {
                      tffa.Logger.debug('partyPartyXref.tffa__RelationCode__r : ' + partyPartyXref.tffa__RelationCode__r);
                      if (partyPartyXref.tffa__RelationCode__r.tffa__Label__c == 'PRINCIPAL') {
                        indx++;
                        d = createDisclosureObj(di, null, partyMap.get(partyPartyXref.tffa__RelatedParty__c));

                        d.CZRelatedApplication__c = '';
                        for (tffa__Application__c app : appList) {
                          for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
                            if (
                              apx.tffa__party__c == partyObj.Id &&
                              (apx.tffa__RoleCode__c == 'POA' ||
                              apx.tffa__RoleCode__c == 'POA_BENEFICIARY')
                            ) {
                              d.CZRelatedApplication__c = d.CZRelatedApplication__c + ',' + app.Id;
                            }
                          }
                        }

                        dl.add(d);
                        //d.Name = d.Name + '-' + resolutionCount;
                      }
                      if (String.isNotBlank(di.tffa__Template__r.CZParticipantRoles__c)) {
                        d = addDisclosureParticipants(d, di, null, partyObj);
                        dl.set(indx, d);
                      }
                    }
                  }
                } else {
                  if (!disclosureAdded || di.CZMultipleRequired__c) {
                    indx++;
                    d = createDisclosureObj(di, null, partyObj);

                    dl.add(d);
                    disclosureAdded = true;
                  }

                  //Create Disclosure Participant
                  if (String.isNotBlank(di.tffa__Template__r.CZParticipantRoles__c)) {
                    d = addDisclosureParticipants(d, di, null, partyObj);
                    dl.set(indx, d);
                  }

                  // Custom handling for Junior saver form and certificate to add related applications
                  if (
                    di.tffa__Template__r.tffa__Code__c == 'JNRSAVERFORM' ||
                    di.tffa__Template__r.tffa__Code__c == 'JUNIORSAVERCERTIFICATE'
                  ) {
                    d.CZRelatedApplication__c = '';
                    for (tffa__Application__c app : appList) {
                      for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
                        if (apx.tffa__party__c == partyObj.Id) {
                          d.CZRelatedApplication__c = d.CZRelatedApplication__c + ',' + app.Id;
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }

      for (List<tffa__Disclosure__c> discAddendumObjList : addendumDiscMap.values()) {
        dl.addAll(discAddendumObjList);
      }

      tffa.Logger.debug('disclosure Created---> ' + dl);

      if (!dl.isEmpty()) {
        dl = CZWTFCHelperRepository.save(dl);
      }
      //Upsert Disclosure participant
      CZWTFCDisclosureHelper.upsertParticipants(dl, partyMap);
      //Split Disclosure
      dl = CZDocusignRepository.getSubmissionDocumentsBySubId(sub.Id);
      dl = CZWTFCDisclosureHelper.splitAndCreateDisclosureSets(dl);
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in resolveForBranchDosusign ' +
        ex.getLineNumber() +
        ' ' +
        ex.getMessage() +
        ' ' +
        ex.getStackTraceString()
      );
    }
    return dl;
  }

  public static Map<String, Object> fetchFacts(Map<String, Object> mp, List<tffa__Application__c> appList) {
    tffa.Logger.debug('In fetchFacts');
    Set<String> prodCode = new Set<String>();
    Set<String> prodCategory = new Set<String>();
    Set<String> accountPurpose = new Set<String>();
    Set<String> promocode = new Set<String>();
    promocode.add('NO-PROMO');

    for (tffa__Application__c app : appList) {
      prodCode.add(app.tffa__ProductCode__c);
      prodCategory.add(app.tffa__ProductCategory__c);
      if (String.isNotBlank(app.tffa__PromotionCode__c)) {
        promocode.add(app.tffa__PromotionCode__c);
      }
      if (String.isNotBlank(app.tffa__AccountPurpose__c)) {
        accountPurpose.add(app.tffa__AccountPurpose__c);
      }
    }

    if (!promocode.isEmpty()) {
      mp.put('PromotionCode__c', new List<String>(promocode));
    }
    if (!accountPurpose.isEmpty()) {
      mp.put('AccountPurpose__c', new List<String>(accountPurpose));
    }
    mp.put('ProductCode__c', new List<String>(prodCode));
    mp.put('ProductCategory__c', new List<String>(prodCategory));
    return mp;
  }

  public static Boolean isParticipant(String role, tffa__ApplicationPartyXref__c apx) {
    if (CZWTFCDisclosureHelper.ROLE_MAP.containsKey(role)) {
      return CZWTFCDisclosureHelper.ROLE_MAP.get(role).contains(apx.tffa__RoleCode__c);
    } else if (role.equalsIgnoreCase(apx.tffa__RoleCode__c)) {
      return true;
    } else {
      return false;
    }
  }
  public static tffa__Disclosure__c addDisclosureParticipants(
    tffa__Disclosure__c d,
    tffa__DisclosureItem__c di,
    tffa__Application__c app,
    tffa__Party__c partyObj
  ) {
    List<String> signers = new List<String>{ 'BUSINESS_SIGNER', 'CONSUMER_SIGNER' };
    List<String> participantRole = di.tffa__Template__r.CZParticipantRoles__c.split(';');
    List<String> participantType = di.tffa__Template__r.CZParticipantTypes__c.split(';');
    List<tffa__DisclosureParticipant__c> disclosureParticipantLst = new List<tffa__DisclosureParticipant__c>();
    disclosureParticipantLst.addAll(d.tffa__DisclosureParticipants__r);

    for (Integer index = 0; index < participantRole.size(); index++) {
      if (String.isNotBlank(participantRole[index])) {
        Integer nbrOfParticipants = di.tffa__Template__r.CZMaxSigners__c != null
          ? Integer.valueOf(di.tffa__Template__r.CZMaxSigners__c)
          : 0;

        if (participantType[index] == 'PARTY') {
          Integer parties = 1;
          if (participantRole[index] == 'TIN_CERTIFIER') {
            tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
            disclosureParticipantObj.Name = partyMap.get(app.CZTINCertifier__c).Name + '-' + ' TIN CERTIFIER';
            disclosureParticipantObj.tffa__party__c = app.CZTINCertifier__c;
            disclosureParticipantObj.tffa__RoleCode__c = 'TIN_CERTIFIER';
            disclosureParticipantObj.tffa__Type__c = 'PARTY';
            if (
              di.CZMultipleRequired__c ||
              !CZWTFCDisclosureHelper.isParticipantAlreadyAdded(disclosureParticipantLst, disclosureParticipantObj)
            ) {
              disclosureParticipantLst.add(disclosureParticipantObj);
            }
          } else if (participantRole[index] == 'RES_CERTIFIER') {
            tffa__party__c resolutionCertifier1 = partyMap.get(app.CZResolutionCertifier1__c);

            tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
            disclosureParticipantObj.Name = resolutionCertifier1.Name;
            disclosureParticipantObj.tffa__party__c = resolutionCertifier1.Id;
            disclosureParticipantObj.tffa__Type__c = 'PARTY';
            disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
            disclosureParticipantLst.add(disclosureParticipantObj);

            if (di.tffa__Template__r.tffa__Code__c == 'RESOLPUBLICDEPO' && app.CZResolutionCertifier2__c != null) {
              tffa__party__c resolutionCertifier2 = partyMap.get(app.CZResolutionCertifier2__c);

              disclosureParticipantObj = new tffa__DisclosureParticipant__c();
              disclosureParticipantObj.Name = resolutionCertifier2.Name;
              disclosureParticipantObj.tffa__party__c = resolutionCertifier2.Id;
              disclosureParticipantObj.tffa__Type__c = 'PARTY';
              disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
              disclosureParticipantLst.add(disclosureParticipantObj);
            }
          } else if (partyObj != null && partyObj.tffa__Type__c == 'INDIVIDUAL' && !isDebitCardProduct) {
            tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
            disclosureParticipantObj.Name = partyObj.Name;
            disclosureParticipantObj.tffa__party__c = partyObj.Id;
            disclosureParticipantObj.tffa__Type__c = 'PARTY';
            disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
            disclosureParticipantLst.add(disclosureParticipantObj);
          } else if (partyObj != null && isDebitCardProduct) {
            tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
            disclosureParticipantObj.Name = partyObj.Name;
            disclosureParticipantObj.tffa__party__c = partyObj.Id;
            disclosureParticipantObj.tffa__Type__c = 'PARTY';
            disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
            disclosureParticipantLst.add(disclosureParticipantObj);
          } else if (participantRole[index] == 'PRIMARY_OWNER') {
            tffa__ApplicationPartyXref__c primaryOwner = new tffa__ApplicationPartyXref__c();
            if (app.tffa__AccountPurpose__c == 'UTMA') {
              primaryOwner = fetchCustodian(app);
            } else {
              primaryOwner = fetchPrimaryOwner(app);
            }
            if (primaryOwner != null) {
              tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
              disclosureParticipantObj.Name = primaryOwner.Name + '-' + participantRole[index];
              disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
              disclosureParticipantObj.tffa__party__c = primaryOwner.tffa__Party__c;
              disclosureParticipantObj.tffa__Type__c = 'PARTY';
              disclosureParticipantLst.add(disclosureParticipantObj);
            }
          } else if (app != null) {
            for (tffa__ApplicationPartyXref__c apx : app.tffa__PartyXrefs__r) {
              if (isParticipant(participantRole[index], apx)) {
                tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
                disclosureParticipantObj.Name = apx.Name + '-' + apx.tffa__RoleCode__c;
                disclosureParticipantObj.tffa__party__c = apx.tffa__party__c;

                if (CZWTFCDisclosureHelper.ROLE_MAP.containsKey(participantRole[index])) {
                  disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
                } else {
                  disclosureParticipantObj.tffa__RoleCode__c = apx.tffa__RoleCode__c;
                }

                disclosureParticipantObj.tffa__Type__c = 'PARTY';

                if (
                  di.CZMultipleRequired__c ||
                  !CZWTFCDisclosureHelper.isParticipantAlreadyAdded(disclosureParticipantLst, disclosureParticipantObj)
                ) {
                  if (
                    !signers.contains(participantRole[index]) ||
                    String.isBlank(di.tffa__Template__r.CZSubTemplateCode__c) ||
                    di.tffa__Template__r.tffa__Code__c == 'HSAAPPLICATION' ||
                    di.tffa__Template__r.tffa__Code__c == 'INHERITIRAAPPLICATION' ||
                    di.tffa__Template__r.tffa__Code__c == 'IRAAPPLICATION'
                  ) {
                    disclosureParticipantLst.add(disclosureParticipantObj);
                  } else {
                    if (parties <= di.tffa__Template__r.CZMaxSigners__c) {
                      disclosureParticipantLst.add(disclosureParticipantObj);
                      parties++;
                    } else {
                      tffa__Disclosure__c addendumDisclosure;
                      if (!addendumDiscMap.containsKey(di.tffa__Template__r.CZSubTemplateCode__c + ' ' + sortOrder)) {
                        if (String.isBlank(d.CZAddendumsAttached__c)) {
                          d.CZAddendumsAttached__c = di.tffa__Template__r.CZSubTemplateCode__c;
                        } else {
                          d.CZAddendumsAttached__c = d.CZAddendumsAttached__c + ';' + di.tffa__Template__r.CZSubTemplateCode__c;
                        }

                        addendumDisclosure = createDisclosureObj(discItemMap.get(di.tffa__Template__r.CZSubTemplateCode__c), app, null);
                        addendumDisclosure = addTINCertifier(addendumDisclosure, partyMap.get(app.CZTINCertifier__c));
                        addendumDiscMap.put(
                          di.tffa__Template__r.CZSubTemplateCode__c +
                          ' ' +
                          sortOrder,
                          new List<tffa__Disclosure__c>{ addendumDisclosure }
                        );
                      } else {
                        List<tffa__Disclosure__c> addendumdiscLst = addendumDiscMap.get(
                          di.tffa__Template__r.CZSubTemplateCode__c +
                          ' ' +
                          sortOrder
                        );
                        tffa__DisclosureTemplate__c discTemp = discItemMap.get(di.tffa__Template__r.CZSubTemplateCode__c).tffa__Template__r;
                        Integer addendumNbr = Integer.valueOf(
                          Math.ceil((parties - di.tffa__Template__r.CZMaxSigners__c) / discTemp.CZMaxSigners__c)
                        );
                        if (addendumNbr > addendumdiscLst.size()) {
                          addendumDisclosure = createDisclosureObj(discItemMap.get(di.tffa__Template__r.CZSubTemplateCode__c), app, null);
                          addendumDisclosure = addTINCertifier(addendumDisclosure, partyMap.get(app.CZTINCertifier__c));
                          addendumdiscLst.add(addendumDisclosure);
                          addendumDiscMap.put(di.tffa__Template__r.CZSubTemplateCode__c + ' ' + sortOrder, addendumdiscLst);
                        }
                      }
                      tffa__DisclosureParticipant__c discParticipantObjAddendum = new tffa__DisclosureParticipant__c();
                      discParticipantObjAddendum.Name = apx.Name + '-' + apx.tffa__RoleCode__c;
                      discParticipantObjAddendum.tffa__party__c = apx.tffa__party__c;
                      discParticipantObjAddendum.tffa__RoleCode__c = participantRole[index];
                      discParticipantObjAddendum.tffa__Type__c = 'PARTY';

                      List<tffa__Disclosure__c> discLst = addendumDiscMap.get(di.tffa__Template__r.CZSubTemplateCode__c + ' ' + sortOrder);
                      tffa__Disclosure__c adddendumDisc = discLst.get(discLst.size() - 1);
                      List<tffa__DisclosureParticipant__c> addendumDiscParticipantLst = adddendumDisc.tffa__DisclosureParticipants__r;
                      tffa.SObjectAssembler disclosureAddendumObjAssembler = new tffa.SObjectAssembler(adddendumDisc);
                      if (addendumDiscParticipantLst != null || !addendumDiscParticipantLst.isEmpty()) {
                        addendumDiscParticipantLst.add(discParticipantObjAddendum);
                        disclosureAddendumObjAssembler.setChildObjects('DisclosureParticipants__r', addendumDiscParticipantLst);
                      } else {
                        disclosureAddendumObjAssembler.setChildObjects(
                          'DisclosureParticipants__r',
                          new List<tffa__DisclosureParticipant__c>{ discParticipantObjAddendum }
                        );
                      }

                      discLst.set(discLst.size() - 1, (tffa__Disclosure__c) disclosureAddendumObjAssembler.assemble());
                      addendumDiscMap.put(di.tffa__Template__r.CZSubTemplateCode__c + ' ' + sortOrder, discLst);
                      parties++;
                    }
                  }
                }
              }
            }
          } else if (partyObj != null) {
            /* for party level disclosures, look for party party relationships */
            List<String> partyRole = CZWTFCDisclosureHelper.getPartyRole(participantRole[index]);
            for (tffa__PartyPartyXref__c partyPartyObj : partyObj.tffa__PartyXrefs__r) {
              if (
                (CZWTFCDisclosureHelper.ROLE_MAP.containsKey(participantRole[index]) &&
                CZWTFCDisclosureHelper.ROLE_MAP.get(participantRole[index]).contains(partyPartyObj.tffa__RelationCode__r.tffa__Label__c)) ||
                (!CZWTFCDisclosureHelper.ROLE_MAP.containsKey(participantRole[index]) &&
                partyRole.contains(partyPartyObj.tffa__RelationCode__r.tffa__Label__c))
              ) {
                tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
                if (partyMap.containsKey(partyPartyObj.tffa__RelatedParty__c)) {
                  disclosureParticipantObj.Name = partyPartyObj.Name + ' ' + partyMap.get(partyPartyObj.tffa__RelatedParty__c).Name;
                } else {
                  disclosureParticipantObj.Name = partyPartyObj.Name;
                }

                disclosureParticipantObj.tffa__party__c = partyPartyObj.tffa__RelatedParty__c;
                disclosureParticipantObj.tffa__Type__c = 'PARTY';

                if (CZWTFCDisclosureHelper.ROLE_MAP.containsKey(participantRole[index])) {
                  disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
                } else {
                  disclosureParticipantObj.tffa__RoleCode__c = CZWTFCDisclosureHelper.getParticipantRoleCode(
                    participantType[index],
                    partyPartyObj.tffa__RelationCode__r.tffa__Label__c
                  );
                }
                if (
                  di.CZMultipleRequired__c ||
                  !CZWTFCDisclosureHelper.isParticipantAlreadyAdded(disclosureParticipantLst, disclosureParticipantObj)
                ) {
                  disclosureParticipantLst.add(disclosureParticipantObj);
                }
              }
            }
          }
        } else if (participantType[index] == 'USER') {
          if (participantRole[index] == 'BRANCHUSER') {
            disclosureParticipantLst.add(createBranchUserParticipant());
          }
        } else if (participantType[index] == 'OTHER') {
          if (participantRole[index] == 'NATURAL_PERSON') {
            if (partyObj.CZNaturalPerson__c != null) {
              tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
              disclosureParticipantObj.Name =
                partyMap.get(partyObj.CZNaturalPerson__c).Name +
                ' (Certifying Individual- ' +
                partyObj.Name +
                ')';
              disclosureParticipantObj.tffa__party__c = partyObj.CZNaturalPerson__c;
              disclosureParticipantObj.tffa__Type__c = 'PARTY';
              disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
              disclosureParticipantLst.add(disclosureParticipantObj);
            } else {
              tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
              String name = partyObj.CZCertifyingIndividualFN__c + ' ' + partyObj.CZCertifyingIndividualLN__c;
              disclosureParticipantObj.Name = name + ' (Certifying Individual- ' + partyObj.Name + ')';
              disclosureParticipantObj.tffa__party__c = partyObj.Id;
              disclosureParticipantObj.tffa__Type__c = 'OTHER';
              disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
              disclosureParticipantLst.add(disclosureParticipantObj);
            }
          } else if (participantRole[index] == 'CUSTODIAN') {
            tffa__party__c custodianParty = partyMap.get(partyObj.CZCustodian__c);
            tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
            disclosureParticipantObj.Name = custodianParty.Name;
            disclosureParticipantObj.tffa__party__c = custodianParty.Id;
            disclosureParticipantObj.tffa__Type__c = 'PARTY';
            disclosureParticipantObj.tffa__RoleCode__c = 'CUSTODIAN';
            disclosureParticipantLst.add(disclosureParticipantObj);
          } else if (participantRole[index] == 'SPOUSE') {
            tffa__ApplicationPartyXref__c primaryOwner = new tffa__ApplicationPartyXref__c();

            primaryOwner = fetchPrimaryOwner(app);

            if (primaryOwner != null && String.isNotBlank(primaryOwner.tffa__Party__r.CZSpouseName__c)) {
              tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
              disclosureParticipantObj.Name = primaryOwner.tffa__Party__r.CZSpouseName__c;
              disclosureParticipantObj.tffa__RoleCode__c = participantRole[index];
              disclosureParticipantObj.tffa__Type__c = 'OTHER';
              disclosureParticipantObj.tffa__party__c = primaryOwner.tffa__Party__c;
              disclosureParticipantLst.add(disclosureParticipantObj);
            }
          }
        }
      }
    }
    if (!disclosureParticipantLst.isEmpty()) {
      tffa.SObjectAssembler disclosureObjAssembler = new tffa.SObjectAssembler(d);
      disclosureObjAssembler.setChildObjects('DisclosureParticipants__r', disclosureParticipantLst);
      return (tffa__Disclosure__c) disclosureObjAssembler.assemble();
    } else
      return d;
  }

  public static tffa__Disclosure__c addTINCertifier(tffa__Disclosure__c disc, tffa__Party__c partyObj) {
    tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
    disclosureParticipantObj.Name = partyObj.Name + '-' + ' TIN CERTIFIER';
    disclosureParticipantObj.tffa__party__c = partyObj.Id;
    disclosureParticipantObj.tffa__RoleCode__c = 'TIN_CERTIFIER';
    disclosureParticipantObj.tffa__Type__c = 'PARTY';

    tffa.SObjectAssembler disclosureObjAssembler = new tffa.SObjectAssembler(disc);
    disclosureObjAssembler.setChildObjects(
      'DisclosureParticipants__r',
      new List<tffa__DisclosureParticipant__c>{ disclosureParticipantObj }
    );
    return (tffa__Disclosure__c) disclosureObjAssembler.assemble();
  }

  public static tffa__ApplicationPartyXref__c fetchPrimaryOwner(tffa__Application__c app) {
    //If Primary party is Individual
    for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
      if (appParty.tffa__Primary__c && appParty.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL) {
        return appParty;
      }
    }

    List<String> rolesList = new List<String>();
    if (app.tffa__ProductCategory__c.contains('BUSINESS')) {
      rolesList = CZWTFCDisclosureHelper.ROLE_MAP.get('BUSINESS_SIGNER');
    } else {
      rolesList = CZWTFCDisclosureHelper.ROLE_MAP.get('CONSUMER_SIGNER');
    }
    //If Primary party is Organization
    for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
      if (appParty.tffa__Type__c == FISCCIntegrationConstants.INDIVIDUAL && rolesList.contains(appParty.tffa__RoleCode__c)) {
        return appParty;
      }
    }
    return null;
  }

  public static tffa__ApplicationPartyXref__c fetchCustodian(tffa__Application__c app) {
    for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
      if (appParty.tffa__RoleCode__c == 'CUSTODIAN') {
        return appParty;
      }
    }

    return null;
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
    } else if (!sub.tffa__Applications__r.isEmpty()) {
      for (tffa__Application__c app : sub.tffa__Applications__r) {
        disclosures.addAll(resolveFor(sub, app, facts));
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
      'Channel__c' => sub.tffa__Channel__c,
      'EventName__c' => eventName,
      'PartyType__c' => p.tffa__Type__c,
      'ProductCategory__c' => app.tffa__ProductCategory__c,
      'ProductCode__c' => app.tffa__ProductCode__c,
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
      'Channel__c' => sub.tffa__Channel__c,
      'EventName__c' => eventName,
      'PartyType__c' => p.tffa__Type__c,
      'ProductCategory__c' => app.tffa__ProductCategory__c,
      'ProductCode__c' => app.tffa__ProductCode__c,
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

    facts.put('Channel__c', sub.tffa__Channel__c);
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
   * Resolves disclosures for submission-application facts
   * @param sub
   * @param facts
   * @return  `List<Disclosure__c>`
   */
  @TestVisible
  private static List<tffa__Disclosure__c> resolveFor(tffa__Submission__c sub, tffa__Application__c app, Map<String, Object> facts) {
    String eventName = tffa.Context.get().eventName;

    List<tffa__Disclosure__c> dl = new List<tffa__Disclosure__c>();

    facts.put('Channel__c', sub.tffa__Channel__c);
    facts.put('Locale__c', sub.tffa__Locale__c);
    facts.put('EventName__c', eventName);
    addFacts(facts, sub);
    addFacts(facts, app);
    tffa.Logger.fine('facts', facts);

    dl = resolveForFacts(facts);

    if (dl != null && !dl.isEmpty()) {
      for (tffa__Disclosure__c d : dl) {
        d.tffa__Submission__c = sub.Id;
        d.tffa__LinkedApplication__c = app.Id;
      }
    }

    return dl;
  }

  /**
   * Adds facts about the application
   */
  @TestVisible
  private static void addFacts(Map<String, Object> facts, tffa__Application__c app) {
    facts.put('ProductCategory__c', app.tffa__ProductCategory__c);
    facts.put('ProductCode__c', app.tffa__ProductCode__c);
    facts.put('Product__c', app.tffa__Product__c);
    facts.put('OfferCode__c', app.tffa__OfferCode__c);
  }

  public static void createMultipleAccountsAddendum(
    tffa__Party__c partyObj,
    String appIds,
    String code,
    Integer resolutionCount,
    tffa__Application__c linkedApplication
  ) {
    tffa__DisclosureItem__c di = discItemMap.get('SCHD1BBUSINESACC');
    tffa__Disclosure__c d = createDisclosureObj(di, null, null);

    d.CZRelatedApplication__c = appIds;
    d.CZParentDisclosureCode__c = code;
    d.Name = d.Name + '-' + resolutionCount;

    tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
    tffa__party__c TINCertifier = partyMap.get(linkedApplication.CZTINCertifier__c);
    disclosureParticipantObj.Name = TINCertifier.Name + ' - ' + 'TIN CERTIFIER';
    disclosureParticipantObj.tffa__party__c = TINCertifier.Id;
    disclosureParticipantObj.tffa__Type__c = 'PARTY';
    disclosureParticipantObj.tffa__RoleCode__c = 'TIN_CERTIFIER';

    tffa.SObjectAssembler disclosureAddendumObjAssembler = new tffa.SObjectAssembler(d);

    disclosureAddendumObjAssembler.setChildObjects(
      'DisclosureParticipants__r',
      new List<tffa__DisclosureParticipant__c>{ disclosureParticipantObj }
    );

    addendumDiscMap.put(
      di.tffa__Template__r.tffa__Code__c +
      ' ' +
      sortOrder,
      new List<tffa__Disclosure__c>{ (tffa__Disclosure__c) disclosureAddendumObjAssembler.assemble() }
    );
  }

  public static void createAccountResolution(
    tffa__Party__c primaryPartyObj,
    List<tffa__Application__c> appBucket,
    Integer resolutionCount,
    String appIds
  ) {
    String resolutionDocCode;
    if (
      primaryPartyObj.tffa__OrganizationType__c == 'CORPORATION' ||
      primaryPartyObj.tffa__OrganizationType__c == 'LIMITED_LIABILITY_COMPANY' ||
      primaryPartyObj.tffa__OrganizationType__c == 'PARTNERSHIP'
    ) {
      resolutionDocCode = 'RESOLCORPPARTLLC';
    } else if (primaryPartyObj.tffa__OrganizationType__c == 'UNINCORPORATED_ORG') {
      resolutionDocCode = 'RESOLASSOCIORG';
    } else if (primaryPartyObj.tffa__Type__c == 'INDIVIDUAL') {
      resolutionDocCode = 'SOLEPROPRESOLUTION';
    } else if (primaryPartyObj.tffa__OrganizationType__c == 'PUBLIC_DEPOSIT') {
      resolutionDocCode = 'RESOLPUBLICDEPO';
    } else {
      return;
    }

    tffa__DisclosureItem__c di = discItemMap.get(resolutionDocCode);

    tffa__Disclosure__c d = createDisclosureObj(di, appBucket.get(0), primaryPartyObj);
    d.CZRelatedApplication__c = appIds;
    if (appBucket.size() > 1) {
      d.Name = di.Name + '-' + CZWTFCDisclosureHelper.getPrimaryParty(appBucket.get(0)).tffa__Party__r.Name + '-' + resolutionCount;
      if (d.Name.length() > 80)
        d.Name = d.Name.subString(0, 80);
    }
    d = addDisclosureParticipants(d, di, appBucket.get(0), primaryPartyObj);

    addendumDiscMap.put(di.tffa__Template__r.tffa__Code__c + ' ' + sortOrder, new List<tffa__Disclosure__c>{ d });
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

    facts.put('Channel__c', sub.tffa__Channel__c);
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
    List<tffa__DisclosureMatrix__c> matrices = tffa.DisclosureMatrixService.resolveByFacts('Facts', facts);
    tffa.Logger.fine('matrices size', matrices.size());
    if (matrices.isEmpty()) {
      return dl;
    }
    Set<String> visitedTemplates = new Set<String>();
    for (tffa__DisclosureMatrix__c mat : matrices) {
      tffa__DisclosureChecklist__c disclosureChecklist = mat.tffa__Checklist__r;
      if (entityType != null && entityType == 'PARTY' && mat.tffa__EntityType__c != 'PARTY') {
        tffa.Logger.fine('skipping from checklist ::', disclosureChecklist.Name);
        continue;
      }
      tffa.Logger.fine('populating from checklist ::', disclosureChecklist.Name);
      for (tffa__DisclosureItem__c di : disclosureChecklist.tffa__Items__r) {
        if (di.tffa__Template__r != null && !visitedTemplates.add(di.tffa__Template__r.tffa__Code__c)) {
          continue;
        }

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

  @TestVisible
  private static List<tffa__Party__c> filteredParties(List<tffa__Application__c> appLst, tffa__DisclosureChecklist__c dc) {
    tffa.Logger.debug('In filteredApps');
    String productCodeDC = dc.CZProductCodeSet__c;
    Map<Id, tffa__Party__c> mp = new Map<Id, tffa__Party__c>();
    for (tffa__Application__c app : appLst) {
      if (productCodeDC != null && productCodeDC.contains(app.tffa__Product__r.tffa__Code__c)) {
        for (tffa__ApplicationPartyXref__c appParty : app.tffa__PartyXrefs__r) {
          mp.put(appParty.tffa__party__c, appParty.tffa__Party__r);
        }
      }
    }
    return mp.Values();
  }

  @TestVisible
  private static tffa__Disclosure__c createDisclosureObj(tffa__DisclosureItem__c di, tffa__Application__c app, tffa__party__c partyObj) {
    tffa__Disclosure__c d = new tffa__Disclosure__c();
    d.Name = di.Name;
    if (app != null) {
      if (di.CZMultipleRequired__c && !isDebitCardProduct) {
        String diName = di.Name;
        if (di.Name.length() > 60) {
          diName = diName.substring(0, 60);
        }
        d.Name =
          diName +
          ' - ' +
          (FISCCIntegrationConstants.SAFE_DEPOSIT_PROD_CATEGORY.contains(app.tffa__ProductCategory__c)
            ? app.tffa__DepositBoxAccountNumber__c
            : app.tffa__AccountNumber__c);
      }
      d.tffa__LinkedApplication__c = app.Id;
      d.CZRelatedApplication__c = app.Id;
    }

    if (partyObj != null) {
      if (di.CZMultipleRequired__c) {
        d.Name = d.Name + ' - ' + partyObj.Name;
      }
      if (d.Name.length() > 75) {
        d.Name = d.Name.substring(0, 75);
      }
      d.tffa__party__c = partyObj.Id;
    }

    d.tffa__SortOrder__c = sortOrder;
    d.tffa__Submission__c = (String) factsMap.get('Submission__c');
    d.tffa__Label__c = di.tffa__Label__c;
    d.tffa__ActionText__c = di.tffa__ActionText__c;
    d.tffa__Required__c = di.tffa__Required__c;
    d.tffa__EventName__c = (String) factsMap.get('EventName__c');
    sortOrder++;

    d.tffa__GroupCode__c = di.tffa__GroupCode__c;
    if (di.tffa__Template__r != null) {
      d.tffa__Type__c = di.tffa__Template__r.tffa__Type__c;
      d.tffa__Code__c = di.tffa__Template__r.tffa__Code__c;
      d.tffa__ExecutionRequired__c = di.tffa__Template__r.tffa__ExecutionRequired__c;
      d.tffa__Template__c = di.tffa__Template__r.tffa__Type__c == tffa.DisclosureType.DOCUSIGN.name()
        ? di.tffa__Template__r.tffa__Template__c
        : null;

      d.tffa__IsExternal__c = di.tffa__Template__r.tffa__IsExternal__c;
      if (di.tffa__Template__r.tffa__Url__c != null) {
        d.tffa__DocumentUrl__c = di.tffa__Template__r.tffa__Url__c;
      }
      if (di.tffa__Template__r.tffa__ApplicantRoleSet__c != null) {
        d.tffa__ApplicantRoleSet__c = di.tffa__Template__r.tffa__ApplicantRoleSet__c;
      }
      if (di.tffa__Template__r.tffa__EntityType__c != null) {
        d.tffa__EntityType__c = di.tffa__Template__r.tffa__EntityType__c;
      }
    }
    return d;
  }

  public static tffa__DisclosureParticipant__c createBranchUserParticipant() {
    User currentUser = tffa.UserService.getCurrentUser();

    tffa__DisclosureParticipant__c disclosureParticipantObj = new tffa__DisclosureParticipant__c();
    disclosureParticipantObj.Name = currentUser.Name;
    disclosureParticipantObj.tffa__User__c = currentUser.Id;
    disclosureParticipantObj.tffa__Type__c = 'USER';
    disclosureParticipantObj.tffa__RoleCode__c = 'BRANCHUSER';

    return disclosureParticipantObj;
  }

  public static Boolean haveSameOwners(List<tffa__Application__c> appList) {
    if (appList == null || appList.size() < 2) {
      return true;
    }
    for (tffa__Application__c app1 : appList) {
      for (tffa__Application__c app2 : appList) {
        if (CZWTFCDisclosureHelper.getPrimaryParty(app1).tffa__Party__c != CZWTFCDisclosureHelper.getPrimaryParty(app2).tffa__Party__c) {
          return false;
        }
      }
    }
    return true;
  }
}