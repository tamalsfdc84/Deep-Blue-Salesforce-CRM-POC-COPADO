global with sharing class CZDeluxeController extends tffa.AbstractController implements tffa.IController {
  private static tffa.IController controller;

  global CZDeluxeController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  global static tffa.Response getRedirectUrl(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZDeluxeController.class, 'getRedirectUrl');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      string url = '';
      if (params.containsKey('applicationId')) {
        return tffa.Response.ok(CZDeluxeService.getRedirectUrl(params.get('applicationId'))).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }
}