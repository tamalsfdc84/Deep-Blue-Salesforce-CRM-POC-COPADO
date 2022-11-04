public class WT_OpportunityBeforeRequiredHandler extends TriggerHandler
{    
    private List<Opportunity> listNewOpportunity = new List<Opportunity>();
    private Map<Id, Opportunity> mapNewOpportunityIdAndOpportunity = new Map<Id, Opportunity>();
    private Map<Id, Opportunity> mapOldOpportunityIdAndOpportunity = new Map<Id, Opportunity>();
    Id easyAccessLoanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Easy_Access_Loan').getRecordTypeId();
    Id opportunityTMRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_TM').getRecordTypeId();
    Id opportunityLeasingRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Leasing').getRecordTypeId();
    Id opportunityInternationalRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_International').getRecordTypeId();
    Id opportunityInvestmentRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Investment').getRecordTypeId();
    Id opportunityLoanRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Loan').getRecordTypeId();
    Id opportunityDepositRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Deposit').getRecordTypeId();
    Id opportunityOtherRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Other').getRecordTypeId();
    Id opportunityLetterOfCreditRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('WT_Letter_of_Credit_Standby').getRecordTypeId();

    public WT_OpportunityBeforeRequiredHandler()
    {      
        PopulateGlobalLists(); 
    }
    public override void beforeInsert()
    {
        SetFieldsRelatedToStage();     
        UpdateOpportunityName(listNewOpportunity);        
    }    
    public override void beforeUpdate()
    {
        ValidateCurrentUpdate();
        SetRecordTypeOnProductChange();
        UpdateOpportunityName(listNewOpportunity);
        SetFieldsRelatedToStage();           
    } 
    private void PopulateGlobalLists()
    {        
        listNewOpportunity = (List<Opportunity>)Trigger.new;
        mapNewOpportunityIdAndOpportunity = (Map<Id, Opportunity>)Trigger.newMap;
        mapOldOpportunityIdAndOpportunity = (Map<Id, Opportunity>)Trigger.oldMap;
    }

    //This method validates that if the Opportunity Recordtype = "Easy Access Loan" &
    //Opportunity Stage >= 3 then only Processor or the underwriter can update the opportunity
    private void ValidateCurrentUpdate()
    {
        Set<Id> setOperationsUserRoleId = new Set<Id>();
        Set<String> setUserRoleName = new Set<String>
        {
            'Small Business Operations',
            'Small Business Operations Closer (Employee)',
            'Small Business Operations Credit Analyst (Employee)',
            'Small Business Operations Processor And Closer Supervisor',
            'Small Business Operations Processor (Employee)'
        };
        for(UserRole userRoleToValidate : [SELECT Id
                                            FROM UserRole
                                            WHERE Name IN :setUserRoleName])
        {
            setOperationsUserRoleId.add(userRoleToValidate.Id);
        }

        Set<String> setStageToBlockUpdate = new Set<String>
        {
            '3. Opportunity Sent For Processing',
            '4. Opportunity In Initial Review',
            '5. Opportunity Incomplete',
            '6. Opportunity In Underwriting',
            '7. Opportunity Approved',
            '8. Opportunity In Pre-Close',
            '9. Opportunity Pending Signed Documents',
            '10. Submitted For Booking',
            '11. Loan Booked',
            '12. Loan Lost/Denied'
        };

        Map<Id, Opportunity> mapOpportunityIdAndOpportunityToCheck = new Map<Id, Opportunity>();
        for(Opportunity relatedOpportunity : listNewOpportunity)
        {
            if(relatedOpportunity.RecordtypeId == easyAccessLoanRecordTypeId && setStageToBlockUpdate.contains(relatedOpportunity.StageName))
            {
                Opportunity oldOpportunity = mapOldOpportunityIdAndOpportunity.get(relatedOpportunity.Id);
                if(relatedOpportunity.Stagename == '3. Opportunity Sent For Processing' && oldOpportunity.StageName != relatedOpportunity.Stagename)
                {
                    //Ignore this use case. 
                }
                else
                {
                    if(!setOperationsUserRoleId.contains(UserInfo.getUserRoleId()))
                    {
                        relatedOpportunity.addError(System.Label.WT_Easy_Access_Loan_Stage_3_Block);
                    }
                }
            }
        }
    }

    private void SetRecordTypeOnProductChange()
    {
        Boolean hasUpdatedProduct = false;
        for(Opportunity updatedOpportunity : listNewOpportunity)
        {
            Opportunity oldOpportunity = mapOldOpportunityIdAndOpportunity.get(updatedOpportunity.Id);

            if(updatedOpportunity.WT_Product__c != oldOpportunity.WT_Product__c)
            {
                hasUpdatedProduct = true;
            }
        }

        if(hasUpdatedProduct)
        {
            Map<Id, String> mapProductIdAndRecordTypeName = GetProductAndRecordTypeName();
            for(Opportunity updatedOpportunity : listNewOpportunity)
            {
                Opportunity oldOpportunity = mapOldOpportunityIdAndOpportunity.get(updatedOpportunity.Id);

                if(updatedOpportunity.WT_Product__c != oldOpportunity.WT_Product__c)
                {
                    if(mapProductIdAndRecordTypeName.containsKey(updatedOpportunity.WT_Product__c))
                    {
                        String recordTypeLabel = mapProductIdAndRecordTypeName.get(updatedOpportunity.WT_Product__c);
                        switch on recordTypeLabel
                        {
                            when 'Easy Access Loan'
                            {
                                updatedOpportunity.RecordTypeId = easyAccessLoanRecordTypeId;  
                            }
                            when 'TM'
                            {
                                updatedOpportunity.RecordTypeId = opportunityTMRecordTypeId;  
                            }
                            when 'Leasing'
                            {
                                updatedOpportunity.RecordTypeId = opportunityLeasingRecordTypeId;  
                            }
                            when 'International'
                            {
                                updatedOpportunity.RecordTypeId = opportunityInternationalRecordTypeId;  
                            }
                            when 'Investment'
                            {
                                updatedOpportunity.RecordTypeId = opportunityInvestmentRecordTypeId;  
                            }
                            when 'Loan'
                            {
                                updatedOpportunity.RecordTypeId = opportunityLoanRecordTypeId;  
                            }
                            when 'Deposit'
                            {
                                updatedOpportunity.RecordTypeId = opportunityDepositRecordTypeId;  
                            }
                            when 'Other'
                            {
                                updatedOpportunity.RecordTypeId = opportunityOtherRecordTypeId;  
                            }
                            when 'Letter of Credit (Standby)'
                            {
                                updatedOpportunity.RecordTypeId = opportunityLetterOfCreditRecordTypeId;  
                            }
                        }
                    }
                }
            }
        }
    }

    private Map<Id, String> GetProductAndRecordTypeName()
    {
        Map<Id, String> mapProductIdAndRecordTypeName = new Map<Id, String>();
        for(Product2 relatedProduct : [SELECT Id,
                                        Family
                                        FROM Product2])
        {
            mapProductIdAndRecordTypeName.put(relatedProduct.Id, relatedProduct.Family);
        }

        return mapProductIdAndRecordTypeName;
    }

    private void SetFieldsRelatedToStage()
    {
        List<String> listOpenStage = new List<String>
        {
            'Stage 1 - Opportunity Identified',
            'Stage 2 - Company Information Obtained/Needs Assessed',
            'Stage 3 - Deal Structured/Presented',
            'Stage 4 - Deal Accepted/Commitment',
            'Stage 5 - Deal Approved',
            '1. Opportunity Identified',
            '2. Company Information Collected',
            '3. Opportunity Sent For Processing',
            '4. Opportunity In Initial Review',
            '5. Opportunity Incomplete',
            '6. Opportunity In Underwriting',
            '7. Opportunity Approved',
            '8. Opportunity In Pre-Close',
            '9. Opportunity Pending Signed Documents',
            '10. Submitted For Booking'
        };
        List<String> listWonStage = new List<String>
        {
            'Stage 6 - Deal Booked/Closed',
            '11. Loan Booked'
        };
        List<String> listLostStage = new List<String>
        {
            'Stage 7 - Deal Lost or Declined',
            '12. Loan Lost/Denied'
        };

        for(Opportunity newOpportunity : listNewOpportunity)
        {
            if(Trigger.isInsert ||
                (Trigger.isUpdate && newOpportunity.StageName != mapOldOpportunityIdAndOpportunity.get(newOpportunity.Id).StageName))
            {
                if(listOpenStage.contains(newOpportunity.StageName))
                {
                    newOpportunity.WT_Actual_Close_Date__c = null;
                    newOpportunity.WT_Date_of_Last_Stage_Update__c = Date.valueOf(newOpportunity.LastModifiedDate);
                    newOpportunity.WT_Status_Reason__c = 'In Progress';
                    newOpportunity.WT_Status__c = 'Open';
                }
                if(listWonStage.contains(newOpportunity.StageName))
                {
                    newOpportunity.WT_Date_of_Last_Stage_Update__c = Date.valueOf(newOpportunity.LastModifiedDate);
                    newOpportunity.WT_Status_Reason__c = 'Won';
                    newOpportunity.WT_Status__c = 'Closed/Won';
                }
                if(listLostStage.contains(newOpportunity.StageName))
                {
                    newOpportunity.WT_Date_of_Last_Stage_Update__c = Date.valueOf(newOpportunity.LastModifiedDate);
                    newOpportunity.WT_Status__c = 'Closed/Lost';
                }
            }   
            
            if(newOpportunity.RecordtypeId == easyAccessLoanRecordTypeId && newOpportunity.Probability != null && Trigger.isInsert)
            {
                newOpportunity.WT_Probability__c = String.valueOf(Integer.valueOf(newOpportunity.Probability));
            }
        }
    }
    
	/**Method to update Opportunity name**/
    //https://wintrust.atlassian.net/browse/SGE-145
    private void UpdateOpportunityName(List<Opportunity> listNewOpportunity)
    {        
        Set<Id> setProductId = new Set<Id>();
        Set<Id> setAccountId = new Set<Id>();
        List<Opportunity> listOpportunityToUpdateName = new List<Opportunity>();
        Map<Id, Product2> mapProductIdAndProduct = new Map<Id, Product2>();
        Map<Id, Account> mapAccountIdAndAccount = new Map<Id, Account>();
        Id personAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Customer').getRecordTypeId();
        Id businessAccountCustomerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Customer').getRecordTypeId();
        Id personAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('PersonAccount_Prospect').getRecordTypeId();
        Id businessAccountProspectRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();

        for(opportunity newOpportunity : listNewOpportunity)
        {
            if(Trigger.isInsert || (Trigger.isUpdate && (newOpportunity.WT_Product__c != mapOldOpportunityIdAndOpportunity.get(newOpportunity.Id).WT_Product__c ||
                                                        newOpportunity.AccountId != mapOldOpportunityIdAndOpportunity.get(newOpportunity.Id).AccountId || 
                                                        newOpportunity.WT_Purpose__c != mapOldOpportunityIdAndOpportunity.get(newOpportunity.Id).WT_Purpose__c)))
            {
                if(newOpportunity.AccountId != null)
                {
                    setAccountId.add(newOpportunity.AccountId);
                }
                if(newOpportunity.WT_Product__c != null)
                {
                    setProductId.add(newOpportunity.WT_Product__c);
                }
                listOpportunityToUpdateName.add(newOpportunity);
            }
        }

        if(!setProductId.isEmpty())
        {
            mapProductIdAndProduct = new Map<Id, Product2>([SELECT Id, 
                                                                Name 
                                                                FROM Product2 
                                                                WHERE Id IN :setProductId]);
        }
                
        if(!setAccountId.isEmpty())
        {
            mapAccountIdAndAccount = new Map<Id, Account>([Select Id,
                                                            Firstname,
                                                            Middlename,
                                                            Lastname,
                                                            Name,
                                                            RecordtypeId 
                                                            FROM Account 
                                                            WHERE Id IN :setAccountId]);
        }
        
        for(opportunity newOpportunity : listOpportunityToUpdateName)
        {
            String opportunityName = '';
            String productName = null;
            Account relatedAccount = null;
            if(mapAccountIdAndAccount.containsKey(newOpportunity.AccountId))
            {
                relatedAccount = mapAccountIdAndAccount.get(newOpportunity.AccountId);
            }
            
            if(mapProductIdAndProduct.containsKey(newOpportunity.WT_Product__c))
            {
                productName = mapProductIdAndProduct.get(newOpportunity.WT_Product__c).Name;
            }

            if(relatedAccount != null)
            {
                if(relatedAccount.RecordtypeId == personAccountCustomerRecordTypeId || relatedAccount.RecordtypeId == personAccountProspectRecordTypeId)
                {
                    opportunityName = String.isNotBlank(relatedAccount.FirstName) ? relatedAccount.FirstName : '';
                    opportunityName += String.isNotBlank(relatedAccount.MiddleName) ? relatedAccount.MiddleName : '';
                    opportunityName += String.isNotBlank(relatedAccount.LastName) ? relatedAccount.LastName : '';
                    opportunityName += String.isNotBlank(productName) ? ' - ' + productName : '';
                }
                else if(relatedAccount.RecordtypeId == businessAccountCustomerRecordTypeId || relatedAccount.RecordtypeId == businessAccountProspectRecordTypeId)
                {
                    opportunityName = relatedAccount.Name;
                    opportunityName += String.isNotBlank(productName) ? ' - ' + productName : '';
                }

                if(String.isNotBlank(newOpportunity.WT_Purpose__c))
                {
                    opportunityName += ' - ' + newOpportunity.WT_Purpose__C;
                }

                if(String.isNotBlank(opportunityName) && opportunityName.length() <= 120)
                {
                    newOpportunity.Name = opportunityName;
                }
                else if(String.isNotBlank(opportunityName))
                {
                    String trimmedOpportunityName = opportunityName.subString(0, 117);
                    trimmedOpportunityName += '...';
                    newOpportunity.Name = trimmedOpportunityName;
                }
            }
        }
    }
}