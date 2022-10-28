/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name				WT_WelcomeMatController_T
* @Author			Vamsi Pulikallu	<vpulikal@wintrust.com>	
* @version 			v1.0 
* @CreatedDate		28 Apr 2021
* @ModifiedDate		28 Apr 2021
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description 
* Class is used as test class for WT_WelcomeMatController_T 
* ----------------------------------------------------------------------------------------------------------------------------------------------------
**/
@isTest
public class WT_WelcomeMatController_T {
	@isTest
    public static void profileNameTest(){
        Test.startTest();
        WT_WelcomeMatController.userProfile();
        Test.stopTest();
    }
}