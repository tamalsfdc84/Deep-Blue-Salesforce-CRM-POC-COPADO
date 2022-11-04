global with sharing class CZWTFCAuthenticationController extends tffa.AbstractController implements tffa.IController {
  private static tffa.IController controller;

  public CZWTFCAuthenticationController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  /**
   * @description authenticateParty
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response authenticateParty(tffa.Context ctx, Map<String, String> reqParams) {
    tffa.Interaction.begin(ctx, CZWTFCAuthenticationController.class, 'authenticateParty');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(reqParams);
      }
      Map<String, String> params = reqParams.clone();
      if (params.containsKey('submission')) {
        String authType = params.containsKey('authType') ? params.get('authType') : '';
        //FISCCIntegrationLogService.setSubmissionObj(params.get('submission'));
        if (params.containsKey('isDebitCardProductSelected') && params.get('isDebitCardProductSelected') == 'Y') {
          if (params.containsKey('mdmPartyId')) {
            params.put('custNbr', (String) params.get('mdmPartyId'));
          }
          CZWTFCIntegrationLogService.setIntegrationLog(
            params.get('submission'),
            FISCCIntegrationConstants.FIS_CUSTOMER_FETCH +
            '-' +
            params.get('custNbr')
          );
          CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.FIS_CUSTOMER_FETCH + '-' + params.get('custNbr'));
        } else if (authType == 'ind-4') {
          CZWTFCIntegrationLogService.setIntegrationLog(
            params.get('submission'),
            FISCCIntegrationConstants.MDM_FETCH_CUST_INFO +
            '-' +
            params.get('mdmPartyId')
          );
          CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MDM_FETCH_CUST_INFO + '-' + params.get('mdmPartyId'));
        } else {
          CZWTFCIntegrationLogService.setIntegrationLog(params.get('submission'), FISCCIntegrationConstants.CUSTOMER_AUTH);
          CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_AUTH);
        }
        CZWTFCAuthResponse resp = CZWTFCAuthenticationService.verifyUser(params);
        return tffa.Response.ok(resp).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description searchIndividualCust
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response searchIndividualCust(tffa.Context ctx, Map<String, Object> reqParams) {
    tffa.Interaction.begin(ctx, CZWTFCAuthenticationController.class, 'searchIndividualCust');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(reqParams);
      }
      Map<String, Object> params = reqParams.clone();

      //FISCCIntegrationLogService.setSubmissionObj((String) params.get('submission'));
      CZWTFCIntegrationLogService.setIntegrationLog((String) params.get('submission'));
      if (params.containsKey('isDebitCardProductSelected') && (String) params.get('isDebitCardProductSelected') == 'Y') {
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.FIS_SEARCH_INQUIRY);
      } else {
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MDM_SEARCH_INQUIRY);
      }

      CZMDMIndividualSearchResponse resp = CZWTFCAuthenticationService.searchIndividual(params);
      return tffa.Response.ok(resp).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description searchBusinessCust
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response searchBusinessCust(tffa.Context ctx, Map<String, Object> reqParams) {
    tffa.Interaction.begin(ctx, CZWTFCAuthenticationController.class, 'searchBusinessCust');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(reqParams);
      }
      Map<String, Object> params = reqParams.clone();

      //FISCCIntegrationLogService.setSubmissionObj((String) params.get('submission'));
      CZWTFCIntegrationLogService.setIntegrationLog((String) params.get('submission'));
      if (params.containsKey('isDebitCardProductSelected') && (String) params.get('isDebitCardProductSelected') == 'Y') {
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.FIS_SEARCH_INQUIRY);
      } else {
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MDM_SEARCH_INQUIRY);
      }
      CZMDMBusinessCustSearchResponse resp = CZWTFCAuthenticationService.searchBusinessCustomers(params);
      return tffa.Response.ok(resp).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description Fetch Business Customer details
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response fetchBusinessCustDetails(tffa.Context ctx, Map<String, Object> reqParams) {
    tffa.Interaction.begin(ctx, CZWTFCAuthenticationController.class, 'fetchBusinessCustDetails');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(reqParams);
      }
      Map<String, Object> params = reqParams.clone();

      if (params.containsKey('isDebitCardProductSelected') && (String) params.get('isDebitCardProductSelected') == 'Y') {
        if (params.containsKey('mdmPartyId')) {
          params.put('custNbr', (String) params.get('mdmPartyId'));
        }
        CZWTFCIntegrationLogService.setIntegrationLog(
          (String) params.get('submission'),
          FISCCIntegrationConstants.FIS_CUSTOMER_FETCH +
          '-' +
          (String) params.get('custNbr')
        );
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.FIS_CUSTOMER_FETCH + '-' + (String) params.get('custNbr'));
      } else {
        CZWTFCIntegrationLogService.setIntegrationLog((String) params.get('submission'));
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MDM_BUSINESS_CUSTOMER_INQUIRY);
      }
      CZMDMBusinessCustDetailsResponse resp = CZWTFCAuthenticationService.fetchBusinessCustomerDetails(params);
      return tffa.Response.ok(resp).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @description Fetch Business Customer details
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response searchParty(tffa.Context ctx, Map<String, Object> reqParams) {
    tffa.Interaction.begin(ctx, CZWTFCAuthenticationController.class, 'searchParty');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(reqParams);
      }
      Map<String, Object> params = reqParams.clone();
      CZWTFCIntegrationLogService.setIntegrationLog((String) params.get('submission'));

      CZCommonResponseDTO resp = CZWTFCAuthenticationService.searchCustomer(params);
      return tffa.Response.ok(resp).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }
}