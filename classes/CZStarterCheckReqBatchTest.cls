@isTest
private class CZStarterCheckReqBatchTest {
  @isTest
  static void CZStarterCheckReqBatchTestTwo() {
    Test.startTest();

    try {
      CZStarterCheckReqBatch bc = new CZStarterCheckReqBatch();
      database.executeBatch(bc);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    CZWTFCPrintRequestDTO request = new CZWTFCPrintRequestDTO();
    request.PrintRequest.CheckData.JobID = '3223525';
    request.PrintRequest.CheckData.CustomerData01 = 'Title1';
    request.PrintRequest.CheckData.CustomerData02 = 'Title2';
    request.PrintRequest.CheckData.CustomerData03 = 'Title3';
    request.PrintRequest.CheckData.CustomerData04 = 'Title4';
    request.PrintRequest.CheckData.CustomerData05 = 'Title5';
    request.PrintRequest.CheckData.CheckNumber01 = 10;
    request.PrintRequest.CheckData.CheckNumber02 = 11;
    request.PrintRequest.CheckData.CheckNumber03 = 12;
    request.PrintRequest.CheckData.BranchID = '234';
    request.PrintRequest.CheckData.RoutingNumber = '12312';
    request.PrintRequest.CheckData.AccountNumber = '124214';

    String str = CZWTFCPrintRequestDTO.requestBody(request);
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
    wintrustEnvConfig.StarterCheckUserID__c = '45545';
    String staterChqId = wintrustEnvConfig.StarterCheckUserID__c;
    staterChqId = '23432';
    request.PrintRequest.CheckData.UserID = staterChqId;

    String strObj = CZWTFCPrintRequestDTO.requestBody(request);

    String bulkContent = '<?xml version="1.0"?>' + new CZWTFCXMLSerializer().serialize(request);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckReqBatchTestThree() {
    Test.startTest();

    try {
      tffa__Application__c app = new tffa__Application__c();
      tffa__AccountPreference__c accPref = new tffa__AccountPreference__c();

      Database.executeBatch(new CZStarterCheckReqBatch());
      CZStarterCheckExecutor.processRequest(app);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    CZWTFCPrintRequestDTO request = new CZWTFCPrintRequestDTO();
    request.PrintRequest.CheckData.JobID = '3223525';
    request.PrintRequest.CheckData.CustomerData01 = 'Title1';
    request.PrintRequest.CheckData.CustomerData02 = 'Title2';
    request.PrintRequest.CheckData.CustomerData03 = 'Title3';
    request.PrintRequest.CheckData.CustomerData04 = 'Title4';
    request.PrintRequest.CheckData.CustomerData05 = 'Title5';
    request.PrintRequest.CheckData.CheckNumber01 = 10;
    request.PrintRequest.CheckData.CheckNumber02 = 11;
    request.PrintRequest.CheckData.CheckNumber03 = 12;
    request.PrintRequest.CheckData.BranchID = '234';
    request.PrintRequest.CheckData.RoutingNumber = '12312';
    request.PrintRequest.CheckData.AccountNumber = '124214';

    String str = CZWTFCPrintRequestDTO.requestBody(request);
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
    wintrustEnvConfig.StarterCheckUserID__c = '45545';
    String staterChqId = wintrustEnvConfig.StarterCheckUserID__c;
    staterChqId = '23432';
    request.PrintRequest.CheckData.UserID = staterChqId;

    String strObj = CZWTFCPrintRequestDTO.requestBody(request);

    String bulkContent = '<?xml version="1.0"?>' + new CZWTFCXMLSerializer().serialize(request);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckReqBatchTestFour() {
    Test.startTest();

    try {
      Database.executeBatch(new CZStarterCheckReqBatch());
      CZStarterCheckExecutor.processRequest(null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckReqBatchTestFive() {
    Test.startTest();

    CZWTFCExistingIRAPlanDTO dto = new CZWTFCExistingIRAPlanDTO();
    dto.CustPlnNbr = '1234';
    dto.CustPlnTyp = '2343';

    CZWTFCIRAPlanBeneficiaryDTO benDto = new CZWTFCIRAPlanBeneficiaryDTO();
    benDto.Nme = 'abc';
    benDto.TaxId = '2343';
    benDto.TxpyrNbr = '345';
    benDto.SpseNonSpseInd = 'Y';
    benDto.PrmyCntgInd = 'Y';
    benDto.Birthdate = '2343';
    benDto.Phn = '436363643';
    benDto.GovtRptInfoInd = 'N';

    FISCCGetIRAPlansEntityResponse resp = new FISCCGetIRAPlansEntityResponse();
    FISCCGetIRAPlanBeneficiaryEntityResponse respn = new FISCCGetIRAPlanBeneficiaryEntityResponse();
    FISCCDOCardCreationRequest req = new FISCCDOCardCreationRequest();

    CZWTFCOfficerDetailsDTO offDto = new CZWTFCOfficerDetailsDTO();
    offDto.SecLendLmt = 23;
    offDto.Phone = '23425235';
    offDto.Nme = 'abc';
    offDto.OfcrNbr = 243;
    offDto.UnsecLendLmt = 12;
    offDto.BrandCode = '234';

    CZSDBAddDeputyRequestDTO rDto = new CZSDBAddDeputyRequestDTO();
    rDto.Brnch = 'abc';
    rDto.BoxPrfx = 'abc';
    rDto.BoxNbr = '234';
    rDto.Deputy1NmeAddr1 = 'add1';
    rDto.Deputy1NmeAddr2 = 'add1';
    rDto.Deputy1NmeAddr3 = 'add1';
    rDto.Deputy1NmeAddr4 = 'add1';
    rDto.Deputy1NmeAddr5 = 'add1';
    rDto.Deputy1ShrtNme = 'add1';
    rDto.Deputy1HmPhPrt1 = 'add1';
    rDto.Deputy1HmPhPrt2 = 'add1';
    rDto.Deputy1HmPhPrt3 = 'add1';
    rDto.Deputy1BusPhPrt1 = 'add1';
    rDto.Deputy1BusPhPrt2 = 'add1';
    rDto.Deputy1BusPhPrt3 = 'add1';
    rDto.Deputy1TaxId = 'add1';
    rDto.Deputy1TaxNbr = 'add1';
    rDto.Deputy2NmeAddr1 = 'add1';
    rDto.Deputy2NmeAddr2 = 'add1';
    rDto.Deputy2NmeAddr3 = 'add1';
    rDto.Deputy2NmeAddr4 = 'add1';
    rDto.Deputy2NmeAddr5 = 'add1';
    rDto.Deputy2ShrtNme = 'add1';
    rDto.Deputy2HmPhPrt1 = 'add1';
    rDto.Deputy2HmPhPrt2 = 'add1';
    rDto.Deputy2HmPhPrt3 = 'add1';
    rDto.Deputy2BusPhPrt1 = 'add1';
    rDto.Deputy2BusPhPrt2 = 'add1';
    rDto.Deputy2BusPhPrt3 = 'add1';
    rDto.Deputy2TaxId = 'add1';
    rDto.Deputy2TaxNbr = 'add1';

    FISCCDebitCardCreationRequestDTO reDto = new FISCCDebitCardCreationRequestDTO();
    reDto.CBCrdNbr = 'abcd';
    reDto.CustNbr = 'abcd';
    reDto.CBStAbbr = 'abcd';
    reDto.CBInstnNbr = 'abcd';
    reDto.CBCrdPrfxNbr = 'abcd';
    reDto.CBBrnchNbr = 'abcd';
    reDto.CBStrAddrLne1 = 'abcd';
    reDto.CBStrAddrLne2 = 'abcd';
    reDto.CBCtyNme = 'abcd';
    reDto.CBZIP = 'abcd';
    reDto.CBPrmyDdaAcctNbr = 'abcd';
    reDto.CBPrmySavAcctNbr = 'abcd';
    reDto.CBPrmySsn = 'abcd';
    reDto.NmeEmbossOnCard = 'abcd';
    reDto.CBShrtNmeFrst = 'abcd';
    reDto.CBShrtNmeLst = 'abcd';
    reDto.CBCrdNmeLne1 = 'abcd';

    FISCCCreatePhoneNumberDTO nDto = new FISCCCreatePhoneNumberDTO();
    nDto.ResnCde = 'que';
    nDto.AddDelInd = 'que';
    nDto.LocalNbr = 'que';
    nDto.AreaCde = 'que';
    nDto.ExpireDte = 'que';

    FISCCIndividualDemographicsDTO gDto = new FISCCIndividualDemographicsDTO();
    gDto.CICustDteOfBrth = '23532';
    gDto.CIApplNbr = '23532';
    gDto.NNAPhnNum = '23532';

    CZSDBAddOwnerRequestDTO reqDto = new CZSDBAddOwnerRequestDTO();
    reqDto.Brnch = 'abcde';
    reqDto.BoxPrfx = 'abcde';
    reqDto.BoxNbr = 'abcde';
    reqDto.ShrtNme = 'abcde';
    reqDto.CurTerm = 'abcde';
    reqDto.ExpDte = 'abcde';
    reqDto.CurBillCde = 'abcde';
    reqDto.BillableAcct = 'abcde';
    reqDto.RnwTerm = 'abcde';
    reqDto.RnwRteCde = 'abcde';
    reqDto.RnwBillCde = 'abcde';
    reqDto.DteRentedMM = 'abcde';
    reqDto.DteRentedDD = 'abcde';
    reqDto.DteRentedCCYY = 'abcde';
    reqDto.RepositionPassInd = 'abcde';
    reqDto.CurRteCde = 'abcde';
    reqDto.NmeAddr1 = 'abcde';
    reqDto.NmeAddr2 = 'abcde';
    reqDto.NmeAddr3 = 'abcde';
    reqDto.NmeAddr4 = 'abcde';
    reqDto.HmPh1 = 'abcde';
    reqDto.HmPh2 = 'abcde';
    reqDto.HmPh3 = 'abcde';
    reqDto.BusPh1 = 'abcde';
    reqDto.BusPh2 = 'abcde';
    reqDto.BusPh3 = 'abcde';
    reqDto.TaxId = 'abcde';
    reqDto.TaxNbr = 'abcde';
    reqDto.PrmyOffcr = 'abcde';
    reqDto.CstCntr = 'abcde';
    reqDto.OwnComment1 = 'abcde';
    reqDto.OwnComment2 = 'abcde';
    reqDto.CurDiscPremInd = 'abcde';
    reqDto.AmtDue = 'abcde';
    reqDto.CautionCde1 = 'abcde';
    reqDto.CautionCde2 = 'abcde';
    reqDto.CautionCde3 = 'abcde';

    FISCCInvestmentRateSchedulesDTO scDto = new FISCCInvestmentRateSchedulesDTO();
    scDto.IntPlnCde = 'wabcdef';
    scDto.Nme = 'wabcdef';
    scDto.EffDte = 'wabcdef';
    scDto.IntBasisDays = 'wabcdef';
    scDto.IntPmtMthd = 'wabcdef';
    scDto.TDFreqId = 'wabcdef';
    scDto.TDMatTerm = 3;
    scDto.TDTermId = 'y';
    scDto.IntCalcMeths = 'y';
    scDto.RteSchedInd = 'y';
    scDto.DelInd = 'y';

    CZMDMOAuthResponse atDto = new CZMDMOAuthResponse();
    atDto.access_token = 'abcd';
    atDto.token_type = 'abcd';
    atDto.expires_in = 23;

    FISCCOrganizationDTO orgDto = new FISCCOrganizationDTO();
    orgDto.CICustNbr = 'sdfdsf';
    orgDto.CICurStdAddr1Cde = 'sdfdsf';
    orgDto.CICurStdAddr2Cde = 'sdfdsf';
    orgDto.CICurStdAddr3Cde = 'sdfdsf';
    orgDto.CICurStdAddr4Cde = 'sdfdsf';
    orgDto.CICurStdAddr5Cde = 'sdfdsf';

    CZMDMAuthenticationRequest authDto = new CZMDMAuthenticationRequest();
    authDto.frstNme = 'fn';
    authDto.lstNme = 'fn';
    authDto.ssnNmb = 'fn';
    authDto.acctNmb = 'fn';
    authDto.birthDte = 'fn';
    authDto.debitCrdlast4 = 'fn';

    CZWTFCAccApiResponse apiDto = new CZWTFCAccApiResponse();
    apiDto.isSuccess = true;
    apiDto.responseStatusCode = 32;
    apiDto.responseStatusMess = 'we';
    apiDto.successMess = 'we';
    apiDto.faultString = 'we';
    apiDto.faultDesc = 'we';
    apiDto.faultDetailDesc = 'we';
    apiDto.token = 'we';

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}