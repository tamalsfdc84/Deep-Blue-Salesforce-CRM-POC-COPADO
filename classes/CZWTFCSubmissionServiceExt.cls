global inherited sharing class CZWTFCSubmissionServiceExt extends tffa.SubmissionServiceExt {
  /**
   * @description Create methods
   * @param Submission__c sobj
   * @return Submission__c
   */
  global override tffa__Submission__c preCreate(tffa__Submission__c sobj) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'preCreate');
    try {
      tffa.Logger.debug('CZCustom');
      sobj.AdditionalSource__c = 'CZCustom';

      return sobj;
    } finally {
      tffa.Interaction.close();
    }
  }

  global override tffa__Submission__c postSubmit(tffa__Submission__c sub) {
    List<tffa__Application__c> modifiedApps = new List<tffa__Application__c>();
    Integer idx = 0;
    try {
      for (tffa__Application__c appObj : sub.tffa__Applications__r) {
        tffa__Application__c app = new tffa__Application__c();
        app = CZWTFCAppRoutingService.routeApplication(appObj);
        // sub.tffa__Applications__r[idx].OwnerId= app.OwnerId;
        modifiedApps.add(app);
        idx++;
      }
      CZWTFCApplicationRepository.save(modifiedApps);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in Submission Extension postSubmit' + ex.getMessage() + ex.getStackTraceString());
    }
    return sub;
  }

  global override void preSubmit(String id) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'preSubmit');
    try {
      tffa.Logger.debug('Inside CZWTFCSubmissionServiceExt preSubmit ' + id);
      CZWTFCSubmissionServiceExt subExt = new CZWTFCSubmissionServiceExt();
      tffa__Submission__c submissionObj = CZWTFCSubmissionRepository.findSubmissionById(id);
      tffa.Logger.debug('Submission obj :::: ' + submissionObj);

      tffa.Logger.debug('submissionObj.tffa__PartyXrefs__r ' + submissionObj.tffa__PartyXrefs__r);
      if (subExt.processSub(submissionObj)) {
        submissionObj = FISCCSubmissionExecutor.processApplication(submissionObj.id);
      }
      /* else if (submissionObj.tffa__KYCDecisionOutcome__c == 'REVIEW') {
        tffa.Logger.debug('Triggering email for review submission.');
        (new CZWTFCSubmissionEventExtension('Submission_Review')).post(submissionObj);
      } else if (submissionObj.tffa__KYCDecisionOutcome__c == 'DECLINED') {
        CZWTFCPartyEventExtension partyExt = new CZWTFCPartyEventExtension('Application_Declined');
        for (tffa__SubmissionPartyXref__c partyXref : submissionObj.tffa__PartyXrefs__r) {
          partyExt.post(partyXref.tffa__Party__r);
        }
      }*/
      // trigger mail for Manual Funding verification app (one mail per submission, filter logic inside function)
      FISCCIntegrationLogService.triggerMailForManualFundingPending(submissionObj.id);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in Submission Extension preSubmit' + ex.getMessage() + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  global override List<tffa__Submission__c> postReadAll(List<tffa__Submission__c> entities, tffa.QueryContext queryCtx) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'postReadAll');
    List<tffa__Submission__c> submissionList = new List<tffa__Submission__c>();
    List<tffa__Submission__c> submissionListFinal = new List<tffa__Submission__c>();
    Map<String, tffa__Party__c> partyMap = new Map<String, tffa__Party__c>();
    List<tffa__Party__c> partyList = new List<tffa__Party__c>();
    List<Id> partyIds = new List<Id>();
    List<String> subIds = new List<String>();
    try {
      if (queryCtx != null) {
        tffa__Party__c partyObj = CZWTFCPartyRepository.fetchPartyById(queryCtx.getValue('partyId'));
        tffa.Logger.debug('partyObj ' + partyObj);

        if (partyObj.tffa__BrandCode__c == null && String.isBlank(partyObj.tffa__BrandCode__c)) {
          partyList = CZWTFCPartyRepository.findPartyObj(
            partyObj.tffa__PrimaryEmail__c,
            partyObj.tffa__LastName__c,
            partyObj.tffa__LastnNationalIdentifierValue__c
          );
        } else {
          partyList = CZWTFCPartyRepository.findPartyObject(
            partyObj.tffa__PrimaryEmail__c,
            partyObj.tffa__LastName__c,
            partyObj.tffa__LastnNationalIdentifierValue__c,
            partyObj.tffa__BrandCode__c
          );
        }

        tffa.Logger.debug('PartyList fetch using ssn,emailId,lastname');

        tffa.Logger.debug('partyList ' + partyList);
        for (tffa__Party__c p : partyList) {
          partyIds.add(p.Id);
        }
        List<tffa__SubmissionPartyXref__c> subPartyXref = CZWTFCSubmissionRepository.findSubmissionByParty(partyIds);

        for (tffa__SubmissionPartyXref__c subParty : subPartyXref) {
          subIds.add(String.valueOf(subParty.tffa__Submission__c));
        }

        submissionList = CZWTFCSubmissionRepository.findSubmissionByIDs(subIds);
        for (tffa__Submission__c sub : submissionList) {
          partyMap = CZWTFCPartyRepository.findAllPartiesWithChildByIds(sub);

          if (partyMap != null && !partyMap.isEmpty() && sub.tffa__PartyXrefs__r != null) {
            for (Integer idx = 0; idx < sub.tffa__PartyXrefs__r.size(); idx++) {
              if (partyMap.containsKey(sub.tffa__PartyXrefs__r[idx].tffa__Party__c)) {
                tffa__Party__c partyObject = partyMap.get(sub.tffa__PartyXrefs__r[idx].tffa__Party__c);
                sub.tffa__PartyXrefs__r[idx].tffa__Party__r = partyObject;
              }
            }
          }
          submissionListFinal.add(sub);
        }
      }
      for (tffa__Submission__c sub : submissionListFinal) {
        tffa.ApplicationProgressCalculator calculator = new tffa.ApplicationProgressCalculator();
        calculator.calculate(sub.tffa__Applications__r, null);
      }
      return submissionListFinal;
    } catch (Exception e) {
      tffa.Logger.debug('exception in postreadall' + e.getMessage() + e.getStackTraceString());
      throw e;
    } finally {
      tffa.Interaction.close();
    }
  }

  global override tffa__Submission__c postModify(tffa__Submission__c sobj) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'postModify');
    Object ctx = null;
    String eventName = null;
    if (tffa.Context.get() != null) {
      ctx = tffa.Context.get().stage;
      eventName = (String) tffa.Context.get().eventName;
    }

    try {
      //To check product Eligibilty
      if (ctx != null && ((String) ctx == 'PersonalInfo' || (String) ctx == 'AccountDetails' || (String) ctx == 'GettingStarted')) {
        if (sobj.tffa__Applications__r != null) {
          checkDuplicateProduct(sobj.tffa__Applications__r);
        }
        Integer idx = 1;
        List<String> rejectedProd = new List<String>();
        CZWTFCSubmissionServiceExt subServiceExt = new CZWTFCSubmissionServiceExt();
        List<tffa__ProductMatrix__c> prodMatrixList = CZWTFCProductRepository.getAllProductsMatrix();

        String errorMessage = '';
        if (sobj.tffa__PartyXrefs__r != null && sobj.tffa__PartyXrefs__r.size() > 0) {
          for (tffa__Application__c appObj : sobj.tffa__Applications__r) {
            if (!appObj.tffa__IsDeleted__c) {
              //fetch valid prodList
              List<tffa__ProductMatrix__c> validProdList = subServiceExt.getMatrixByprodCode(
                prodMatrixList,
                appObj.tffa__Product__c,
                sobj.tffa__Brand__c
              );

              //loop over each party
              for (tffa__SubmissionPartyXref__c subParty : sobj.tffa__PartyXrefs__r) {
                tffa__Party__c partyObj = subParty.tffa__Party__r;
                boolean validateStateZip = true;
                if ((String) ctx == 'GettingStarted' && !partyObj.IsAuthenticatedCustomer__c) {
                  validateStateZip = false;
                }
                if (subParty.tffa__IsPresent__c && !subParty.tffa__IsDeleted__c && validateStateZip) {
                  boolean throwError = true;
                  String zipCode = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__ZipCode__c;
                  String updatedZipcode = '';
                  if (zipCode.length() > 5) {
                    updatedZipcode = zipCode.substring(0, 5);
                  } else {
                    updatedZipcode = zipCode;
                  }

                  String stateCode = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__State__c;

                  for (tffa__ProductMatrix__c prod : validProdList) {
                    if (String.isNotBlank(prod.ZipCodeSet__c) && String.isNotBlank(prod.StateCodeSet__c)) {
                      if ((prod.ZipCodeSet__c).contains(updatedZipcode) && (prod.StateCodeSet__c).contains(stateCode)) {
                        throwError = false;
                        break;
                      }
                    } else if (String.isNotBlank(prod.StateCodeSet__c)) {
                      if ((prod.StateCodeSet__c).contains(stateCode)) {
                        throwError = false;
                        break;
                      }
                    } else {
                      throwError = false;
                      break;
                    }
                  }

                  if (throwError) {
                    errorMessage = errorMessage + idx + ') ' + subParty.Name + ' is not eligible for Product ' + appObj.Name + '.  \r\n';
                    idx++;
                    if (!rejectedProd.contains(appObj.Name)) {
                      rejectedProd.add(appObj.Name);
                    }
                  }
                }
              }
            }
          }
        }
        throwError(errorMessage, rejectedProd);
      }

      if (String.isNotBlank(eventName) && eventName.equals('verifyFunding')) {
        List<tffa__FundingMatrix__c> fundingMatList = CZWTFCHelperRepository.getFundingMat();
        for (tffa__Application__c appObj : sobj.tffa__Applications__r) {
          if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
            for (tffa__FundingMatrix__c fundMat : fundingMatList) {
              if (
                (appObj.tffa__Product__c == fundMat.tffa__Product__c) &&
                (appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c).equalsIgnoreCase(fundMat.tffa__Type__c)
              ) {
                if (
                  (fundMat.tffa__MinAmount__c - 1) > appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c ||
                  (fundMat.tffa__MaxAmount__c + 1) < appObj.tffa__LinkedFundingRequests__r[0].tffa__Amount__c
                ) {
                  tffa.Logger.error(
                    appObj.Name +
                    ' AMOUNT SHOULD BE BETWEEN ' +
                    fundMat.tffa__MinAmount__c +
                    ' & ' +
                    fundMat.tffa__MaxAmount__c
                  );
                  throw new tffa.ApplicationException(
                    appObj.Name +
                    ' AMOUNT SHOULD BE BETWEEN ' +
                    fundMat.tffa__MinAmount__c +
                    ' & ' +
                    fundMat.tffa__MaxAmount__c
                  );
                }
              }
            }
          } else {
            Decimal minAmount = 0;
            Boolean firstRecord = true;
            for (tffa__FundingMatrix__c fundMat : fundingMatList) {
              if (appObj.tffa__Product__c == fundMat.tffa__Product__c) {
                if (firstRecord) {
                  firstRecord = false;
                  minAmount = fundMat.tffa__MinAmount__c;
                } else if (fundMat.tffa__MinAmount__c < minAmount) {
                  minAmount = fundMat.tffa__MinAmount__c;
                }
              }
            }
            if (minAmount > 0) {
              tffa.Logger.error(appObj.Name + ' HAS A MINIMUM FUNDING AMOUNT OF ' + minAmount);
              throw new tffa.ApplicationException(appObj.Name + ' HAS A MINIMUM FUNDING AMOUNT OF ' + minAmount);
            }
          }
        }
      }
      return sobj;
    } finally {
      tffa.Interaction.close();
    }
  }

  global override tffa__Submission__c postResume(tffa__Submission__c sub) {
    tffa.Logger.debug('postResume CALLED');
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'postResume');
    try {
      PageReference pageRef = new PageReference('/apex/sales');
      Map<String, Object> params = pageRef.getParameters();
      params.put('id', sub.Id);
      params.put('brandCode', sub.tffa__Brand__c);

      String baseUrl = RestContext.request == null
        ? URL.getSalesforceBaseUrl().toExternalForm()
        : tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c;
      sub.tffa__Url__c = baseUrl + pageRef.getUrl();
      tffa.Logger.debug('sub.tffa__Url__c  ' + sub.tffa__Url__c);

      return sub;
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Error into SubmissionService EXT ' +
        ex.getMessage() +
        '  Line number ::: ' +
        ex.getStackTraceString() +
        ' Message ::: ' +
        ex.getMessage()
      );
      return sub;
    } finally {
      tffa.Interaction.close();
    }
  }

  private List<tffa__ProductMatrix__c> getMatrixByprodCode(List<tffa__ProductMatrix__c> prodMatList, String prodCode, String brandCode) {
    List<tffa__ProductMatrix__c> updatedProdList = new List<tffa__ProductMatrix__c>();

    for (tffa__ProductMatrix__c prod : prodMatList) {
      if (String.isNotBlank(prod.tffa__BrandCodeSet__c)) {
        if (prodCode.equalsIgnoreCase(prod.tffa__Product__c) && prod.tffa__BrandCodeSet__c.contains(brandCode)) {
          updatedProdList.add(prod);
        }
      } else if (prodCode.equalsIgnoreCase(prod.tffa__Product__c)) {
        updatedProdList.add(prod);
      }
    }
    return updatedProdList;
  }
  /**
   * @description : Called after updating status of submission entity to SUBMITTED
   * @param tffa__Submission__c sobj
   * @return tffa__Submission__c
   */

  global override tffa__Submission__c postSave(tffa__Submission__c submission) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'postSave');
    try {
      List<tffa__SubmissionPartyXref__c> subPartyXrefList = new List<tffa__SubmissionPartyXref__c>();
      List<tffa__SubmissionPartyXref__c> subPartyList = submission.tffa__PartyXrefs__r;
      /**
       * set status incomplete in subpartyXref
       */
      for (tffa__SubmissionPartyXref__c subPartyXref : subPartyList) {
        if (subPartyXref.tffa__Type__c == 'INDIVIDUAL' && !subPartyXref.tffa__IsPresent__c) {
          subPartyXref.tffa__Status__c = 'INCOMPLETE';
          subPartyXrefList.add(subPartyXref);
        }
      }
      tffa.Logger.debug('8786548 we are inside post submission method');
      CZWTFCPartyRepository.saveSubPartyXref(subPartyXrefList);
      return submission;
    } catch (Exception e) {
      tffa.Logger.debug(
        'Exception in postsave = ' +
        e.getStackTraceString() +
        ' -> Message :' +
        e.getMessage() +
        'Line ::: ' +
        e.getLineNumber()
      );
    } finally {
      tffa.Interaction.close();
    }
    return submission;
  }

  global boolean processSub(tffa__Submission__c sub) {
    tffa.Logger.debug('tetsttt ' + sub.tffa__Status__c);
    List<tffa__Application__c> appObjs = CZWTFCApplicationRepository.findApplicationWithChildObjsBySubId(sub);
    List<String> appStatus = new List<String>{
      CZWTFCConstants.ACCOUNT_OPENED,
      CZWTFCConstants.ABANDONED,
      CZWTFCConstants.CANCELLED,
      CZWTFCConstants.SAVED,
      CZWTFCConstants.FUNDED
    };
    List<String> fundingStatus = new List<String>{ 'VERIFIED', 'AUTOMATICALLY_VERIFIED' };
    Boolean allPartiesPresent = true;

    try {
      for (tffa__SubmissionPartyXref__c partyXref : sub.tffa__PartyXrefs__r) {
        if (!partyXref.tffa__IsPresent__c) {
          allPartiesPresent = false;
        }
      }

      if (appObjs != null && appObjs.size() > 0) {
        for (tffa__Application__c appObj : appObjs) {
          if (
            appObj.tffa__KYCDecisionOutcome__c != null &&
            appObj.tffa__KYCDecisionOutcome__c.equalsIgnoreCase('APPROVED') &&
            !appStatus.contains(appObj.tffa__Status__c) &&
            allPartiesPresent
          ) {
            if (appObj.tffa__LinkedFundingRequests__r != null && !appObj.tffa__LinkedFundingRequests__r.isEmpty()) {
              if (
                fundingStatus.contains(appObj.tffa__LinkedFundingRequests__r[0].tffa__VerificationStatus__c) ||
                appObj.tffa__LinkedFundingRequests__r[0].tffa__Type__c != CZWTFCConstants.FUNDING_TYPE_ACH
              ) {
                return true;
              }
            } else {
              return true;
            }
          }
        }
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in checking application and funding status:: ' + ex.getStackTraceString());
    }
    return false;
  }

  /**
   * Called after modifying submission entity
   *
   * @see SubmissionService.createOrUpdateParties
   * @param parties An instance of SubmissionPartyXref__c
   * @returns `List<SubmissionPartyXref__c>`
   */
  global override List<tffa__SubmissionPartyXref__c> postCreateOrUpdateParties(List<tffa__SubmissionPartyXref__c> parties) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'postCreateOrUpdateParties');
    try {
      Integer idx = 1;
      List<String> rejectedProd = new List<String>();
      CZWTFCSubmissionServiceExt subServiceExt = new CZWTFCSubmissionServiceExt();
      List<tffa__ProductMatrix__c> prodMatrixList = CZWTFCProductRepository.getAllProductsMatrix();
      List<tffa__Party__c> partyLst = new List<tffa__Party__c>();

      String errorMessage = '';

      tffa__Submission__c subObj = CZWTFCApplicationRepository.findSubmissionById(parties[0].tffa__Submission__c);

      List<tffa__Application__c> applicationList = FISCCIntegrationLogRepository.findApplicationWithChildObjects(
        subObj.tffa__Applications__r
      );

      for (tffa__Application__c appObj : applicationList) {
        if (!appObj.tffa__IsDeleted__c) {
          //fetch valid prodList
          List<tffa__ProductMatrix__c> validProdList = subServiceExt.getMatrixByprodCode(
            prodMatrixList,
            appObj.tffa__Product__c,
            appObj.tffa__Brand__c
          );

          if (!parties[0].tffa__IsDeleted__c) {
            boolean throwError = true;
            tffa__Party__c partyObj = parties[0].tffa__Party__r;
            String zipCode = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__ZipCode__c;
            String updatedZipcode = '';
            if (zipCode.length() > 5) {
              updatedZipcode = zipCode.substring(0, 5);
            } else {
              updatedZipcode = zipCode;
            }

            String stateCode = partyObj.tffa__AddressXrefs__r[0].tffa__Address__r.tffa__State__c;

            for (tffa__ProductMatrix__c prod : validProdList) {
              if (String.isNotBlank(prod.ZipCodeSet__c) && String.isNotBlank(prod.StateCodeSet__c)) {
                if ((prod.ZipCodeSet__c).contains(updatedZipcode) && (prod.StateCodeSet__c).contains(stateCode)) {
                  throwError = false;
                  break;
                }
              } else if (String.isNotBlank(prod.StateCodeSet__c)) {
                if ((prod.StateCodeSet__c).contains(stateCode)) {
                  throwError = false;
                  break;
                }
              } else {
                throwError = false;
                break;
              }
            }

            if (throwError) {
              errorMessage = errorMessage + idx + ') ' + parties[0].Name + ' is not eligible for Product ' + appObj.Name + '.  \r\n';
              idx++;
              if (!rejectedProd.contains(appObj.Name)) {
                rejectedProd.add(appObj.Name);
              }
            }
          }
        }
      }

      throwError(errorMessage, rejectedProd);

      //to check if duplicate SSN is added for Joint applicant in Joint not present Flow
      List<String> partySSNLst = new List<String>();
      for (tffa__SubmissionPartyXref__c subParty : subObj.tffa__PartyXrefs__r) {
        if (!partySSNLst.contains(subParty.tffa__Party__r.tffa__NationalIdentifierValue__c)) {
          partySSNLst.add(subParty.tffa__Party__r.tffa__NationalIdentifierValue__c);
        } else {
          throw new tffa.ApplicationException('CANNOT ADD 2 APPLICANTS WITH SAME SSN.');
        }
        partyLst.add(subParty.tffa__Party__r);
      }

      // Update Embossed Name for Party in Joint not present Flow
      updateEmbossedName(partyLst);

      return parties;
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Called after starting a submission
   *
   * @see SubmissionService.start
   * @param submission An instance of submission entity
   * @param facts additional information provided when starting the submission, this can be `partyId`, `channel`, etc
   * @return `Submission__c`
   */
  global override tffa__Submission__c postStart(tffa__Submission__c submission, Map<String, Object> facts) {
    tffa.Interaction.begin(CZWTFCSubmissionServiceExt.class, 'postStart');
    try {
      tffa.Logger.debug('facts ' + facts);
      // if (this.delegate != null) {
      //   return this.delegate.postStart(submission, facts);
      // }
      return doStartSub(submission, facts);
    } finally {
      tffa.Interaction.close();
    }
  }

  private tffa__Submission__c doStartSub(tffa__Submission__c sub, Map<String, Object> facts) {
    tffa__Party__c party;

    //setting the brand
    String brand = (String) facts.get('brand');
    if (brand != null) {
      sub.tffa__Brand__c = brand;
    }

    //setting the channel
    String channel = (String) facts.remove('channel');
    if (channel != null) {
      sub.tffa__CreatedChannel__c = channel;
    }

    if (sub.tffa__CreatedChannel__c == null && RestContext.request != null) {
      sub.tffa__CreatedChannel__c = 'DIGITAL';
      sub.tffa__Channel__c = 'DIGITAL';
    }

    if (facts.containsKey('partyId')) {
      CZWTFCAuthResponse authResp = CZWTFCAuthenticationService.verifyUser(getPartySearchMapRequest(sub, facts));
      tffa.Logger.debug('authResp ' + authResp);
      if (authResp.custInfo.FirstName == null && authResp.custInfo.LastName == null && !Test.isRunningTest()) {
        throw new tffa.ApplicationException('Information not available. Please try again after some time');
      } else {
        sub.CZAuthenticationMethod__c = 'OLB_AUTHENTICATION';
      }
      List<tffa__Party__c> partyLst = parseSearchResponse(authResp);

      if (partyLst != null && partyLst.size() > 0) {
        party = partyLst[0];
        sub = tffa.SubmissionService.addParty(sub, party, true, true);
      }
    } else {
      //throw new IllegalArgumentException('Invalid Request Parameters');
    }

    sub = tffa.SubmissionService.create(sub);

    if (facts.get('promotionCode') != null) {
      String promotionCode = (String) facts.remove('promotionCode');
      sub = tffa.SubmissionService.applyPromotion(sub, promotionCode);
    } else if (facts.get('bundleCode') != null) {
      String bundleCode = (String) facts.remove('bundleCode');
      sub = tffa.SubmissionService.addBundle(sub, bundleCode);
    } else if (facts.get('productCode') != null) {
      tffa.SObjectAssembler subAssembler = new tffa.SObjectAssembler(sub);
      String recommendationId = (String) facts.remove('recommendationId');
      for (String productCode : ((String) facts.remove('productCode')).split(',')) {
        subAssembler.addChildObject(
          'Applications__r',
          new tffa__Application__c(tffa__ProductCode__c = productCode, tffa__RecommendationId__c = recommendationId)
        );
      }
      sub = (tffa__Submission__c) subAssembler.assemble();
    }

    sub = tffa.SubmissionService.modify(sub);
    // read submission only
    sub = CZWTFCSubmissionRepository.findOne(sub.Id);
    //tffa.SubmissionService.setUrl(sub, facts);
    PageReference pageRef = new PageReference('/apex/sales');
    Map<String, Object> params = pageRef.getParameters();
    params.put('id', sub.Id);
    // String brandCode = brand !=null ? (String) facts.get('brand') : '380';

    String baseUrl = RestContext.request == null
      ? URL.getSalesforceBaseUrl().toExternalForm()
      : tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c;

    sub.tffa__Url__c = baseUrl + pageRef.getUrl();
    return sub;
  }

  /**
   * Generate party Search Request
   */
  private static Map<String, String> getPartySearchMapRequest(tffa__Submission__c sub, Map<String, Object> mp) {
    Map<String, String> params = new Map<String, String>();
    params.put('D3Login', 'D3Login');
    params.put('authType', 'ind-4');
    params.put('method', 'DP_ACCOUNT');
    String brand = mp.containsKey('brand') ? (String) mp.get('brand') : '380';
    params.put('brandCode', brand);
    params.put('channel', 'DIGITAL');
    String partyId = mp.containsKey('partyId') ? (String) mp.get('partyId') : null;
    params.put('mdmPartyId', partyId);
    return params;
  }

  @TestVisible
  private static List<tffa__Party__c> parseSearchResponse(CZWTFCAuthResponse authResp) {
    tffa.Logger.debug('Parse CZWTFCAuthResponse ' + authResp);
    tffa__Party__c partyObj = new tffa__Party__c();
    try {
      //Set Party Details
      partyObj.CZMDMPartyID__c = authResp.globalCustomerId;
      partyObj.tffa__FirstName__c = authResp.custInfo.FirstName;
      partyObj.tffa__LastName__c = authResp.custInfo.LastName;
      partyObj.tffa__MiddleName__c = authResp.custInfo.MiddleName;
      partyObj.tffa__Suffix__c = authResp.custInfo.Suffix;
      partyObj.IsOLBEnrolled__c = 'Y';

      if (authResp.custInfo.DateOfBirth != null) {
        partyObj.tffa__BirthDate__c = Date.valueOf(authResp.custInfo.DateOfBirth);
      }
      partyObj.tffa__NationalIdentifierValue__c = authResp.custInfo.SSN;
      partyObj.tffa__NationalIdentifierType__c = 'SSN';
      partyObj.CellPhoneNumber__c = authResp.custInfo.CellPhoneNo;
      if (authResp.custInfo.HomePhoneNo != null) {
        partyObj.PreferredContactNumber__c = 'HOME';
      } else if (authResp.custInfo.CellPhoneNo != null) {
        partyObj.PreferredContactNumber__c = 'CELL';
      } else if (authResp.custInfo.OfficePhoneNo != null) {
        partyObj.PreferredContactNumber__c = 'WORK';
      }
      partyObj.IsPhoneNumberMissing__c = authResp.custInfo.IsPhoneNumberMissing;
      partyObj.IsEmailIdMissing__c = authResp.custInfo.IsEmailIdMissing;
      partyObj.IsAuthenticatedCustomer__c = true;
      partyObj.tffa__PrimaryPhone__c = authResp.custInfo.HomePhoneNo;
      partyObj.tffa__SecondaryPhone__c = authResp.custInfo.OfficePhoneNo;
      partyObj.tffa__PrimaryEmail__c = authResp.custInfo.EmailId;
      partyObj.tffa__Citizenship__c = authResp.custInfo.Citizenship;
      partyObj.Customer_Number__c = authResp.custInfo.CISNumber;
      partyObj.IsCrossCharterCustomer__c = authResp.custInfo.IsCrossCharterCustomer != null
        ? Boolean.valueOf(authResp.custInfo.IsCrossCharterCustomer)
        : null;
      partyObj.IsExceptionPlanRequired__c = authResp.custInfo.IsExceptionPlanRequired != null
        ? Boolean.valueOf(authResp.custInfo.IsExceptionPlanRequired)
        : null;
      partyObj.tffa__IsExistingCustomer__c = authResp.custInfo.IsExistingCustomer != null
        ? Boolean.valueOf(authResp.custInfo.IsExistingCustomer)
        : null;
      List<tffa__Party__c> partyLst = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
      tffa.SObjectAssembler asm = new tffa.SObjectAssembler(partyLst[0]);

      //Set address Details
      tffa__Address__c addressObj = new tffa__Address__c();
      addressObj.tffa__Line1__c = authResp.custInfo.AddressLineOne;
      addressObj.tffa__Line2__c = authResp.custInfo.AddressLineTwo;
      addressObj.tffa__State__c = authResp.custInfo.State;
      addressObj.tffa__City__c = authResp.custInfo.City;
      addressObj.tffa__ZipCode__c = authResp.custInfo.ZipCode;
      addressObj.tffa__Country__c = 'US';
      List<tffa__Address__c> addressObjLst = CZWTFCHelperRepository.doUpsertaddress(addressObj);

      //Set Party Address Details
      tffa__PartyAddressXref__c partyAddressObj = new tffa__PartyAddressXref__c();
      partyAddressObj.tffa__Type__c = 'Home';
      partyAddressObj.tffa__Address__r = addressObjLst[0];
      partyAddressObj.tffa__Address__c = addressObjLst[0].Id;
      partyAddressObj.tffa__Party__c = partyLst[0].Id;
      List<tffa__PartyAddressXref__c> partyAddObjLst = CZWTFCHelperRepository.doUpsertPartyaddress(partyAddressObj);
      tffa.Logger.debug('addressObj ' + addressObjLst[0]);
      tffa.Logger.debug('updatedPartyAddressObj ' + partyAddObjLst[0].tffa__Address__r);
      asm.addChildObjects('tffa__AddressXrefs__r', new List<tffa__PartyAddressXref__c>{ partyAddObjLst[0] });

      //Set Identity Details
      try {
        List<tffa__Identification__c> identityObjLst = new List<tffa__Identification__c>();
        for (CZWTFCAuthResponse.IdentificationDetails identityObj : authResp.custInfo.identificationDetails) {
          tffa__Identification__c identification = new tffa__Identification__c();
          identification.tffa__IssuingState__c = identityObj.IssuingStateCode;
          identification.tffa__IdentificationNumber__c = identityObj.IdentificationNumber;
          if (identityObj.ExpirationDate != null) {
            identification.tffa__ExpirationDate__c = Date.valueOf(identityObj.ExpirationDate);
          }
          if (identityObj.IssueDate != null) {
            try {
              Date issueDate = Date.valueOf(identityObj.IssueDate);
              if (partyObj.tffa__BirthDate__c != null && issueDate > partyObj.tffa__BirthDate__c) {
                identification.tffa__IssueDate__c = issueDate;
              }
            } catch (Exception ex) {
              tffa.Logger.debug('Parsing failed for Issue date ' + ex.getMessage());
            }
          }
          identification.tffa__Party__c = partyLst[0].id;
          identification.tffa__Type__c = identityObj.IdentificationType;
          identityObjLst.add(identification);
        }
        identityObjLst = CZWTFCHelperRepository.doUpsertIdentification(identityObjLst);
        asm.addChildObjects('tffa__Identifications__r', identityObjLst);
      } catch (Exception ex) {
        tffa.Logger.debug('Excep during processing Identification in auth flow ' + ex.getMessage());
      }
      //Set Emp Details
      try {
        List<tffa__Employment__c> empLst = new List<tffa__Employment__c>();
        tffa__Employment__c emp = new tffa__Employment__c();
        emp.tffa__EmployerName__c = authResp.custInfo.EmployeeName;
        if (authResp.custInfo.EmploymentStatusCode != null) {
          emp.Name = authResp.custInfo.EmploymentStatusCode;
          emp.tffa__Type__c = authResp.custInfo.EmploymentStatusCode;
        }
        if (authResp.custInfo.OccupationCode != null) {
          emp.tffa__Occupation__c = authResp.custInfo.OccupationCode;
        }
        if (authResp.custInfo.Title != null) {
          emp.tffa__Title__c = authResp.custInfo.Title;
        }
        emp.tffa__Party__c = partyLst[0].id;
        empLst = CZWTFCHelperRepository.doUpsertEmployment(new List<tffa__Employment__c>{ emp });
        asm.addChildObject('tffa__Employments__r', empLst[0]);
      } catch (Exception ex) {
        tffa.Logger.debug('Excep during processing employemnt in auth flow ' + ex.getMessage());
      }
      //Party Obj Assembler
      tffa__Party__c updatedPartyObj = (tffa__Party__c) asm.assemble();
      tffa.Logger.debug('updatedPartyObj ' + updatedPartyObj);
      return new List<tffa__Party__c>{ updatedPartyObj };
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCAuthResponse ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return new List<tffa__Party__c>{ partyObj };
  }

  public static void throwError(String errorMessage, List<String> rejectedProd) {
    if (!String.isBlank(errorMessage)) {
      tffa.Logger.debug('Detail Product Eligibilty Error ---> ' + errorMessage);
      if (rejectedProd.size() < 2) {
        throw new tffa.ApplicationException('THE ACCOUNT YOU ARE ATTEMPTING TO APPLY FOR IS NOT AVAILABLE IN YOUR AREA.');
      } else {
        throw new tffa.ApplicationException('THE ACCOUNTS YOU ARE ATTEMPTING TO APPLY FOR ARE NOT AVAILABLE IN YOUR AREA.');
      }
    }
  }

  public static void checkDuplicateProduct(List<tffa__Application__c> appList) {
    List<String> prodCodeList = new List<String>();
    for (tffa__Application__c appObj : appList) {
      if (!prodCodeList.contains(appObj.tffa__ProductCode__c)) {
        prodCodeList.add(appObj.tffa__ProductCode__c);
      } else {
        throw new tffa.ApplicationException('PLEASE, REMOVE DUPLICATE PRODUCT FROM THE PRODUCT CART.');
      }
    }
  }

  public static void updateEmbossedName(List<tffa__Party__c> partyLst) {
    try {
      List<tffa__AccountPreference__c> updatedAccPrefLst = new List<tffa__AccountPreference__c>();
      List<tffa__AccountPreference__c> accPrefLst = CZWTFCHelperRepository.fetchAccountPrefByType(partyLst, CZWTFCConstants.DEBIT_CARD);

      for (tffa__Party__c partyObj : partyLst) {
        for (tffa__AccountPreference__c accPref : accPrefLst) {
          if (partyObj.Id == accPref.tffa__Party__c) {
            String suffix = partyObj.tffa__Suffix__c != null ? partyObj.tffa__Suffix__c : '';
            accPref.tffa__EmbossedName__c = CZWTFCCommonHelper.getFormattedFullName(
              partyObj.tffa__FirstName__c,
              partyObj.tffa__MiddleName__c,
              partyObj.tffa__LastName__c,
              suffix,
              FISCCIntegrationConstants.EMBOSSED_NAME_LENGTH
            );
            updatedAccPrefLst.add(accPref);
          }
        }
      }
      CZWTFCHelperRepository.saveAccountPref(updatedAccPrefLst);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in updating Embossed Name: ' + ex.getStackTraceString());
    }
  }
}