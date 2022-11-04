@isTest
public class WT_EmployeeAfterHandler_T 
{
    @Testsetup
    static void setup()
    {
        WT_Switch_Settings__c switchSettings = WT_TestSetupHelper.GetCustomSetting();
        insert switchSettings;
    }
    
    @isTest
	static void CreateEmployee()
    {
        Test.startTest();
        WT_Employee__c newEmployee = new WT_Employee__c();
        newEmployee.WT_Employee_ID__c = '1';
        newEmployee.WT_First_Name__c = 'Test';
        newEmployee.WT_Last_Name__c = 'Test LastName';
        newEmployee.WT_Email__c = 'test@test.com';
        newEmployee.WT_Employee_Status__c = 'Active';
        
        insert newEmployee;
        
        Contact newContact = [SELECT Id,
                              WT_Employee__c,
                              Name,
                              RecordType.Name,
                              Email
                              FROM Contact];
        
        System.assertEquals('Test Test LastName (Employee)', newContact.Name);
        System.assertEquals(newEmployee.Id, newContact.WT_Employee__c);
        System.assertEquals(newEmployee.WT_Email__c, newContact.Email);
        System.assertEquals('Employee', newContact.RecordType.Name);
        
        Test.stopTest();
    }
    
    @isTest
	static void UpdateEmployee()
    {
        Test.startTest();
        WT_Employee__c newEmployee = new WT_Employee__c();
        newEmployee.WT_Employee_ID__c = '1';
        newEmployee.WT_First_Name__c = 'Test';
        newEmployee.WT_Last_Name__c = 'Test LastName';
        newEmployee.WT_Email__c = 'test@test.com';
        newEmployee.WT_Employee_Status__c = 'Active';
        
        insert newEmployee;
        
        newEmployee.WT_Email__c = 'test2@test.com';
        newEmployee.WT_Employee_ID__c = 'test2';
        newEmployee.WT_First_Name__c = 'Test2';
        newEmployee.WT_Last_Name__c = 'Test2 LastName';        
        update newEmployee;
        
        Contact newContact = [SELECT Id,
                              WT_Employee__c,
                              WT_Employee_Number__c,
                              Name,
                              RecordType.Name,
                              Email
                              FROM Contact];
        
        System.assertEquals('Test2 Test2 LastName (Employee)', newContact.Name);
        System.assertEquals('test2', newContact.WT_Employee_Number__c);
        System.assertEquals('test2@test.com', newContact.Email);
        System.assertEquals('Employee', newContact.RecordType.Name);
        
        Test.stopTest();
    }
    
    @isTest
	static void DeleteEmployee()
    {
        Test.startTest();
        WT_Employee__c newEmployee = new WT_Employee__c();
        newEmployee.WT_Employee_ID__c = '1';
        newEmployee.WT_First_Name__c = 'Test';
        newEmployee.WT_Last_Name__c = 'Test LastName';
        newEmployee.WT_Email__c = 'test@test.com';
        newEmployee.WT_Employee_Status__c = 'Active';
        
        insert newEmployee;
        
        delete newEmployee;
        
        Test.stopTest();
    }
}