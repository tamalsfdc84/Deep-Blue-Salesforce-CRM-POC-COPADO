/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name            WT_WelcomeMatController
* @Author          Vamsi Pulikallu     <vpulikal@wintrust.com> 
* @version         v1.0 
* @CreatedDate     27 April 2021
* @UsedBy          
* ---------------------------------------------------------------------------------------------------------------------------------------------------
* @Description * Class is used to display welcome mat
**/
public class WT_WelcomeMatController {    
    @AuraEnabled(cacheable=true)
    public static string userProfile() {
        profile profileName = [SELECT Id,name FROM profile where id =: UserInfo.getProfileId()];
        return profileName.name;
    }
}