global with sharing class CZWTFCAuthenticationController extends tffa.AbstractController implements tffa.IController {
  private static tffa.IController controller;

  public CZWTFCAuthenticationController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  /**
   * @description ping test . do nothing
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response authenticateParty(tffa.Context ctx, Map<String, String> reqParams) {
    tffa.Interaction.begin(ctx, CZWTFCAuthenticationController.class, 'authenticateParty');
    try {
      Map<String, String> params = reqParams.clone();
      if (params.containsKey('submission')) {
        CZWTFCIntegrationLogService.setIntegrationLog(params.get('submission'));
        CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.CUSTOMER_VALIDATION);
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
}