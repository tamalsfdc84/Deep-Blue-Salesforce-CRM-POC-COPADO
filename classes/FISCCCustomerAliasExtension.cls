public with sharing class FISCCCustomerAliasExtension {
  @TestVisible
  private static boolean testException = false;
  public static boolean invokeAddAliasAPI(tffa__Party__c party) {
    tffa.Logger.debug('In FISCCCustomerAliasProvider.invokeAddAliasAPI ' + party.Id);
    List<String> aliasLst = new List<String>();
    boolean allAliasAdded = true;
    String strDeveloperName = 'CreateAlias';
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      if (!Test.isRunningTest()) {
        adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
          '{CustomerNbr}',
          FISCCCommonHelper.encrypt(party.Customer_Number__c)
        );
      }
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      }
      if (party.CZPartyAliases__r != null && !party.CZPartyAliases__r.isEmpty()) {
        for (CZPartyAlias__c partyAliasObj : party.CZPartyAliases__r) {
          String aliasName = '';
          if (String.isNotBlank(partyAliasObj.AliasFirstName__c)) {
            aliasName = partyAliasObj.AliasFirstName__c;
          }
          if (String.isNotBlank(partyAliasObj.AliasLastName__c)) {
            aliasName = aliasName + partyAliasObj.AliasLastName__c;
          }
          aliasLst.add(aliasName);
        }
      }
      tffa.Logger.debug('aliasLst ' + aliasLst);
      if (!aliasLst.isEmpty()) {
        Integer counter = 1;
        for (String alias : aliasLst) {
          Object result = null;
          Boolean isSuccess = false;
          String aliasLogItemName = FISCCIntegrationLogService.setCurrentLogItem(
            FISCCIntegrationConstants.ALIAS +
            '-' +
            counter +
            '-' +
            party.Name,
            party.Id,
            false
          );
          if (FISCCIntegrationLogService.isLogItemNewOrFailed(aliasLogItemName)) {
            FISCCRequestBaseDTO fisccRequestBaseDTO = generateAliasRequest(alias);
            result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
            isSuccess = parseAliasResponse(result);
            if (isSuccess) {
              FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.ALIAS, FISCCIntegrationConstants.ALIAS_API_CALL_SUCCESS);
            } else {
              allAliasAdded = false;
              FISCCIntegrationLogService.setLogItemFailed(
                FISCCIntegrationConstants.ALIAS,
                FISCCIntegrationConstants.ALIAS_API_CALL_FAILURE
              );
              break;
            }
          }
          counter++;
        }
      }

      if (allAliasAdded) {
        party.CZAllAliasCreated__c = true;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in invokeAddAliasAPI ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return allAliasAdded;
  }

  public static List<String> fetchCustomerAliasSeqNo(tffa__Party__c party) {
    tffa.Logger.debug('In fetchCustomerAliasSeqNo ' + party.Id);
    List<String> aliasSeqLst = new List<String>();
    boolean allAliasAdded = true;
    String strDeveloperName = 'FetchAlias';
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
      if (!Test.isRunningTest()) {
        adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
          '{CustomerNbr}',
          FISCCCommonHelper.encrypt(party.Customer_Number__c)
        );
      }
      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      }

      FISCCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.FETCH_ALIAS + '_' + party.Name, party.Id, true);
      Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, charterConfig);
      aliasSeqLst = parseFetchAliasResponse(result);
      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.ALIAS, FISCCIntegrationConstants.ALIAS_API_CALL_SUCCESS);
      tffa.Logger.debug('aliasSeqLst --> ' + aliasSeqLst);
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in fetchCustomerAliasSeqNo ' + ex.getLineNumber() + ' ' + ex.getMessage());
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ALIAS, FISCCIntegrationConstants.ALIAS_API_CALL_FAILURE);
    }
    return aliasSeqLst;
  }

  public static boolean deleteCustomerAlias(tffa__Party__c party, List<String> aliasSeqList) {
    tffa.Logger.debug('In fetchCustomerAliasSeqNo ' + party.Id);
    List<String> aliasSeqLst = new List<String>();
    boolean allAliasDeleted = true;
    String strDeveloperName = 'DeleteAlias';
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      FISCC_Charter_Config__mdt charterConfig = FISCCIntegrationLogService.charterConfig;
      if (String.isBlank(FISCCIntegrationLogService.auth)) {
        FISCCIntegrationLogService.auth = FISCCGetAccessTokenProvider.processGetAccessToken(charterConfig);
      }
      tffa.Logger.debug('aliasSeqList ' + aliasSeqList);
      for (String seqNo : aliasSeqList) {
        FISCC_Adapter_Configs__mdt adapterConfig = FISCCIntegrationLogRepository.findAdapterConfig(strDeveloperName);
        if (!Test.isRunningTest()) {
          adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace(
            '{CustomerNbr}',
            FISCCCommonHelper.encrypt(party.Customer_Number__c)
          );
        }
        FISCCIntegrationLogService.setCurrentLogItem(
          FISCCIntegrationConstants.DELETE_ALIAS +
          '_' +
          seqNo +
          '_' +
          party.Name,
          party.Id,
          true
        );
        adapterConfig.ServiceURL__c = adapterConfig.ServiceURL__c.replace('{AlSeqNbr}', seqNo);
        Object result = FISCCHostAdapter.processHostRequest(null, adapterConfig, charterConfig);
        boolean isSuccess = parseDeleteAliasResponse(result);
        if (!isSuccess) {
          allAliasDeleted = false;
          FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ALIAS, FISCCIntegrationConstants.ALIAS_API_CALL_FAILURE);
        } else {
          FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.ALIAS, FISCCIntegrationConstants.ALIAS_API_CALL_SUCCESS);
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in fetchCustomerAliasSeqNo ' + ex.getLineNumber() + ' ' + ex.getMessage());
      FISCCIntegrationLogService.setLogItemFailed(FISCCIntegrationConstants.ALIAS, FISCCIntegrationConstants.ALIAS_API_CALL_FAILURE);
    }
    return allAliasDeleted;
  }

  public static FISCCRequestBaseDTO generateAliasRequest(String alias) {
    tffa.Logger.debug('In generateAliasRequest ' + alias);

    FISCCCreateAliasRequestDTO reqDto = new FISCCCreateAliasRequestDTO();
    reqDto.customerAliasNew.AlNme = alias;
    reqDto.customerAliasNew.NmeAddrStandOvrideInd = 'Y';
    return reqDto;
  }

  public static boolean parseDeleteAliasResponse(Object resp) {
    tffa.Logger.debug('In parseDeleteAliasResponse ' + resp);
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (resp instanceof FISCCDeleteAliasResponseDTO) {
        FISCCDeleteAliasResponseDTO aliasResp = (FISCCDeleteAliasResponseDTO) resp;
        return true;
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in Parsing Delete Alias Resp ' + ex.getMessage());
    }
    return false;
  }

  public static List<String> parseFetchAliasResponse(Object resp) {
    tffa.Logger.debug('In parseFetchAliasResponse ' + resp);
    List<String> aliasFetchResp = new List<String>();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (resp instanceof FISCCFetchAliasResponseDTO) {
        FISCCFetchAliasResponseDTO aliasResp = (FISCCFetchAliasResponseDTO) resp;
        if (!aliasResp.Entity.fetchCustomerAlias.isEmpty()) {
          for (FISCCFetchAliasResponseDTO.AliasList aliasObj : aliasResp.Entity.fetchCustomerAlias) {
            aliasFetchResp.add(aliasObj.Seq);
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in Parsing Fetch Alias Resp ' + ex.getMessage());
    }
    return aliasFetchResp;
  }

  public static boolean parseAliasResponse(Object resp) {
    tffa.Logger.debug('In parseAliasResponse ' + resp);
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (resp instanceof FISCCCreateAliasResponseDTO) {
        FISCCCreateAliasResponseDTO aliasResp = (FISCCCreateAliasResponseDTO) resp;
        if (String.isNotBlank(aliasResp.Entity.customerAliasNew.AlNme)) {
          return true;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Exception in Parsing Alias Resp ' + ex.getMessage());
    }
    return false;
  }
}