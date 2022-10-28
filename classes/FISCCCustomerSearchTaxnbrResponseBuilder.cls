public inherited sharing class FISCCCustomerSearchTaxnbrResponseBuilder implements FISCCHostResponseBuilder {
  @TestVisible
  private static boolean testException = false;
  public FISCCCustomerSearchTaxnbrResponseBuilder() {
  }

  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      hostResponse = hostResponse.replace('control-data', 'controlData');
      tffa.Logger.debug('Response ==> ' + System.JSON.deserialize(hostResponse, FISCCCustomerSearchTaxnbrEntityResponse.class));
      tffa.Logger.debug(
        'deserialized Response ==> ' +
        (FISCCCustomerSearchTaxnbrEntityResponse) System.JSON.deserialize(hostResponse, FISCCCustomerSearchTaxnbrEntityResponse.class)
      );
      return (String.isNotBlank(hostResponse))
        ? (FISCCCustomerSearchTaxnbrEntityResponse) System.JSON.deserialize(hostResponse, FISCCCustomerSearchTaxnbrEntityResponse.class)
        : null;
    } catch (Exception ex) {
      tffa.Logger.debug('Exception into getHostResponseString :::' + ex.getMessage() + ' LineNumber :::' + ex.getStackTraceString());
      return null;
    }
  }

  public Object parseResponse(
    FISCCTransactionResponseBaseDTO response,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    FISCCCustomerSearchTaxnbrEntityResponse perOutputResponse = null;
    List<FISCCCustomerSearchTaxnbrResponse> customersResponseList = null;
    List<FISCCCustomerSearchTaxnbrResponse> personsResult = new List<FISCCCustomerSearchTaxnbrResponse>();
    Map<Integer, String> errorResponse = null;
    FISCCCustomerDTO customerObj = null;

    FISCCCustomerSearchTaxnbrResponse objFISCCCustomerSearchTaxnbrResponse;
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (response != null) {
        perOutputResponse = (FISCCCustomerSearchTaxnbrEntityResponse) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
        if (perOutputResponse.Entity != null) {
          objFISCCCustomerSearchTaxnbrResponse = new FISCCCustomerSearchTaxnbrResponse();

          String strCISncDate = perOutputResponse.Entity.customersLst[0].CISncDte;
          integer indexofLatestDate = 0;
          integer intCount = 0;
          tffa.Logger.debug('strCISncDate ==>' + strCISncDate);
          for (FISCCCustomerDTO customer : perOutputResponse.Entity.customersLst) {
            if (customer.CISncDte > strCISncDate) {
              strCISncDate = customer.CISncDte;
              tffa.Logger.debug('Customer ==>' + customer);
              indexofLatestDate = intCount;
            }
            intCount++;
          }
          objFISCCCustomerSearchTaxnbrResponse.customersLst.add(perOutputResponse.Entity.customersLst[indexofLatestDate]);

          objFISCCCustomerSearchTaxnbrResponse.controlData = perOutputResponse.Entity.controlData;
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug(
        'Exception in FISCCCustomerSearchTaxnbrResponseBuilder : ' +
        ex.getMessage() +
        ' Exception :::' +
        ex.getStackTraceString()
      );
      return null;
    }
    tffa.Logger.debug('Response in SearchCustomerTaxbr ::: ' + objFISCCCustomerSearchTaxnbrResponse);
    return objFISCCCustomerSearchTaxnbrResponse;
  }
}