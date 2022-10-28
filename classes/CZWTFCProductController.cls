global with sharing class CZWTFCProductController extends tffa.AbstractController implements tffa.IController {
  private static tffa.IController controller;

  global CZWTFCProductController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  /**
   * @Description Returns Brand Object
   * @return Response
   */
  global static tffa.Response getProductList(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCProductController.class, 'getProductList');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      List<tffa__ProductMatrix__c> prodMatrixList = new List<tffa__ProductMatrix__c>();
      List<tffa__Product__c> productList = new List<tffa__Product__c>();
      if (params.containsKey('brandCode')) {
        prodMatrixList = CZWTFCProductService.readProductMatrix(params);
        if (prodMatrixList == null || prodMatrixList.isEmpty()) {
          throw new IllegalArgumentException('THE ACCOUNT YOU ARE ATTEMPTING TO APPLY FOR IS NOT AVAILABLE IN YOUR AREA.');
        } else {
          productList = CZWTFCProductService.readProducts(prodMatrixList, params);
        }
        return tffa.Response.ok(productList).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCProductController' + ex.getMessage() + ex.getStackTraceString());
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }
}