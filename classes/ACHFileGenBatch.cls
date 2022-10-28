global inherited sharing class ACHFileGenBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  //private String IsCoreEntryComplete = 'true';
  // private String IsObsolete = 'false';
  private List<String> param = new List<String>{};

  public Database.QueryLocator start(Database.BatchableContext BC) {
    tffa.Logger.debug('start Datetime : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
    return Database.getQueryLocator(getQuery());
  }

  public void execute(Database.BatchableContext BC, List<SObject> abtAccts) {
    tffa.Logger.debug('execute Datetime Started on : ' + String.valueOf(Datetime.now()));
    tffa.Logger.debug('abtAccts' + abtAccts);

    param = new List<String>{};

    for (tffa__Brand__c brand : (List<tffa__Brand__c>) abtAccts) {
      param = new List<String>{};

      List<SObject> fundingRequests = CZWTFCACHRepository.getFundingRequestsForACHFileGeneration(brand.tffa__Code__c);
      if (fundingRequests != null && fundingRequests.size() > 0) {
        ACHFileDTO achdata = new ACHFileDTO(ACHFileType.ACH, fundingRequests, brand.tffa__Code__c);
        ACHFileBuilder afb = new ACHFileBuilder(achdata);
        afb.buildACHFile();
        if (tffa__FundingRequest__c.sObjectType.getDescribe().isUpdateable()) {
          //update abtAccts;
          WTFCObjectManagerRepository.doUpsertObjects(fundingRequests);
        }
      } else {
        tffa.Logger.error('No pending requests for brand ' + brand.tffa__Code__c);
      }
    }
    tffa.Logger.debug('execute Datetime Ended on : ' + String.valueOf(Datetime.now()));
    tffa.Logger.flush();
  }

  public void finish(Database.BatchableContext BC) {
    CZNachaFileTransferBatch batch = new CZNachaFileTransferBatch();
    ID id = Database.executeBatch(batch);
    tffa.Logger.flush();
  }

  private static String getQuery() {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields(new List<String>{ 'tffa__Code__c' }).build().toQuery();

    tffa.Logger.debug(query);
    return query;
  }
}