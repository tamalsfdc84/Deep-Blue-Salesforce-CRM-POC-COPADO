public class WT_UtilityMethods 
{
    //The following method takes in the parameters to send an email with a CSV attachment
    public static void SendEmailWithCsvAttachment(List<String> listToEmailAddress, String csvFileAttachmentName, String subject,
                                                    String body, String csvHeader, String csvBody)
    {
        Messaging.EmailFileAttachment emailAttachment = new Messaging.EmailFileAttachment();
        Blob csvBlob = Blob.valueOf(csvHeader + '\n' + csvBody);
        emailAttachment.setFileName(csvFileAttachmentName);
        emailAttachment.setBody(csvBlob);

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setSubject(subject);
        emailMessage.setToAddresses(listToEmailAddress);
        emailMessage.setPlainTextBody(body);
        emailMessage.setFileAttachments(new Messaging.EmailFileAttachment[]{emailAttachment});

        if(!Test.isRunningTest())
        {
            Messaging.SendEmailResult[] emailResult = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailMessage});
        }
    }
	
	//the following method takes in the parameter to send an email template
    public static Messaging.SingleEmailMessage SendEmailToRecordWhatId(List<String> listOfEmailAddress,List<String> listCcEmailAddress,Id targetObjectId, 
                                                boolean saveAsActivity, Id templateId, Id WhatId)
    {
        system.debug('Inside SendEmail');
        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setTargetObjectId(targetObjectId);        
        emailMessage.setSaveAsActivity(saveAsActivity);       
        emailMessage.setTemplateId(templateId);
        emailMessage.setToAddresses(listOfEmailAddress);  
        emailMessage.setCcAddresses(listCcEmailAddress);
        emailMessage.setWhatId(WhatId); 
		return emailMessage;
    }
}