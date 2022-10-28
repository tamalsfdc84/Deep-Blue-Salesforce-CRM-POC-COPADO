@isTest
private class CZWTFCCustomMetadataRepositoryTest {
  @isTest
  public static void testCreate() {
    Test.startTest();
    Nacha_Config__mdt result1 = CZWTFCCustomMetadataRepository.fetchWtfcNachaConfig();
    Test.stopTest();
  }

  @isTest
  public static void testHelperRepository() {
    tffa__Promotion__c promo = new tffa__Promotion__c();
    promo.tffa__Code__c = 'Test';
    promo.InterestPlanCode__c = '1244';
    promo.Name = 'Test';
    insert promo;

    tffa__Promotion__c promo1 = new tffa__Promotion__c();
    promo1.tffa__Code__c = 'Test1';
    promo1.Name = 'Test1';
    insert promo1;

    Test.startTest();
    CZWTFCHelperRepository.findProductTerms('qwrtty', 12.0);
    CZWTFCHelperRepository.fetchPromotionPlanCode('Test1');
    CZWTFCHelperRepository.fetchPromotionPlanCode('Test');
    Test.stopTest();
  }

  @isTest
  public static void helperRepoTest() {
    Test.startTest();
    CZWTFCHelperRepository.fetchLocationById('qwrtty');
    CZWTFCHelperRepository.fetchBrandById('Test1');
    CZWTFCHelperRepository.fetchSubBrandByextId('test', 'Test');
    CZWTFCHelperRepository.fetchSubBrandByBrand('qwrtty');
    CZWTFCHelperRepository.fetchBrandLocByBrand('Test1');
    CZWTFCHelperRepository.fetchBrandLocByLoc('Test');
    CZWTFCHelperRepository.fetchBrandLocByextId('qwrtty');
    CZWTFCHelperRepository.fetchProductById('Test1');
    CZWTFCHelperRepository.fetchfundMatByextId('Test', 'Test', 'Test');

    CZWTFCHelperRepository.fetchProdMatByextId('Test1');
    CZWTFCHelperRepository.fetchAppDecMatBySort(12, 'Test');
    CZWTFCHelperRepository.fetchpromoById('qwrtty');
    CZWTFCHelperRepository.fetchPromoPlan('Test1', 'Test2', 'test');
    CZWTFCHelperRepository.fetchPromoPlanByPromo('Test');

    CZWTFCHelperRepository.fetchLocationByAddAndCode('Test1', 'test');
    CZWTFCHelperRepository.fetchAddById('122');
    CZWTFCHelperRepository.fetchAddByExtId('qwrtty');
    CZWTFCHelperRepository.fetchRecommendConfigByName('Test1', 'Testt');
    CZWTFCHelperRepository.fetchdiscCheckListByName('Test', 'test');

    CZWTFCHelperRepository.fetchdiscCheckListById('122');
    CZWTFCHelperRepository.fetchdiscTempById('qwrtty');
    CZWTFCHelperRepository.fetchdiscTempByExtId('Test1', 'testt');
    CZWTFCHelperRepository.fetchAddOnServListByName('Test', 'Test');

    CZWTFCHelperRepository.fetchAddOnServListById('122');
    CZWTFCHelperRepository.fetchAddOnServById('qwrtty');
    CZWTFCHelperRepository.fetchRecommendConfigById('Test1');
    CZWTFCHelperRepository.fetchRecommendItemByExtId('Test', 'Test');

    CZWTFCHelperRepository.fetchAddOnServiceItemByExtId('122', 'test');

    CZWTFCHelperRepository.fetchProdXrefById('Test', 'Test');

    CZWTFCHelperRepository.fetchProdMatById('122', 'test', 1);

    Test.stopTest();
  }
}