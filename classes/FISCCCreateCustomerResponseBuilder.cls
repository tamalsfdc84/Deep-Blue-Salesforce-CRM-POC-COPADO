public inherited sharing class FISCCCreateCustomerResponseBuilder implements FISCCHostResponseBuilder {
  public FISCCTransactionResponseBaseDTO build(
    String hostResponse,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt codeConnectConfig
  ) {
    try {
      return (String.isNotBlank(hostResponse))
        ? (FISCCCreateCustomerEntityResponse) System.JSON.deserialize(hostResponse, FISCCCreateCustomerEntityResponse.class)
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
    FISCCCreateCustomerEntityResponse perOutputResponse = null;

    FISCCCustomerDTO customerObj = null;

    try {
      if (response != null) {
        perOutputResponse = (FISCCCreateCustomerEntityResponse) response;
        tffa.Logger.debug('perOutputResponse  in response builder ==> ' + perOutputResponse);
        if (perOutputResponse.Entity != null) {
          customerObj = perOutputResponse.Entity.customer;
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
    tffa.Logger.debug('Response in createcustomer ::: ' + customerObj);
    return customerObj;
  }
}