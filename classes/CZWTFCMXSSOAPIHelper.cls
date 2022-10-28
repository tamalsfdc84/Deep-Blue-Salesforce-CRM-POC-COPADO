public with sharing class CZWTFCMXSSOAPIHelper {
  public static Object onSuccess(Map<String, Object> ssoApiResponse) {
    tffa.Logger.debug('Inside MXSSOAPIHelper onSuccess');
    Map<String, String> responseMap = new Map<String, String>();
    if (ssoApiResponse.get('url') != null) {
      responseMap.put('url', String.valueOf(ssoApiResponse.get('url')));
    }
    return responseMap;
  }

  public static Map<String, Object> onError(Map<String, Object> fault) {
    tffa.Logger.debug('Inside MXSSOAPIHelper onError');
    Map<String, Object> errorList = fault != null ? (Map<String, Object>) fault.get('detail') : null;
    errorList = errorList != null ? (Map<String, Object>) errorList.get('Fault') : null;
    errorList = errorList != null ? (Map<String, Object>) errorList.get('ErrorList') : null;
    tffa.Logger.debug('errorList=' + errorList);
    return new Map<String, Object>(errorList);
  }

  // Method to check whether the object recieved is list or not
  public static boolean checkForInstance(Object o) {
    if (o instanceof List<Object>) {
      return true;
    } else {
      return false;
    }
  }
}