/**
 * Copyright (c) 2020 Terafina Inc
 * @group  Provider
 * @description Override the package default functionalities for due diligence
 **/

global with sharing class CZWTFCIDAServiceProvider extends tffa.DueDiligenceServiceProvider {
  /**
   * @description
   * @param tffa__Party__c partyObj
   * @param Map<String Object> params
   * @return List<tffa__Party__c>
   **/
  private List<tffa__Application__c> apps;
  global override List<tffa__Party__c> verify(List<tffa__Party__c> parties, Map<String, Object> params) {
    /*  tffa.Logger.debug('In CZWTFCIDAServiceProvider Verify');
    Boolean skipDSS = false;
    Boolean saveIDA = false;
    Boolean saveVerifyIDA = false;
    Boolean saveIDV = false;
    Boolean isStudent = false;
    Boolean doIDV = false;
    Boolean isStudProd = false;
    Boolean isAuthKycRequired = false;

    FISIDAResponseDTO idaResp;
    FISIDVResponseDTO idvResp;

    List<tffa__Party__c> partyList;
    List<tffa__Party__c> partyDetailList = new List<tffa__Party__c>();
    List<String> ids = new List<String>();
    tffa__DueDiligence__c dueDiligenceVerify;

    try {
      FISCCIntegrationLogService.setSubmissionObj((String) params.get('Submission__c'));

      if (parties[0].tffa__DueDiligences__r != null && !parties[0].tffa__DueDiligences__r.isEmpty()) {
        for (tffa__DueDiligence__c dd : parties[0].tffa__DueDiligences__r) {
          if (dd.tffa__Type__c.equals('IDA')) {
            dueDiligenceVerify = dd;
          }
        }
      }

      for (tffa__Party__c party : parties) {
        ids.add(party.Id);
      }

      parties = CZWTFCPartyRepository.findAllPartiesByIds(ids);
      FISCCIntegrationLogService.setIntegrationLog(
        (String) params.get('Submission__c'),
        parties[0].Name +
        '-' +
        FISCCIntegrationConstants.CUSTOMER_API_INQUIRES
      );
      FISCCIntegrationLogService.setCurrentLog(parties[0].Name + '-' + FISCCIntegrationConstants.CUSTOMER_API_INQUIRES);

      if (parties[0].tffa__IDAStatus__c == null || !parties[0].tffa__IDAStatus__c.equalsIgnoreCase('CHALLENGED')) {
        if (!parties[0].IsAuthenticatedCustomer__c) {
          parties[0].tffa__IsExistingCustomer__c = false;
          parties[0].IsCrossCharterCustomer__c = false;
          parties[0].IsExceptionPlanRequired__c = true;
          parties[0].Customer_Number__c = '';
          parties[0].CZMDMPartyID__c = '';
          parties[0].IsOLBEnrolled__c = 'F';
          parties[0].FISDob__c = '';
          parties[0].FISLastName__c = '';
          parties[0] = searchCustomerInMDM(parties[0]);
        }

        if (parties[0].tffa__IsExistingCustomer__c) {
          parties[0] = FISCCDepositOriginationExtension.fetchContactEffDate(parties[0]);
          parties[0] = FISCCDepositOriginationExtension.FetchCustomerInfo(parties[0]);
        }

        /*FISCCCustomerSearchTaxnbrProvider.processSearchByTaxbr((String) params.get('Submission__c'), parties[0]);
        //FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.SEARCH_CUSTOMER);

        if (parties[0].tffa__IsExistingCustomer__c) {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.SEARCH_CUSTOMER);
        } else {
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.SEARCH_CUSTOMER);
        }*

        for (tffa__Party__c party : parties) {
          if ((party.tffa__IsExistingCustomer__c || party.IsCrossCharterCustomer__c) && !party.IsAuthenticatedCustomer__c) {
            try {
              CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OLB_CHECK, parties[0].name, true);
              if (CZWTFCOLBEnrollmentCheckService.checkIfOLBIsEnrolled(party.CZMDMPartyID__c)) {
                party.IsOLBEnrolled__c = 'Y';
                CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OLB_CHECK);
              } else {
                party.IsOLBEnrolled__c = 'N';
                CZWTFCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.OLB_CHECK);
              }
            } catch (Exception ex) {
              tffa.Logger.error('In IDA Service Provider OLB ' + ex.getMessage() + ' ' + ex.getStackTraceString());
              party.IsOLBEnrolled__c = 'F';
              CZWTFCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.OLB_CHECK);
            }
          }
          // party.tffa__IDAStatus__c = 'PASSED';
        }
      }

      //--------------------------------------FIS DSS------------------------------------------------------------//
      tffa.Logger.debug('Processing DSS');

      tffa__Party__c detailedParty = CZWTFCPartyRepository.findByIdWithChildObjects(parties[0].Id);
      tffa__Employment__c emp = CZWTFCPartyRepository.findEmploymentByPartyID(detailedParty.Id);
      tffa__Submission__c sub = CZWTFCSubmissionRepository.findSubWithProdById(detailedParty.Id);
      tffa__SubmissionPartyXref__c subParty = CZWTFCPartyRepository.findSubPartyById(detailedParty.Id);
      Boolean idUploaded = false;

      if (
        detailedParty.tffa__Identifications__r != null &&
        detailedParty.tffa__Identifications__r.size() > 0 &&
        detailedParty.tffa__Identifications__r[0] != null
      ) {
        if (
          !String.isBlank(detailedParty.tffa__Identifications__r[0].tffa__FrontPhotoId__c) ||
          !String.isBlank(detailedParty.tffa__Identifications__r[0].tffa__BackPhotoId__c)
        ) {
          idUploaded = true;
        }
      }

      detailedParty.tffa__IsExistingCustomer__c = parties[0].tffa__IsExistingCustomer__c;
      detailedParty.Customer_Number__c = parties[0].Customer_Number__c;
      detailedParty.IsOLBEnrolled__c = parties[0].IsOLBEnrolled__c;
      detailedParty.FISDob__c = parties[0].FISDob__c;
      detailedParty.FISLastName__c = parties[0].FISLastName__c;
      detailedParty.IsCrossCharterCustomer__c = parties[0].IsCrossCharterCustomer__c;
      detailedParty.IsExceptionPlanRequired__c = parties[0].IsExceptionPlanRequired__c;
      detailedParty.CZMDMPartyID__c = parties[0].CZMDMPartyID__c;
      detailedParty.CZFisHomeNbr__c = parties[0].CZFisHomeNbr__c;
      detailedParty.CZFisWorkNbr__c = parties[0].CZFisWorkNbr__c;
      detailedParty.CZFisCellNbr__c = parties[0].CZFisCellNbr__c;
      detailedParty.CZFisEmail__c = parties[0].CZFisEmail__c;
      detailedParty.CZFisCustCodes__c = parties[0].CZFisCustCodes__c;
      detailedParty.CZFisHomeNbrEffDt__c = parties[0].CZFisHomeNbrEffDt__c;
      detailedParty.CZFisWorkNbrEffDt__c = parties[0].CZFisWorkNbrEffDt__c;
      detailedParty.CZFisCellNbrEffDt__c = parties[0].CZFisCellNbrEffDt__c;
      detailedParty.CZFisEmailEffDt__c = parties[0].CZFisEmailEffDt__c;

      if (detailedParty.tffa__isMinor__c || (detailedParty.IsAuthenticatedCustomer__c && !detailedParty.IsKYCRequired__c)) {
        skipDSS = true;
      }

      //to check if it's a cust/stud product
      if (!skipDSS && sub.tffa__Applications__r != null) {
        for (tffa__Application__c app : sub.tffa__Applications__r) {
          if (app.tffa__Product__r.IsCustodianProduct__c && subParty.tffa__Primary__c) {
            skipDSS = true;
          }
          if (app.tffa__Product__r.IsStudentProduct__c) {
            isStudProd = true;
          }
        }
      }

      if (!skipDSS) {
        if (
          emp != null &&
          emp.tffa__Type__c != null &&
          emp.tffa__Type__c.equalsIgnoreCase('STUDENT') &&
          isStudProd &&
          subParty.tffa__Primary__c
        ) {
          isStudent = true;
          doIDV = true;
        }

        if (detailedParty.IsAuthenticatedCustomer__c && detailedParty.IsKYCRequired__c) {
          doIDV = true;
          isAuthKycRequired = true;
        }
      }

      if (
        !skipDSS &&
        !isStudent &&
        !isAuthKycRequired &&
        (String.isBlank(detailedParty.tffa__IDAStatus__c) || !detailedParty.tffa__IDAStatus__c.equalsIgnoreCase('CHALLENGED'))
      ) {
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS, parties[0].name, true);
        idaResp = FISIDAProvider.fetchOOWQuestions(detailedParty);
        saveIDA = true;
        if (idaResp == null) {
          saveIDA = false;
          detailedParty.IsDobMatch__c = false;
          detailedParty.IsSsnMatch__c = false;
          detailedParty.tffa__IDAStatus__c = 'FAILED';
          if (idUploaded) {
            doIDV = true;
          }
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS);
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS_FAILURE);
        } else {
          if (idaResp.errorCd != null && !String.isBlank(idaResp.errorCd)) {
            if (idUploaded) {
              doIDV = true;
            }
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS);
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS_FAILURE);
          } else if (idaResp.idaQuestion1 == null) {
            saveIDA = false;
            detailedParty.IsDobMatch__c = false;
            detailedParty.IsSsnMatch__c = false;
            if (idUploaded) {
              doIDV = true;
            }
            detailedParty.tffa__IDAStatus__c = 'FAILED';
            FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS);
            FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.FETCH_OOW_QUESTIONS_FAILURE);
          } else {
            FISCCIntegrationLogService.setLogItemOk(
              FISCCIntegrationConstants.FETCH_OOW_QUESTIONS,
              FISCCIntegrationConstants.FETCH_OOW_QUESTIONS_SUCCESS
            );
          }
        }
        tffa.Logger.debug('In CZWTFCIDAServiceProvider Verify CheckPoint One');
      } else if (!skipDSS && !isStudent && !isAuthKycRequired && detailedParty.tffa__IDAStatus__c.equalsIgnoreCase('CHALLENGED')) {
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.VERIFY_OOW_QUESTIONS, parties[0].name, true);
        idaResp = FISIDAProvider.verifyOOWQuestions(detailedParty, dueDiligenceVerify);
        FISCCIntegrationLogService.setLogItemOk(
          FISCCIntegrationConstants.VERIFY_OOW_QUESTIONS,
          FISCCIntegrationConstants.VERIFY_OOW_QUESTIONS_SUCCESS
        );

        saveVerifyIDA = true;
        if (idaResp != null && idaResp.decision != null) {
          if (idaResp.decision.equalsIgnoreCase('Pass') || idUploaded) {
            doIDV = true;
          }
        } else {
          saveVerifyIDA = false;
          detailedParty.IsDobMatch__c = false;
          detailedParty.IsSsnMatch__c = false;
          detailedParty.tffa__OFACStatus__c = 'FAILED';
          detailedParty.tffa__DebitBureauStatus__c = 'FAILED';
          detailedParty.tffa__IDVStatus__c = 'FAILED';
          detailedParty.tffa__IDAStatus__c = 'FAILED';
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.VERIFY_OOW_QUESTIONS);
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.VERIFY_OOW_QUESTIONS_FAILURE);
        }
      }

      if (skipDSS) {
        detailedParty.IsDobMatch__c = true;
        detailedParty.IsSsnMatch__c = true;
        detailedParty.tffa__OFACStatus__c = 'PASSED';
        detailedParty.tffa__DebitBureauStatus__c = 'PASSED';
        detailedParty.tffa__IDVStatus__c = 'PASSED';
        detailedParty.tffa__IDAStatus__c = 'PASSED';
      }

      if (isStudent || isAuthKycRequired) {
        detailedParty.tffa__IDAStatus__c = 'PASSED';
      }

      tffa.Logger.debug('In CZWTFCIDAServiceProvider Verify CheckPoint Two');
      if (!skipDSS && doIDV) {
        FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.DO_IDV_VERIFICATION, parties[0].name, true);
        idvResp = FISIDVProvider.doIdentityVerification(detailedParty);
        FISCCIntegrationLogService.setLogItemOk(
          FISCCIntegrationConstants.DO_IDV_VERIFICATION,
          FISCCIntegrationConstants.DO_IDV_VERIFICATION_SUCCESS
        );

        saveIDV = true;
        if (idvResp == null) {
          saveIDV = false;
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.DO_IDV_VERIFICATION);
          FISCCIntegrationLogService.setLogItemMessage(FISCCIntegrationConstants.DO_IDV_VERIFICATION_FAILURE);
        }
      }

      if (saveIDA) {
        FISDSSService.removeExistingDueDiligence(detailedParty, new List<String>{ 'IDA', 'IDV', 'DEBIT_BUREAU', 'OFAC' });

        // try{
        //   CZWTFCHelperRepository.deleteContentDocument(FISDSSService.qualifyReportName('idv_report.html',detailedParty));
        // }catch(Exception){
        //   tffa.Logger.debug('Exception in Delete Existing IDV Report Document '+ex.getMessage()+' '+ex.getStackTraceString());
        // }

        detailedParty = FISDSSService.upsertDueDiligence(detailedParty, idaResp);
      }

      if (saveVerifyIDA) {
        tffa__DueDiligence__c dueDiligence;
        List<tffa__DueDiligence__c> ddList = CZWTFCHelperRepository.getDueDiligenceList(detailedParty.Id);
        if (detailedParty.tffa__IDAStatus__c.equals('CHALLENGED') && ddList != null) {
          for (tffa__DueDiligence__c dd : ddList) {
            if (dd.tffa__Type__c.equals('IDA')) {
              dueDiligence = dd;
            }
          }
        }
        detailedParty = FISDSSService.doAnswersCheckAndBuildDD(detailedParty, idaResp, dueDiligence);
      }

      if (saveIDV) {
        FISDSSService.removeExistingDueDiligence(detailedParty, new List<String>{ 'IDV', 'DEBIT_BUREAU', 'OFAC' });
        detailedParty = FISDSSService.processIDVResult(detailedParty, idvResp);
      }
      tffa.Logger.debug('Adding updated party to Party List after DSS API call');
      partyDetailList.add(detailedParty);
    } catch (Exception ex) {
      tffa.Logger.error(' Exception In IDA Service Provider FIS DSS ' + ex.getMessage() + ' ' + ex.getStackTraceString());
      partyDetailList = parties;
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
    }

    CZWTFCPartyRepository.save(partyDetailList);
    //fetch without dd
    tffa__party__c updatedPartyObj = CZWTFCPartyRepository.findByIdWithChildObjs(partyDetailList[0].Id);
    List<tffa__DueDiligence__c> updatedDDList = CZWTFCHelperRepository.getDueDiligenceList(updatedPartyObj.Id);
    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(updatedPartyObj);
    asm.addChildObjects('DueDiligences__r', updatedDDList);
    partyDetailList.clear();
    partyDetailList.add((tffa__Party__c) asm.assemble());*/
    return parties;
  }

  public static tffa__Party__c searchCustomerInMDM(tffa__Party__c partyObj) {
    /* tffa.Logger.debug('Search Cust in MDM');
    try {
      Map<String, String> params = new Map<String, String>();
      params.put('lstNme', partyObj.tffa__LastName__c);
      params.put('ssnNmb', partyObj.tffa__NationalIdentifierValue__c);
      params.put('brandCode', partyObj.tffa__BrandCode__c);
      params.put('authType', 'ind-3');
      params.put('method', 'CUSTOMER_SEARCH');
      CZWTFCAuthResponse authResp = CZWTFCAuthenticationService.verifyUser(params);
      tffa.Logger.debug('authResp ' + authResp);
      if (String.isNotBlank(authResp.status) && authResp.status.equalsIgnoreCase('success')) {
        if (String.isNotBlank(authResp.custInfo.CISNumber)) {
          partyObj.tffa__IsExistingCustomer__c = authResp.custInfo.IsExistingCustomer;
          partyObj.Customer_Number__c = authResp.custInfo.CISNumber;
        }
        partyObj.IsCrossCharterCustomer__c = authResp.custInfo.IsCrossCharterCustomer;
        partyObj.IsExceptionPlanRequired__c = authResp.custInfo.IsExceptionPlanRequired;
        partyObj.CZMDMPartyID__c = authResp.globalCustomerId;
        partyObj.FISDob__c = authResp.custInfo.DateOfBirth;
        partyObj.FISLastName__c = authResp.custInfo.LastName;
      }
    } catch (Exception ex) {
      tffa.Logger.error(' Exception In IDA Service Provider searchCustomerInMDM ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    }*/
    return partyObj;
  }
}