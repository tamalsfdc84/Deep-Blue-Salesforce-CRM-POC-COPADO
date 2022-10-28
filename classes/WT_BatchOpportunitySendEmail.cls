/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_BatchOpportunitySendEmail
* @Author			Vamsi Pulikallu	<VPulikal@wintrust.com>
* @ModifiedBy		Vamsi Pulikallu	<VPulikal@wintrust.com>
* @Version			v1.0
* @CreatedDate		09 Feb 2021
* @ModifiedDate		09 Feb 2021
* @UsedBy			
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used to send email notifications for Past due and future due Opportunities to the owner
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v1.0
*--------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_BatchOpportunity_T
public class WT_BatchOpportunitySendEmail implements Database.Batchable<sObject>, Database.Stateful
{
    Map<id,List<Opportunity>> mapOwnerwithPastOpportunities = new Map<id,List<Opportunity>>();
    Map<id,List<Opportunity>> mapOwnerwithFutureOpportunities = new Map<id,List<Opportunity>>();
    Map<id,List<Opportunity>> mapManagerwithPastOpportunities = new Map<id,List<Opportunity>>();
    List<Opportunity> listOpportunity = New List<Opportunity>();
    set<Id> setIds = new set<Id>();
    set<Id> setManagerIds = new set<Id>();
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'SELECT Id, name, CloseDate, WT_Probability__c ,Amount, WT_Actual_Close_Date__c , WT_Status__c, StageName, WT_New_Dollar__c,WT_Product__r.Name, Account.name , Owner.Name, Owner.Email, OwnerId FROM Opportunity WHERE WT_Status__c = \'Open\' AND (CloseDate <= TODAY OR CloseDate <= NEXT_N_DAYS:7) ORDER BY CloseDate';
        return Database.getQueryLocator(query);
    }
    public void execute(Database.BatchableContext bc, List<Opportunity> scope)
    {
        for(Opportunity opportunityRecord : scope) 
        {
            //if the estimated close date is within 7 days
            boolean isFutureDate = false;
            if(opportunityRecord.CloseDate >= system.now() && opportunityRecord.CloseDate <= system.now().addMinutes(10080))
            {
                isFutureDate = true;
            }
            if(isFutureDate)
            {
                setIds.add(opportunityRecord.ownerid);
                if(mapOwnerwithFutureOpportunities.get(opportunityRecord.ownerid)!=null)
                {
                    listOpportunity = mapOwnerwithFutureOpportunities.get(opportunityRecord.ownerid);
                    listOpportunity.add(opportunityRecord);
                    mapOwnerwithFutureOpportunities.put(opportunityRecord.ownerid,listOpportunity);
                }
                else
                {
                    listOpportunity = new List<Opportunity>();
                    listOpportunity.add(opportunityRecord);
                    mapOwnerwithFutureOpportunities.put(opportunityRecord.ownerid,listOpportunity);
                }
            }
            //if the estimated closed date is already passed
            else if(opportunityRecord.CloseDate < system.now())
            {
                setIds.add(opportunityRecord.ownerid);
                if(mapOwnerwithPastOpportunities.get(opportunityRecord.ownerid)!=null)
                {
                    listOpportunity = mapOwnerwithPastOpportunities.get(opportunityRecord.ownerid);
                    listOpportunity.add(opportunityRecord);
                    mapOwnerwithPastOpportunities.put(opportunityRecord.ownerid,listOpportunity);
                }
                else
                {
                    listOpportunity = new List<Opportunity>();
                    listOpportunity.add(opportunityRecord);
                    mapOwnerwithPastOpportunities.put(opportunityRecord.ownerid,listOpportunity);
                }
            }
            //if the estimated close date is more than 20 days, send email to manager
            if(opportunityRecord.CloseDate <= system.now().addMinutes(-28800))
            {
                setManagerIds.add(opportunityRecord.ownerid);
                if(mapManagerwithPastOpportunities.get(opportunityRecord.ownerid)!=null)
                {
                    listOpportunity = mapManagerwithPastOpportunities.get(opportunityRecord.ownerid);
                    listOpportunity.add(opportunityRecord);
                    mapManagerwithPastOpportunities.put(opportunityRecord.ownerid,listOpportunity);
                }
                else
                {
                    listOpportunity = new List<Opportunity>();
                    listOpportunity.add(opportunityRecord);
                    mapManagerwithPastOpportunities.put(opportunityRecord.ownerid,listOpportunity);
                }
            }
        }
    }
    public void finish(Database.BatchableContext bc)
    {
        if(!mapOwnerwithPastOpportunities.isEmpty() || !mapOwnerwithFutureOpportunities.isEmpty()
           || !mapManagerwithPastOpportunities.isEmpty())
        {
            Map<id,User> mapOwnerDetails = New MaP<id,User>([SELECT id,email,isactive,Name FROM user WHERE id IN:setIds AND Isactive=true]);
            Map<id,User> mapManagerDetails = New MaP<id,User>([SELECT id,email,isactive,Name,Managerid,Manager.name,Manager.email FROM user WHERE id IN:setManagerIds AND Isactive=true AND manager.email!= NULL]);
            List<Messaging.SingleEmailMessage> listOfMail = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail;
            user userRecord;
            List<String> toAddresses;
            List<Opportunity> listPastOpportunities = new List<Opportunity>();
            List<Opportunity> listFutureOpportunities = new List<Opportunity>();
            List<Opportunity> listManagerPastOpportunities = new List<Opportunity>();
            string td1='"border:1px solid black; width=200px;"';
            string tdHead='"border:1px solid black; width:200px; font-weight:bold;"';
            if(mapOwnerDetails.keyset() != null)
            {                
                for(Id ownerId:mapOwnerDetails.keyset())
                {
                    listPastOpportunities = new list<Opportunity>();
                    listFutureOpportunities = new list<Opportunity>();
                    listPastOpportunities = mapOwnerwithPastOpportunities.get(ownerId);
                    listFutureOpportunities = mapOwnerwithFutureOpportunities.get(ownerId);
                    mail = new Messaging.SingleEmailMessage();
                    toAddresses = new List<String>();
                    userRecord = mapOwnerDetails.get(ownerId);
                    toAddresses.add(userRecord.email);
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Sales Opportunities Information ');                
                    string htmlBody = '<div><p>Dear '+userRecord.name+',</p></div>'
                        +'<p>You have the following open Sales Opportunities with estimated close dates either in the past or coming due within the next 7 days.</p></n></n>'
                        +'<p>Please review each sales opportunity and update as appropriate.</p></n></n>'
                        +'<p>If a Sales Opportunity is past due, but still pending, please update the Sales Opportunity\'s estimated close date and probability. If it is no longer pending, please update the stage to reflect if the deal was won or lost.</p></n></n>';
                    if(listPastOpportunities != null && listPastOpportunities.size() > 0)
                    {                    
                        htmlBody+='Sales Opportunities Past Due </n>'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Account Name</th>'
                            +'<th style='+tdHead+'>Estimated Close Date</th>'
                            +'<th style='+tdHead+'>Probability</th>'
                            +'<th style='+tdHead+'>Product</th>'
                            +'<th style='+tdHead+'>New $</th>';
                        for(Opportunity opportunityRecord:listPastOpportunities)
                        {
                            string estimatedCloseDateString = '';
                            if(opportunityRecord.CloseDate != null)
                            {
                               datetime estimatedCloseDate = opportunityRecord.CloseDate;
                               estimatedCloseDateString = estimatedCloseDate.formatGMT('MM-dd-yyyy');
                            }                            
                            string newDollar = '';
                            if(opportunityRecord.WT_New_Dollar__c != null)
                            {
                                newDollar = string.valueOf(opportunityRecord.WT_New_Dollar__c.format());
                            }
                            htmlBody += '<tr>'
                                +'<td style='+td1+'>'+opportunityRecord.Account.name+'</td>'
                                +'<td style='+td1+'>'+estimatedCloseDateString+'</td>'
                                +'<td style='+td1+'>'+opportunityRecord.WT_Probability__c+'%</td>'
                                +'<td style='+td1+'>'+opportunityRecord.WT_Product__r.Name+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opportunityRecord.id+'">'+opportunityRecord.name+'</a></td>'
                                +'<td style='+td1+'>'+newDollar+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }                
                    if(listFutureOpportunities != null && listFutureOpportunities.size() > 0)
                    {
                        htmlBody+='Sales Opportunities Coming Due </n>'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Account Name</th>'
                            +'<th style='+tdHead+'>Estimated Close Date</th>'
                            +'<th style='+tdHead+'>Probability</th>'
                            +'<th style='+tdHead+'>Product</th>'
                            +'<th style='+tdHead+'>New $</th>';
                        for(Opportunity opportunityRecord:listFutureOpportunities)
                        {
                            string estimatedCloseDateString = '';
                            if(opportunityRecord.CloseDate != null)
                            {
                               datetime estimatedCloseDate = opportunityRecord.CloseDate;
                               estimatedCloseDateString = estimatedCloseDate.formatGMT('MM-dd-yyyy');
                            }
                            string newDollar = '';
                            if(opportunityRecord.WT_New_Dollar__c != null)
                            {
                                newDollar = string.valueOf(opportunityRecord.WT_New_Dollar__c.format());
                            }
                            htmlBody += '<tr>'
                                +'<td style='+td1+'>'+opportunityRecord.Account.name+'</td>'
                                +'<td style='+td1+'>'+estimatedCloseDateString+'</td>'
                                +'<td style='+td1+'>'+opportunityRecord.WT_Probability__c+'%</td>'
                                +'<td style='+td1+'>'+opportunityRecord.WT_Product__r.Name+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opportunityRecord.id+'">'+opportunityRecord.name+'</a></td>'
                                +'<td style='+td1+'>'+newDollar+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }
                    htmlBody+='Sincerely, <br/>'
                        +'CRM Support <br/>'
                        +'crmsupport@wintrust.com';
                    mail.setHtmlBody(htmlBody);                
                    listOfMail.add(mail);
                }
            }
            
            if(mapManagerDetails.keyset() != null)
            {
                for(Id ownerId:mapManagerDetails.keyset())
                {
                    listManagerPastOpportunities = new list<Opportunity>();
                    listManagerPastOpportunities = mapManagerwithPastOpportunities.get(ownerId);
                    mail = new Messaging.SingleEmailMessage();
                    toAddresses = new List<String>();
                    userRecord = mapManagerDetails.get(ownerId);
                    toAddresses.add(userRecord.Manager.email);
                    mail.setToAddresses(toAddresses);
                    mail.setSubject('Your Team\'s Sales Opportunities Information ');                
                    string htmlBody = '<div><p>Dear '+userRecord.Manager.name+',</p></div>'
                        +'<p>Your team has the following open Sales Opportunities with estimated close dates 20 days or more in the past.</p></n></n>'
                        +'<p>Please work with your team members to update these Sales Opportunities.</p></n></n>'
                        +'<p>If a Sales Opportunity is still pending, please update the Sales Opportunity\'s estimated close date and probability.  If it is no longer pending, please update the stage to reflect if the deal was won or lost.</p></n></n>';
                    if(listManagerPastOpportunities != null && listManagerPastOpportunities.size() > 0)
                    {
                        htmlBody+='Sales Opportunities Past Due </n></n>'
                            +'<left><table border="1" style="border-collapse: collapse">'
                            +'<tr><th style='+tdHead+'>Owner</th>'
                            +'<th style='+tdHead+'>Account Name</th>'
                            +'<th style='+tdHead+'>Estimated Close Date</th>'
                            +'<th style='+tdHead+'>Probability</th>'
                            +'<th style='+tdHead+'>Product</th>'
                            +'<th style='+tdHead+'>New $</th>';
                        for(Opportunity opportunityRecord:listManagerPastOpportunities)
                        {
                            string estimatedCloseDateString = '';
                            if(opportunityRecord.CloseDate != null)
                            {
                               datetime estimatedCloseDate = opportunityRecord.CloseDate;
                               estimatedCloseDateString = estimatedCloseDate.formatGMT('MM-dd-yyyy');
                            }
                            string newDollar = '';
                            if(opportunityRecord.WT_New_Dollar__c != null)
                            {
                                newDollar = string.valueOf(opportunityRecord.WT_New_Dollar__c.format());
                            }
                            htmlBody += '<tr>'
                                +'<td style='+td1+'>'+opportunityRecord.owner.name+'</td>'
                                +'<td style='+td1+'>'+opportunityRecord.Account.name+'</td>'
                                +'<td style='+td1+'>'+estimatedCloseDateString+'</td>'
                                +'<td style='+td1+'>'+opportunityRecord.WT_Probability__c+'%</td>'
                                +'<td style='+td1+'>'+opportunityRecord.WT_Product__r.Name+'<br/><a href="'+URL.getSalesforceBaseUrl().toExternalForm()+'/'+opportunityRecord.id+'">'+opportunityRecord.name+'</a></td>'
                                +'<td style='+td1+'>'+newDollar+'</td></tr>';
                        }                    
                        htmlBody+='</table></left><br/>';
                    }
                    htmlBody+='Sincerely, <br/>'
                        +'CRM Support <br/>'
                        +'crmsupport@wintrust.com';
                    mail.setHtmlBody(htmlBody);                
                    listOfMail.add(mail);
                }
            }
            Messaging.sendEmail(listOfMail);
        }
    } 
}