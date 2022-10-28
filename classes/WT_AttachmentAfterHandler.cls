/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_AttachmentAfterHandler 
* @Author           Femi Onakoya    <fonakoya@wintrust.com>
* @ModifiedBy       
* @Version          v1.0
* @CreatedDate      07-18-2022
* @UsedBy           trigger:  WT_AttachmentTrigger
* --------------------------------------------------------------------------------------------------------------
* @Description
* This  class to is used to convert attachment to File
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/

//Test Class : WT_AttachmentAfterHandler_T

public class WT_AttachmentAfterHandler extends TriggerHandler
{
    public List<Attachment> listOfNewAttachments = new List<Attachment>();
    
    public WT_AttachmentAfterHandler()
    {
        this.listOfNewAttachments = (List<Attachment>) Trigger.new;
    }
    public override void afterInsert()
    {   
        ConvertAttachmentToFile();
    }
    
    public void ConvertAttachmentToFile()
    {  
        List<ContentdocumentLink> listOfContentDocumentLink = new List<ContentdocumentLink>();
        List<ContentVersion> listOfContentVersions = new List<ContentVersion>();
        List<ContentVersion> listOfContentVersionsToUpdate = new List<ContentVersion>();
        Map<id,List<Attachment>> mapEmailMessageIdAndListAttachment = new Map<id,List<Attachment>>();   
        
        //If the attachments are audio files, retrieving them, iterating in the for loop, and storing them
        for(Attachment attachmentRecord : listOfNewAttachments)
        {
            if( attachmentRecord.ContentType != null  && (string.valueOf(attachmentRecord.ContentType).toLowerCase() == '.wav' ||
                                                          string.valueOf(attachmentRecord.ContentType).toLowerCase() == 'audio/wav'))
            {                
                if(mapEmailMessageIdAndListAttachment.ContainsKey(attachmentRecord.ParentId))
                {
                    mapEmailMessageIdAndListAttachment.get(attachmentRecord.ParentId).add(attachmentRecord);
                }
                mapEmailMessageIdAndListAttachment.put(attachmentRecord.ParentId, new List<Attachment>{attachmentRecord});
            }
        }
        //obtaining the attachments, iterating through the for loop, and constructing a content version from them if the email messages Id is connected to the attachment record parent id.
        for(EmailMessage relatedEmailMessage: [SELECT id,ParentId FROM EmailMessage WHERE id IN:mapEmailMessageIdAndListAttachment.keyset()])
        {
            string emailParentId = relatedEmailMessage.ParentId;
            if(emailParentId.substring(0,3) == '500')
            {   
                for(Attachment attachmentRecord :mapEmailMessageIdAndListAttachment.get(relatedEmailMessage.Id))
                { 
                    ContentVersion contentVersionRecord = new ContentVersion();
                    contentVersionRecord.ContentLocation = 'S';
                    contentVersionRecord.VersionData = attachmentRecord.body;
                    contentVersionRecord.Title = attachmentRecord.name;
                    contentVersionRecord.PathOnClient = attachmentRecord.name;
                    contentVersionRecord.Description = relatedEmailMessage.ParentId;
                    listOfContentVersions.add(contentVersionRecord);
                }
            }
        }
        if(listOfContentVersions.size() >0)
        {
            Database.insert(listOfContentVersions,false);
            //getting the inserted contentversion records, iterating through the for loop, and producing a content document link
            for(ContentVersion contentVersionRecord :[SELECT Id,ContentdocumentID,Title,description 
                                                      FROM ContentVersion WHERE id =:listOfContentVersions ])
            {
                string strParentid = contentVersionRecord.description;
                ContentdocumentLink contentDocumentLink = new ContentdocumentLink();
                contentDocumentLink.contentdocumentid=contentVersionRecord.contentdocumentId;
                contentDocumentLink.shareType='v';
                contentDocumentLink.LinkedEntityId = strParentid;
                listOfContentDocumentLink.add(contentDocumentLink);    
                contentVersionRecord.description = null;
                listOfContentVersionsToUpdate.add(contentVersionRecord);
            }
            
            //Inserting the ContentdocumentLink if there were more than 1 ContentdocumentLink in the list listcontentDocumentLinks.
            if(listOfContentDocumentLink.size() > 0)
            {
                Database.insert(listOfContentDocumentLink,false);  
            }
            if(listOfContentVersionsToUpdate.size() > 0)
            {
                Database.update(listOfContentVersionsToUpdate, false);
            }
        }
    } 
}