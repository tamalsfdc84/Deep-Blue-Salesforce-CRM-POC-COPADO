public with sharing class FISCCDeficitTransferExtension {
  @TestVisible
  private static boolean testException = false;

  public static boolean invokeApiCall(
    Map<String, String> reqData,
    FISCC_Adapter_Configs__mdt adapterConfig,
    FISCC_Charter_Config__mdt charterConfig
  ) {
    tffa.Logger.debug('In FISCCDeficitTransferExtension invokeApiCall');

    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    Object result = null;
    Boolean isSuccess;

    String accNbr = reqData.get('accNbr');
    String senderAccNbr = reqData.get('senderAccNbr');
    String custName = reqData.get('custName');

    fisccRequestBaseDTO = FISCCDeficitTransferExtension.generateRequest(accNbr, senderAccNbr, custName);
    tffa.Logger.debug('--------- fisccRequestBaseDTO' + fisccRequestBaseDTO);

    result = FISCCHostAdapter.processHostRequest(fisccRequestBaseDTO, adapterConfig, charterConfig);
    tffa.Logger.debug('--------- result' + result);

    isSuccess = FISCCDeficitTransferExtension.parseDeficitTransResp(result);
    return isSuccess;
  }

  public static FISCCRequestBaseDTO generateRequest(String accNbr, String senderAccNbr, String custName) {
    tffa.Logger.debug('In FISCCDeficitTransferExtension generateRequest');
    FISCCRequestBaseDTO fisccRequestBaseDTO = null;
    FISCCDeficitTransferRequest fisDeficitTrans = new FISCCDeficitTransferRequest();
    FISCCDeficitTransferRequest.deficitTransferSender senderObj = new FISCCDeficitTransferRequest.deficitTransferSender();
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      fisDeficitTrans.defTransfer.FMBalTyp = FISCCIntegrationConstants.FMBALANCETYPE;
      fisDeficitTrans.defTransfer.FMMinTrsfrTyp = FISCCIntegrationConstants.FM_MIN_TRANSFER_TYPE;
      fisDeficitTrans.defTransfer.FMCustNme = custName;
      fisDeficitTrans.defTransfer.FMDfctTrsfrSeqNbr = FISCCIntegrationConstants.FM_DEFICIT_TRANSFER_SEQ_NBR;
      fisDeficitTrans.defTransfer.FMDPSysReceivingAcctNbr = accNbr;
      fisDeficitTrans.defTransfer.RcvAcctSysCde = FISCCIntegrationConstants.RECEIVING_ACC_SYS_CODE;
      fisDeficitTrans.defTransfer.FMTrsfrIncmt = FISCCIntegrationConstants.FM_TRANSFER_INCREMENT;
      senderObj.FMAcctNbr = senderAccNbr;
      senderObj.FMOrd = FISCCIntegrationConstants.FM_ORDER_B;
      senderObj.FMSysCde = FISCCIntegrationConstants.FM_SYSTEM_CODE;
      fisDeficitTrans.deficitTransferSenderLst.add(senderObj);
      fisccRequestBaseDTO = fisDeficitTrans;
    } catch (Exception ex) {
      tffa.Logger.error(
        'Exception in FISCCDeficitTransferExtension.generateRequest ' +
        ex.getMessage() +
        ' Exception' +
        ex.getStackTraceString()
      );
    }
    return fisccRequestBaseDTO;
  }

  public static Boolean parseDeficitTransResp(Object response) {
    tffa.Logger.debug('parseDeficitTransResp----> ' + response);

    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (response instanceof FISCCDeficitTransferResponse) {
        FISCCDeficitTransferResponse resp = (FISCCDeficitTransferResponse) response;
        return true;
      } else {
        return false;
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in parseDeficitTransResp ' + ex.getMessage() + ' Exception :::' + ex.getStackTraceString());
      return false;
    }
  }
}