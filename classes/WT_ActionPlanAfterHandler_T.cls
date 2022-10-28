/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_ActionPlanAfterHandler_T
* @Author			Vamsi Krishna	<vpulikal@wintrust.com>
* @ModifiedBy		Vamsi Krishna	<vpulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		25-06-2021
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is test class for after handler class for WT_ActionPlanAfterHandler.
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
* 1- run() 
* 	> used to test the error of commercial onboarding template selection for household accounts
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_ActionPlanAfterHandler_T 
{
    @isTest(SeeAllData=true)    
    public static void runRestrictCommercialTemplateForHousehold() 
    {
        User userCreateRecord = WT_DataFactory.createUser('System Administrator');
        insert userCreateRecord;
        system.runAs(userCreateRecord)
        {
            List <Account> listNewClassifiedAccount = WT_DataFactory.createAccounts(1,'PersonAccount_Prospect',userCreateRecord.id);
            insert listNewClassifiedAccount;
            List<ActionPlan> listCreateActionPlan = new List<ActionPlan>();
            ActionPlan actionPlanRecord;
            actionplanTemplateversion commercialTempalteVersion = [Select id,Name,Status from ActionPlanTemplateVersion where Name = 'Commercial Onboarding' and Status = 'Final' limit 1];        
            if(commercialTempalteVersion!=null)
            {            
                for(Account accountRec:listNewClassifiedAccount)
                {  
                    actionPlanRecord = new ActionPlan(ActionPlanTemplateVersionId=commercialTempalteVersion.Id,
                                                      TargetId=accountRec.Id,StartDate=System.today(), ActionPlanType='Industries',
                                                      ActionPlanState='Not Started',Name='Commercial Onboarding'
                                                     );                        
                    listCreateActionPlan.add(actionPlanRecord);
                }                
            }
            if(!listCreateActionPlan.isEmpty())
            {
                test.startTest();
                insert listCreateActionPlan;
                test.stopTest();
                listCreateActionPlan = [select id,ownerid from actionplan where id In: listCreateActionPlan];
            }
            system.assertEquals(1,listCreateActionPlan.size());
        } 
    }
}