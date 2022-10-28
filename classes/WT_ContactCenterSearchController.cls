/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           WT_ContactCenterSearchController
* @Author         Himanshu Patel
* @ModifiedBy     Himanshu Patel
* @Version        v1.0
* @CreatedDate    05-17-2021
* @UsedBy         wt_ContactCenterSearch (LWC) 
* @TestClass      WT_ContactCenterSearchController_T
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Server side controller for wt_ContactCenterSearch(LWC)
* This controller contains all the methods that are required to display the contact information for contact center users
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Changes
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
public without sharing class WT_ContactCenterSearchController 
{    
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to format a phone number to match the format that Data management provides 

* This method takes in the below parameters. If phoneNumber length is valid, the method will format the number to match Data management
* format, else if it's not valid, the method would return the same string back. 
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     phoneNumber     		String attribute for phone number to format
* @return    String   				Formatted phone string. Format: (111) 111-1111
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static D3ChangeResultModel GetD3ChangeFlag()
    {
        D3ChangeResultModel returnModel = new D3ChangeResultModel();
        returnModel.ShouldShowD3Changes = false;
        for(WT_Contact_Center_D3_Config__mdt configRecord : WT_Contact_Center_D3_Config__mdt.getAll().values())
        {
            returnModel.ShouldShowD3Changes = configRecord.WT_Should_Enable_D3_Changes__c;
        }

        return returnModel;
    }

    public static String FormatPhoneNumber(String phoneNumber)
    {
        String formattedPhone = '';
        String phoneNumberReplaced = phoneNumber.replaceAll('\\D','');
        if (phoneNumberReplaced.length() == 10)
        {
            phoneNumberReplaced = '(' + phoneNumberReplaced.substring(0, 3) + ') ' + phoneNumberReplaced.substring(3, 6) + '-' + phoneNumberReplaced.substring(6);
            formattedPhone = phoneNumberReplaced;
        }
        else
        {
            formattedPhone = phoneNumber;
        }
        
        return formattedPhone;
    }
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to retrieve Person Account details based on user input 

* This method takes in the below parameters. If accountNumber is not empty or null, the method retrieves a list of Person Account IDs that 
* are related to a given accountNumber and uses that in the where clause of the main query. The main query searches for the Person Account
* with AND operators. If any parameter is blank or empty, it is not considered in the query
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     phoneNumber     					String attribute for phone number to search
* @param     firstName     						String attribute for phone number to search
* @param     lastName     						String attribute for phone number to search
* @param     ssn     							String attribute for phone number to search
* @param     accountNumber     					String attribute for phone number to search
* @return    List<AccountSearchResultModel>   	A list of custom search model that contains Person Account information for any matches
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static List<AccountSearchResultModel> GetAccounts(String phoneNumber, String firstName, String lastName, String ssn, String accountNumber) 
    {
        List<AccountSearchResultModel> listSearchResult = new List<AccountSearchResultModel>();
        Set<Id> setAccountIdRelatedToAccountNumber = new Set<Id>();
        if(String.isNotBlank(accountNumber))
        {
            String likeOperator = '%' + accountNumber + '%';
            for(FinServ__FinancialAccountRole__c financialAccountRole : [SELECT Id, FinServ__RelatedAccount__c
                                                                         FROM FinServ__FinancialAccountRole__c
                                                                         WHERE FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c LIKE: likeOperator
                                                                         AND (FinServ__FinancialAccount__r.FinServ__Status__c = 'Open' OR FinServ__FinancialAccount__r.FinServ__Status__c = 'Active')
                                                                         AND FinServ__EndDate__c = null
                                                                         LIMIT 20000])
            {
                if(!setAccountIdRelatedToAccountNumber.contains(financialAccountRole.FinServ__RelatedAccount__c))
                {
                    setAccountIdRelatedToAccountNumber.add(financialAccountRole.FinServ__RelatedAccount__c);
                }
            }
        }        
        
        String strippedPhone = '';
        List<String> listFormattedPhone = new List<String>();
        String query =
            'SELECT Id, Name, FinServ__LastFourDigitSSN__pc, FinServ__TaxId__pc, PersonBirthdate, ' +
            'PersonMobilePhone, PersonHomePhone, Phone, PersonOtherPhone, PersonAssistantPhone, ' +
            'PersonEmail, FinServ__MotherMaidenName__pc, WT_Last_8_Of_Debit_Card__c ' +
            'FROM Account ' +
            'WHERE';
        String whereClause = '';
        if (String.isNotBlank(phoneNumber)) 
        {
            strippedPhone = phoneNumber.replaceAll('[^0-9]', '');
            strippedPhone = strippedPhone.trim();
            if (strippedPhone.length() == 11 && strippedPhone.startsWith('1')) 
            {
                strippedPhone = strippedPhone.substring(1, strippedPhone.length());
            }
            if (strippedPhone.length() == 10) 
            {
                listFormattedPhone.add(strippedPhone);
                listFormattedPhone.add(FormatPhoneNumber(strippedPhone));
                whereClause +=
                    ' (PersonMobilePhone IN: listFormattedPhone OR PersonHomePhone IN: listFormattedPhone OR ' +
                    'Phone IN: listFormattedPhone OR PersonOtherPhone IN: listFormattedPhone OR PersonAssistantPhone IN: listFormattedPhone)';
            }
        }
        
        if (String.isNotBlank(firstName)) 
        {
            firstName = firstName.trim();
            if (String.isNotBlank(whereClause))
            {
                whereClause += ' AND';
            }
            whereClause += ' FirstName =: firstName';
        }
        
        if (String.isNotBlank(lastName)) 
        {
            lastName = lastName.trim();
            if (String.isNotBlank(whereClause)) 
            {
                whereClause += ' AND';
            }
            whereClause += ' LastName =: lastName';
        }
        
        if (String.isNotBlank(ssn)) 
        {
            ssn = ssn.replaceAll('[^0-9]', '');
            ssn = ssn.trim();
            if (String.isNotBlank(whereClause)) 
            {
                whereClause += ' AND';
            }
            whereClause += ' FinServ__TaxId__pc =: ssn';
        }
        
        if (!setAccountIdRelatedToAccountNumber.isEmpty()) 
        {
            if (String.isNotBlank(whereClause)) 
            {
                whereClause += ' AND';
            }
            whereClause += ' Id IN: setAccountIdRelatedToAccountNumber';
        }
        
        if (String.isNotBlank(whereClause)) 
        {
            whereClause += ' ORDER BY Name LIMIT 500';
            try 
            {
                List<Account> listAccount = Database.query(query + whereClause);
                if (listAccount != null && listAccount.size() > 0) 
                {
                    for (Account searchedAccount : listAccount) 
                    {
                        AccountSearchResultModel searchModel = new AccountSearchResultModel();
                        searchModel.AccountId = searchedAccount.Id;
                        searchModel.Name = searchedAccount.Name;
                        searchModel.Last4OfSocial = (String.isNotBlank(searchedAccount.FinServ__TaxId__pc)) ? searchedAccount.FinServ__TaxId__pc.right(4) : null;
                        searchModel.DateOfBirth = (searchedAccount.PersonBirthdate != null) ? String.valueOf(searchedAccount.PersonBirthdate) : null;
                        searchModel.MobilePhone = searchedAccount.PersonMobilePhone;
                        searchModel.HomePhone = searchedAccount.PersonHomePhone;
                        searchModel.BusinessPhone = searchedAccount.Phone;
                        searchModel.OtherPhone = searchedAccount.PersonOtherPhone;
                        searchModel.AssistantPhone = searchedAccount.PersonAssistantPhone;
                        searchModel.Email = searchedAccount.PersonEmail;
                        searchModel.MothersMaidenName = searchedAccount.FinServ__MotherMaidenName__pc;
                        searchModel.Last8OfDebitCard = searchedAccount.WT_Last_8_Of_Debit_Card__c;
                        searchModel.DriversLicense = null;
                        searchModel.HasReturnedMulesoftResult = false;
                        searchModel.HasOneOrMorePasswordResult = false;                        
                        searchModel.ListPassword = null;
                        
                        listSearchResult.add(searchModel);
                    }
                }
            } 
            catch (Exception ex)
            {
                System.debug('ex: ' + ex.getMessage());
            }
        }
        
        return listSearchResult;
    }
    
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to retrieve Mulesoft data based on First Name, Last Name and SSN of a given Person Account

* This method take in a Person Account Id. It then queries the Account record and retrieves First Name, Last Name & SSN for that record
* Those three attributes are then sent over to Mulesoft through a synchronous API call
* The API response is then parsed in Apex object and mapped to the return model
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     accountId	     					Id attribute for the Person Account. Used to query name and ssn
* @return    MulesoftSearchResultModel   		Custom search result that returns the Driver's License and a list of Password Phrases
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static MulesoftSearchResultModel GetMulesoftData(Id accountId, String phoneNumber)
    {
        MulesoftSearchResultModel returnModel = new MulesoftSearchResultModel();
        List<MulesoftPasswordSearchResultModel> listPassword = new List<MulesoftPasswordSearchResultModel>();
        if(accountId != null)
        {
            List<Account> listAccount = [SELECT Id, FinServ__TaxId__pc, FirstName, LastName
                                         FROM Account
                                         WHERE Id =: accountId];
            
            if(listAccount != null && listAccount.Size() > 0)
            {
                String formattedNumber = '';
                if(String.isNotBlank(phoneNumber))
                {
                    String strippedPhone = phoneNumber.replaceAll('[^0-9]', '');
                    strippedPhone = strippedPhone.trim();
                    if (strippedPhone.length() == 11 && strippedPhone.startsWith('1')) 
                    {
                        strippedPhone = strippedPhone.substring(1, strippedPhone.length());
                    }
                    if (strippedPhone.length() == 10) 
                    {
                        formattedNumber = FormatPhoneNumber(strippedPhone);
                    }                    
                }
                
                Account relatedAccount = listAccount[0];
                String calloutResponse = WT_ContactCenterMulesoftHelper.MakeMulesoftCallout(relatedAccount.FirstName, relatedAccount.LastName, relatedAccount.FinServ__TaxId__pc, formattedNumber);
                WT_ContactCenterMulesoftHelper.MulesoftCustomerProfileResponseModel mulesoftResponse = null;
                
                try
                {
                    mulesoftResponse = (WT_ContactCenterMulesoftHelper.MulesoftCustomerProfileResponseModel)JSON.deserialize(calloutResponse, WT_ContactCenterMulesoftHelper.MulesoftCustomerProfileResponseModel.class);
                }
                catch(Exception ex)
                {
                    System.debug('ex: ' + ex.getMessage());
                }
                
                if(mulesoftResponse != null && mulesoftResponse.Individuals != null && mulesoftResponse.Individuals.size() > 0)
                {
                    if(mulesoftResponse.Individuals[0].PasswordPhase.size() > 0)
                    {
                        Integer count = 1;
                        for(WT_ContactCenterMulesoftHelper.MulesoftCustomerProfileIndividualPasswordPhase passwordResponse : mulesoftResponse.Individuals[0].PasswordPhase)
                        {
                            if(String.isNotBlank(passwordResponse.pwd_question) || String.isNotBlank(passwordResponse.pwd_value))
                            {
                                MulesoftPasswordSearchResultModel responseModel = new MulesoftPasswordSearchResultModel();
                                responseModel.PasswordQuestion = passwordResponse.pwd_question;
                                responseModel.PasswordAnswer = passwordResponse.pwd_value;
                                responseModel.BankCode = passwordResponse.acc_bnk_cd;
                                responseModel.RecordCount = count;
                                
                                listPassword.add(responseModel);
                                count++;
                            }
                        }
                    }
                    if(mulesoftResponse.Individuals[0].Identifiers.size() > 0)
                    {
                        for(WT_ContactCenterMulesoftHelper.MulesoftCustomerProfileIndividualIdentifiers identifierResponse : mulesoftResponse.Individuals[0].Identifiers)
                        {
                            if(String.isNotBlank(identifierResponse.idnty_type) && identifierResponse.idnty_type == 'Driver License' && identifierResponse.idnty_status == 'Active' && String.isNotBlank(identifierResponse.idnty_cd))
                            {
                                returnModel.DriversLicense = identifierResponse.idnty_cd;
                            }
                        }
                    }
                }
            }
        }
        
        returnModel.ListPasswordModel = listPassword;
        return returnModel;
    }
    
/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* Method to retrieve Residence and list of Financial Accounts of a given Person Account

* This method take in a Person Account Id. It then queries the Account record and retrieves residence information for that record
* The same Account Id is then used to query FinServ__FinancialAccountRole__c to retrieve the list of Financial Accounts that are related
* to that record
* -----------------------------------------------------------------------------------------------------------------------------------------
* @param     accountId	     						Id attribute for the Person Account. Used to query name and ssn
* @return    AdditionalDetailSearchResultModel   	Custom search result that returns a list of Residence & a list of Financial Accounts
* -----------------------------------------------------------------------------------------------------------------------------------------
**/
    @AuraEnabled
    public static AdditionalDetailSearchResultModel GetAdditionalDetails(Id accountId)
    {
        Set<Id> setFinancialAccountIdProcessed = new Set<Id>();
        AdditionalDetailSearchResultModel returnModel = new AdditionalDetailSearchResultModel();
        List<ResidenceSearchResultModel> listResidence = new List<ResidenceSearchResultModel>();
        List<FinancialAccountSearchResultModel> listFinancialAccount = new List<FinancialAccountSearchResultModel>();
        List<RecentTransactionModel> listRecentTransaction = new List<RecentTransactionModel>();
        returnModel.ListFinancialAccount = null;
        returnModel.CurrentResidence = null;
        returnModel.ListRecentTransaction = null;
        returnModel.ListPhoneNumber = null;
        
        Boolean shouldShowD3Changes = false;
        if(WT_Contact_Center_D3_Config__mdt.getAll() != null && !WT_Contact_Center_D3_Config__mdt.getAll().isEmpty())
        {
            for(WT_Contact_Center_D3_Config__mdt configRecord : WT_Contact_Center_D3_Config__mdt.getAll().values())
            {
                shouldShowD3Changes = configRecord.WT_Should_Enable_D3_Changes__c;
            }
        }
        
        if(accountId != null)
        {
            List<Account> listAccount = [SELECT Id, BillingStreet, BillingCity, BillingCountry, 
                                            BillingState, BillingPostalCode, FirstName, Phone,
                                            PersonHomePhone, PersonMobilePhone, PersonEmail, PersonOtherPhone
                                         FROM Account
                                         WHERE Id =: accountId];
            
            if(listAccount != null && listAccount.size() > 0)
            {
                Set<String> setIncludedPhone = new Set<String>();
                Account relatedAccount = listAccount[0];
                ResidenceSearchResultModel residenceModel = new ResidenceSearchResultModel();
                residenceModel.Street = relatedAccount.BillingStreet;
                residenceModel.City = relatedAccount.BillingCity;
                residenceModel.State = relatedAccount.BillingState;
                residenceModel.Zip = relatedAccount.BillingPostalCode;
                residenceModel.Country = relatedAccount.BillingCountry;
                residenceModel.RecordKey = relatedAccount.Id;

                returnModel.CurrentResidence = residenceModel;
                returnModel.CustomerFirstName = relatedAccount.FirstName;
                returnModel.AccountId = relatedAccount.Id;
                
                Set<String> setFieldNameToCheckHistory = new Set<String>
                {
                    'PersonMobilePhone',
                    'PersonHomePhone',
                    'Phone',
                    'PersonOtherPhone',
                    'PersonEmail'
                };
                Map<String, Datetime> mapFieldNameAndLastChangeDate = new map<String, Datetime>();
                for(AccountHistory relatedAccountHistory : [SELECT Id,
                                                            CreatedDate,
                                                            Field
                                                            FROM AccountHistory
                                                            WHERE AccountId = :relatedAccount.Id
                                                            AND Field IN :setFieldNameToCheckHistory
                                                            ORDER BY CreatedDate DESC])
                {
                    if(!mapFieldNameAndLastChangeDate.containsKey(relatedAccountHistory.Field))
                    {
                        mapFieldNameAndLastChangeDate.put(relatedAccountHistory.Field, relatedAccountHistory.CreatedDate);
                    }
                }

                returnModel.CustomerEmailValue = relatedAccount.PersonEmail;
                returnModel.CustomerEmailLabel = returnModel.CustomerEmailValue;
                if(returnModel.CustomerEmailValue != null && mapFieldNameAndLastChangeDate.containsKey('PersonEmail'))
                {
                    returnModel.CustomerEmailLabel = returnModel.CustomerEmailValue + ' | Last Changed On: ' + mapFieldNameAndLastChangeDate.get('PersonEmail').format();
                }

                if(relatedAccount.Phone != null || relatedAccount.PersonHomePhone != null || relatedAccount.PersonMobilePhone != null)
                {                    
                    returnModel.ListPhoneNumber = new List<AccountPhoneResultModel>();
                    if(relatedAccount.PersonMobilePhone != null)
                    {                        
                        setIncludedPhone.add(relatedAccount.PersonMobilePhone);
                        Datetime dateMobilePhoneLastChanged = null;
                        if(mapFieldNameAndLastChangeDate.containsKey('PersonMobilePhone'))
                        {
                            dateMobilePhoneLastChanged = mapFieldNameAndLastChangeDate.get('PersonMobilePhone');
                        }
                        returnModel.ListPhoneNumber.add(new AccountPhoneResultModel('Mobile Phone', relatedAccount.PersonMobilePhone, dateMobilePhoneLastChanged));
                    }
                    if(relatedAccount.PersonHomePhone != null && !setIncludedPhone.contains(relatedAccount.PersonHomePhone))
                    {
                        setIncludedPhone.add(relatedAccount.PersonHomePhone);
                        Datetime dateHomePhoneLastChanged = null;
                        if(mapFieldNameAndLastChangeDate.containsKey('PersonHomePhone'))
                        {
                            dateHomePhoneLastChanged = mapFieldNameAndLastChangeDate.get('PersonHomePhone');
                        }
                        returnModel.ListPhoneNumber.add(new AccountPhoneResultModel('Home Phone', relatedAccount.PersonHomePhone, dateHomePhoneLastChanged));
                    }
                    if(relatedAccount.Phone != null && !setIncludedPhone.contains(relatedAccount.Phone))
                    {
                        setIncludedPhone.add(relatedAccount.Phone);
                        Datetime dateWorkPhoneLastChanged = null;
                        if(mapFieldNameAndLastChangeDate.containsKey('Phone'))
                        {
                            dateWorkPhoneLastChanged = mapFieldNameAndLastChangeDate.get('Phone');
                        }
                        returnModel.ListPhoneNumber.add(new AccountPhoneResultModel('Work Phone', relatedAccount.Phone, dateWorkPhoneLastChanged));
                    }
                    if(relatedAccount.PersonOtherPhone != null && !setIncludedPhone.contains(relatedAccount.PersonOtherPhone))
                    {
                        setIncludedPhone.add(relatedAccount.PersonOtherPhone);
                        Datetime dateOtherPhoneLastChanged = null;
                        if(mapFieldNameAndLastChangeDate.containsKey('PersonOtherPhone'))
                        {
                            dateOtherPhoneLastChanged = mapFieldNameAndLastChangeDate.get('PersonOtherPhone');
                        }
                        returnModel.ListPhoneNumber.add(new AccountPhoneResultModel('Other Phone', relatedAccount.PersonOtherPhone, dateOtherPhoneLastChanged));
                    }
                }
                
                List<FinServ__FinancialAccountRole__c> listFinancialAccountRole = [SELECT Id, FinServ__FinancialAccount__r.WT_Charter_Name__c,
                                                                                   FinServ__FinancialAccount__r.WT_Bank__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__FinancialAccountType__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__Description__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__Status__c,
                                                                                   FinServ__FinancialAccount__c, 
                                                                                   FinServ__Role__c,
                                                                                   FinServ__FinancialAccount__r.WT_FIS_Automatic_Status__c,
                                                                                   FinServ__FinancialAccount__r.WT_FIS_Manual_Status__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__SourceSystemId__c
                                                                                   FROM FinServ__FinancialAccountRole__c
                                                                                   WHERE FinServ__RelatedAccount__c =: relatedAccount.Id
                                                                                   AND FinServ__EndDate__c = null
                                                                                   ORDER BY FinServ__FinancialAccount__r.LastModifiedDate DESC];
                
                if(listFinancialAccountRole != null && listFinancialAccountRole.size() > 0)
                {                    
                    for(FinServ__FinancialAccountRole__c financialAccountRole : listFinancialAccountRole)
                    {
                        if(!setFinancialAccountIdProcessed.contains(financialAccountRole.FinServ__FinancialAccount__c))
                        {
                            FinancialAccountSearchResultModel financialAccountModel = new FinancialAccountSearchResultModel();
                            financialAccountModel.Charter = financialAccountRole.FinServ__FinancialAccount__r.WT_Charter_Name__c;
                            financialAccountModel.Branch = financialAccountRole.FinServ__FinancialAccount__r.WT_Bank__c;
                            financialAccountModel.AccountNumber = financialAccountRole.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c;
                            financialAccountModel.AccountType = financialAccountRole.FinServ__FinancialAccount__r.FinServ__FinancialAccountType__c + '|' + 
                                financialAccountRole.FinServ__FinancialAccount__r.FinServ__Description__c;
                            financialAccountModel.Status = financialAccountRole.FinServ__FinancialAccount__r.FinServ__Status__c;
                            financialAccountModel.FinancialAccountId = financialAccountRole.FinServ__FinancialAccount__c;
                            financialAccountModel.RelationshipType = financialAccountRole.FinServ__Role__c;
                            financialAccountModel.FISAutomaticStatus = financialAccountRole.FinServ__FinancialAccount__r.WT_FIS_Automatic_Status__c;
                            financialAccountModel.FISManualStatus = financialAccountRole.FinServ__FinancialAccount__r.WT_FIS_Manual_Status__c;
                            
                            listFinancialAccount.add(financialAccountModel);
                            setFinancialAccountIdProcessed.add(financialAccountRole.FinServ__FinancialAccount__c);
                        }
                    }
                    returnModel.ListFinancialAccount = listFinancialAccount;

                    //Callout to Mulesoft to get recent transactions
                    //					 if(listFinancialAccountRole != null && !listFinancialAccountRole.isEmpty() && shouldShowD3Changes)
                    //                   {
                    //                       for(FinServ__FinancialAccountRole__c financialAccountRole : listFinancialAccountRole)
                    //                       {
                    //                           String calloutResponse = WT_ContactCenterMulesoftHelper.MakeTransactionAPIMulesoftCallout(financialAccountRole.FinServ__FinancialAccount__r.FinServ__SourceSystemId__c);
                    //                           WT_ContactCenterMulesoftHelper.TransactionApiResponseModel mulesoftTransactionApiResponse = null;
                    //                           
                    //                           try
                    //                           {
                    //                               mulesoftTransactionApiResponse = (WT_ContactCenterMulesoftHelper.TransactionApiResponseModel)JSON.deserialize(calloutResponse, WT_ContactCenterMulesoftHelper.TransactionApiResponseModel.class);
                    //                           }
                    //                           catch(Exception ex)
                    //                           {
                    //                               System.debug('ex: ' + ex.getMessage());
                    //                           }
                    //                           
                    //                           Integer transactionCount = 0;
                    //                           if(mulesoftTransactionApiResponse != null && mulesoftTransactionApiResponse.Response != null)
                    //                           {
                    //                               if(mulesoftTransactionApiResponse.Response.transactionsIntradayDataLst != null && mulesoftTransactionApiResponse.Response.transactionsIntradayDataLst.transactions != null &&
                    //                                  !mulesoftTransactionApiResponse.Response.transactionsIntradayDataLst.transactions.isEmpty())
                    //                               {
                    //                                   for(WT_ContactCenterMulesoftHelper.TransactionModel intradayTransaction : mulesoftTransactionApiResponse.Response.transactionsIntradayDataLst.transactions)
                    //                                   {
                    //                                       listRecentTransaction.add(new RecentTransactionModel(intradayTransaction.TranDate, financialAccountRole.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, 
                    //                                                                                            intradayTransaction.TranDesc, 'Pending', intradayTransaction.TranTypeInd,
                    //                                                                                            intradayTransaction.TranAmnt, String.valueOf(transactionCount)));
                    //                                       
                    //                                       transactionCount++;
                    //                                   }
                    //                               }
                    //                               
                    //                               if(mulesoftTransactionApiResponse.Response.savingsPendingTxnLst != null && mulesoftTransactionApiResponse.Response.savingsPendingTxnLst.transactions != null &&
                    //                                  !mulesoftTransactionApiResponse.Response.savingsPendingTxnLst.transactions.isEmpty())
                    //                               {
                    //                                   for(WT_ContactCenterMulesoftHelper.TransactionModel savingsPendingTransaction : mulesoftTransactionApiResponse.Response.savingsPendingTxnLst.transactions)
                    //                                   {
                    //                                       listRecentTransaction.add(new RecentTransactionModel(savingsPendingTransaction.TranDate, financialAccountRole.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, 
                    //                                                                                            savingsPendingTransaction.TranDesc, 'Pending', savingsPendingTransaction.TranTypeInd,
                    //                                                                                            savingsPendingTransaction.TranAmnt, String.valueOf(transactionCount)));
                    //                                       
                    //                                       transactionCount++;
                    //                                   }
                    //                               }
                    //                               
                    //                               if(mulesoftTransactionApiResponse.Response.ddaPendingTxnLst != null && mulesoftTransactionApiResponse.Response.ddaPendingTxnLst.transactions != null &&
                    //                                  !mulesoftTransactionApiResponse.Response.ddaPendingTxnLst.transactions.isEmpty())
                    //                               {
                    //                                   for(WT_ContactCenterMulesoftHelper.TransactionModel ddaPendingTransaction : mulesoftTransactionApiResponse.Response.ddaPendingTxnLst.transactions)
                    //                                   {
                    //                                       listRecentTransaction.add(new RecentTransactionModel(ddaPendingTransaction.TranDate, financialAccountRole.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, 
                    //                                                                                            ddaPendingTransaction.TranDesc, 'Pending', ddaPendingTransaction.TranTypeInd,
                    //                                                                                            ddaPendingTransaction.TranAmnt, String.valueOf(transactionCount)));
                    //                                       
                    //                                       transactionCount++;
                    //                                   }
                    //                               }
                    //                               
                    //                               if(mulesoftTransactionApiResponse.Response.postedTransactionsLst != null && mulesoftTransactionApiResponse.Response.postedTransactionsLst.transactions != null &&
                    //                                  !mulesoftTransactionApiResponse.Response.postedTransactionsLst.transactions.isEmpty())
                    //                               {
                    //                                   for(WT_ContactCenterMulesoftHelper.TransactionModel postedTransaction : mulesoftTransactionApiResponse.Response.postedTransactionsLst.transactions)
                    //                                   {
                    //                                       listRecentTransaction.add(new RecentTransactionModel(postedTransaction.TranDate, financialAccountRole.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c, 
                    //                                                                                            postedTransaction.TranDesc, 'Posted', postedTransaction.TranTypeInd,
                    //                                                                                            postedTransaction.TranAmnt, String.valueOf(transactionCount)));
                    //                                       
                    //                                       transactionCount++;
                    //                                   }
                    //                               }
                    //                           }
                    //                       }
                    //                   }
                }
            }
        }
        
        if(!listRecentTransaction.isEmpty())
        {
            listRecentTransaction.sort();
        }
        returnModel.ListRecentTransaction = listRecentTransaction;
        return returnModel;
    }

    @AuraEnabled
    public static SavePermissionResultModel SetApprovalOnCustomer(Id accountId)
    {
        SavePermissionResultModel returnModel = new SavePermissionResultModel();
        returnModel.IsSuccess = false;

        List<Account> listRelatedAccount = [SELECT Id
                                            FROM Account
                                            WHERE Id = :accountId];
        if(listRelatedAccount != null && !listRelatedAccount.isEmpty())
        {
            Account accountToUpdate = new Account();
            accountToUpdate.Id = accountId;
            accountToUpdate.WT_Has_Given_Permission_To_Contact__c = true;
            accountToUpdate.WT_Date_Provided_Permission_To_Contact__c = System.now();

            try 
            {
                TriggerHandler.bypass('WT_AccountBeforeHandler');
                TriggerHandler.bypass('WT_AccountAfterHandler');
                TriggerHandler.bypass('WT_AccountAfterRequiredHandler');
                update accountToUpdate;   
                TriggerHandler.clearAllBypasses();
                returnModel.IsSuccess = true; 
            } 
            catch (Exception ex) 
            {
                WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'SetApprovalOnCustomer', ex.getMessage());
                returnModel.Error = ex.getMessage();
            }
        }
        return returnModel;
    }

    @AuraEnabled
    public static VerificationCodeGenerationModel SendVerificationCode(String accountId, String verificationMethod, String verificationEmailOrPhone)
    {
        VerificationCodeGenerationModel returnModel = new VerificationCodeGenerationModel();
        returnModel.IsSuccess = false;
        Boolean hasSentVerificationCode = false;
        Datetime time15MinutesAgo = System.now().addMinutes(-15);

        if(String.isNotBlank(accountId))
        {
            List<WT_Customer_Verification_Attempt_Log__c> listVerificationAttemptLog = [SELECT Id,
                                                                                        WT_Account_Id__c
                                                                                        FROM WT_Customer_Verification_Attempt_Log__c
                                                                                        WHERE WT_Date_Verification_Attempted__c >= :time15MinutesAgo
                                                                                        AND WT_Account_Id__c =: accountId
                                                                                        AND WT_Attempt_Type__c = 'Send'];

            if(listVerificationAttemptLog == null || listVerificationAttemptLog.isEmpty() || (!listVerificationAttemptLog.isEmpty() && listVerificationAttemptLog.size() < 3))
            {            
                List<Account> listRelatedAccount = [SELECT Id, PersonContactId, FirstName
                                                    FROM Account
                                                    WHERE Id = :accountId];
                if(listRelatedAccount != null && !listRelatedAccount.isEmpty())
                {
                    WT_Customer_Verification_Log__c newVerificationLog = new WT_Customer_Verification_Log__c();
                    Account relatedAccount = listRelatedAccount[0];
                    Integer randomInteger = Math.round(Math.random()*1000000);
                    String code  = string.valueOf(randomInteger);
                    String phone = null;
                    String email = null;
                    newVerificationLog.WT_Account__c = relatedAccount.Id;
                    newVerificationLog.WT_Verification_Code__c = code;
                    newVerificationLog.WT_Customer_First_Name__c = relatedAccount.FirstName;
                    returnModel.Code = code;
                    
                    if(String.isNotBlank(verificationMethod))
                    {
                        if(verificationMethod.toLowerCase() == 'sms')
                        {
                            phone = WT_PhoneUtility.FormatPhoneTo10Digit(verificationEmailOrPhone);
                            newVerificationLog.WT_Verification_Method__c = 'SMS';
                            newVerificationLog.WT_Verification_Code__c = null;

                            hasSentVerificationCode = WT_TwilioHelper.SendVerificationCode(phone, 'sms');
                        }
                        else if(verificationMethod.toLowerCase() == 'email')
                        {
                            email = verificationEmailOrPhone;
                            newVerificationLog.WT_Verification_Method__c = 'Email';
                            newVerificationLog.WT_Email__c = email;

                            try 
                            {
                                insert newVerificationLog;                            
                                hasSentVerificationCode = SendEmailVerificationCode(newVerificationLog, email, relatedAccount);
                            }
                            catch (Exception ex) 
                            {
                                WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'SendVerificationCode', ex.getMessage());
                                returnModel.IsSuccess = false;
                            }
                        }
                    }

                    if(hasSentVerificationCode)
                    {
                        returnModel.IsSuccess = true;

                        if(verificationMethod.toLowerCase() == 'sms')
                        {
                            try 
                            {
                                insert newVerificationLog;                            
                            }
                            catch (Exception ex) 
                            {
                                WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'SendVerificationCode', ex.getMessage());
                                returnModel.IsSuccess = false;
                            }
                        }

                        WT_Customer_Verification_Attempt_Log__c newVerificationAttemptLog = new WT_Customer_Verification_Attempt_Log__c();
                        newVerificationAttemptLog.WT_Account_Id__c = accountId;
                        newVerificationAttemptLog.WT_Date_Verification_Attempted__c = System.now();
                        newVerificationAttemptLog.WT_Attempt_Type__c = 'Send';

                        try 
                        {
                            insert newVerificationAttemptLog;                            
                        }
                        catch (Exception ex) 
                        {
                            WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'SendVerificationCode', ex.getMessage());
                        }
                    }
                    else
                    {
                        returnModel.IsSuccess = false;
                        returnModel.Message = 'Verification code could not be sent. Please try again or reach out to CRM Support for assistance.';
                    }
                }
            }
            else
            {
                returnModel.IsAccountLockedOut = true;
                returnModel.IsSuccess = false;
                returnModel.Message = 'We have reached the limit of generating verification requests.  Please advise the customer that we are unable to proceed with identify verification over the phone. For further assistance, the customer should come into a branch with valid identification. ';
            }
        }

        return returnModel;
    }

    public static Boolean SendEmailVerificationCode(WT_Customer_Verification_Log__c newVerificationLog, String email, Account relatedAccount)
    {
        Boolean isSuccess = true;
        List<EmailTemplate> listEmailTemplate = [SELECT Id, Body, HtmlValue, Subject
                                                FROM EmailTemplate
                                                WHERE DeveloperName = 'WT_Contact_Center_Verification_Code'];

        try
        {
            List<Messaging.SingleEmailMessage> listEmailToSend = new List<Messaging.SingleEmailMessage>();
            List<String> listToEmail = new List<String>();
            listToEmail.add(email);

            String htmlBody = listEmailTemplate[0].HtmlValue;
            htmlBody = htmlBody.replace('{{VerificationCode}}', newVerificationLog.WT_Verification_Code__c);

            String textBody = listEmailTemplate[0].Body;
            textBody = textBody.replace('{{VerificationCode}}', newVerificationLog.WT_Verification_Code__c);

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(listToEmail);
            mail.setHtmlBody(htmlBody);
            mail.setSubject(listEmailTemplate[0].Subject);
            mail.setPlainTextBody(textBody);
            mail.setBccSender(false);
            mail.setUseSignature(false);
            //mail.setReplyTo('verification@wintrust.com');
            //mail.setSenderDisplayName('Wintrust Bank');
            mail.setSaveAsActivity(false); 
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'verification@wintrust.com'];
            if ( owea.size() > 0)
            {
                mail.setOrgWideEmailAddressId(owea.get(0).Id);
                system.Debug(owea.get(0).Id);
            }
            listEmailToSend.add(mail);
            Messaging.sendEmail(listEmailToSend);
            //system.debug('$$$$ SENT');
        }
        catch(Exception ex)
        {
            //system.Debug('$$$$ Exception ' + ex);
            isSuccess = false;
        }

        return isSuccess;
    }

    @AuraEnabled
    public static VerifyCodeResponseModel VerifyCode(String accountId, String verificationMethod, String verificationEmailOrPhone, String code)
    {
        VerifyCodeResponseModel returnModel = new VerifyCodeResponseModel();
        returnModel.IsSuccess = false;
        String verificationTo = '';
        Datetime time15MinutesAgo = System.now().addMinutes(-15);

        if(String.isNotBlank(verificationEmailOrPhone) && String.isNotBlank(code))
        {
            if(String.isNotBlank(verificationMethod))
            {
                verificationTo = verificationEmailOrPhone;
                if(verificationMethod.toLowerCase() == 'sms')
                {
                    verificationTo = WT_PhoneUtility.FormatPhoneTo10Digit(verificationEmailOrPhone);
                }
            }

            List<WT_Customer_Verification_Attempt_Log__c> listVerificationAttemptLog = [SELECT Id,
                                                                                        WT_Account_Id__c
                                                                                        FROM WT_Customer_Verification_Attempt_Log__c
                                                                                        WHERE WT_Date_Verification_Attempted__c >= :time15MinutesAgo
                                                                                        AND WT_Account_Id__c =: accountId
                                                                                       	AND WT_Attempt_Type__c = 'Verify'];

            if(listVerificationAttemptLog == null || listVerificationAttemptLog.isEmpty() || (!listVerificationAttemptLog.isEmpty() && listVerificationAttemptLog.size() < 3))
            { 
                if(String.isNotBlank(verificationTo))
                {
                    if(verificationMethod.toLowerCase() == 'sms')
                    {
                        returnModel.IsSuccess = WT_TwilioHelper.VerifyCode(verificationTo, code);
                    }
                    else if(verificationMethod.toLowerCase() == 'email')
                    {
                        returnModel.IsSuccess = VerifyEmailCode(accountId, code, verificationTo);
                    }

                    WT_Customer_Verification_Attempt_Log__c newVerificationAttemptLog = new WT_Customer_Verification_Attempt_Log__c();
                    newVerificationAttemptLog.WT_Account_Id__c = accountId;
                    newVerificationAttemptLog.WT_Date_Verification_Attempted__c = System.now();
                    newVerificationAttemptLog.WT_Attempt_Type__c = 'Verify';

                    try 
                    {
                        insert newVerificationAttemptLog;                            
                    }
                    catch (Exception ex) 
                    {
                        WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'SendVerificationCode', ex.getMessage());
                    }
                }
            }
            else
            {
                returnModel.IsSuccess = false;
                returnModel.IsAccountLockedOut = true;
                returnModel.Message = 'We have reached the limit of generating verification requests.  Please advise the customer that we are unable to proceed with identify verification over the phone. For further assistance, the customer should come into a branch with valid identification. ';
            }
        }

        return returnModel;
    }

    public static Boolean VerifyEmailCode(String accountId, String code, String email)
    {
        Boolean isValid = false;
        if(String.isNotBlank(accountId) && String.isNotBlank(code) && String.isNotBlank(email))
        {
            List<WT_Customer_Verification_Log__c> listCustomerVerificationLog = [SELECT Id,
                                                                                WT_Account__c,
                                                                                WT_Email__c,
                                                                                WT_Verification_Code__c,
                                                                                WT_Verification_Method__c
                                                                                FROM WT_Customer_Verification_Log__c
                                                                                WHERE WT_Account__c = :accountId
                                                                                AND WT_Verification_Method__c = 'Email'
                                                                                AND WT_Email__c = :email
                                                                                ORDER BY CreatedDate DESC
                                                                                LIMIT 1];
            if(listCustomerVerificationLog != null && !listCustomerVerificationLog.isEmpty() && listCustomerVerificationLog[0].WT_Verification_Code__c == code)
            {
                isValid = true;
            }
        }

        return isValid;
    }

    @AuraEnabled 
    public static FISIdentificationQuestionResponseModel GetPenleyQuestion(String accountId)
    {
        FISIdentificationQuestionResponseModel responseModel = new FISIdentificationQuestionResponseModel();
        List<FISIdentificationQuestionModel> listQuestion = new List<FISIdentificationQuestionModel>();
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        Integer questionCount = 0;
        Datetime time15MinutesAgo = System.now().addMinutes(-15);
        
        IdaIdentificationRequestModel requestModel = new IdaIdentificationRequestModel();
        IdaIdentification identificationRequestModel = new IdaIdentification();
        IdaPerson identificationPersonRequestModel = new IdaPerson();
        responseModel.IsSuccess = false;
        responseModel.Message = 'Error: Something went wrong. Could not generate the identification questions.';
        
        if(accountId != null)
        {
            Blob requestIdBlob = Crypto.GenerateAESKey(128);
            String hexString = EncodingUtil.ConvertTohex(requestIdBlob);
            String requestIdGuid = hexString.SubString(0,8)+ '-' + hexString.SubString(8,12) + '-' + hexString.SubString(12,16) + '-' + hexString.SubString(16,20) + '-' + hexString.substring(20);
            
            WT_Contact_Center_Mulesoft__c contactCenterSetting = WT_Contact_Center_Mulesoft__c.getOrgDefaults();
            identificationRequestModel.acquirerid = contactCenterSetting.WT_IDA_API_Acquirer_Id__c;
            identificationRequestModel.configkey = contactCenterSetting.WT_IDA_API_Config_Key__c;
            identificationRequestModel.customerid = contactCenterSetting.WT_IDA_API_Customer_Id__c;
            identificationRequestModel.instancecd = contactCenterSetting.WT_IDA_API_Instance_CD__c;
            identificationRequestModel.productcd = contactCenterSetting.WT_IDA_API_Product_CD__c;
            identificationRequestModel.productversion = contactCenterSetting.WT_IDA_API_Product_Version__c;
            identificationRequestModel.msgUuid = requestIdGuid;
            identificationRequestModel.staging = isSandbox;
            identificationRequestModel.locationid = '';
            identificationRequestModel.aqrcustomerid = '';
            identificationRequestModel.aqr = '';
            identificationRequestModel.userdefinedtransactiontext1 = '';
            identificationRequestModel.userdefinedtransactiontext2 = '';
            identificationRequestModel.userdefinedtransactiontext3 = '';
                        
            List<Account> listAccount = [SELECT Id, BillingStreet, BillingCity, BillingCountry, 
                                         BillingState, BillingPostalCode, PersonBirthdate,
                                         FirstName, LastName, MiddleName, FinServ__TaxId__pc
                                         FROM Account
                                         WHERE Id =: accountId];
            
            if(listAccount != null && listAccount.size() > 0)
            {
                List<WT_Customer_Verification_Attempt_Log__c> listVerificationAttemptLog = [SELECT Id,
                                                                                            WT_Account_Id__c
                                                                                            FROM WT_Customer_Verification_Attempt_Log__c
                                                                                            WHERE WT_Date_Verification_Attempted__c >= :time15MinutesAgo
                                                                                            AND WT_Account_Id__c =: accountId
                                                                                            AND WT_Attempt_Type__c = 'Send'];
                
                if(listVerificationAttemptLog == null || listVerificationAttemptLog.isEmpty() || (!listVerificationAttemptLog.isEmpty() && listVerificationAttemptLog.size() < 3))
                { 
                    Account relatedAccount = listAccount[0];
                    identificationPersonRequestModel.address = (String.isNotBlank(relatedAccount.BillingStreet)) ? relatedAccount.BillingStreet : '';
                    identificationPersonRequestModel.city = (String.isNotBlank(relatedAccount.BillingCity)) ? relatedAccount.BillingCity : '';
                    identificationPersonRequestModel.state = (String.isNotBlank(relatedAccount.BillingState)) ? relatedAccount.BillingState : '';
                    identificationPersonRequestModel.zip = (String.isNotBlank(relatedAccount.BillingPostalCode)) ? relatedAccount.BillingPostalCode : '';
                    identificationPersonRequestModel.firstName = (String.isNotBlank(relatedAccount.FirstName)) ? relatedAccount.FirstName : '';
                    identificationPersonRequestModel.middleName = (String.isNotBlank(relatedAccount.MiddleName)) ? relatedAccount.MiddleName : '';
                    identificationPersonRequestModel.lastName = (String.isNotBlank(relatedAccount.LastName)) ? relatedAccount.LastName : '';
                    identificationPersonRequestModel.govtNbr = (String.isNotBlank(relatedAccount.FinServ__TaxId__pc)) ? relatedAccount.FinServ__TaxId__pc : '';
                    identificationPersonRequestModel.dob = (relatedAccount.PersonBirthdate != null) ? Datetime.newInstance(relatedAccount.PersonBirthdate.year(), relatedAccount.PersonBirthdate.month(), relatedAccount.PersonBirthdate.day()).format('MMddyyyy') : '';
                    identificationPersonRequestModel.idvOid = '';
                    
                    requestModel.idaIdentification = identificationRequestModel;
                    requestModel.idaPerson = identificationPersonRequestModel;
                    String jsonBody = JSON.serialize(requestModel);
                    if(Test.isRunningTest())
                    {
                        jsonBody = GetIdaApiMockRequestString();
                    }
                    
                    if(String.isNotBlank(jsonBody))
                    {
                        String apiResponse = WT_ContactCenterMulesoftHelper.MakeIdaAPIQuestionMulesoftCallout(jsonBody, false);
                        
                        IdaIdentificationQuestionResponseModel mulesoftIdaQuestionApiResponse = null;
                        
                        try
                        {
                            mulesoftIdaQuestionApiResponse = (IdaIdentificationQuestionResponseModel)JSON.deserialize(apiResponse, IdaIdentificationQuestionResponseModel.class);
                            
                            if(mulesoftIdaQuestionApiResponse != null)
                            {
                                if(mulesoftIdaQuestionApiResponse.idaQuestion1 != null)
                                {
                                    listQuestion.add(GetFISIdentificationQuestionModel(mulesoftIdaQuestionApiResponse.idaQuestion1));
                                    questionCount++;
                                }
                                if(mulesoftIdaQuestionApiResponse.idaQuestion2 != null)
                                {
                                    listQuestion.add(GetFISIdentificationQuestionModel(mulesoftIdaQuestionApiResponse.idaQuestion2));
                                    questionCount++;
                                }
                                if(mulesoftIdaQuestionApiResponse.idaQuestion3 != null)
                                {
                                    listQuestion.add(GetFISIdentificationQuestionModel(mulesoftIdaQuestionApiResponse.idaQuestion3));
                                    questionCount++;
                                }
                                if(mulesoftIdaQuestionApiResponse.idaQuestion4 != null)
                                {
                                    listQuestion.add(GetFISIdentificationQuestionModel(mulesoftIdaQuestionApiResponse.idaQuestion4));
                                    questionCount++;
                                }
                                if(mulesoftIdaQuestionApiResponse.idaQuestion5 != null)
                                {
                                    listQuestion.add(GetFISIdentificationQuestionModel(mulesoftIdaQuestionApiResponse.idaQuestion5));
                                    questionCount++;
                                }
                                if(mulesoftIdaQuestionApiResponse.idaQuestion6 != null)
                                {
                                    listQuestion.add(GetFISIdentificationQuestionModel(mulesoftIdaQuestionApiResponse.idaQuestion6));
                                    questionCount++;
                                }
                                
                                responseModel.QuizId = mulesoftIdaQuestionApiResponse.quizId;
                                responseModel.TransactionId = mulesoftIdaQuestionApiResponse.transId;
                                responseModel.IsSuccess = true;
                                if(listQuestion.isEmpty())
                                {
                                    responseModel.IsSuccess = false;
                                }
                                
                                WT_Customer_Verification_Attempt_Log__c newVerificationAttemptLog = new WT_Customer_Verification_Attempt_Log__c();
                                newVerificationAttemptLog.WT_Account_Id__c = accountId;
                                newVerificationAttemptLog.WT_Date_Verification_Attempted__c = System.now();
                                newVerificationAttemptLog.WT_Attempt_Type__c = 'Send';
                                
                                try 
                                {
                                    insert newVerificationAttemptLog;                            
                                }
                                catch (Exception ex) 
                                {
                                    WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'GetPenleyQuestion', ex.getMessage());
                                }
                            }
                            else
                            {
                                responseModel.IsSuccess = false;
                            }
                        }
                        catch(Exception ex)
                        {
                            System.debug('ex: ' + ex.getMessage());
                            responseModel.IsSuccess = false;
                        }
                    }
                }
                else
                {
                    responseModel.IsSuccess = false;
                    responseModel.IsAccountLockedOut = true;
                    responseModel.Message = 'We have reached the limit of generating verification requests.  Please advise the customer that we are unable to proceed with identify verification over the phone. For further assistance, the customer should come into a branch with valid identification. ';
                }
            }
        }
        
        responseModel.ListQuestion = listQuestion;
        responseModel.QuestionCount = questionCount;

        return responseModel;
    }
    
    @AuraEnabled
    public static IdaDecisionResponseModelForFrontEnd GetPenleyDecision(String accountId, String quizId, String transactionId, String listQuestionString)
    {
        IdaDecisionResponseModelForFrontEnd returnModel = new IdaDecisionResponseModelForFrontEnd();
        IdaIdentificationDecisionRequestModel decisionRequestModel = new IdaIdentificationDecisionRequestModel();
        IdaIdentification identificationRequestModel = new IdaIdentification();
        Boolean isSandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
        returnModel.IsSuccess = false;
        Datetime time15MinutesAgo = System.now().addMinutes(-15);
        returnModel.Message = 'Customer cannot be verified.';
        
        if(String.isNotBlank(accountId) && String.isNotBlank(accountId) && String.isNotBlank(accountId) && String.isNotEmpty(listQuestionString))
        {
            List<WT_Customer_Verification_Attempt_Log__c> listVerificationAttemptLog = [SELECT Id,
                                                                                        WT_Account_Id__c
                                                                                        FROM WT_Customer_Verification_Attempt_Log__c
                                                                                        WHERE WT_Date_Verification_Attempted__c >= :time15MinutesAgo
                                                                                        AND WT_Account_Id__c =: accountId
                                                                                       	AND WT_Attempt_Type__c = 'Verify'];

            if(listVerificationAttemptLog == null || listVerificationAttemptLog.isEmpty() || (!listVerificationAttemptLog.isEmpty() && listVerificationAttemptLog.size() < 3))
            {                 
                List<FISIdentificationQuestionModel> listQuestion = (List<FISIdentificationQuestionModel>)JSON.deserialize(listQuestionString, List<FISIdentificationQuestionModel>.class);
                Blob requestIdBlob = Crypto.GenerateAESKey(128);
                String hexString = EncodingUtil.ConvertTohex(requestIdBlob);
                String requestIdGuid = hexString.SubString(0,8)+ '-' + hexString.SubString(8,12) + '-' + hexString.SubString(12,16) + '-' + hexString.SubString(16,20) + '-' + hexString.substring(20);
                
                WT_Contact_Center_Mulesoft__c contactCenterSetting = WT_Contact_Center_Mulesoft__c.getOrgDefaults();
                identificationRequestModel.acquirerid = contactCenterSetting.WT_IDA_API_Acquirer_Id__c;
                identificationRequestModel.configkey = contactCenterSetting.WT_IDA_API_Config_Key__c;
                identificationRequestModel.customerid = contactCenterSetting.WT_IDA_API_Customer_Id__c;
                identificationRequestModel.instancecd = contactCenterSetting.WT_IDA_API_Instance_CD__c;
                identificationRequestModel.productcd = contactCenterSetting.WT_IDA_API_Product_CD__c;
                identificationRequestModel.productversion = contactCenterSetting.WT_IDA_API_Product_Version__c;
                identificationRequestModel.msgUuid = requestIdGuid;
                identificationRequestModel.staging = isSandbox;
                identificationRequestModel.locationid = '';
                identificationRequestModel.aqrcustomerid = '';
                identificationRequestModel.aqr = '';
                identificationRequestModel.userdefinedtransactiontext1 = '';
                identificationRequestModel.userdefinedtransactiontext2 = '';
                identificationRequestModel.userdefinedtransactiontext3 = '';
                
                AnswerRequestModel decisionAnswerRequestModel = new AnswerRequestModel();
                for(Integer iterationCount = 1; iterationCount < 10; iterationCount++)
                {
                    FISIdentificationQuestionModel question = null;
                    if(listQuestion.size() >= iterationCount)
                    {
                        question = listQuestion[iterationCount - 1];
                    }
                    else
                    {
                        question = new FISIdentificationQuestionModel();
                        question.QuestionId = '';
                        question.AnswerId = '';
                    }
                    
                    switch on iterationCount 
                    {
                        when 1
                        {
                            decisionAnswerRequestModel.answer1QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer1ResponseId = question.AnswerId;
                        }
                        when 2
                        {
                            decisionAnswerRequestModel.answer2QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer2ResponseId = question.AnswerId;
                        }
                        when 3
                        {
                            decisionAnswerRequestModel.answer3QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer3ResponseId = question.AnswerId;
                        }
                        when 4
                        {
                            decisionAnswerRequestModel.answer4QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer4ResponseId = question.AnswerId;
                        }
                        when 5
                        {
                            decisionAnswerRequestModel.answer5QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer5ResponseId = question.AnswerId;
                        }
                        when 6
                        {
                            decisionAnswerRequestModel.answer6QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer6ResponseId = question.AnswerId;
                        }
                        when 7
                        {
                            decisionAnswerRequestModel.answer7QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer7ResponseId = question.AnswerId;
                        }
                        when 8
                        {
                            decisionAnswerRequestModel.answer8QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer8ResponseId = question.AnswerId;
                        }
                        when 9
                        {
                            decisionAnswerRequestModel.answer9QuestionId = question.QuestionId;
                            decisionAnswerRequestModel.answer9ResponseId = question.AnswerId;
                        }
                    }
                }
                
                decisionAnswerRequestModel.quizId = quizId;
                decisionAnswerRequestModel.transId = transactionId;
                decisionAnswerRequestModel.userDefinedTransactionText1 = '';
                decisionAnswerRequestModel.userDefinedTransactionText2 = '';
                decisionAnswerRequestModel.userDefinedTransactionText3 = '';
                decisionAnswerRequestModel.msgUuid = '';
                
                decisionRequestModel.idaIdentification = identificationRequestModel;
                decisionRequestModel.ans = decisionAnswerRequestModel;
                
                String jsonBody = JSON.serialize(decisionRequestModel);
                if(Test.isRunningTest())
                {
                    jsonBody = GetIdaDecisionApiMockRequestString();
                }
                
                if(String.isNotBlank(jsonBody))
                {
                    String apiResponse = WT_ContactCenterMulesoftHelper.MakeIdaAPIQuestionMulesoftCallout(jsonBody, true);
                    
                    IdaIdentificationDecisionResponseModel mulesoftIdaDecisionApiResponse = null;
                    
                    try
                    {
                        mulesoftIdaDecisionApiResponse = (IdaIdentificationDecisionResponseModel)JSON.deserialize(apiResponse, IdaIdentificationDecisionResponseModel.class);
                        
                        if(mulesoftIdaDecisionApiResponse != null)
                        {
                            if(String.isNotBlank(mulesoftIdaDecisionApiResponse.decision) && mulesoftIdaDecisionApiResponse.decision.toLowerCase() == 'fail')
                            {
                                returnModel.IsSuccess = true;
                                returnModel.IsVerified = false;
                                returnModel.Message = 'Customer cannot be verified.';
                            }
                            else if(String.isNotBlank(mulesoftIdaDecisionApiResponse.decision) && mulesoftIdaDecisionApiResponse.decision.toLowerCase() == 'pass')
                            {
                                returnModel.IsSuccess = true;
                                returnModel.IsVerified = true;
                                returnModel.Message = 'Customer has been verified.';
                            }
                            
                            Account accountToUpdate = new Account();
                            accountToUpdate.Id = accountId;
                            accountToUpdate.WT_IDA_Verification_Id__c = mulesoftIdaDecisionApiResponse.idaOid;
                            try 
                            {
                                TriggerHandler.bypass('WT_AccountBeforeHandler');
                                TriggerHandler.bypass('WT_AccountAfterHandler');
                                TriggerHandler.bypass('WT_AccountAfterRequiredHandler');
                                update accountToUpdate;   
                                TriggerHandler.clearAllBypasses();                 
                            }
                            catch (Exception ex) 
                            {
                                WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'GetPenleyDecision', ex.getMessage());
                            }
                            
                            WT_Customer_Verification_Attempt_Log__c newVerificationAttemptLog = new WT_Customer_Verification_Attempt_Log__c();
                            newVerificationAttemptLog.WT_Account_Id__c = accountId;
                            newVerificationAttemptLog.WT_Date_Verification_Attempted__c = System.now();
                            newVerificationAttemptLog.WT_Attempt_Type__c = 'Verify';
                            
                            try 
                            {
                                insert newVerificationAttemptLog;                            
                            }
                            catch (Exception ex) 
                            {
                                WT_ExceptionLogHelper.LogException(accountId, 'WT_ContactCenterSearchController', 'GetPenleyDecision', ex.getMessage());
                            }
                        }
                    }
                    catch(Exception ex)
                    {
                        System.debug('ex: ' + ex.getMessage());
                        returnModel.IsSuccess = false;
                    }
                }
            }
            else
            {
                returnModel.IsSuccess = false;
                returnModel.IsAccountLockedOut = true;
                returnModel.Message = 'We have reached the limit of generating verification requests.  Please advise the customer that we are unable to proceed with identify verification over the phone. For further assistance, the customer should come into a branch with valid identification. ';
            }
        }
        
        return returnModel;
    }
    
    public static FISIdentificationQuestionModel GetFISIdentificationQuestionModel(IdaInnerQuestionModel questionModel)
    {
        FISIdentificationQuestionModel returnModel = new FISIdentificationQuestionModel();
        List<FISIdentificationQuestionSubModel> listAnswer = new List<FISIdentificationQuestionSubModel>();
        
        if(String.isNotBlank(questionModel.answer1Text))
        {
        	listAnswer.add(new FISIdentificationQuestionSubModel(questionModel.answer1Text, questionModel.answer1Id));
        }
        if(String.isNotBlank(questionModel.answer2Text))
        {
        	listAnswer.add(new FISIdentificationQuestionSubModel(questionModel.answer2Text, questionModel.answer2Id));
        }
        if(String.isNotBlank(questionModel.answer3Text))
        {
        	listAnswer.add(new FISIdentificationQuestionSubModel(questionModel.answer3Text, questionModel.answer3Id));
        }
        if(String.isNotBlank(questionModel.answer4Text))
        {
        	listAnswer.add(new FISIdentificationQuestionSubModel(questionModel.answer4Text, questionModel.answer4Id));
        }
        if(String.isNotBlank(questionModel.answer5Text))
        {
        	listAnswer.add(new FISIdentificationQuestionSubModel(questionModel.answer5Text, questionModel.answer5Id));
        }
        if(String.isNotBlank(questionModel.answer6Text))
        {
        	listAnswer.add(new FISIdentificationQuestionSubModel(questionModel.answer6Text, questionModel.answer6Id));
        }
        
        if(String.isNotBlank(questionModel.questionText))
        {
         	returnModel = new FISIdentificationQuestionModel(questionModel.questionText, questionModel.id, listAnswer);
        }
        
        return returnModel;
    }
    
    public static String GetIdaDecisionApiMockRequestString()
    {
        return '{' +
            '   "idaIdentification":{' +
            '      "acquirerid":"193073",' +
            '      "configkey":"idaaliaskey",' +
            '      "customerid":"74408199",' +
            '      "locationid":"",' +
            '      "productcd":"01",' +
            '      "productversion":"0001",' +
            '      "staging":false,' +
            '      "userdefinedtransactiontext1":"",' +
            '      "userdefinedtransactiontext2":"",' +
            '      "userdefinedtransactiontext3":"",' +
            '      "aqrcustomerid":"",' +
            '      "aqr":"",' +
            '      "instancecd":"001",' +
            '      "msgUuid":"d3a99c05-9bc7-4db5-b900-ffe054c18e19"' +
            '   },' +
            '   "ans":{' +
            '      "answer1QuestionId":"67699909",' +
            '      "answer1ResponseId":"12288030",' +
            '      "answer2QuestionId":"26461533",' +
            '      "answer2ResponseId":"18728412",' +
            '      "answer3QuestionId":"28460036",' +
            '      "answer3ResponseId":"20857282",' +
            '      "answer4QuestionId":"18235850",' +
            '      "answer4ResponseId":"08864024",' +
            '      "answer5QuestionId":"",' +
            '      "answer5ResponseId":"",' +
            '      "answer6QuestionId":"",' +
            '      "answer6ResponseId":"",' +
            '      "quizId":"DISC:PEN:2148559395",' +
            '      "transId":"4163860766",' +
            '      "userDefinedTransactionText1":"",' +
            '      "userDefinedTransactionText2":"",' +
            '      "userDefinedTransactionText3":"",' +
            '      "answer7QuestionId":"",' +
            '      "answer7ResponseId":"",' +
            '      "answer8QuestionId":"",' +
            '      "answer8ResponseId":"",' +
            '      "answer9QuestionId":"",' +
            '      "answer9ResponseId":"",' +
            '      "msgUuid":""' +
            '   }' +
            '}';   
    }
    
    public static String GetIdaApiMockRequestString()
    {
        return '{' +
            '  "idaIdentification": {' +
            '    "acquirerid": "193073",' +
            '    "configkey": "idaaliaskey",' +
            '    "customerid": "74408199",' +
            '    "locationid": "",' +
            '    "aqrcustomerid": "",' +
            '    "aqr": "",' +
            '    "instancecd": "001",' +
            '    "productcd": "01",' +
            '    "productversion": "0001",' +
            '    "staging": true,' +
            '    "userdefinedtransactiontext1": "",' +
            '    "userdefinedtransactiontext2": "",' +
            '    "userdefinedtransactiontext3": "",' +
            '    "msgUuid": "d3a99c05-9bc7-4db5-b900-ffe054c18e18"' +
            '  },' +
            '  "idaPerson": {' +
            '    "address": "401 N LAZY LAKE RD",' +
            '    "city": "ANN ARBOR",' +
            '    "dob": "04151975",' +
            '    "firstName": "MARK",' +
            '    "idvOid": "",' +
            '    "lastName": "MARSUPIAL",' +
            '    "middleName": "",' +
            '    "govtNbr": "351762213",' +
            '    "state": "MI",' +
            '    "zip": "48014"' +
            '  }' +
            '}';   
    }

    public class D3ChangeResultModel
    {
        @AuraEnabled public Boolean ShouldShowD3Changes;
    }
    
    public class IdaDecisionResponseModelForFrontEnd
    {
        @AuraEnabled public Boolean IsVerified;
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsAccountLockedOut;
        @AuraEnabled public String Message;
    }
    
    public class IdaIdentificationDecisionResponseModel
    {
        public Integer base { get; set; }
        public String decision { get; set; }
        public String idaOid { get; set; }
        public Integer score { get; set; }
    }
    
    public class AnswerRequestModel
    {
        public string answer1QuestionId { get; set; }
        public string answer1ResponseId { get; set; }
        public string answer2QuestionId { get; set; }
        public string answer2ResponseId { get; set; }
        public string answer3QuestionId { get; set; }
        public string answer3ResponseId { get; set; }
        public string answer4QuestionId { get; set; }
        public string answer4ResponseId { get; set; }
        public string answer5QuestionId { get; set; }
        public string answer5ResponseId { get; set; }
        public string answer6QuestionId { get; set; }
        public string answer6ResponseId { get; set; }
        public string quizId { get; set; }
        public string transId { get; set; }
        public string userDefinedTransactionText1 { get; set; }
        public string userDefinedTransactionText2 { get; set; }
        public string userDefinedTransactionText3 { get; set; }
        public string answer7QuestionId { get; set; }
        public string answer7ResponseId { get; set; }
        public string answer8QuestionId { get; set; }
        public string answer8ResponseId { get; set; }
        public string answer9QuestionId { get; set; }
        public string answer9ResponseId { get; set; }
        public string msgUuid { get; set; }
    }

    public class IdaIdentificationDecisionRequestModel
    {
        public IdaIdentification idaIdentification { get; set; }
        public AnswerRequestModel ans { get; set; }
    }
    
    public class IdaInnerQuestionModel
    {
        public string answer1Id { get; set; }
        public string answer1Text { get; set; }
        public string answer2Id { get; set; }
        public string answer2Text { get; set; }
        public string answer3Id { get; set; }
        public string answer3Text { get; set; }
        public string answer4Id { get; set; }
        public string answer4Text { get; set; }
        public string answer5Id { get; set; }
        public string answer5Text { get; set; }
        public string answer6Id { get; set; }
        public string answer6Text { get; set; }
        public string id { get; set; }
        public string questionText { get; set; }
    }

    public class IdaIdentificationQuestionResponseModel
    {
        public IdaInnerQuestionModel idaQuestion1 { get; set; }
        public IdaInnerQuestionModel idaQuestion2 { get; set; }
        public IdaInnerQuestionModel idaQuestion3 { get; set; }
        public IdaInnerQuestionModel idaQuestion4 { get; set; }
        public IdaInnerQuestionModel idaQuestion5 { get; set; }
        public IdaInnerQuestionModel idaQuestion6 { get; set; }
        public IdaInnerQuestionModel idaQuestion7 { get; set; }
        public IdaInnerQuestionModel idaQuestion8 { get; set; }
        public IdaInnerQuestionModel idaQuestion9 { get; set; }
        public string quizId { get; set; }
        public string quizRemain { get; set; }
        public string quizTime { get; set; }
        public string transId { get; set; }
    }
    
    public class IdaIdentification
    {
        public String acquirerid { get; set; }
        public String configkey { get; set; }
        public String customerid { get; set; }
        public String locationid { get; set; }
        public String aqrcustomerid { get; set; }
        public String aqr { get; set; }
        public String instancecd { get; set; }
        public String productcd { get; set; }
        public String productversion { get; set; }
        public Boolean staging { get; set; }
        public String userdefinedtransactiontext1 { get; set; }
        public String userdefinedtransactiontext2 { get; set; }
        public String userdefinedtransactiontext3 { get; set; }
        public String msgUuid { get; set; }
    }

    public class IdaPerson
    {
        public String address { get; set; }
        public String city { get; set; }
        public String dob { get; set; }
        public String firstName { get; set; }
        public String idvOid { get; set; }
        public String lastName { get; set; }
        public String middleName { get; set; }
        public String govtNbr { get; set; }
        public String state { get; set; }
        public String zip { get; set; }
    }

    public class IdaIdentificationRequestModel
    {
        public IdaIdentification idaIdentification { get; set; }
        public IdaPerson idaPerson { get; set; }
    }

    public class FISIdentificationQuestionResponseModel
    {
        @AuraEnabled public List<FISIdentificationQuestionModel> ListQuestion;
        @AuraEnabled public Integer QuestionCount;
        @AuraEnabled public String QuizId;
        @AuraEnabled public String TransactionId;
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsAccountLockedOut;
        @AuraEnabled public String Message;
    }

    public class FISIdentificationQuestionModel
    {
        @AuraEnabled public String QuestionText;
        @AuraEnabled public String QuestionId;
        @AuraEnabled public String AnswerId;
        @AuraEnabled public List<FISIdentificationQuestionSubModel> ListAnswer;
        
        public FISIdentificationQuestionModel()
        {
            
        }

        public FISIdentificationQuestionModel(String questionText, String questionId, List<FISIdentificationQuestionSubModel> listAnswer)
        {
            this.QuestionText = questionText;
            this.QuestionId = questionId;
            this.ListAnswer = listAnswer;
            this.AnswerId = '';
        }
    }

    public class FISIdentificationQuestionSubModel
    {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public FISIdentificationQuestionSubModel(String answerText, String answerId)
        {
            this.label = answerText;
            this.value = answerId;
        }
    }

    public class VerifyCodeResponseModel
    {
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsAccountLockedOut;
        @AuraEnabled public String Message;
    }
    
    public class VerificationCodeGenerationModel
    {
        @AuraEnabled public String Code;
        @AuraEnabled public Boolean IsSuccess;
        @AuraEnabled public Boolean IsAccountLockedOut;
        @AuraEnabled public String Message;
    }
    
    public class MulesoftSearchResultModel
    {
        @AuraEnabled public String DriversLicense;
        @AuraEnabled public List<MulesoftPasswordSearchResultModel> ListPasswordModel;
    }
    
    public class MulesoftPasswordSearchResultModel
    {
        @AuraEnabled public String PasswordQuestion;
        @AuraEnabled public String PasswordAnswer;
        @AuraEnabled public String BankCode;
        @AuraEnabled public Integer RecordCount;
    }
    
    public class AdditionalDetailSearchResultModel
    {
        @AuraEnabled public Id AccountId;
        @AuraEnabled public String CustomerFirstName;
        @AuraEnabled public String CustomerEmailLabel;
        @AuraEnabled public String CustomerEmailValue;
        @AuraEnabled public List<AccountPhoneResultModel> ListPhoneNumber;
        @AuraEnabled public List<FinancialAccountSearchResultModel> ListFinancialAccount;
        @AuraEnabled public ResidenceSearchResultModel CurrentResidence;
        @AuraEnabled public List<RecentTransactionModel> ListRecentTransaction;
    }
    
    public class FinancialAccountSearchResultModel
    {
        @AuraEnabled public String Charter;
        @AuraEnabled public String Branch;
        @AuraEnabled public String AccountNumber;
        @AuraEnabled public String AccountType;
        @AuraEnabled public String Status;
        @AuraEnabled public String FinancialAccountId;
        @AuraEnabled public String RelationshipType;
        @AuraEnabled public String FISAutomaticStatus;//Added for SGE-88
        @AuraEnabled public String FISManualStatus; //Added for SGE-88
    }

    public class RecentTransactionModel implements Comparable
    {
        @AuraEnabled public Date DateTransaction;
        @AuraEnabled public String AccountNumber;
        @AuraEnabled public String AccountType;
        @AuraEnabled public String Status;
        @AuraEnabled public String TransactionType;
        @AuraEnabled public Double Amount;
        @AuraEnabled public String RecordKey;
        
        public RecentTransactionModel(String dateTransaction, String accountNumber, String accountType, String status, String transactionType, double amount, String recordKey)
        {
            if(String.isNotBlank(dateTransaction))
            {
                try
                {
                    if(dateTransaction.contains('-'))
                    {
                        this.DateTransaction = Date.valueOf(dateTransaction);
                    }
                    else if(dateTransaction.length() == 8)
                    {
                     	String formattedDateString = dateTransaction.substring(0, 4) + '-' + dateTransaction.substring(4, 6) + '-' + dateTransaction.substring(6, 8);
                        this.DateTransaction = Date.valueOf(formattedDateString);
                    }                        
                }
                catch(Exception ex)
                {
                    System.debug('ex: ' + ex.getMessage());
                }
            }
            else
            {
                this.DateTransaction = null;
            }
            this.AccountNumber = accountNumber;
            this.AccountType = accountType;
            this.Status = status;
            this.TransactionType = (String.isNotBlank(transactionType)) ? (transactionType == 'C') ? 'Credit' : 'Debit' : null;
            this.Amount = amount;
            this.RecordKey = recordKey;
        }
        
        public Integer compareTo(Object compareObject) 
        {
            RecentTransactionModel otherRecord = (RecentTransactionModel)compareObject;

            Date thisValue = this.DateTransaction;
            Date thatValue = otherRecord.DateTransaction;            

            if(thatValue == null)
            {
                return -1;
            }
            else if (thisValue < thatValue) 
            {
                return 1;
            }
            else if (thisValue > thatValue)
            {
                return -1;
            }
            else
            {
                return 0;
            }
        }
    }
    
    public class ResidenceSearchResultModel
    {
        @AuraEnabled public String Street;
        @AuraEnabled public String City;
        @AuraEnabled public String State;
        @AuraEnabled public String Zip;
        @AuraEnabled public String Country;
        @AuraEnabled public String RecordKey;
    }
    
    public class AccountSearchResultModel 
    {
        @AuraEnabled public String AccountId;
        @AuraEnabled public String Name;
        @AuraEnabled public String Last4OfSocial;
        @AuraEnabled public String DateOfBirth;
        @AuraEnabled public String MobilePhone;
        @AuraEnabled public String HomePhone;
        @AuraEnabled public String BusinessPhone;
        @AuraEnabled public String OtherPhone;
        @AuraEnabled public String AssistantPhone;
        @AuraEnabled public String Email;
        @AuraEnabled public String MothersMaidenName;
        @AuraEnabled public String Last8OfDebitCard;
        @AuraEnabled public String DriversLicense;
        @AuraEnabled public List<MulesoftSearchResultModel> ListPassword;
        @AuraEnabled public Boolean HasReturnedMulesoftResult;
        @AuraEnabled public Boolean HasOneOrMorePasswordResult;
    }   
    
    public class SavePermissionResultModel
    {
        @AuraEnabled public String Error;
        @AuraEnabled public Boolean IsSuccess;
    }

    public class AccountPhoneResultModel
    {
        @AuraEnabled public String label;
        @AuraEnabled public String value;

        public AccountPhoneResultModel(String phoneType, String phoneNumber, Datetime dateLastChanged)
        {
            this.label = phoneType + ': ' + WT_PhoneUtility.FormatPhoneForFrontEnd(phoneNumber);
            if(dateLastChanged != null)
            {
                this.label = this.label + ' | Last Changed On: ' + dateLastChanged.format();
            }
            this.value = phoneNumber;
        }
    }
}