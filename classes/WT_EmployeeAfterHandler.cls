public class WT_EmployeeAfterHandler extends TriggerHandler
{
    List<WT_Employee__c> listNewEmployee = new List<WT_Employee__c>();
    List<WT_Employee__c> listOldEmployee = new List<WT_Employee__c>();
    Map<Id, WT_Employee__c> mapNewEmployeeIdandEmployee = new Map<Id, WT_Employee__c>();
    Map<Id, WT_Employee__c> mapOldEmployeeIdandEmployee = new Map<Id, WT_Employee__c>();
    List<Contact> listContactToInsert = new List<Contact>();
    List<Contact> listContactToUpdate = new List<Contact>();
    
    public WT_EmployeeAfterHandler()
    {
        PopulateGlobalLists();        
    }
    public override void afterInsert()
    {
        CreateContact();
        PerformDml();
    }
    public override void afterUpdate()
    {
        UpdateContact();
        PerformDml();
    }
    public override void afterDelete()
    {
        DeleteContact();
    }
    private void PopulateGlobalLists()
    {        
        listNewEmployee = (List<WT_Employee__c>) Trigger.new;
        listOldEmployee = (List<WT_Employee__c>) Trigger.old;
        mapNewEmployeeIdandEmployee = (Map<Id, WT_Employee__c>) Trigger.newMap;
        mapOldEmployeeIdandEmployee = (Map<Id, WT_Employee__c>) Trigger.oldMap;
    }
    
    private void PerformDml()
    {
        if(!listContactToInsert.isEmpty())
        {
            insert listContactToInsert;
        }
        if(!listContactToUpdate.isEmpty())
        {
            update listContactToUpdate;
        }
    }
    
    private void CreateContact()
    {
        Id integrationServiceUserId = [SELECT Id FROM User WHERE Name = 'Integration Service Account'].Id;
        Id employeeContactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('WT_Employee').getRecordTypeId();
        Id employeeAccountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('WT_Employee').getRecordTypeId();
        List<Account> listAccountToInsert = new List<Account>();
        List<WT_Employee__c> listNewActiveEmployee = new List<WT_Employee__c>();
        
        for(WT_Employee__c newEmployee : listNewEmployee)
        {
			if(newEmployee.WT_Employee_Status__c == 'Active')
        	{
                Account newAccount = new Account();
                newAccount.RecordTypeId = employeeAccountRecordTypeId;
                if(String.isNotBlank(newEmployee.WT_Middle_Initial__c))
                {
                    newAccount.Name = newEmployee.WT_First_Name__c + ' ' + newEmployee.WT_Middle_Initial__c + ' ' + newEmployee.WT_Last_Name__c + ' (Employee)';
                }
                else
                {
                    newAccount.Name = newEmployee.WT_First_Name__c + ' ' + newEmployee.WT_Last_Name__c + ' (Employee)';
                }
                newAccount.OwnerId = integrationServiceUserId;
                
                listAccountToInsert.add(newAccount);
                listNewActiveEmployee.add(newEmployee);
            }
        }
        
        TriggerHandler.bypass('WT_AccountBeforeHandler');
        TriggerHandler.bypass('WT_AccountAfterHandler');
        TriggerHandler.bypass('WT_AccountContactRelationBeforeHandler');
        Database.SaveResult[] setInsertResult = Database.insert(listAccountToInsert, false);
        Integer iterationIndex = 0;
        for(Database.SaveResult insertResult : setInsertResult)
        {
            if(insertResult.isSuccess())
            {
                WT_Employee__c newEmployee = listNewActiveEmployee[iterationIndex];
                
                Contact newContact = new Contact();
                newContact.AccountId = insertResult.getId();
                newContact.OwnerId = integrationServiceUserId;
                newContact.FirstName = newEmployee.WT_First_Name__c;
                newContact.LastName = newEmployee.WT_Last_Name__c + ' (Employee)';
                newContact.MiddleName = newEmployee.WT_Middle_Initial__c;
                newContact.Email = newEmployee.WT_Email__c;
                newContact.WT_Employee__c = newEmployee.Id;
                newContact.WT_Employee_Number__c = newEmployee.WT_Employee_ID__c;
                newContact.RecordTypeId = employeeContactRecordTypeId;
                
                listContactToInsert.add(newContact);
            }
            iterationIndex++;
        }
    }
    
    private void UpdateContact()
    {
        Map<Id, WT_Employee__c> mapUpdatedEmployeeIdAndEmployee = new Map<Id, WT_Employee__c>();
        for(WT_Employee__c updatedEmployee : listNewEmployee)
        {
            WT_Employee__c oldEmployeeRecord = mapOldEmployeeIdandEmployee.get(updatedEmployee.Id);
            
            if(updatedEmployee.WT_Employee_ID__c != oldEmployeeRecord.WT_Employee_ID__c ||
               updatedEmployee.WT_Email__c != oldEmployeeRecord.WT_Email__c ||
               updatedEmployee.WT_First_Name__c != oldEmployeeRecord.WT_First_Name__c ||
               updatedEmployee.WT_Last_Name__c != oldEmployeeRecord.WT_Last_Name__c)
            {
                mapUpdatedEmployeeIdAndEmployee.put(updatedEmployee.Id, updatedEmployee);
            }
        }
        
        if(!mapUpdatedEmployeeIdAndEmployee.isEmpty())
        {
            for(Contact contactToUpdate : [SELECT Id,
                                           FirstName,
                                           LastName,
                                           Email,
                                           WT_Employee_Number__c,
                                           WT_Employee__c
                                           FROM Contact
                                           WHERE WT_Employee__c IN :mapUpdatedEmployeeIdAndEmployee.keySet()])
            {
                WT_Employee__c relatedEmployee = mapUpdatedEmployeeIdAndEmployee.get(contactToUpdate.WT_Employee__c);
                contactToUpdate.FirstName = relatedEmployee.WT_First_Name__c;
                contactToUpdate.LastName = relatedEmployee.WT_Last_Name__c + ' (Employee)';
                contactToUpdate.MiddleName = relatedEmployee.WT_Middle_Initial__c;
                contactToUpdate.Email = relatedEmployee.WT_Email__c;
                contactToUpdate.WT_Employee_Number__c = relatedEmployee.WT_Employee_ID__c;
                
                listContactToUpdate.add(contactToUpdate);
            }
        }
    }
    
    private void DeleteContact()
    {
        List<Contact> listContactToDelete = new List<Contact>();
        List<Account> listAccountToDelete = new List<Account>();
        Set<Id> setEmployeeId = new Set<Id>();
        for(WT_Employee__c deletedEmployee : listOldEmployee)
        {
            setEmployeeId.add(deletedEmployee.Id);
        }
        
        if(!setEmployeeId.isEmpty())
        {
            for(Contact relatedContact : [SELECT Id,
                                          AccountId
                                          FROM Contact
                                          WHERE WT_Employee__c IN :setEmployeeId])
            {
                listContactToDelete.add(relatedContact);
                
                if(relatedContact.AccountId != null)
                {
                    Account accountToDelete = new Account();
                    accountToDelete.Id = relatedContact.AccountId;
                    listAccountToDelete.add(accountToDelete);
                }
            }
        }
        
        TriggerHandler.bypass('WT_AccountBeforeHandler');
        TriggerHandler.bypass('WT_AccountAfterHandler');
        TriggerHandler.bypass('WT_AccountContactRelationBeforeHandler');
        if(!listContactToDelete.isEmpty())
        {
            delete listContactToDelete;
        }
        if(!listAccountToDelete.isEmpty())
        {
            delete listAccountToDelete;
        }
    }
}