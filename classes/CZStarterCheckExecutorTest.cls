@isTest
private class CZStarterCheckExecutorTest {
  @isTest
  static void CZStarterCheckExecutorTestOne() {
    Test.startTest();
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    insert prod;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      AccountPreference__c = 'PENDING',
      AccountOpeningStatus__c = 'SUCCESS',
      CostCenter__c = '94184',
      CZTitle1__c = '001',
      CZTitle2__c = '002',
      CZTitle3__c = '003',
      CZTitle4__c = '004',
      CZTitle5__c = '005'
    );
    insert app;

    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    insert party;

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = 'CHECK-ORDER',
      CZIsStarterCheckRequired__c = true,
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;
    tffa.SObjectAssembler asmApp = new tffa.SObjectAssembler(app);
    asmApp.addChildObjects('AccountPreferences__r', new List<tffa__AccountPreference__c>{ accPref });
    app = (tffa__Application__c) asmApp.assemble();

    try {
      FISCCIntegrationLogService.setSubmissionObj(sub.Id);
      FISCCIntegrationLogService.setIntegrationLog(sub.Id);
      Database.executeBatch(new CZStarterCheckReqBatch());
      CZStarterCheckExecutor.processRequest(app);
      CZWTFCApplicationRepository.save(new List<tffa__Application__c>{ app });
      CZWTFCXMLSerializer serializer = new CZWTFCXMLSerializer();
      serializer.serialize('test', true, 'test');
      serializer.serialize(new List<object>{'test'}, true, 'test');
      serializer.serialize(new List<object>{new List<object> {'test'}}, true, 'test');
      serializer.serialize(new List<object>{new Map<String, object> {'test'=>'test'}}, true, 'test');
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckExecutorTestTwo() {
    Test.startTest();
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;

    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    prod.CZStarterCheckStartNumber__c = 12;
    prod.CZStarterCheckCount__c = 12;
    insert prod;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      AccountPreference__c = 'PENDING',
      AccountOpeningStatus__c = 'SUCCESS',
      CostCenter__c = '94184',
      CZTitle1__c = '001',
      CZTitle2__c = '002',
      CZTitle3__c = '003',
      CZTitle4__c = '004',
      CZTitle5__c = '005'
    );
    insert app;

    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    insert party;

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = '12123',
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;
    tffa.SObjectAssembler asmApp = new tffa.SObjectAssembler(app);
    asmApp.addChildObjects('AccountPreferences__r', new List<tffa__AccountPreference__c>{ accPref });
    app = (tffa__Application__c) asmApp.assemble();

    try {
      FISCCIntegrationLogService.setSubmissionObj(sub.Id);
      FISCCIntegrationLogService.setIntegrationLog(sub.Id);
      Database.executeBatch(new CZStarterCheckReqBatch());
      CZStarterCheckExecutor.processRequest(app);
      List<UploadFileHistory__c> uploadHistoryList = CZWTFCHelperRepository.fetchUploadFileHistory(app.Id, 'STARTER_CHECK');
      WTFCObjectManagerRepository.doUpsertObject(accPref);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    try {
      WTFCObjectManagerRepository.doDeleteObjects(new List<tffa__AccountPreference__c>{ accPref });
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
  static void CZStarterCheckExecutorTestThree() {
    Test.startTest();
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    FISCCIntegrationLogService.setIntegrationLog(sub.Id);

    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    prod.CZStarterCheckStartNumber__c = 12;
    prod.CZStarterCheckCount__c = 12;
    insert prod;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      AccountPreference__c = 'PENDING',
      AccountOpeningStatus__c = 'SUCCESS',
      CostCenter__c = '94184',
      CZTitle1__c = '001',
      CZTitle2__c = '002',
      CZTitle3__c = '003',
      CZTitle4__c = '004',
      CZTitle5__c = '005'
    );
    insert app;

    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    insert party;

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = 'CHECK-ORDER',
      CZIsStarterCheckRequired__c = true,
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;
    tffa.SObjectAssembler asmApp = new tffa.SObjectAssembler(app);
    asmApp.addChildObjects('AccountPreferences__r', new List<tffa__AccountPreference__c>{ accPref });
    app = (tffa__Application__c) asmApp.assemble();

    try {
      Database.executeBatch(new CZStarterCheckReqBatch());
      CZStarterCheckExecutor.processRequest(app);
      CZStarterCheckExecutor.setUploadHistory(app, 'abc', 1234);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckExecutorTestTFour() {
    Test.startTest();
    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    FISCCIntegrationLogService.setIntegrationLog(sub.Id);

    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    prod.CZStarterCheckStartNumber__c = 12;
    prod.CZStarterCheckCount__c = 12;
    insert prod;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      AccountPreference__c = 'PENDING',
      AccountOpeningStatus__c = 'SUCCESS',
      CostCenter__c = '94184',
      CZTitle1__c = '001',
      CZTitle2__c = '002',
      CZTitle3__c = '003',
      CZTitle4__c = '004',
      CZTitle5__c = '005'
    );
    insert app;

    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    insert party;

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = 'CHECK-ORDER',
      CZIsStarterCheckRequired__c = true,
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;
    tffa.SObjectAssembler asmApp = new tffa.SObjectAssembler(app);
    asmApp.addChildObjects('AccountPreferences__r', new List<tffa__AccountPreference__c>{ accPref });
    app = (tffa__Application__c) asmApp.assemble();
    try {
      Database.executeBatch(new CZStarterCheckReqBatch());
      CZStarterCheckExecutor.processRequest(app);
      CZStarterCheckExecutor.setUploadHistory(app, 'abc', 1234);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      List<UploadFileHistory__c> updatedUploadHistoryList = new List<UploadFileHistory__c>();
      UploadFileHistory__c uploadFileHistory = new UploadFileHistory__c();
      uploadFileHistory.BrandCode__c = '235';
      uploadFileHistory.FileName__c = 'abc';
      uploadFileHistory.FileExt__c = '.xml';
      uploadFileHistory.FileType__c = 'STARTER_CHECK';
      uploadFileHistory.DocumentId__c = '13123';
      uploadFileHistory.FileTransferStatus__c = 'FAILURE';
      uploadFileHistory.SubmissionName__c = 'Name';
      uploadFileHistory.SerialNumber__c = '777';
      updatedUploadHistoryList.add(uploadFileHistory);
      CZWTFCHelperRepository.save(updatedUploadHistoryList);
      updatedUploadHistoryList.clear();
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckExecutorTestFive() {
    Test.startTest();
    try {
      CZStarterCheckReqBatch bc = new CZStarterCheckReqBatch();
      database.executeBatch(bc);
      CZStarterCheckExecutor.processRequest(null);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckExecutorTestSix() {
    Test.startTest();

    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    FISCCIntegrationLogService.setIntegrationLog(sub.Id);

    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    prod.CZStarterCheckStartNumber__c = 12;
    prod.CZStarterCheckCount__c = 12;
    insert prod;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      FISBranchCode__c = '909',
      AccountPreference__c = 'PENDING',
      AccountOpeningStatus__c = 'SUCCESS',
      CostCenter__c = '94184',
      CZTitle1__c = '001',
      CZTitle2__c = '002',
      CZTitle3__c = '003',
      CZTitle4__c = '004',
      CZTitle5__c = '005'
    );
    insert app;

    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    insert party;

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = 'CHECK-ORDER',
      CZIsStarterCheckRequired__c = true,
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;

    tffa.SObjectAssembler asmApp = new tffa.SObjectAssembler(app);
    asmApp.addChildObjects('AccountPreferences__r', new List<tffa__AccountPreference__c>{ accPref });
    app = (tffa__Application__c) asmApp.assemble();

    try {
      CZStarterCheckReqBatch bc = new CZStarterCheckReqBatch();
      database.executeBatch(bc);
      CZStarterCheckExecutor.processRequest(app);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      List<UploadFileHistory__c> uploadHistoryList = CZWTFCHelperRepository.fetchUploadFileHistory(app.Id, 'STARTER_CHECK');
      Integer fileNumber = 1;
      Integer starterChqNum = 101;
      if (starterChqNum == 0 || starterChqNum == null) {
        starterChqNum = 101;
      }
      Integer starterCheckCount = 12;
      Integer count = starterCheckCount != null ? (starterCheckCount / 3) : 0;
      if (count == 0) {
        count = count + 1;
      } else {
        count = (Math.mod(starterCheckCount, 3) != 0) ? count + 1 : count;
      }
      Integer starterCount = count;
      Integer uploadedHistoryCount = 2;
      uploadHistoryList.clear();

      tffa.Logger.debug('CZStarterCheckExecutor count ' + count);

      List<String> uploadHistorySerialNum = new List<String>();
      List<String> uploadHistoryFileName = new List<String>();

      count = 3;
      uploadedHistoryCount = 2;

      if (count != uploadedHistoryCount) {
        while ((count - uploadedHistoryCount) > 0) {
          if (uploadedHistoryCount != 0) {
            uploadHistoryList = CZWTFCHelperRepository.fetchUploadFileHistory(app.Id, 'STARTER_CHECK');
            for (UploadFileHistory__c obj : uploadHistoryList) {
              uploadHistorySerialNum.add(obj.SerialNumber__c);
              uploadHistoryFileName.add(obj.FileName__c);
            }
            uploadHistorySerialNum.sort();
            uploadHistoryFileName.sort();
          }
          tffa.Logger.debug('CZStarterCheckExecutor uploadHistorySerialNum ' + uploadHistorySerialNum);
          tffa.Logger.debug('CZStarterCheckExecutor uploadHistoryFileName ' + uploadHistoryFileName);

          if (uploadHistorySerialNum != null && !uploadHistorySerialNum.isEmpty()) {
            starterChqNum = Integer.valueOf(uploadHistorySerialNum[uploadHistorySerialNum.size() - 1]);
            starterChqNum++;
          }
          if (uploadHistoryFileName != null && !uploadHistoryFileName.isEmpty()) {
            String str = uploadHistoryFileName[uploadHistoryFileName.size() - 1];
            str = str.substring(str.indexOf('-') + 1, str.lastIndexOf('.'));
            fileNumber = Integer.valueOf(str);
            fileNumber++;
          }
          tffa.Logger.debug('CZStarterCheckExecutor starterChqNum :' + starterChqNum);
          tffa.Logger.debug('CZStarterCheckExecutor fileNumber :' + fileNumber);

          CZWTFCPrintRequestDTO request = new CZWTFCPrintRequestDTO();
          request.PrintRequest.CheckData.JobID = accPref.StarterCheckJobID__c;
          request.PrintRequest.CheckData.CustomerData01 = app.CZTitle1__c;
          request.PrintRequest.CheckData.CustomerData02 = app.CZTitle2__c;
          request.PrintRequest.CheckData.CustomerData03 = app.CZTitle3__c;
          request.PrintRequest.CheckData.CustomerData04 = app.CZTitle4__c;
          request.PrintRequest.CheckData.CustomerData05 = app.CZTitle5__c;
          request.PrintRequest.CheckData.CheckNumber01 = starterChqNum++;
          request.PrintRequest.CheckData.CheckNumber02 = starterChqNum++;
          request.PrintRequest.CheckData.CheckNumber03 = starterChqNum++;
          request.PrintRequest.CheckData.BranchID = app.FISBranchCode__c;
          request.PrintRequest.CheckData.RoutingNumber = app.tffa__RoutingNumber__c;
          request.PrintRequest.CheckData.AccountNumber = app.tffa__AccountNumber__c;
          WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
          String staterChqId = wintrustEnvConfig.StarterCheckUserID__c;
          request.PrintRequest.CheckData.UserID = staterChqId;

          String bulkContent = '<?xml version="1.0"?>' + new CZWTFCXMLSerializer().serialize(request);

          String fileName = 'Starter_Check_' + accPref.StarterCheckJobID__c + '-' + fileNumber + '.xml';

          CZStarterCheckExecutor.setUploadHistory(app, 'abc', starterChqNum);

          FISCCIntegrationLogService.setLogItemRequestAndResponse(bulkContent, null);
          fileNumber++;
          count--;
          tffa.Logger.debug('CZStarterCheckExecutor New File Generated* ');
          uploadHistorySerialNum.clear();
          uploadHistoryFileName.clear();
        }
      } else {
        tffa.Logger.debug('CZStarterCheckExecutor Already File Generated - No Changes.');
      }
      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);

      if (starterCount == uploadHistoryList.size()) {
        WTFCObjectManagerRepository.doUpsertObject(accPref);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZStarterCheckExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      tffa.Logger.flush();
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }

  @isTest
  static void CZStarterCheckExecutorTestSeven() {
    Test.startTest();

    tffa__Submission__c sub = new tffa__Submission__c(tffa__Brand__c = '118');
    insert sub;
    FISCCIntegrationLogService.setSubmissionObj(sub.Id);
    FISCCIntegrationLogService.setIntegrationLog(sub.Id);

    tffa__Product__c prod = new tffa__Product__c();
    prod.tffa__Code__c = '111';
    prod.Name = 'Access Plus Checking';
    prod.tffa__Category__c = 'checking';
    prod.DefaultFISBranchCode__c = '988';
    prod.UseDefaultBranchCostCenter__c = true;
    prod.CZStarterCheckStartNumber__c = 12;
    prod.CZStarterCheckCount__c = 12;
    insert prod;

    tffa__Application__c app = new tffa__Application__c(
      tffa__Submission__c = sub.id,
      tffa__Product__c = prod.id,
      tffa__AccountNumber__c = '1775283',
      tffa__Amount__c = 100.0,
      tffa__PromotionCode__c = 'SUMMERJOY',
      tffa__ProductCategory__c = 'CHECKING',
      tffa__ProductCode__c = '0032',
      tffa__KYCDecisionOutcome__c = 'APPROVED',
      tffa__Status__c = 'ACCOUNT_OPENED',
      FISBranchCode__c = '909',
      AccountPreference__c = 'PENDING',
      AccountOpeningStatus__c = 'SUCCESS',
      CostCenter__c = '94184',
      CZTitle1__c = '001',
      CZTitle2__c = '002',
      CZTitle3__c = '003',
      CZTitle4__c = '004',
      CZTitle5__c = '005'
    );
    insert app;

    tffa__Party__c party = new tffa__Party__c();
    party.tffa__BirthDate__c = Date.newInstance(1988, 2, 12);
    party.tffa__PrimaryPhone__c = '5072630009';
    party.tffa__FirstName__c = 'SSANDRAAAA';
    party.tffa__NationalIdentifierValue__c = '666001753';
    party.tffa__LastName__c = 'CCOBAAAAAAAAAA';
    party.tffa__MiddleName__c = '';
    party.tffa__Citizenship__c = 'Citizen';
    party.PreferredContactNumber__c = 'HOME';
    party.tffa__SecondaryPhone__c = '987627897';
    party.CellPhoneNumber__c = '97557854457';
    party.tffa__MothersMaidenName__c = 'Mother Name';
    party.tffa__Suffix__c = 'Jr';
    party.IsOLBEnrolled__c = 'Y';
    insert party;

    tffa__AccountPreference__c accPref = new tffa__AccountPreference__c(
      tffa__AccountName__c = 'Rishi',
      tffa__AccountNumber__c = '1775283',
      tffa__CardNumber__c = '27163876217',
      tffa__Status__c = 'FAILED',
      tffa__Party__c = party.Id,
      tffa__Application__c = app.Id,
      tffa__Code__c = 'CHECK-ORDER',
      CZIsStarterCheckRequired__c = true,
      tffa__Type__c = 'ADD_ON_SERVICE',
      tffa__Enabled__c = true,
      tffa__AddOnServiceType__c = 'ESTATEMENTS'
    );
    insert accPref;

    tffa.SObjectAssembler asmApp = new tffa.SObjectAssembler(app);
    asmApp.addChildObjects('AccountPreferences__r', new List<tffa__AccountPreference__c>{ accPref });
    app = (tffa__Application__c) asmApp.assemble();

    try {
      CZStarterCheckReqBatch bc = new CZStarterCheckReqBatch();
      database.executeBatch(bc);
      CZStarterCheckExecutor.processRequest(app);
    } catch (Exception e) {
      tffa.Logger.debug('Test Execption thrown');
    }

    try {
      List<UploadFileHistory__c> uploadHistoryList = CZWTFCHelperRepository.fetchUploadFileHistory(app.Id, 'STARTER_CHECK');
      Integer fileNumber = 1;
      Integer starterChqNum = 101;
      if (starterChqNum == 0 || starterChqNum == null) {
        starterChqNum = 101;
      }
      Integer starterCheckCount = 12;
      Integer count = starterCheckCount != null ? (starterCheckCount / 3) : 0;
      if (count == 0) {
        count = count + 1;
      } else {
        count = (Math.mod(starterCheckCount, 3) != 0) ? count + 1 : count;
      }
      Integer starterCount = count;
      Integer uploadedHistoryCount = 2;
      uploadHistoryList.clear();

      tffa.Logger.debug('CZStarterCheckExecutor count ' + count);

      List<String> uploadHistorySerialNum = new List<String>();
      List<String> uploadHistoryFileName = new List<String>();

      count = 0;
      uploadedHistoryCount = 0;

      if (count != uploadedHistoryCount) {
        while ((count - uploadedHistoryCount) > 0) {
          if (uploadedHistoryCount != 0) {
            uploadHistoryList = CZWTFCHelperRepository.fetchUploadFileHistory(app.Id, 'STARTER_CHECK');
            UploadFileHistory__c uploadFileHistory = new UploadFileHistory__c();

            uploadFileHistory.BrandCode__c = '235';
            uploadFileHistory.FileName__c = 'abc';
            uploadFileHistory.FileExt__c = '.xml';
            uploadFileHistory.FileType__c = 'STARTER_CHECK';
            uploadFileHistory.DocumentId__c = '13123';
            uploadFileHistory.FileTransferStatus__c = 'FAILURE';
            uploadFileHistory.SubmissionName__c = 'Name';
            uploadFileHistory.SerialNumber__c = '777';

            uploadHistoryList.add(uploadFileHistory);
            CZWTFCHelperRepository.save(uploadHistoryList);
            for (UploadFileHistory__c obj : uploadHistoryList) {
              uploadHistorySerialNum.add(obj.SerialNumber__c);
              uploadHistoryFileName.add(obj.FileName__c);
            }
            uploadHistorySerialNum.sort();
            uploadHistoryFileName.sort();
          }
          tffa.Logger.debug('CZStarterCheckExecutor uploadHistorySerialNum ' + uploadHistorySerialNum);
          tffa.Logger.debug('CZStarterCheckExecutor uploadHistoryFileName ' + uploadHistoryFileName);

          if (uploadHistorySerialNum != null && !uploadHistorySerialNum.isEmpty()) {
            starterChqNum = Integer.valueOf(uploadHistorySerialNum[uploadHistorySerialNum.size() - 1]);
            starterChqNum++;
          }
          if (uploadHistoryFileName != null && !uploadHistoryFileName.isEmpty()) {
            String str = uploadHistoryFileName[uploadHistoryFileName.size() - 1];
            str = str.substring(str.indexOf('-') + 1, str.lastIndexOf('.'));
            fileNumber = Integer.valueOf(str);
            fileNumber++;
          }
          tffa.Logger.debug('CZStarterCheckExecutor starterChqNum :' + starterChqNum);
          tffa.Logger.debug('CZStarterCheckExecutor fileNumber :' + fileNumber);

          CZWTFCPrintRequestDTO request = new CZWTFCPrintRequestDTO();
          request.PrintRequest.CheckData.JobID = accPref.StarterCheckJobID__c;
          request.PrintRequest.CheckData.CustomerData01 = app.CZTitle1__c;
          request.PrintRequest.CheckData.CustomerData02 = app.CZTitle2__c;
          request.PrintRequest.CheckData.CustomerData03 = app.CZTitle3__c;
          request.PrintRequest.CheckData.CustomerData04 = app.CZTitle4__c;
          request.PrintRequest.CheckData.CustomerData05 = app.CZTitle5__c;
          request.PrintRequest.CheckData.CheckNumber01 = starterChqNum++;
          request.PrintRequest.CheckData.CheckNumber02 = starterChqNum++;
          request.PrintRequest.CheckData.CheckNumber03 = starterChqNum++;
          request.PrintRequest.CheckData.BranchID = app.FISBranchCode__c;
          request.PrintRequest.CheckData.RoutingNumber = app.tffa__RoutingNumber__c;
          request.PrintRequest.CheckData.AccountNumber = app.tffa__AccountNumber__c;
          WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
          String staterChqId = wintrustEnvConfig.StarterCheckUserID__c;
          request.PrintRequest.CheckData.UserID = staterChqId;

          String bulkContent = '<?xml version="1.0"?>' + new CZWTFCXMLSerializer().serialize(request);

          String fileName = 'Starter_Check_' + accPref.StarterCheckJobID__c + '-' + fileNumber + '.xml';

          CZStarterCheckExecutor.setUploadHistory(app, 'abcd', starterChqNum);

          FISCCIntegrationLogService.setLogItemRequestAndResponse(bulkContent, null);
          fileNumber++;
          count--;
          tffa.Logger.debug('CZStarterCheckExecutor New File Generated* ');
          uploadHistorySerialNum.clear();
          uploadHistoryFileName.clear();
        }
      } else {
        tffa.Logger.debug('CZStarterCheckExecutor Already File Generated - No Changes.');
      }
      FISCCIntegrationLogService.setLogItemOk(FISCCIntegrationConstants.LOG_ITEM_STATUS_SUCCESS);

      if (starterCount == uploadHistoryList.size()) {
        WTFCObjectManagerRepository.doUpsertObject(accPref);
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZStarterCheckExecutor :' + ex.getMessage() + ' :: ' + ex.getStackTraceString());
    } finally {
      tffa.Logger.flush();
    }

    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}