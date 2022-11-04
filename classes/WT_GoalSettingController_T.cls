/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_TestGoalSettingController
* @Author         Krupa Chinthakindi
* @ModifiedBy     Krupa Chinthakindi
* @Version        v1.0
* @CreatedDate    12/29/2021
* @TestClass      WT_TestGoalSettingController_T
* --------------------------------------------------------------------------,---------------------------------------------------------------
* @Description
* This class is used to return the list of fields for an object. 
* -----------------------------------------------------------------------------------------------------------------------------------------
* 
**/



@isTest
public with sharing class WT_GoalSettingController_T {
   // This method is to cover the getObjectField method from WT_GoalSettingController
    @isTest
    static void TestGetFieldList(){
        Test.startTest();
        List<String> fieldLst = WT_GoalSettingController.getObjectFields('Account');
        Test.stopTest();
    }
    //This method is to cover the getIntegerFieldsFromObject method from WT_GoalSettingController
      @isTest
    static void TestGetIntegerFieldList(){
    
        Test.startTest();
        List<WT_GoalSettingController.IntegerFieldOnObject> fieldLst = WT_GoalSettingController.getIntegerFieldsFromObject('Account');
        Test.stopTest();
    }
    
     //This method is to cover the field method from WT_GoalSettingController
      @isTest
    static void TestGetFieldType(){
    
        Test.startTest();
        Schema.DisplayType ft = WT_GoalSettingController.fieldType('Opportunity','CloseDate');
        Test.stopTest();
    }
    
}