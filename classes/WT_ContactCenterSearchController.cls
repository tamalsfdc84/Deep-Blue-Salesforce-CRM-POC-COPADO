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
                                                                         AND FinServ__FinancialAccount__r.FinServ__Status__c = 'Open'
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
                
                if(mulesoftResponse != null && mulesoftResponse.Individuals.size() > 0)
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
        AdditionalDetailSearchResultModel returnModel = new AdditionalDetailSearchResultModel();
        List<ResidenceSearchResultModel> listResidence = new List<ResidenceSearchResultModel>();
        List<FinancialAccountSearchResultModel> listFinancialAccount = new List<FinancialAccountSearchResultModel>();
        returnModel.ListFinancialAccount = null;
        returnModel.ListResidence = null;
        
        if(accountId != null)
        {
            List<Account> listAccount = [SELECT Id, BillingStreet, BillingCity, BillingCountry, BillingState, BillingPostalCode
                                         FROM Account
                                         WHERE Id =: accountId];
            
            if(listAccount != null && listAccount.size() > 0)
            {
                Account relatedAccount = listAccount[0];
                ResidenceSearchResultModel residenceModel = new ResidenceSearchResultModel();
                residenceModel.Street = relatedAccount.BillingStreet;
                residenceModel.City = relatedAccount.BillingCity;
                residenceModel.State = relatedAccount.BillingState;
                residenceModel.Zip = relatedAccount.BillingPostalCode;
                residenceModel.Country = relatedAccount.BillingCountry;
                residenceModel.RecordKey = relatedAccount.Id;
                listResidence.add(residenceModel);
                returnModel.ListResidence = listResidence;
                
                List<FinServ__FinancialAccountRole__c> listFinancialAccountRole = [SELECT Id, FinServ__FinancialAccount__r.WT_Charter_Name__c,
                                                                                   FinServ__FinancialAccount__r.WT_Bank__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__FinancialAccountType__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__Description__c,
                                                                                   FinServ__FinancialAccount__r.FinServ__Status__c,
                                                                                   FinServ__FinancialAccount__c, FinServ__Role__c
                                                                                   FROM FinServ__FinancialAccountRole__c
                                                                                   WHERE FinServ__RelatedAccount__c =: relatedAccount.Id
                                                                                   AND FinServ__EndDate__c = null
                                                                                   ORDER BY FinServ__FinancialAccount__r.LastModifiedDate DESC];
                
                if(listFinancialAccountRole != null && listFinancialAccountRole.size() > 0)
                {
                    for(FinServ__FinancialAccountRole__c financialAccountRole : listFinancialAccountRole)
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
                        
                        listFinancialAccount.add(financialAccountModel);
                    }
                    returnModel.ListFinancialAccount = listFinancialAccount;
                }
            }
        }
        
        return returnModel;
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
        @AuraEnabled public List<FinancialAccountSearchResultModel> ListFinancialAccount;
        @AuraEnabled public List<ResidenceSearchResultModel> ListResidence;
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
}