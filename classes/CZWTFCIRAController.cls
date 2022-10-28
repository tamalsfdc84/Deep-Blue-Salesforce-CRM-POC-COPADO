global with sharing class CZWTFCIRAController extends tffa.AbstractController implements tffa.IController {
  private static tffa.IController controller;

  global CZWTFCIRAController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  /**
   * @Description Return Customer IRA Plans
   * @return Response
   */
  global static tffa.Response FetchIRAPlans(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCIRAController.class, 'FetchIRAPlans');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      if (params.containsKey('submissionId') && params.containsKey('ssn') && params.containsKey('charterCode')) {
        CZWTFCIRAService iraService = new CZWTFCIRAService();
        CZWTFCExistingIRAPlanResponse reposne = iraService.fetchIRAPlans(params);

        return tffa.Response.ok(reposne).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Return Customer IRA Plans
   * @return Response
   */
  global static tffa.Response FetchIRABeneficiary(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCIRAController.class, 'FetchIRABeneficiary');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      if (params.containsKey('submissionId') && params.containsKey('PlnNbr') && params.containsKey('charterCode')) {
        CZWTFCIRAService iraService = new CZWTFCIRAService();
        CZWTFCIRAPlanBeneficiaryResponse reposne = iraService.FetchIRABeneficiary(params);

        return tffa.Response.ok(reposne).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Return Customer IRA Details
   * @return Response
   */
  global static tffa.Response FetchIRAPlanDetails(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCIRAController.class, 'FetchIRAPlanDetails');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      if (params.containsKey('submissionId') && params.containsKey('PlnNbr')) {
        CZWTFCIRAService iraService = new CZWTFCIRAService();
        CZWTFCIRAPlanDetailsResponse reposne = iraService.fetchIRAPlanDetails(params);

        return tffa.Response.ok(reposne).build();
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