public with sharing class CZWTFCInvokeEmailService implements Queueable {
  private tffa__Application__c applicationObject;
  public CZWTFCInvokeEmailService(tffa__Application__c appObject) {
    this.applicationObject = appObject;
    tffa.Logger.debug('CZWTFCInvokeEmailService called for : ' + appObject.Id);
  }

  public void execute(QueueableContext context) {
    (new CZWTFCApplicationEventExtension()).post(applicationObject);
  }
}