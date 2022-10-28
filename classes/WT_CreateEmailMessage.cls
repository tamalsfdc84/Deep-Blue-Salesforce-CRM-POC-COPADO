/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_CreateEmailMessage
* @Author			Karishma Keswani	<kkeswani@wintrust.com>
* @ModifiedBy		Karishma Keswani	<kkeswani@wintrust.com>
* @Version			v1.0
* @CreatedDate		14-12-2020
* @UsedBy			Process Builder :  Email Notifications on Case Status
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used for inserting emailmessage record.
*
* This class inserts the email message record when we need to track any email communication
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_CreateEmailMessage 
{   
    /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This method is invocable and is used to insert email message.
    *
    * --------------------------------------------------------------------------------------------------------------
    * @Param  request    List of FlowInputs
    * @Return void           Returns none
    * --------------------------------------------------------------------------------------------------------------
    **/
    @InvocableMethod(label='Add Email On Case')
    public static void CreateMessageOnCase(List<FlowInputs> request) 
    {
        EmailMessage EmailMessageToInsert = new EmailMessage();
        List<emailTemplate> emailTemplateRecord = [select id, subject,body from emailTemplate where developername=:request[0].emailTemplateDevelperName limit 1];
        if(emailTemplateRecord!=null && !emailTemplateRecord.isEmpty())
        {
            EmailMessageToInsert.ParentId = request[0].caseRecord.Id;
            //ToAddress
            if(request[0].toAddress!=null && !String.isBlank(request[0].toAddress))
            {
                EmailMessageToInsert.ToAddress = request[0].toAddress;
            }
            else
            {
                case caseRecord = request[0].caseRecord;
                if(caseRecord.ownerid.getsobjecttype() == Group.SobjectType) 
                {
                    Group queueRecord = [select developername,email from group where id = :caseRecord.ownerid];
                    if(queueRecord.email!=null)
                    {
                        EmailMessageToInsert.ToAddress = queueRecord.email;
                    }
                }
                else
                {
                     EmailMessageToInsert.ToAddress = [Select id,email from user where id=:request[0].caseRecord.OwnerId].email;
                }
               
            }
            //FromAddress
            if(request[0].fromAddress!=null && !String.isBlank(request[0].fromAddress))
            {
                EmailMessageToInsert.fromAddress = request[0].fromAddress;
            }
            else
            {
                EmailMessageToInsert.fromAddress = userInfo.getUserEmail();
            }
            List<Messaging.RenderEmailTemplateBodyResult> renderResults = Messaging.renderEmailTemplate(null,request[0].caserecord.id, new List<String>{emailTemplateRecord[0].subject,emailTemplateRecord[0].body});           
            EmailMessageToInsert.RelatedToId = request[0].caserecord.id;
            EmailMessageToInsert.ParentId = request[0].caserecord.id;
            EmailMessageToInsert.Subject = renderResults[0].getMergedBody();
            EmailMessageToInsert.HtmlBody= renderResults[1].getMergedBody();            
            insert EmailMessageToInsert;
        }        
    }
    
    /**
    * --------------------------------------------------------------------------------------------------------------
    * @Description
    * This is wrapper class to capture inputs for inserting email message.
    **/
    public class FlowInputs
    {
        @InvocableVariable(required=true)
        public Case caseRecord;
        
        @InvocableVariable(required=true)
        public String emailTemplateDevelperName;
        
        @InvocableVariable
        public String toAddress;
        
        @InvocableVariable
        public String fromAddress;
    }   
}