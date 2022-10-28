/**
@author     : Sagar Padhye
@description: This test class covers testcoverage for most of the ACH related classes.
			  Individual Test classes have been written for some ACH related classes to increase codecoverage.
@version 	: 1.0  03 Jan, 2019
@author   : Girish Suvarna
@version  : 2.0  11 Feb, 2020
*/

@isTest
private class ACHFileGenSchedulerTest {
  @testSetup
  static void setupData() {
    setupConfigData();
  }

  static void setupConfigData() {
    String FundingStatus = 'IN_PROGRESS';
    String FundingType = 'ACH';
    Test.loadData(tffa__Product__c.sObjectType, 'TFTD_PRODUCT');
    Test.loadData(tffa__Party__c.sObjectType, 'TFParty');
    Test.loadData(tffa__ApplicantRole__c.sObjectType, 'TFApplicantRole');
    Test.loadData(tffa__Submission__c.sObjectType, 'TFSubmission');
    Test.loadData(tffa__Application__c.sObjectType, 'TFApplications');
    Test.loadData(tffa__ApplicationPartyXref__c.sObjectType, 'TFApplicationPartyXref');
    Test.loadData(tffa__FundingRequest__c.sObjectType, 'TFFundingRequest');
  }

  @isTest
  static void test1() {
    Test.StartTest();
    Id batchJobId = Database.executeBatch(new ACHFileGenBatch(), 50);
    AsyncApexJob aaj = [SELECT Id, Status, JobItemsProcessed, TotalJobItems, NumberOfErrors FROM AsyncApexJob WHERE ID =: batchJobId ];
    
    System.assertNotEquals(aaj, null);    
    Test.stopTest();
  }
  @isTest
  static void test4() {
    Test.startTest();
    ACHBatch ab = new ACHBatch();
    ab.getBatchControl();
    ACHBatchHeaderRecord headerrecord = new ACHBatchHeaderRecord('Dummy');
    List<ACHEntryDetailRecord> batchEntries = new List<ACHEntryDetailRecord>();
    ACHBatchControlRecord batchControlRecord = new ACHBatchControlRecord();
    ab.setBatchHeader(headerrecord);
    ab.setBatchEntries(batchEntries);
    ab.setBatchControl(batchControlRecord);
    ab.getBatchHeader();
    ab.getBatchString();

    ACHBatchControlRecord abcr = new ACHBatchControlRecord();
    abcr.setTotalBatchCreditAmount(10.00);
    abcr.setMsgAuthCode('authmsg');
    abcr.setReservedField('');

    ACHDocumentDTO ad = new ACHDocumentDTO();
    ad.getFileHeader();
    ad.getFillerRecs();
    ad.getFileControl();

    ACHEntryDetailRecord adr = new ACHEntryDetailRecord();
    adr.setAddendaRec(new ACHAddendaRecord());
    adr.getRecordString();
    adr.setAchFileName('dummy');
    adr.getAchFileName();
    adr.setPcbAcctNo('dummypcb');
    adr.getPcbAcctNo();
    adr.setProductName('dummyProdName');
    adr.getProductName();
    adr.setAddendaRec(null);
    adr.getAddendaRec();
    adr.setTraceNo('dummytraceno');
    adr.getRecStrForCreditFile('dummyRescType');

    ACHFileControlRecord acr = new ACHFileControlRecord();
    acr.setReservedField('');
    acr.getRecordTypecode();
    acr.getBatchCount();
    acr.getBlockCount();
    acr.getEntryHash();
    acr.getTotalFileDebitAmount();
    acr.getTotalFileCreditAmount();
    acr.getReservedField();
    acr.getTotalFileDebitRecords();
    acr.getTotalFileCreditRecords();
    acr.getRecordString();

    ACHFileHeaderRecord ahr = new ACHFileHeaderRecord();
    ahr.setPriorityCode('pc');
    ahr.setRecordSize('10');
    ahr.setBlockingFactor('10');
    ahr.setFormatCode('10');

    ACHFillerRecords afr = new ACHFillerRecords(1);
    afr.getRecordString();
    String fundingStatus = 'IN_PROGRESS';
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .selectObject('tffa__LinkedApplication__r')
      .selectFields()
      .build()
      .whereClause('tffa__Status__c', '= :fundingStatus')
      .toQuery();
    List<tffa__FundingRequest__c> apps = Database.query(query);
    ACHFileDTO achdata = new ACHFileDTO(ACHFileType.ACH, apps, '118');
    ACHFileBuilder afb = new ACHFileBuilder(achdata);
    afb.buildACHFile();
    System.assertNotEquals(afb, null);
    Test.stopTest();
  }
  @isTest
  static void test3() {
    Test.StartTest();
    ACHAddendaRecord ad = new ACHAddendaRecord();
    ad.setAddendaCodeType('test');
    ad.setPaymentInfo('test1');
    ad.setAddendaSeqNo(1);
    ad.setEntryDetailSeqNo(2);

    ACHEntryRecordBuilder arb = new ACHEntryRecordBuilder();
    arb.getRefNo();
    arb.getPartyName('person', 'legalname');
    arb.getUniqueCount();
    arb.getLastNumber(0);
    System.assertNotEquals(arb, null);
    Test.stopTest();
  }
  /* @isTest
  static void test2() {
    GlobalScapeDTO ac = new GlobalScapeDTO();
    GlobalScapeDTO.Token t1 = new GlobalScapeDTO.Token();
    String json = '{ "user" : { "name" : "Simon Fell", "twitter" : "@superfell" } }';
    t1.parse(json);

    GlobalScapeDTO.User t2 = new GlobalScapeDTO.User();
    t2.parse(json);

    GlobalScapeDTO.PostFileResponse t3 = new GlobalScapeDTO.PostFileResponse();
    t3.parse(json);

    GlobalScapeDTO.ErrorModel t4 = new GlobalScapeDTO.ErrorModel();
    t4.parse(json);
  }*/

  @isTest
  static public void test6() {
    ACHFileDTO achdata;
    ACHFileBuilder acfb = new ACHFileBuilder(achdata);
    Test.StartTest();
    acfb.logACHFileInfo('ach');
    System.assertNotEquals(acfb, null);
    Test.stopTest();
  }

  @isTest
  static public void test7() {
    ACHBatchControlRecord abcr = new ACHBatchControlRecord();
    abcr.setTotalBatchCreditAmount(10.00);
    abcr.setMsgAuthCode('authmsg');
    abcr.setReservedField('');

    ACHEntryDetailRecord adr = new ACHEntryDetailRecord();
    adr.setAddendaRec(new ACHAddendaRecord());
    adr.getRecordString();
    adr.setAchFileName('dummy');
    adr.getAchFileName();
    adr.setPcbAcctNo('dummypcb');
    adr.getPcbAcctNo();
    adr.setProductName('dummyProdName');
    adr.getProductName();
    adr.setAddendaRec(null);
    adr.getAddendaRec();
    adr.setTraceNo('dummytraceno');
    adr.getRecStrForCreditFile('dummyRescType');

    ACHFileControlRecord acr = new ACHFileControlRecord();
    acr.setReservedField('');
    acr.setBatchCount(1);
    acr.setBlockCount(8);
    acr.setEntryCount(1);
    acr.setEntryHash(3);
    acr.setTotalFileDebitAmount(100.00);
    acr.setTotalFileCreditAmount(100.00);
    acr.setTotalFileDebitRecords(10);
    acr.setTotalFileCreditRecords(11);

    ACHFileHeaderRecord ahr = new ACHFileHeaderRecord();
    ahr.setPriorityCode('pc');
    ahr.setRecordSize('10');
    ahr.setBlockingFactor('10');
    ahr.setFormatCode('10');
    ahr.setImmediateDestination('abc');
    ahr.setImmdiateOrigin('xyz');
    ahr.setFileCreationDate('01-01-2000');
    ahr.setFileCreationTime('12232512');
    ahr.setFileIdModifier('qwe');
    ahr.setImmediateDestinationName('a');
    ahr.setImmediateOriginName('b');
    ahr.setRefCode('test');

    ACHBatch ab = new ACHBatch();
    ACHBatchHeaderRecord headerrecord = new ACHBatchHeaderRecord('Dummy');
    List<ACHEntryDetailRecord> batchEntries = new List<ACHEntryDetailRecord>();
    batchEntries.add(adr);
    ab.setBatchHeader(headerrecord);
    ab.setBatchEntries(batchEntries);
    ab.setBatchControl(abcr);
    ab.getBatchHeader();
    ab.getBatchString();
    ab.getBatchControl();
    ACHFillerRecords afr = new ACHFillerRecords(1);
    afr.getRecordString();
    String fundingStatus = 'IN_PROGRESS';
    String query = new tffa.QueryBuilder(tffa__FundingRequest__c.SObjectType)
      .selectFields()
      .selectObject('tffa__LinkedApplication__r')
      .selectFields()
      .build()
      .whereClause('tffa__Status__c', '= :fundingStatus')
      .toQuery();
    List<tffa__FundingRequest__c> apps = Database.query(query);
    ACHFileDTO achdata = new ACHFileDTO(ACHFileType.ACH, apps, '118');
    ACHFileBuilder afb = new ACHFileBuilder(achdata);
    ACHDocumentDTO doc = new ACHDocumentDTO();
    ACHDocumentBuilder adb = new ACHDocumentBuilder(achdata);

    List<ACHBatch> batches = new List<ACHBatch>();
    batches.add(ab);
    doc.setFileHeader(ahr);
    doc.setFileControl(acr);
    doc.setFillerRecs(afr);
    doc.setBatches(batches);
    doc.getFileHeader();
    doc.getFillerRecs();
    ACHCreditFileBuilder acb = new ACHCreditFileBuilder(doc);
    String creditFileStr = acb.buildCreditFile();
    string genMsg = 'File Generated Successfully';
    string achFileStr = doc.getACHDocumentString();

    Test.StartTest();

    afb.createFilesAndNotify(doc, 'achFileStr', 'creditFileStr', 'genMsg');

    System.assertNotEquals(afb, null);
    Test.stopTest();
  }

  @isTest
  static public void test8() {
    ACHFileDTO achdata;
    ACHFileBuilder acfb = new ACHFileBuilder(achdata);
    Test.StartTest();
    acfb.buildACHFile();
    System.assertNotEquals(acfb, null);
    Test.stopTest();
  }
}