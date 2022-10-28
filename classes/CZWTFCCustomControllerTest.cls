/**
 *
 * @description This is the test class of CZWTFCCustomController
 */

@isTest
public class CZWTFCCustomControllerTest {
  @testSetup
  static void setup() {
    CZWTFCTestDataRepository.generateEnvironmentConfiguration();
  }
  /**
   * @description Test using salescontroller init
   **/
  @isTest
  static void testPing() {
    Test.startTest();
    tffa.Context ctx = tffa.Context.get();
    tffa.Response response = CZWTFCCustomController.ping(ctx);

    tffa.IController controller;
    new CZWTFCCustomController(controller);
    new CZWTFCMXController(controller);
    tffa.Response response1 = CZWTFCMXController.ping(ctx);
    Test.stopTest();
  }

  @isTest
  public static void fetchBrandTest() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    insert brandObj;

    SubBrand__c subB = new SubBrand__c();
    subB.Brand__c = brandObj.Id;
    subB.Name = 'Test';
    insert subB;

    Test.startTest();
    Map<String, String> params = new Map<String, String>();
    CZWTFCCustomService customService = new CZWTFCCustomService();
    params.put('brandCode', '118');
    CZWTFCCustomController.fetchBrand(params);
    customService.fetchSubBrands('118');

    try {
      Map<String, String> paramsOne = new Map<String, String>();
      CZWTFCCustomController.fetchBrand(paramsOne);
    } catch (Exception ex) {
      tffa.Logger.debug('Test Execption thrown');
    }

    //   try{
    //     Map<String,String> paramsOne = new Map<String,String>();
    //     CZWTFCCustomController.fetchSubBrand(paramsOne);
    //  }catch(Exception ex){
    //      tffa.Logger.debug('Test Execption thrown');
    //  }

    Test.stopTest();
  }

  @isTest
  public static void customProductControllerTest() {
    tffa__Product__c prod800 = new tffa__Product__c();
    prod800.tffa__Category__c = 'CHECKING';
    prod800.tffa__Code__c = '800';
    prod800.Name = 'Test';
    insert prod800;

    tffa__Product__c prod8001 = new tffa__Product__c();
    prod8001.tffa__Category__c = 'CHECKING';
    prod8001.tffa__Code__c = '8001';
    prod8001.Name = 'Test';
    insert prod8001;

    tffa__Product__c prod8002 = new tffa__Product__c();
    prod8002.tffa__Category__c = 'CHECKING';
    prod8002.tffa__Code__c = '8002';
    prod8002.Name = 'Test';
    insert prod8002;

    tffa__Product__c prod8003 = new tffa__Product__c();
    prod8003.tffa__Category__c = 'CHECKING';
    prod8003.tffa__Code__c = '8004';
    prod8003.Name = 'Test';
    insert prod8003;

    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '1234';
    prod2.Name = 'Test';
    insert prod2;

    tffa__Product__c prod4 = new tffa__Product__c();
    prod4.tffa__Category__c = 'CHECKING';
    prod4.tffa__Code__c = '123455555';
    prod4.Name = 'Test1';
    insert prod4;

    tffa__ProductMatrix__c prodMat1 = new tffa__ProductMatrix__c();
    prodMat1.tffa__BrandCodeSet__c = '1234';
    prodMat1.StateCodeSet__c = '3211';
    prodMat1.tffa__Product__c = prod2.Id;
    insert prodMat1;

    tffa__ProductMatrix__c prodMat66 = new tffa__ProductMatrix__c();
    prodMat66.tffa__BrandCodeSet__c = '1234';
    prodMat66.StateCodeSet__c = '3211';
    prodMat66.tffa__Product__c = prod4.Id;
    insert prodMat66;

    tffa__ProductMatrix__c prodMat2 = new tffa__ProductMatrix__c();
    prodMat2.tffa__BrandCodeSet__c = '12342';
    prodMat2.ZipCodeSet__c = '1234';
    prodMat2.StateCodeSet__c = '3211';
    prodMat2.tffa__Product__c = prod800.Id;
    insert prodMat2;

    tffa__ProductMatrix__c prodMat3 = new tffa__ProductMatrix__c();
    prodMat3.tffa__BrandCodeSet__c = '12342';

    prodMat3.StateCodeSet__c = '3211';
    prodMat3.tffa__Product__c = prod8003.Id;
    insert prodMat3;

    tffa__ProductMatrix__c prodMat4 = new tffa__ProductMatrix__c();
    prodMat4.tffa__BrandCodeSet__c = '12342';
    prodMat4.tffa__Product__c = prod8002.Id;
    insert prodMat4;

    tffa__ProductMatrix__c prodMat6 = new tffa__ProductMatrix__c();
    prodMat6.tffa__Product__c = prod8001.Id;
    insert prodMat6;

    Test.startTest();
    Map<String, Object> facts = new Map<String, Object>();
    facts.put('zipCode', '1234');
    facts.put('stateCode', '3211');
    facts.put('brandCode', '12342');
    facts.put('productCode', '1234');
    CZWTFCProductService.readProductMatrix(facts);

    Map<String, Object> factsmultiProd = new Map<String, Object>();
    factsmultiProd.put('brandCode', '12342');
    factsmultiProd.put('productCode', '1234,123455555');
    CZWTFCProductService.readProductMatrix(factsmultiProd);

    Map<String, Object> facts1 = new Map<String, Object>();
    facts1.put('zipCode', '34108');
    facts1.put('stateCode', '3211');
    facts1.put('brandCode', '12342');
    CZWTFCProductService.readProductMatrix(facts1);

    Map<String, Object> facts2 = new Map<String, Object>();
    facts2.put('zipCode', '1234');
    facts2.put('stateCode', '3211');
    facts2.put('brandCode', '12342');
    CZWTFCProductService.readProductMatrix(facts2);

    Map<String, Object> facts4 = new Map<String, Object>();
    facts4.put('stateCode', '3211');
    facts4.put('brandCode', '12342');
    CZWTFCProductService.readProductMatrix(facts4);

    Map<String, Object> facts3 = new Map<String, Object>();
    facts3.put('brandCode', '12342');
    List<tffa__ProductMatrix__c> prod = CZWTFCProductService.readProductMatrix(facts3);
    CZWTFCProductService.readProducts(prod, facts3);

    tffa.IController p;
    new CZWTFCProductController(p);
    CZWTFCProductController.getProductList(facts3);

    //Test exception block in product controller
    try {
      Map<String, Object> facts55 = new Map<String, Object>();
      CZWTFCProductController.getProductList(facts55);
    } catch (Exception e) {
    }
    Test.stopTest();
  }

  @isTest
  public static void mxControllerTest() {
    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    insert brandObj;

    SubBrand__c subB = new SubBrand__c();
    subB.Brand__c = brandObj.Id;
    subB.Name = 'Test';
    insert subB;

    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    Map<String, String> mp = new Map<String, String>();
    mp.put('subId', sub.Id);
    mp.put('isMXUserCreated', 'false');
    Test.startTest();
    tffa.Context ctx = tffa.Context.get();
    ctx.id = sub.Id;
    CZWTFCMXController.setSubForTest = true;

    try {
      CZWTFCMXController.generateMxUrl(ctx, mp);
      CZWTFCMXController.openNexusSession(ctx, mp);
      CZWTFCMXController.checkVerificationStatus(ctx, mp);
      CZWTFCMXController.fetchAccountDetails(ctx, mp);
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXController.testException = true;
      CZWTFCMXController.generateMxUrl(ctx, new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXController.testException = true;
      CZWTFCMXController.openNexusSession(ctx, new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXController.testException = true;
      CZWTFCMXController.checkVerificationStatus(ctx, new Map<String, String>());
    } catch (Exception ex) {
    }

    try {
      CZWTFCMXController.testException = true;
      CZWTFCMXController.fetchAccountDetails(ctx, new Map<String, String>());
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  @isTest
  public static void getAccountDetailsTest() {
    Test.startTest();

    FISIBSAuthConfig__c fisAuth1 = new FISIBSAuthConfig__c();
    fisAuth1.BrandCode__c = '118';
    fisAuth1.Name = 'test1';
    fisAuth1.IsActive__c = true;
    fisAuth1.UserId__c = '1234';
    fisAuth1.IBSAuthorization__c = 'Qzg4OTk5NTpDY1NlcEAyMQ==';
    fisAuth1.LastUpdatedDate__c = Date.newInstance(2016, 12, 9);
    insert fisAuth1;

    Map<String, String> params = new Map<String, String>();
    params.put('charterCode', '118');
    params.put('accountNumber', '7881525');

    CZWTFCCustomController.getAccountDetails(params);

    try {
      tffa__Submission__c sub = new tffa__Submission__c(tffa__Status__c = 'SUBMITTED', FISBranchCode__c = '888');
      insert sub;
      Map<String, String> params1 = new Map<String, String>();
      params1.put('submissionId', sub.Id);
      CZWTFCCustomController.processSubmission(params1);
    } catch (Exception ex) {
    }

    try {
      Map<String, String> params2 = new Map<String, String>();
      CZWTFCCustomController.processSubmission(params2);
    } catch (Exception exp) {
    }

    Test.stopTest();
  }

  @isTest
  public static void interestRatesTestCase() {
    String validResponse = '{"Entity":{"control-data":{"NbrRtes":34,"NbrTiers":12,"MoreInd":"N","ReqCde":"D"},"investment-rate-schedulesLst":[{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":3,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.03,"Nme":"3 MONTH","TDMatTerm":3,"EffDte":"2020-10-29","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":4,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.04,"Nme":"SAVINGS","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":12,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0,"Nme":"12 M TERAFINA PROMO","TDMatTerm":12,"EffDte":"2021-09-17","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":26,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.01,"Nme":"PLATINUM PREFERRED","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":27,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.01,"Nme":"PLATINUM FOUNDERS","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":46,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.05,"Nme":"SAVINGS","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":67,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.001,"Nme":"WESTAMERICA MORTGAGE","TDMatTerm":0,"EffDte":"2020-05-01","IntBasisDays":"S","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":80,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.5,"Nme":"IOLTA NOW","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":119,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.15,"Nme":"MONEY SMART SAVINGS","TDMatTerm":0,"EffDte":"2020-03-26","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":122,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0,"Nme":"TERAFINA PROMO TEST","TDMatTerm":12,"EffDte":"2021-09-17","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":156,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.3,"Nme":"RETAIN 14M GOV PROMO","TDMatTerm":14,"EffDte":"2020-10-29","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":227,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.5,"Nme":"CHARITY MASTER NOW","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":268,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.05,"Nme":"BUSINESS NOW","TDMatTerm":0,"EffDte":"2020-01-14","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":303,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.1,"Nme":"MAXSAFE COMM ADV","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":304,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.1,"Nme":"MAXSAFE CA SWEEP","TDMatTerm":0,"EffDte":"2020-03-05","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":310,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0,"Nme":"BROKERED CD","TDMatTerm":12,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":403,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.03,"Nme":"3 MONTH FOUNDERS","TDMatTerm":3,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":406,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.06,"Nme":"6 MONTH FOUNDERS","TDMatTerm":6,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":409,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.09,"Nme":"9 MONTH FOUNDERS","TDMatTerm":9,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":412,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.12,"Nme":"12 MONTH FOUNDERS","TDMatTerm":12,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":418,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.18,"Nme":"18 MONTH FOUNDERS","TDMatTerm":18,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":424,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.24,"Nme":"24 MONTH FOUNDERS","TDMatTerm":24,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":430,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.3,"Nme":"30 MONTH FOUNDERS","TDMatTerm":30,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":436,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.36,"Nme":"36 MONTH FOUNDERS","TDMatTerm":36,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":448,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.48,"Nme":"48 MONTH FOUNDERS","TDMatTerm":48,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"M","IntPlnCde":460,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.6,"Nme":"60 MONTH FOUNDERS","TDMatTerm":60,"EffDte":"2020-06-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":670,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.045,"Nme":"RETENTION LEVEL SAV","TDMatTerm":0,"EffDte":"2020-03-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":671,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.02,"Nme":"RETENTION BUS LV SAV","TDMatTerm":0,"EffDte":"2020-03-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":672,"TDTermId":"D","RteSchedInd":"Y","IntStateRte":0,"Nme":"MMKT LEVEL 1","TDMatTerm":0,"EffDte":"2020-03-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":673,"TDTermId":"D","RteSchedInd":"Y","IntStateRte":0,"Nme":"BUS MMKT LEVEL 1","TDMatTerm":0,"EffDte":"2020-03-24","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":725,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.01,"Nme":"PLATINUM PREFERRED","TDMatTerm":0,"EffDte":"2020-10-19","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":750,"TDTermId":"D","RteSchedInd":"N","IntStateRte":0.01,"Nme":"RVM TEST LOW PLAN","TDMatTerm":0,"EffDte":"2021-08-16","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","TDFreqId":"T","IntPlnCde":751,"TDTermId":"D","RteSchedInd":"Y","IntStateRte":0,"Nme":"RVM TEST LOW PLAN","TDMatTerm":0,"EffDte":"2021-08-16","IntBasisDays":"T","IntCalcMeths":"S"},{"IntPmtMthd":"A","IntPlnCde":806,"TDTermId":"M","RteSchedInd":"N","IntStateRte":0.14,"Nme":"MAXSAFE 6 MONTHS","TDMatTerm":6,"EffDte":"2020-11-01","IntBasisDays":"T","IntCalcMeths":"S"}],"investment-rate-tiersLst":[{"TierMaxBal":10000,"InvestRteSchedIndx":672,"TierMinBal":0,"TierRte":0.45},{"TierMaxBal":50000,"InvestRteSchedIndx":672,"TierMinBal":10000,"TierRte":0.45},{"TierMaxBal":100000,"InvestRteSchedIndx":672,"TierMinBal":50000,"TierRte":0.45},{"TierMaxBal":9.99999999E8,"InvestRteSchedIndx":672,"TierMinBal":100000,"TierRte":0.45},{"TierMaxBal":100000,"InvestRteSchedIndx":673,"TierMinBal":0,"TierRte":0.02},{"TierMaxBal":250000,"InvestRteSchedIndx":673,"TierMinBal":100000,"TierRte":0.02},{"TierMaxBal":500000,"InvestRteSchedIndx":673,"TierMinBal":250000,"TierRte":0.02},{"TierMaxBal":750000,"InvestRteSchedIndx":673,"TierMinBal":500000,"TierRte":0.03},{"TierMaxBal":1000000,"InvestRteSchedIndx":673,"TierMinBal":750000,"TierRte":0.03},{"TierMaxBal":9.99999999E8,"InvestRteSchedIndx":673,"TierMinBal":1000000,"TierRte":0.05},{"TierMaxBal":100000,"InvestRteSchedIndx":751,"TierMinBal":0,"TierRte":0.995},{"TierMaxBal":9.99999999E8,"InvestRteSchedIndx":751,"TierMinBal":100000,"TierRte":0.05}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    String success = '{"Entity": {"control-data": {"CIMoreToBeReturnedInd": "N","CIKeySSN": "333001234","CICustNbrToStrtSearch": "00000088844","CIRequestedResTimes": 3},"customersLst": [{"CICurStdAddr1Cde": "S","CICurStdAddr2Cde": "C","CICurStdAddr1Txt": "1 WESTERN WAY","CICurStdAddr2Txt": "MILWAUKEE WI 53224","CICurStdNmeCde01": "N","CICurStdNme01": "MR Test Data","CICustRemarksInd": "N","CICustBnkNbr": 547,"CICustRtnNbr": "00000003818","CICustTaxNbr": "333001234","CICurNmeAddrEffDte": "2005-02-22","CICurNmePrcsTme": "13.20.23","MktAreaPrcVal": 90,"ElmntLstNme": "MELLEN","ElmntFrstNme": "JESSE","ElmntHouseNbr": "1","ElmntOddEvenInd": "1","ElmntStreet": "WESTERN WAY","ElmntCity": "MILWAUKEE","ElmntState": "WI","ElmntZip": "53224","CIPrspctInd": "C","CIBirthdate": "1920-01-01","CIDrvrLic": "WI","CICustTaxCde": "S","CISncDte": "1988-06-01","SurNme": "MELLEN","CIRecTypInd": "M","CITtl": "MR","CIFrstNmeMidInitl": "JESSE"},{"CICurStdAddr1Cde": "S","CICurStdAddr2Cde": "C","CICurStdAddr1Txt": "123 TESTING ST","CICurStdAddr2Txt": "MILWAUKEE WI 53222","CICurStdNmeCde01": "N","CICurStdNme01": "TEST ACCOUNTSS","CICustRemarksInd": "N","CICustBnkNbr": 547,"CICustRtnNbr": "00000079674","CICustTaxNbr": "333001234","CICurNmeAddrEffDte": "2008-02-20","CICurNmePrcsTme": "12.50.25","MktAreaPrcVal": 90,"ElmntLstNme": "ACCOUNTSS","ElmntFrstNme": "TEST","ElmntHouseNbr": "123","ElmntOddEvenInd": "1","ElmntStreet": "TESTING ST","ElmntCity": "MILWAUKEE","ElmntState": "WI","ElmntZip": "53222","CIPrspctInd": "C","CICustTaxCde": "S","CISncDte": "2008-02-20","CtryCde": "USA","SurNme": "ACCOUNTSS","CIFrstNmeMidInitl": "TEST"},{"CICurStdAddr1Cde": "S","CICurStdAddr2Cde": "C","CICurStdAddr1Txt": "777 REGDD DR","CICurStdAddr2Txt": "ANYTOWN WI 53222","CICurStdNmeCde01": "N","CICurStdNme01": "REGDD CUSTOMER","CICustRemarksInd": "N","CICustBnkNbr": 547,"CICustRtnNbr": "00000088844","CICustTaxNbr": "333001234","CICurNmeAddrEffDte": "2009-10-09","CICurNmePrcsTme": "13.39.01","MktAreaPrcVal": 90,"ElmntLstNme": "CUSTOMER","ElmntFrstNme": "REGDD","ElmntHouseNbr": "777","ElmntOddEvenInd": "1","ElmntStreet": "REGDD DR","ElmntCity": "ANYTOWN","ElmntState": "WI","ElmntZip": "53222","CIPrspctInd": "C","CICustTaxCde": "S","CISncDte": "2009-10-09","CtryCde": "USA","SurNme": "CUSTOMER","CIFrstNmeMidInitl": "REGDD"}]},"Metadata": {"MsgLst": [{"Type": "Informational Message","Code": "0","Text": "Success","Severity": "Info"}]}}';
    String successone = '{"Entity":{"control-data":{"CIMoreToBeReturnedInd":"N","CIRequestedResTimes":1,"CICustNbrToStrtSearch":"00000053531","CIKeySSN":999999993},"customersLst":[{"CIPrspctInd":"C","CICurStdAddr1Cde":"S","CIFrstNmeMidInitl":"BUZZ","CICurNmeAddrEffDte":"2020-10-02","CIBirthdate":"1990-01-01","AddrOvrideInd":"N","CICurNmePrcsTme":"09.30.03","ElmntState":"IL","CIDrvrLic":"L123-1010-1010","CICustBnkNbr":889,"CICurStdAddr1Txt":"9801WHIGGINSSUITE7001","CICustTaxNbr":999999993,"ElmntOddEvenInd":1,"CICustRtnNbr":"00000053531","ScndyPhn":8154445715,"CIPrmyPhNbr":3125551212,"ElmntDirection":"W","CtryCde":"USA","CICustEmpltSchl":"TOTHEMOON,INC","CICurStdAddr2Cde":"C","CICurStdNmeCde01":"N","ElmntZip":60018,"CIMothersMdnNme":"INFINITY","CICustTaxCde":"S","CISncDte":"2016-10-22","ElmntHouseNbr":9801,"ElmntSupplAddr":"SUITE7001","CICurStdNme01":"BUZZLIGHTYEAR","SurNme":"LIGHTYEAR","ElmntFrstNme":"BUZZ","CIRecTypInd":"M","CICurStdAddr2Txt":"ROSEMONTIL60018","MktAreaPrcVal":0,"ElmntLstNme":"LIGHTYEAR","ElmntCity":"ROSEMONT","CICustRemarksInd":"N","ElmntStreet":"HIGGINS"},{"CIPrspctInd":"C","CICurStdAddr1Cde":"S","CIFrstNmeMidInitl":"BUZZ11","CICurNmeAddrEffDte":"2020-10-02","CIBirthdate":"1990-01-01","AddrOvrideInd":"N","CICurNmePrcsTme":"09.30.03","ElmntState":"IL","CIDrvrLic":"L123-1010-1010","CICustBnkNbr":889,"CICurStdAddr1Txt":"9801WHIGGINSSUITE7001","CICustTaxNbr":999999993,"ElmntOddEvenInd":1,"CICustRtnNbr":"00000053531","ScndyPhn":8154445715,"CIPrmyPhNbr":3125551212,"ElmntDirection":"W","CtryCde":"USA","CICustEmpltSchl":"TOTHEMOON,INC","CICurStdAddr2Cde":"C","CICurStdNmeCde01":"N","ElmntZip":60018,"CIMothersMdnNme":"INFINITY","CICustTaxCde":"S","CISncDte":"2022-02-22","ElmntHouseNbr":9801,"ElmntSupplAddr":"SUITE7001","CICurStdNme01":"BUZZLIGHTYEAR","SurNme":"LIGHTYEAR","ElmntFrstNme":"BUZZ11","CIRecTypInd":"M","CICurStdAddr2Txt":"Addr2","MktAreaPrcVal":0,"ElmntLstNme":"LIGHTYEAR11","ElmntCity":"ROSEMONT","CICustRemarksInd":"N","ElmntStreet":"HIGGINS"}]},"Metadata":{"MsgLst":[{"Type":"InformationalMessage","Text":"Success","Severity":"Info","Code":"0"}]}}';
    Test.startTest();

    try {
      new FISCCGetInterestRatesResponseBuilder().build(validResponse, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      new FISCCGetInterestRatesResponseBuilder().parseResponse(new FISCCGetInterestRatesEntityResponse(), null, null);
    } catch (Exception e) {
    }
    try {
      FISCCGetInterestRatesResponseBuilder.testException = true;
      new FISCCGetInterestRatesResponseBuilder().build(null, null, null);
      new FISCCGetInterestRatesResponseBuilder().parseResponse(null, null, null);
    } catch (Exception e) {
    }

    try {
      new FISCCCustomerSearchTaxnbrResponseBuilder().build(success, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      //  new FISCCCustomerSearchTaxnbrResponseBuilder().parseResponse(new FISCCCustomerSearchTaxnbrResponse(), null, null);
    } catch (Exception e) {
    }

    try {
      new FISCCDepositOriginationResponseBuilder().build(successone, new FISCC_Adapter_Configs__mdt(), new FISCC_Charter_Config__mdt());
      new FISCCDepositOriginationResponseBuilder().parseResponse(new FISCCDepositOriginationEntityResponse(), null, null);
    } catch (Exception e) {
    }

    //DO
    try {
      FISCCDepositOriginationResponseBuilder.testException = true;
      new FISCCDepositOriginationResponseBuilder().build(null, null, null);
      new FISCCDepositOriginationResponseBuilder().parseResponse(null, null, null);
    } catch (Exception e) {
    }

    //customerSearch
    try {
      FISCCCustomerSearchTaxnbrResponseBuilder.testException = true;
      new FISCCCustomerSearchTaxnbrResponseBuilder().build(null, null, null);
      new FISCCCustomerSearchTaxnbrResponseBuilder().parseResponse(null, null, null);
    } catch (Exception e) {
    }
    Test.stopTest();
  }

  @isTest
  public static void apyFetaureTest() {
    tffa__Product__c prod800 = new tffa__Product__c();
    prod800.tffa__Category__c = 'CHECKING';
    prod800.tffa__Code__c = '800';
    prod800.Name = 'Test 800';
    prod800.InterestPlanCode__c = '750';
    insert prod800;

    tffa__ProductFeature__c prod800Feat = new tffa__ProductFeature__c();
    prod800Feat.Name = 'FEATURE_1';
    prod800Feat.tffa__Description__c = 'Variable, may be changed at any time';
    prod800Feat.tffa__Disabled__c = false;
    prod800Feat.tffa__FieldType__c = 'PERCENT';
    prod800Feat.tffa__IsComparable__c = true;
    prod800Feat.tffa__Label__c = 'Annual percentage yield';
    prod800Feat.tffa__SortOrder__c = 7;
    prod800Feat.tffa__Value__c = '0.02%';
    prod800Feat.ShowOnCard__c = false;
    prod800Feat.tffa__Product__c = prod800.Id;
    insert prod800Feat;

    tffa__Product__c prod8001 = new tffa__Product__c();
    prod8001.tffa__Category__c = 'CERTIFICATE';
    prod8001.tffa__Code__c = '8001';
    prod8001.Name = 'Test 8001';
    insert prod8001;

    tffa__ProductTerm__c prodTerm1 = new tffa__ProductTerm__c();
    prodTerm1.tffa__Code__c = 'PT-0003';
    prodTerm1.tffa__Description__c = 'We have a 12-month safe and secure CD for your savings success.';
    prodTerm1.tffa__Label__c = '12 month term';
    prodTerm1.tffa__MaxAmount__c = 999999999;
    prodTerm1.tffa__MaxTerm__c = 12;
    prodTerm1.tffa__MinAmount__c = 100000;
    prodTerm1.tffa__MinTerm__c = 12;
    prodTerm1.tffa__SortOrder__c = 1;
    prodTerm1.tffa__InterestPlanCode__c = '812';
    prodTerm1.tffa__Product__c = prod8001.Id;
    insert prodTerm1;

    tffa__ProductTerm__c prodTerm2 = new tffa__ProductTerm__c();
    prodTerm2.tffa__Code__c = 'PT-0004';
    prodTerm2.tffa__Description__c = 'We have a 18-month safe and secure CD for your savings success.';
    prodTerm2.tffa__Label__c = '18 month term';
    prodTerm2.tffa__MaxAmount__c = 99999999;
    prodTerm2.tffa__MaxTerm__c = 18;
    prodTerm2.tffa__MinAmount__c = 100000;
    prodTerm2.tffa__MinTerm__c = 18;
    prodTerm2.tffa__SortOrder__c = 2;
    prodTerm2.tffa__InterestPlanCode__c = '818';
    prodTerm2.tffa__Product__c = prod8001.Id;
    insert prodTerm2;

    tffa__ProductFeature__c prod8001Feat1 = new tffa__ProductFeature__c();
    prod8001Feat1.Name = 'FEATURE_1';
    prod8001Feat1.tffa__Description__c = '12 month term';
    prod8001Feat1.tffa__Disabled__c = false;
    prod8001Feat1.tffa__FieldType__c = 'PERCENT';
    prod8001Feat1.tffa__IsComparable__c = true;
    prod8001Feat1.tffa__Label__c = 'Annual percentage yield';
    prod8001Feat1.tffa__SortOrder__c = 1;
    prod8001Feat1.tffa__Value__c = '0.02%';
    prod8001Feat1.ShowOnCard__c = false;
    prod8001Feat1.tffa__Product__c = prod8001.Id;
    insert prod8001Feat1;

    tffa__ProductFeature__c prod8001Feat2 = new tffa__ProductFeature__c();
    prod8001Feat2.Name = 'FEATURE_2';
    prod8001Feat2.tffa__Description__c = '18 month term';
    prod8001Feat2.tffa__Disabled__c = false;
    prod8001Feat2.tffa__FieldType__c = 'PERCENT';
    prod8001Feat2.tffa__IsComparable__c = true;
    prod8001Feat2.tffa__Label__c = 'Annual percentage yield';
    prod8001Feat2.tffa__SortOrder__c = 1;
    prod8001Feat2.tffa__Value__c = '0.02%';
    prod8001Feat2.ShowOnCard__c = false;
    prod8001Feat2.tffa__Product__c = prod8001.Id;
    insert prod8001Feat2;

    tffa__Product__c prod8002 = new tffa__Product__c();
    prod8002.tffa__Category__c = 'CHECKING';
    prod8002.tffa__Code__c = '8002';
    prod8002.Name = 'Test 8002';
    insert prod8002;

    tffa__ProductTerm__c prodTerm3 = new tffa__ProductTerm__c();
    prodTerm3.tffa__Code__c = 'PT-0005';
    prodTerm3.tffa__Description__c = 'We have a 12-month safe and secure CD for your savings success.';
    prodTerm3.tffa__Label__c = '12 month term';
    prodTerm3.tffa__MaxAmount__c = 999999999;
    prodTerm3.tffa__MaxTerm__c = 12;
    prodTerm3.tffa__MinAmount__c = 100000;
    prodTerm3.tffa__MinTerm__c = 12;
    prodTerm3.tffa__SortOrder__c = 1;
    prodTerm3.tffa__InterestPlanCode__c = '915';
    prodTerm3.tffa__Product__c = prod8002.Id;
    insert prodTerm3;

    tffa__ProductTerm__c prodTerm4 = new tffa__ProductTerm__c();
    prodTerm4.tffa__Code__c = 'PT-0004';
    prodTerm4.tffa__Description__c = 'We have a 18-month safe and secure CD for your savings success.';
    prodTerm4.tffa__Label__c = '18 month term';
    prodTerm4.tffa__MaxAmount__c = 99999999;
    prodTerm4.tffa__MaxTerm__c = 18;
    prodTerm4.tffa__MinAmount__c = 100000;
    prodTerm4.tffa__MinTerm__c = 18;
    prodTerm4.tffa__SortOrder__c = 2;
    prodTerm4.tffa__InterestPlanCode__c = '916';
    prodTerm4.tffa__Product__c = prod8002.Id;
    insert prodTerm4;

    tffa__Product__c prod8003 = new tffa__Product__c();
    prod8003.tffa__Category__c = 'CHECKING';
    prod8003.tffa__Code__c = '8004';
    prod8003.Name = 'Test 8004';
    prod8003.InterestPlanCode__c = '753';
    insert prod8003;

    tffa__ProductFeature__c prod8003Feat = new tffa__ProductFeature__c();
    prod8003Feat.Name = 'FEATURE_1';
    prod8003Feat.tffa__Description__c = 'Variable, may be changed at any time';
    prod8003Feat.tffa__Disabled__c = false;
    prod8003Feat.tffa__FieldType__c = 'PERCENT';
    prod8003Feat.tffa__IsComparable__c = true;
    prod8003Feat.tffa__Label__c = 'Annual percentage yield';
    prod8003Feat.tffa__SortOrder__c = 7;
    prod8003Feat.tffa__Value__c = '0.02%';
    prod8003Feat.ShowOnCard__c = false;
    prod8003Feat.tffa__Product__c = prod8003.Id;
    insert prod8003Feat;

    tffa__ProductMatrix__c prodMat2 = new tffa__ProductMatrix__c();
    prodMat2.tffa__BrandCodeSet__c = '12342';
    prodMat2.StateCodeSet__c = '3211';
    prodMat2.ZipCodeSet__c = '1234';
    prodMat2.tffa__Product__c = prod800.Id;
    insert prodMat2;

    tffa__ProductMatrix__c prodMat3 = new tffa__ProductMatrix__c();
    prodMat3.tffa__BrandCodeSet__c = '12342';
    prodMat3.StateCodeSet__c = '3211';
    prodMat3.ZipCodeSet__c = '1234';
    prodMat3.tffa__Product__c = prod8003.Id;
    insert prodMat3;

    tffa__ProductMatrix__c prodMat4 = new tffa__ProductMatrix__c();
    prodMat4.tffa__BrandCodeSet__c = '12342';
    prodMat4.StateCodeSet__c = '3211';
    prodMat4.ZipCodeSet__c = '1234';
    prodMat4.tffa__Product__c = prod8002.Id;
    insert prodMat4;

    tffa__ProductMatrix__c prodMat6 = new tffa__ProductMatrix__c();
    prodMat6.tffa__BrandCodeSet__c = '12342';
    prodMat6.StateCodeSet__c = '3211';
    prodMat6.ZipCodeSet__c = '1234';
    prodMat6.tffa__Product__c = prod8001.Id;
    insert prodMat6;

    InterestPlanDetails__c intPln750 = new InterestPlanDetails__c();
    intPln750.IntPlnCde__c = '750';
    intPln750.BrandCode__c = '12342';
    intPln750.RteSchedInd__c = 'N';
    intPln750.APY__c = 0.01;
    insert intPln750;

    InterestPlanDetails__c intPln753 = new InterestPlanDetails__c();
    intPln753.IntPlnCde__c = '753';
    intPln753.BrandCode__c = '12342';
    intPln753.RteSchedInd__c = 'Y';
    insert intPln753;

    InterestPlanDetails__c intPln812 = new InterestPlanDetails__c();
    intPln812.IntPlnCde__c = '812';
    intPln812.BrandCode__c = '12342';
    intPln812.APY__c = 0.05;
    insert intPln812;

    InterestPlanDetails__c intPln818 = new InterestPlanDetails__c();
    intPln818.IntPlnCde__c = '818';
    intPln818.BrandCode__c = '12342';
    intPln818.APY__c = 0.06;
    insert intPln818;

    InterestPlanDetails__c intPln915 = new InterestPlanDetails__c();
    intPln915.IntPlnCde__c = '915';
    intPln915.BrandCode__c = '12342';
    intPln915.RteSchedInd__c = 'N';
    insert intPln915;

    InterestPlanDetails__c intPln916 = new InterestPlanDetails__c();
    intPln916.IntPlnCde__c = '916';
    intPln916.BrandCode__c = '12342';
    intPln916.APY__c = 0.45;
    intPln916.RteSchedInd__c = 'N';
    insert intPln916;

    Test.startTest();
    Map<String, Object> facts = new Map<String, Object>();
    facts.put('zipCode', '1234');
    facts.put('stateCode', '3211');
    facts.put('brandCode', '12342');

    Map<String, Object> facts2 = new Map<String, Object>();
    facts2.put('brandCode', '12342');
    List<tffa__ProductMatrix__c> prod = CZWTFCProductService.readProductMatrix(facts);
    CZWTFCProductService.readProducts(prod, facts2);
    Test.stopTest();
  }

  @isTest
  public static void NCRD3Test() {
    tffa__Submission__c sub = new tffa__Submission__c(
      tffa__Status__c = 'SUBMITTED',
      tffa__State__c = 'ReviewSubmit',
      DisclosureConverted__c = true,
      tffa__Brand__c = '118'
    );
    insert sub;
    tffa__Product__c product = CZWTFCTestDataRepository.createCheckingProduct();

    tffa__Brand__c brandObj = new tffa__Brand__c();
    brandObj.Name = '118';
    brandObj.tffa__Code__c = '118';
    brandObj.FooterLogo__c = 'test';
    brandObj.HeaderLogo__c = 'test';
    brandObj.CIPrmyOffcrNbr__c = '1000';
    insert brandObj;

    tffa__Party__c party = CZWTFCTestDataRepository.createIndividualParty();
    party.tffa__OnboardingDate__c = Date.newInstance(2038, 10, 12);
    party.CellPhoneNumber__c = '+11234567891';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '+11234567892';
    party.tffa__BrandCode__c = brandObj.tffa__Code__c;

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(party);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
      party = (tffa__Party__c) asmParty.assemble();
      insert party;
    
    tffa__AdditionalPreference__c testprefernce = new tffa__AdditionalPreference__c();
    testprefernce.Name = 'abc';
    testprefernce.tffa__Code__c = 'abc';
    testprefernce.tffa__Submission__c = sub.Id;
    testprefernce.tffa__Party__c = party.Id;
    testprefernce.tffa__AddOnServiceType__c = 'ONLINE_BANKING';
    insert testprefernce;
    
      List<tffa__AdditionalPreference__c> testprefernces = new List<tffa__AdditionalPreference__c>();
      testprefernces.add(testprefernce);
    
      asmParty.addChildObjects('tffa__AdditionalPreferences__r', testprefernces);
      party = (tffa__Party__c) asmParty.assemble();
      upsert party;
    
      CZNCRD3PartyAuthenticationProvider.registerOnlineBankingUserId(sub, party);
  }
}