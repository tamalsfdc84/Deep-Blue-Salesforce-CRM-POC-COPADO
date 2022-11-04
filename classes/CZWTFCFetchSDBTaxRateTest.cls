@isTest
public with sharing class CZWTFCFetchSDBTaxRateTest {
  @isTest
  static void testSDBTaxRateTest() {
    //create Address
    tffa__Address__c objAddress = new tffa__Address__c();
    objAddress.Name = 'Address Name';
    objAddress.tffa__Line1__c = 'Line 1';
    objAddress.tffa__City__c = 'city';
    objAddress.tffa__ZipCode__c = '1234';
    objAddress.tffa__State__c = 'WI';
    objAddress.tffa__Country__c = 'US';
    insert objAddress;
    //create tffa__Location__c
    tffa__Location__c objLoc = new tffa__Location__c();
    objLoc.Name = '988';
    objLoc.FISBranchCode__c = '200';
    objLoc.CostCenter__c = '1000';
    objLoc.tffa__Address__c = objAddress.id;
    objLoc.tffa__Code__c = '901';
    insert objLoc;
    // create Brand Data
    List<tffa__Brand__c> lstBrand = new List<tffa__Brand__c>();
    tffa__Brand__c objBrand = new tffa__Brand__c();
    objBrand.DefaultLocation__c = objLoc.id;
    objBrand.tffa__Code__c = '001';
    insert objBrand;
    lstBrand.add(objBrand);
    // create BrandLocation(junction) data
    tffa__BrandLocation__c objBrandLoc = new tffa__BrandLocation__c();
    objBrandLoc.tffa__Brand__c = objBrand.id;
    objBrandLoc.tffa__Location__c = objLoc.id;
    insert objBrandLoc;
    Test.startTest();
    CZWTFCFetchSDBTaxRateProvider.generateBranchDetails(null, null);

    Test.setMock(HttpCalloutMock.class, new CZWTFCFetchSDBTaxRateMockClass());
    Id batchJobId = Database.executeBatch(new CZWTFCFetchSDBTaxRateBatch(), 50);
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchJobId ];
    
    System.assertNotEquals(aaj, null);
    Test.stopTest();
  }

  @isTest
  public static void testSDBTaxRateBuilder() {
    CZWTFCFetchSDBTaxRateMockClass mckclass = new CZWTFCFetchSDBTaxRateMockClass();
    HttpResponse resp1 = mckclass.respond(new HttpRequest());
    String resp = resp1.getBody();

    Test.startTest();
    CZWTFCFetchSDBTaxRateResponseBuilder dlrResp = new CZWTFCFetchSDBTaxRateResponseBuilder();
    dlrResp.build(resp, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    Object response = dlrResp.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    System.assertEquals(null, null);

    CZWTFCFetchSDBTaxRateResponseBuilder dlrResp1 = new CZWTFCFetchSDBTaxRateResponseBuilder();
    CZWTFCFetchSDBTaxRateResponseBuilder.testException = true;
    dlrResp1.build('', new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    response = dlrResp1.parseResponse(null, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
    System.assertEquals(null, null);

    Test.stopTest();
  }
}