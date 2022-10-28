/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name         WT_CalculateSLAController_T
* @Author       Anoop <abattini@wintrust.com> 
* @version      v1.0 
* @CreatedDate  04-15-2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_CalculateSLAController
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* FUNCTIONAL TEST LOGIC
*   > use to run test CalculateSLA method
* 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_CalculateSLAController_T {
    @isTest
    static void CalculateSLA_Test()
    {
        DATE testDate=Date.valueOf('2021-01-01 00:00:00');
        Date resultDate=WT_CalculateSLAController.calculateWorkingDays(testDate,45);
    }
    
}