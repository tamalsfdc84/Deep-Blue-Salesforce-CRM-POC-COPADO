global class WT_OpportunityNotificationQueueable implements Queueable
{
    Map<Id, String> mapOpportunityIdAndRoleToNotify;
    String roleToSendNotificationFor;
    public WT_OpportunityNotificationQueueable(Map<Id, String> mapOpportunityIdAndRoleToNotify) 
    {
        this.mapOpportunityIdAndRoleToNotify = mapOpportunityIdAndRoleToNotify;
    }

    public void execute(QueueableContext context) 
    {
        List<Messaging.SingleEmailMessage> listEmailMessage = new List<Messaging.SingleEmailMessage>();
        CustomNotificationType opportunityNotificationType = new CustomNotificationType();
        Map<Id, OpportunityTeamMember> mapOpportunityIdAndOpportunityTeamMember = new Map<Id, OpportunityTeamMember>();
        Set<Id> setOpportunityToNotify = new Set<Id>();
        Map<Id, List<String>> mapOpportunityIdAndListUserIdToNotify = new Map<Id, List<String>>();
        Map<Id, String> mapOpportunityIdAndSubject = new Map<Id, String>();
        
        opportunityNotificationType = [SELECT Id, DeveloperName 
                                        FROM CustomNotificationType 
                                        WHERE DeveloperName = 'WT_Opportunity_Notification_Event'];

        for(OpportunityTeamMember relatedTeamMember : [SELECT Id,
                                                        UserId,
                                                        User.Email,
                                                        TeamMemberRole,
                                                        OpportunityId,
                                                        Opportunity.Name,
                                                        Opportunity.Owner.Name,
                                                        Opportunity.WT_Product__r.Name
                                                        FROM OpportunityTeamMember
                                                        WHERE OpportunityId IN :mapOpportunityIdAndRoleToNotify.keySet()
                                                        AND TeamMemberRole IN ('Processor', 'Closer', 'Credit Analyst')])
        {
            if(mapOpportunityIdAndRoleToNotify.containsKey(relatedTeamMember.OpportunityId))
            {
                Boolean isValidRole = false;
                String notificationRole = mapOpportunityIdAndRoleToNotify.get(relatedTeamMember.OpportunityId);
                String subject = 'Opportunity Sent For Processing'; 

                switch on notificationRole
                {
                    when 'Processing'
                    {
                        subject = 'Opportunity Sent For Processing';
                        if(relatedTeamMember.TeamMemberRole == 'Processor')
                        {
                            isValidRole = true;
                        }
                    }
                    when 'Underwriting'
                    {
                        subject = 'Opportunity Sent For Underwriting';
                        if(relatedTeamMember.TeamMemberRole == 'Credit Analyst')
                        {
                            isValidRole = true;
                        }
                    }
                    when 'Closing'
                    {
                        subject = 'Opportunity Sent For Closing';
                        if(relatedTeamMember.TeamMemberRole == 'Closer')
                        {
                            isValidRole = true;
                        }
                    }
                    when 'DeniedProcessing'
                    {
                        subject = 'Opportunity Sent For Post-Withdrawal/Denial';
                        if(relatedTeamMember.TeamMemberRole == 'Processor')
                        {
                            isValidRole = true;
                        }
                    }
                }

                mapOpportunityIdAndSubject.put(relatedTeamMember.OpportunityId, subject);

                if(isValidRole)
                {
                    List<String> listUserIdToNotify = new List<String>();
                    if(mapOpportunityIdAndListUserIdToNotify.containsKey(relatedTeamMember.OpportunityId))
                    {
                        listUserIdToNotify = mapOpportunityIdAndListUserIdToNotify.get(relatedTeamMember.OpportunityId);
                    }
                    listUserIdToNotify.add(relatedTeamMember.UserId);
                    mapOpportunityIdAndListUserIdToNotify.put(relatedTeamMember.OpportunityId, listUserIdToNotify);
                    mapOpportunityIdAndOpportunityTeamMember.put(relatedTeamMember.OpportunityId, relatedTeamMember);
                }
            }
        }

        for(Id opportunityIdToNotify : mapOpportunityIdAndListUserIdToNotify.keySet())
        {
            String customNotificationBody = '';
            for(Id userIdToNotify : mapOpportunityIdAndListUserIdToNotify.get(opportunityIdToNotify))
            {
                String opportunityName = mapOpportunityIdAndOpportunityTeamMember.get(opportunityIdToNotify).Opportunity.Name;
                String opportunityOwnerName = mapOpportunityIdAndOpportunityTeamMember.get(opportunityIdToNotify).Opportunity.Owner.Name;
                String opportunityProductName = mapOpportunityIdAndOpportunityTeamMember.get(opportunityIdToNotify).Opportunity.WT_Product__r.Name;
                
                customNotificationBody += 'The following opportunity has been assigned to you. \n\n';
                customNotificationBody += 'Opportunity Name: ' + opportunityName + '\n';
                customNotificationBody += 'Submitted By: ' + opportunityOwnerName + '\n';
                customNotificationBody += 'Product: ' + opportunityProductName;

                String emailSubject = mapOpportunityIdAndSubject.get(opportunityIdToNotify);
                String emailBody = '<html>';
                emailBody += 'The following opportunity has been assigned to you. <br><br>';
                emailBody += 'Opportunity Name: ' + opportunityName + '<br>';
                emailBody += 'Submitted By: ' + opportunityOwnerName + '<br>';
                emailBody += 'Product: ' + opportunityProductName + '<br><br>'; 
                emailBody += 'You can view the details of this opportunity using the link below: <br>';
                emailBody += URL.getSalesforceBaseUrl().toExternalForm() + '/' + opportunityIdToNotify;
                emailBody += '</html>';
                                
                Messaging.SingleEmailMessage newMessage = new Messaging.SingleEmailMessage();
                newMessage.setSubject(emailSubject);
                newMessage.setSaveAsActivity(false);
                newMessage.setHtmlBody(emailBody);
                newMessage.setSenderDisplayName('Wintrust CRM Notification'); 
                newMessage.setReplyTo('no-reply@wintrust.com');
                newMessage.setTargetObjectId(userIdToNotify);
                listEmailMessage.add(newMessage);              
            }

            String title = mapOpportunityIdAndSubject.get(opportunityIdToNotify);  
            WT_CustomNotificationUtility.NotifyUsers(new Set<String>(mapOpportunityIdAndListUserIdToNotify.get(opportunityIdToNotify)), title, customNotificationBody, 
                                                            opportunityNotificationType.Id, opportunityIdToNotify, null);
        }

        if(!listEmailMessage.isEmpty() && !Test.isRunningTest())
        {
            Messaging.SendEmailResult[] listEmailSendResult = Messaging.sendEmail(listEmailMessage);
        }
    }
}