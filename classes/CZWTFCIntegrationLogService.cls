public abstract class CZWTFCIntegrationLogService {
  //log related
  public static String subId { get; set; }
  public static IntegrationLog__c currentLog { get; set; }
  public static Map<String, IntegrationLog__c> integrationLogMap { get; set; }
  public static IntegrationLogItem__c currentLogItem { get; set; }
  public static Map<String, IntegrationLogItem__c> currentLogItemMap { get; set; }
  public static Map<String, Map<String, IntegrationLogItem__c>> integrationLogItemMap { get; set; }

  public static void persistIntegationLogs() {
    List<IntegrationLogItem__c> logItemObjs = new List<IntegrationLogItem__c>();
    if (
      CZWTFCIntegrationLogService.integrationLogMap != null &&
      CZWTFCIntegrationLogService.integrationLogMap.size() != 0 &&
      CZWTFCIntegrationLogService.integrationLogMap.values() != null &&
      CZWTFCIntegrationLogService.integrationLogMap.values().size() != 0
    ) {
      //upsert CZWTFCIntegrationLogService.integrationLogMap.values();
      FISCCObjectManagerRepository.doUpsertIntegrationLogs(CZWTFCIntegrationLogService.integrationLogMap.values());
      for (IntegrationLog__c log : CZWTFCIntegrationLogService.integrationLogMap.values()) {
        for (IntegrationLogItem__c logItem : CZWTFCIntegrationLogService.integrationLogItemMap.get(log.FlowName__c).values()) {
          if (logItem.IntegrationLog__c == null) {
            logItem.IntegrationLog__c = log.id;
          }
          logItemObjs.add(logItem);
        }
      }
      //upsert logItemObjs;
      FISCCObjectManagerRepository.doUpsertIntegrationLogItems(logItemObjs);
    }
  }

  public static void setIntegrationLog(String submissionId, String flowName) {
    subId = submissionId;
    integrationLogMap = new Map<String, IntegrationLog__c>();
    integrationLogItemMap = new Map<String, Map<String, IntegrationLogItem__c>>();

    List<IntegrationLog__c> integrationLogsList;

    if (String.isBlank(flowName))
      integrationLogsList = FISCCIntegrationLogRepository.findLogsBySubmissionId(submissionId);
    else
      integrationLogsList = FISCCIntegrationLogRepository.findLogsBySubmissionAndFlowName(submissionId, flowName);

    for (IntegrationLog__c apiLogObj : integrationLogsList) {
      integrationLogMap.put(apiLogObj.FlowName__c, apiLogObj);
      Map<String, IntegrationLogItem__c> itemMap = new Map<String, IntegrationLogItem__c>();
      if (apiLogObj.IntegrationLogs__r != null) {
        if (integrationLogItemMap.containsKey(apiLogObj.FlowName__c)) {
          itemMap = integrationLogItemMap.get(apiLogObj.FlowName__c);
        }
        for (IntegrationLogItem__c item : apiLogObj.IntegrationLogs__r) {
          itemMap.put(item.Name, item);
        }
      }
      integrationLogItemMap.put(apiLogObj.FlowName__c, itemMap);
    }
  }

  public static void setIntegrationLog(String submissionId) {
    setIntegrationLog(submissionId, null);
  }

  public static Boolean isLogNewOrFailed(String flowName) {
    if (integrationLogMap.containsKey(flowName)) {
      if (
        String.isNotBlank(integrationLogMap.get(flowName).Status__c) &&
        integrationLogMap.get(flowName).Status__c.equalsIgnoreCase(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS)
      ) {
        return false;
      }
    }
    return true;
  }

  private static void setLog(String status, String message) {
    currentLog.Status__c = status;
    currentLog.Message__c = message;
    currentLog.EndTime__c = System.now();
  }

  public static void setLogOk(String message) {
    setLog(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS, message);
  }

  public static void setLogFailed(String message) {
    setLog(FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE, message);
  }

  // Set integration log Flow
  public static void setCurrentLog(String flowName) {
    if (integrationLogMap.containskey(flowName)) {
      currentLog = integrationLogMap.get(flowName);
      currentLogItemMap = integrationLogItemMap.get(flowName);
    } else {
      currentLog = new IntegrationLog__c(
        FlowName__c = flowName,
        Message__c = ' ',
        Status__c = ' ',
        Submission__c = subId,
        StartTime__c = System.now()
      );
      currentLogItemMap = new Map<String, IntegrationLogItem__c>();
    }
    integrationLogMap.put(flowName, currentLog);
    integrationLogItemMap.put(flowName, currentLogItemMap);
  }

  public static Boolean isLogOk(String flowName) {
    if (integrationLogMap.containsKey(flowName)) {
      if (
        String.isNotBlank(integrationLogMap.get(flowName).Status__c) &&
        integrationLogMap.get(flowName).Status__c.equalsIgnoreCase(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS)
      ) {
        return true;
      }
    }
    return false;
  }

  public static Boolean isLogExist(String flowName) {
    if (integrationLogMap.containsKey(flowName)) {
      return true;
    } else {
      return false;
    }
  }

  public static Boolean isLogItemOk(String recordId) {
    if (currentLogItemMap.containsKey(recordId)) {
      if (
        String.isNotBlank(currentLogItemMap.get(recordId).Status__c) &&
        currentLogItemMap.get(recordId).Status__c.equalsIgnoreCase(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS)
      ) {
        return true;
      }
    }
    return false;
  }

  public static Boolean isLogItemNewOrFailed(String recordId) {
    if (currentLogItemMap.containsKey(recordId)) {
      if (
        String.isNotBlank(currentLogItemMap.get(recordId).Status__c) &&
        currentLogItemMap.get(recordId).Status__c.equalsIgnoreCase(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS)
      ) {
        return false;
      }
    }
    return true;
  }

  public static Boolean isLogItemNewOrFailed() {
    return isLogItemNewOrFailed(currentLogItem.Name);
  }

  private static void setLogItem(String apiName, String status, String message) {
    currentLogItem.ApiName__c = apiName;
    currentLogItem.Status__c = status;
    currentLogItem.Message__c = message;
  }

  public static void setLogItemOk(String apiName) {
    setLogItem(apiName, FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS, '');
  }

  public static void setLogItemOk(String apiName, String message) {
    setLogItem(apiName, FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS, message);
  }

  public static void setLogItemFailed(String apiName) {
    setLogItem(apiName, FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE, currentLogItem.Message__c);
  }

  public static void setLogItemFailed(String apiName, String message) {
    setLogItem(apiName, FISCCIntegrationConstants.LOG_ITEM_STATUS_FAILURE, message);
  }

  public static void setLogItemMessage(String message) {
    if (currentLogItem != null) {
      if (message.length() > 1999) {
        currentLogItem.Message__c = message.substring(0, 1999);
      } else {
        currentLogItem.Message__c = message;
      }
    }
  }
  public static void setLogItemRequestAndResponse(String apiRequest, String apiResponse) {
    if (currentLogItem != null) {
      if (!String.isBlank(apiRequest)) {
        if (apiRequest.length() > 24999) {
          currentLogItem.APIRequest__c = apiRequest.substring(0, 24999);
        } else {
          currentLogItem.APIRequest__c = apiRequest;
        }
      }
      if (!String.isBlank(apiResponse)) {
        if (apiResponse.length() > 24999) {
          currentLogItem.APIResponse__c = apiResponse.substring(0, 24999);
        } else {
          currentLogItem.APIResponse__c = apiResponse;
        }
      }
    }
  }

  // Set integration item log Flow
  private static String setCurrentLogItem(String key) {
    if (currentLogItemMap.containskey(key)) {
      currentLogItem = currentLogItemMap.get(key);
    } else {
      currentLogItem = new IntegrationLogItem__c(
        Name = key,
        ApiName__c = ' ',
        Message__c = ' ',
        SubRecord__c = ' ',
        Status__c = ' ',
        APIRequest__c = ' ',
        APIResponse__c = ' '
      );
    }
    currentLogItemMap.put(key, currentLogItem);
    return key;
  }

  //FiServDNAServiceMapper  IMMServiceMapper DeluxeServiceMapper
  public static String setCurrentLogItem(String recordId, String apiName, Boolean allowDuplicates) {
    if (!String.isBlank(apiName) && apiName.length() > 44) {
      apiName = apiName.substring(0, 43);
    }

    if (!String.isBlank(recordId) && recordId.length() > 21) {
      recordId = recordId.substring(0, 20);
    }

    String key = recordId + '-' + apiName;

    Integer maxLength = allowDuplicates ? 66 : 80;

    if (String.isNotBlank(key) && key.length() > maxLength) {
      key.substring(0, maxLength - 1);
    }

    if (allowDuplicates)
      key = key + '-' + System.now().format('MMddHHmmssSSS');
    return setCurrentLogItem(key);
  }
}