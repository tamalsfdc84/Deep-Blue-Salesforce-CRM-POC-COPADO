public with sharing class FISCCCEBEnrollmentService {
  @TestVisible
  private static boolean testException = false;
  public Map<String, Object> enrollForOLB(Map<String, String> params) {
    final String invaildResponseMessage = 'Enrollment failed';
    final String nullResponseMessage = 'NULL Response recieved';
    final String invalidPartyMessage = 'Party not found';
    final String invalidParamsMessage = 'Null parameter value recieved for partyID or userName or password';
    Map<String, Object> result;
    String partyID = params.get('partyID');
    String userName = params.get('userName');
    String password = params.get('password');
    List<String> errMsg = new List<String>();
    String resultJson;
    String message;
    String status;
    String addPrefStatus;
    String subId;
    Object responseResult;
    tffa__AdditionalPreference__c addPrefObj;

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (partyID != null && userName != null && password != null) {
        tffa__party__c partyObj = CZWTFCPartyRepository.findByIdWithChildObjects(partyID);
        tffa.logger.debug('inside enrollForOLB partyObj ==>' + partyObj);
        if (partyObj != null) {
          subId = CZWTFCPartyRepository.findSubPartyById(partyID).tffa__Submission__c;
          FISCCIntegrationLogService.setSubmissionObj(subId);
          //          FISCCIntegrationLogService.setPartyObjs();
          FISCCIntegrationLogService.setIntegrationLog(subId);
          //      FISCCIntegrationLogService.setApplicationObjs();
          FISCCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CEB_ENROLLMENT + partyObj.Name);
          FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.CEB_ENROLLMENT, partyObj.Name, false);
          addPrefObj = getOLBAddPrefObj(partyObj.tffa__AdditionalPreferences__r);

          if (
            addPrefObj != null &&
            !addPrefObj.tffa__Status__c.equals(CZWTFCConstants.ADDON_STATUS_COMPLETED) &&
            FISCCIntegrationLogService.isLogNewOrFailed(FISCCIntegrationConstants.CEB_ENROLLMENT + partyObj.Name)
          ) {
            responseResult = FISCCCEBEnrollmentProvider.CEBEnroll(partyObj, userName, password);
            tffa.logger.debug('inside enrollForOLB CEBEnroll result  ==>' + responseResult);
            if (responseResult != null) {
              if (responseResult instanceof FISCCTransactionResponseBaseDTO) {
                resultJson = JSON.serialize(responseResult);
                FISCCCEBEnrollmentResponseDTO response = (FISCCCEBEnrollmentResponseDTO) System.JSON.deserialize(
                  resultJson,
                  FISCCCEBEnrollmentResponseDTO.class
                ); //JSON.deserializeUntyped(resultJson);
                Integer msgLstSize = response.Metadata.MsgLst.size();
                for (Integer i = 0; i < msgLstSize; i++) {
                  errMsg.add(response.Metadata.MsgLst[i].Text);
                  if (response.Metadata.MsgLst[i].Severity.equals('Error')) {
                    status = CZWTFCConstants.PROCESS_STATUS_FAILURE;
                    // updating status as COMPLETED to skip view in UI
                    addPrefStatus = CZWTFCConstants.ADDON_STATUS_FAILED;
                  } else {
                    status = CZWTFCConstants.PROCESS_STATUS_SUCCESS;
                    // updating status as COMPLETED to skip view in UI
                    addPrefStatus = CZWTFCConstants.ADDON_STATUS_COMPLETED;
                    partyObj.CZIsOLBEnrollCompleted__c = true;
                  }
                }
                addPrefObj.tffa__Status__c = addPrefStatus;
                CZWTFCPartyRepository.saveAddPreferences(new List<tffa__AdditionalPreference__c>{ addPrefObj });
                WTFCObjectManagerRepository.doUpsertObject(partyObj);
                message = String.join(errMsg, ', ');
                if ((CZWTFCConstants.PROCESS_STATUS_SUCCESS).equalsIgnoreCase(status)) {
                  FISCCIntegrationLogService.setLogOk(FISCCIntegrationConstants.CEB_ENROLLMENT_SUCCESS);
                  FISCCIntegrationLogService.setLogItemOk(
                    FISCCIntegrationConstants.CEB_ENROLLMENT,
                    FISCCIntegrationConstants.CEB_ENROLLMENT_SUCCESS
                  );

                  List<tffa__Application__c> applicationList = new List<tffa__Application__c>();
                  for (tffa__ApplicationPartyXref__c applicationParty : partyObj.tffa__Applications__r) {
                    tffa__Application__c app = CZWTFCApplicationRepository.findApplicationById(
                      String.valueOf(applicationParty.tffa__Application__c)
                    );
                    if (app.FCMUploadStatus__c == CZWTFCConstants.PROCESS_STATUS_SUCCESS) {
                      app.FCMUploadStatus__c = 'MORE_INFO';
                      if (app.FCMUploadRetryCount__c >= 5) {
                        app.FCMUploadRetryCount__c--;
                      }
                    }

                    applicationList.add(app);
                  }

                  CZWTFCApplicationRepository.save(applicationList);
                } else {
                  FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CEB_ENROLLMENT_FAILURE);
                  FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CEB_ENROLLMENT, message);
                }
                result = new Map<String, Object>{ 'Status' => status, 'StatusMessage' => message };
              } else if (responseResult instanceof Map<String, Object>) {
                Map<String, Object> errorMessage = (Map<String, Object>) responseResult;
                if (errorMessage.containsKey('StatusMessage')) {
                  result = new Map<String, Object>{ 'Status' => status, 'StatusMessage' => errorMessage.get('StatusMessage') };
                } else {
                  result = new Map<String, Object>{ 'Status' => status, 'StatusMessage' => invaildResponseMessage };
                }
              } else {
                // hostAdapter failure responses
                tffa.Logger.debug('HostAdapter response in FISCCCEBEnrollmentService : ' + responseResult);
                result = new Map<String, Object>{
                  'Status' => CZWTFCConstants.PROCESS_STATUS_FAILURE,
                  'StatusMessage' => invaildResponseMessage
                };
                FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CEB_ENROLLMENT_FAILURE);
                FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CEB_ENROLLMENT);
              }
            } else {
              result = new Map<String, Object>{ 'Status' => status, 'StatusMessage' => invaildResponseMessage };
              FISCCIntegrationLogService.setLogFailed(FISCCIntegrationConstants.CEB_ENROLLMENT_FAILURE);
              FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.CEB_ENROLLMENT, nullResponseMessage);
            }
          } else {
            result = new Map<String, Object>{
              'Status' => CZWTFCConstants.PROCESS_STATUS_FAILURE,
              'StatusMessage' => 'User Already Enrolled'
            };
          }
        } else {
          result = new Map<String, Object>{ 'Status' => CZWTFCConstants.PROCESS_STATUS_FAILURE, 'StatusMessage' => invalidPartyMessage };
        }
      } else {
        result = new Map<String, Object>{ 'Status' => CZWTFCConstants.PROCESS_STATUS_FAILURE, 'StatusMessage' => invalidParamsMessage };
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in FISCCCEBEnrollmentService : ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return result;
    } finally {
      FISCCIntegrationLogService.persistIntegationLogs();
    }
    return result;
  }

  private static tffa__AdditionalPreference__c getOLBAddPrefObj(List<tffa__AdditionalPreference__c> addPrefLst) {
    tffa__AdditionalPreference__c addPref;
    for (tffa__AdditionalPreference__c aPref : addPrefLst) {
      if ((FISCCIntegrationConstants.ADDON_OLB_TYPE).equals(aPref.tffa__AddOnServiceType__c)) {
        addPref = aPref;
      }
    }
    return addPref;
  }
}