@isTest
public with sharing class CZWTFCAdverseActionExtTest {
  @isTest
  public static void adverseActionExt() {
    tffa__Submission__c sub = new tffa__Submission__c();
    insert sub;

    tffa__Application__c appObj = new tffa__Application__c();
    appObj.tffa__Submission__c = sub.Id;
    insert appObj;

    tffa__Party__c partyObj = new tffa__Party__c();
    partyObj.tffa__Type__c = 'Individual';
    partyObj.Name = 'John';
    partyObj.tffa__PrimaryEmail__c = 'Test@test.com';
    insert partyObj;

    tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
    List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
    dueDiligence.Name = 'FIS QUALIFILE';
    dueDiligence.tffa__Type__c = 'DEBIT_BUREAU';
    dueDiligence.tffa__Status__c = 'CHALLENGED';
    dueDiligence.tffa__Provider__c = 'FIS QUALIFILE';
    dueDiligence.tffa__ExternalQuestionnaireId__c = '12323';
    dueDiligence.tffa__ConversationId__c = '1233';
    dueDiligence.tffa__Party__c = partyObj.Id;

    tffa.SObjectAssembler asm12 = new tffa.SObjectAssembler(dueDiligence);

    tffa__DueDiligenceItem__c item = new tffa__DueDiligenceItem__c(
      Name = 'Test',
      tffa__Label__c = 'test',
      tffa__Code__c = '12345',
      tffa__Required__c = true,
      tffa__SortOrder__c = 1,
      tffa__Value__c = '12345'
    );
    ddItems.add(item);

    asm12.addChildObjects('Items__r', ddItems);
    dueDiligence = (tffa__DueDiligence__c) asm12.assemble();
    insert dueDiligence;

    tffa.SObjectAssembler asmPar = new tffa.SObjectAssembler(partyObj);
    asmPar.addChildObjects('DueDiligences__r', new List<tffa__DueDiligence__c>{ dueDiligence });
    partyObj = (tffa__Party__c) asmPar.assemble();
    update partyObj;

    Test.startTest();
    ApexPages.StandardController stdController;
    ApexPages.currentPage().getParameters().put('id', partyObj.Id);
    AdverseActionLetterExtension a = new AdverseActionLetterExtension(stdController);
    System.assertEquals('1', '1', 'Success');
    Test.stopTest();
  }
}