public class WT_ThirdPartyDataToAccountMatchUtility 
{
    private static Id BUSINESS_ACCOUNT_PROSPECT_RECORDTYPE_ID = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('BusinessAccount_Prospect').getRecordTypeId();
    public static void MatchThirdPartyDataToAccount(List<WT_Third_Party_Data__c> listThirdPartyData)
    {
        Map<String, WT_Third_Party_Data__c> mapInfoUsaIdAndThirdPartyData = new Map<String, WT_Third_Party_Data__c>();
        Map<String, WT_Third_Party_Data__c> mapDunsNumberAndThirdPartyData = new Map<String, WT_Third_Party_Data__c>();
        Map<Id, Id> mapThirdPartyDataIdAndMatchedAccountId = new Map<Id, Id>();
        Map<Id, Account> mapAccountIdAndAccount = new Map<Id, Account>();
        List<String> listAddressToMatchWithExistingAccount = new List<String>();
        Map<Id, WT_Third_Party_Data__c> mapThirdPartyDataIdAndThirdPartyDataToMatch = new Map<Id, WT_Third_Party_Data__c>();
        Map<Id, WT_Third_Party_Data__c> mapThirdPartyDataIdAndThirdPartyData = new Map<Id, WT_Third_Party_Data__c>();
        List<WT_Third_Party_Data__c> listThirdPartyDataToUpdate = new List<WT_Third_Party_Data__c>();
        Set<Id> setAccountIdToUpdate = new Set<Id>();
        List<Account> listAccountToUpdate = new List<Account>();
        List<Account> listAccountToInsert = new List<Account>();
        
        for(WT_Third_Party_Data__c newItem : listThirdPartyData)
        {
            mapThirdPartyDataIdAndThirdPartyData.put(newItem.Id, newItem);
            if(String.isNotBlank(newItem.WT_INFOUSAID__c))
            {
                mapInfoUsaIdAndThirdPartyData.put(newItem.WT_INFOUSAID__c, newItem);
            }
            else if(String.isNotBlank(newItem.WT_D_U_N_S_Number__c))
            {
                mapDunsNumberAndThirdPartyData.put(newItem.WT_D_U_N_S_Number__c, newItem);
            }
            else
            {
                mapThirdPartyDataIdAndThirdPartyDataToMatch.put(newItem.Id, newItem);
            }
        }
        
        //Grab list of accounts which match on either INFOUSA ID OR the DUNS Number
        //Add the matched Third Party Data Records to the matched Map
        //Remove the records from their corresponding InfoUSA or DUNS map so that we can fall into the next tier match for remaining records
        if(!mapInfoUsaIdAndThirdPartyData.isEmpty())
        {
            for(Account matchedAccount : [SELECT Id,
                                          WT_InfoUSA_Prospect_ID__c
                                          FROM Account
                                          WHERE RecordTypeId = :BUSINESS_ACCOUNT_PROSPECT_RECORDTYPE_ID
                                          AND WT_InfoUSA_Prospect_ID__c IN :mapInfoUsaIdAndThirdPartyData.keySet()
                                          LIMIT 50000])
            {
                mapAccountIdAndAccount.put(matchedAccount.Id, matchedAccount);
                if(String.isNotBlank(matchedAccount.WT_InfoUSA_Prospect_ID__c) && !mapInfoUsaIdAndThirdPartyData.isEmpty() 
                   && mapInfoUsaIdAndThirdPartyData.containsKey(matchedAccount.WT_InfoUSA_Prospect_ID__c))
                {
                    mapThirdPartyDataIdAndMatchedAccountId.put(mapInfoUsaIdAndThirdPartyData.get(matchedAccount.WT_InfoUSA_Prospect_ID__c).Id, matchedAccount.Id);
                    mapInfoUsaIdAndThirdPartyData.remove(matchedAccount.WT_InfoUSA_Prospect_ID__c);
                }
            }
        }
        
        if(!mapDunsNumberAndThirdPartyData.isEmpty())
        {
            for(Account matchedAccount : [SELECT Id,
                                          WT_DUNS_Number__c
                                          FROM Account
                                          WHERE RecordTypeId = :BUSINESS_ACCOUNT_PROSPECT_RECORDTYPE_ID
                                          AND WT_DUNS_Number__c IN :mapDunsNumberAndThirdPartyData.keySet()
                                          LIMIT 50000])
            {
                mapAccountIdAndAccount.put(matchedAccount.Id, matchedAccount);
                if(String.isNotBlank(matchedAccount.WT_DUNS_Number__c) && !mapDunsNumberAndThirdPartyData.isEmpty() 
                   && mapDunsNumberAndThirdPartyData.containsKey(matchedAccount.WT_DUNS_Number__c))
                {
                    mapThirdPartyDataIdAndMatchedAccountId.put(mapDunsNumberAndThirdPartyData.get(matchedAccount.WT_DUNS_Number__c).Id, matchedAccount.Id);
                    mapDunsNumberAndThirdPartyData.remove(matchedAccount.WT_DUNS_Number__c);
                }
            }
        }        
        
        //Grab a list of Concatenated Address 1, Address 2, Address 3 strings and match with any Account that has those strings        
        Set<String> setAddressLineToCheckAgainstAccount = new Set<String>();
        if(!mapInfoUsaIdAndThirdPartyData.isEmpty())
        {
            for(WT_Third_Party_Data__c unmatchedInfoUsaData : mapInfoUsaIdAndThirdPartyData.values())
            {
                mapThirdPartyDataIdAndThirdPartyDataToMatch.put(unmatchedInfoUsaData.Id, unmatchedInfoUsaData);
            }
        }
        if(!mapDunsNumberAndThirdPartyData.isEmpty())
        {
            for(WT_Third_Party_Data__c unmatchedDunsData : mapDunsNumberAndThirdPartyData.values())
            {
                mapThirdPartyDataIdAndThirdPartyDataToMatch.put(unmatchedDunsData.Id, unmatchedDunsData);
            }
        }
        
        if(!mapThirdPartyDataIdAndThirdPartyDataToMatch.isEmpty())
        {
            for(WT_Third_Party_Data__c newThirdPartyItem : mapThirdPartyDataIdAndThirdPartyDataToMatch.values())
            {
                Set<String> setAddressLine = GetSetOfAddressFromThirdPartyData(newThirdPartyItem);
                if(!setAddressLine.isEmpty())
                {
                    setAddressLineToCheckAgainstAccount.addAll(setAddressLine);
                }
            }
        }
        
        if(!setAddressLineToCheckAgainstAccount.isEmpty())
        {
            List<Account> listMatchingAccount = GetAccountsMatchingAddress(setAddressLineToCheckAgainstAccount);
            if(listMatchingAccount != null && !listMatchingAccount.isEmpty())
            {
                for(Account accountToMatch : listMatchingAccount)
                {
                    Boolean hasFoundMatchingThirdPartyData = false;
                    for(WT_Third_Party_Data__c unmatchedThirdParty : mapThirdPartyDataIdAndThirdPartyDataToMatch.values())
                    {
                        Boolean isThirdPartyDataAddressMatching = GetIsAddressMatchingForThirdPartyDataAndAccount(unmatchedThirdParty, accountToMatch, false);
                        if(isThirdPartyDataAddressMatching)
                        {
                            Boolean isCompanyName85PercentMatch = GetAreStrings85PercentFuzzyMatch(unmatchedThirdParty.Name, accountToMatch.Name);
                            if(isCompanyName85PercentMatch)
                            {
                                mapThirdPartyDataIdAndMatchedAccountId.put(unmatchedThirdParty.Id, accountToMatch.Id);
                                mapThirdPartyDataIdAndThirdPartyDataToMatch.remove(unmatchedThirdParty.Id);
                                break;
                            }
                        }
                    }
                }
            }
        }
        
        //Tier 3 check
        Set<String> setAddressLineToCheckAgainstAccountForTier3 = new Set<String>();
        if(!mapThirdPartyDataIdAndThirdPartyDataToMatch.isEmpty())
        {
            for(WT_Third_Party_Data__c newThirdPartyItem : mapThirdPartyDataIdAndThirdPartyDataToMatch.values())
            {
                Set<String> setAddressLine = GetSetOfAddressFromThirdPartyData(newThirdPartyItem);
                if(!setAddressLine.isEmpty())
                {
                    setAddressLineToCheckAgainstAccountForTier3.addAll(setAddressLine);
                }
            }
            
            if(!setAddressLineToCheckAgainstAccountForTier3.isEmpty())
            {
                List<Account> listMatchingAccountForTier3 = GetAccountsMatchingAddress(setAddressLineToCheckAgainstAccountForTier3);
                if(listMatchingAccountForTier3 != null && !listMatchingAccountForTier3.isEmpty())
                {
                    for(Account accountToMatch : listMatchingAccountForTier3)
                    {
                        Boolean hasFoundMatchingThirdPartyData = false;
                        for(WT_Third_Party_Data__c unmatchedThirdParty : mapThirdPartyDataIdAndThirdPartyDataToMatch.values())
                        {
                            Boolean isThirdPartyDataAddressMatching = GetIsAddressMatchingForThirdPartyDataAndAccount(unmatchedThirdParty, accountToMatch, true);
                            if(isThirdPartyDataAddressMatching && unmatchedThirdParty.Name.toLowerCase() == accountToMatch.Name.toLowerCase())
                            {
                                if(GetNumericString(unmatchedThirdParty.WT_PHONE__c) == GetNumericString(accountToMatch.Phone))
                                {
                                    mapThirdPartyDataIdAndMatchedAccountId.put(unmatchedThirdParty.Id, accountToMatch.Id);
                                    mapThirdPartyDataIdAndThirdPartyDataToMatch.remove(unmatchedThirdParty.Id);
                                    break;
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //All 3 tier checks are complete
        //Update/Create the Account records & update the lookup on Third Party Data
        if(!mapThirdPartyDataIdAndMatchedAccountId.isEmpty())
        {
            for(Id thirdPartyDataId : mapThirdPartyDataIdAndMatchedAccountId.keySet())
            {
                Id matchedAccountId = mapThirdPartyDataIdAndMatchedAccountId.get(thirdPartyDataId);
                WT_Third_Party_Data__c relatedThirdPartyData = mapThirdPartyDataIdAndThirdPartyData.get(thirdPartyDataId);
                Account accountToUpdate = new Account();
                accountToUpdate.Id = matchedAccountId;                
                accountToUpdate = GetMappedAccountObjectFromThirdPartyData(accountToUpdate, relatedThirdPartyData);  
                if(!setAccountIdToUpdate.contains(matchedAccountId))
                {
                    setAccountIdToUpdate.add(matchedAccountId);
                    listAccountToUpdate.add(accountToUpdate);
                }
                
                WT_Third_Party_Data__c thirdPartyDataToUpdate = new WT_Third_Party_Data__c();
                thirdPartyDataToUpdate.Id = relatedThirdPartyData.Id;
                thirdPartyDataToUpdate.WT_Account__c = matchedAccountId;
                listThirdPartyDataToUpdate.add(thirdPartyDataToUpdate);
            }
        }
        
        if(!mapThirdPartyDataIdAndThirdPartyDataToMatch.isEmpty())
        {
            for(Id thirdPartyDataId : mapThirdPartyDataIdAndThirdPartyDataToMatch.keySet())
            {
                WT_Third_Party_Data__c relatedThirdPartyData = mapThirdPartyDataIdAndThirdPartyDataToMatch.get(thirdPartyDataId);
                Account newBusinessProspectAccountToInsert = new Account();
                newBusinessProspectAccountToInsert.RecordTypeId = BUSINESS_ACCOUNT_PROSPECT_RECORDTYPE_ID;
                newBusinessProspectAccountToInsert.Name = relatedThirdPartyData.Name;
                newBusinessProspectAccountToInsert.Phone = relatedThirdPartyData.WT_PHONE__c; 
                if(String.isNotBlank(relatedThirdPartyData.WT_Primary_Address__c))
                {
                    newBusinessProspectAccountToInsert.BillingStreet = relatedThirdPartyData.WT_Primary_Address__c;
                }
                if(String.isNotBlank(relatedThirdPartyData.WT_Primary_City__c))
                {
                    newBusinessProspectAccountToInsert.BillingCity = relatedThirdPartyData.WT_Primary_City__c;
                }
                if(String.isNotBlank(relatedThirdPartyData.WT_Primary_state__c))
                {
                    newBusinessProspectAccountToInsert.BillingState = relatedThirdPartyData.WT_Primary_state__c;
                }
                if(String.isNotBlank(relatedThirdPartyData.WT_Primary_Zip_Code__c))
                {
                    newBusinessProspectAccountToInsert.BillingPostalCode = relatedThirdPartyData.WT_Primary_Zip_Code__c;
                }
                newBusinessProspectAccountToInsert = GetMappedAccountObjectFromThirdPartyData(newBusinessProspectAccountToInsert, relatedThirdPartyData);
                
                listAccountToInsert.add(newBusinessProspectAccountToInsert);
            }
            
            if(!listAccountToInsert.isEmpty())
            {
                Database.SaveResult[] listInsertSaveResult = Database.insert(listAccountToInsert, false);
                
                Integer saveResultIndex = 0;
                for(Id thirdPartyDataId : mapThirdPartyDataIdAndThirdPartyDataToMatch.keySet())
                {
                    WT_Third_Party_Data__c relatedThirdPartyData = mapThirdPartyDataIdAndThirdPartyDataToMatch.get(thirdPartyDataId);
                    Database.SaveResult insertSaveResult = listInsertSaveResult[saveResultIndex];
                    if(insertSaveResult.isSuccess())
                    {
                        Id newAccountId = insertSaveResult.getId();
                        WT_Third_Party_Data__c thirdPartyDataToUpdate = new WT_Third_Party_Data__c();
                        thirdPartyDataToUpdate.Id = relatedThirdPartyData.Id;
                        thirdPartyDataToUpdate.WT_Account__c = newAccountId;                        
                        listThirdPartyDataToUpdate.add(thirdPartyDataToUpdate);
                    }
                    
                    saveResultIndex++;
                }
            }
        }
        
        if(!listAccountToUpdate.isEmpty())
        {
            update listAccountToUpdate;
        }
        if(!listThirdPartyDataToUpdate.isEmpty())
        {
            update listThirdPartyDataToUpdate;
        }
    }
    
    public static Account GetMappedAccountObjectFromThirdPartyData(Account accountToMap, WT_Third_Party_Data__c thirdPartyDataToMap)
    {        
        if(String.isNotBlank(thirdPartyDataToMap.WT_INFOUSAID__c))
        {
            accountToMap.WT_Annual_Revenue_InfoUSA__c = thirdPartyDataToMap.WT_Revenue_USD__c;
            if(String.isNotBlank(thirdPartyDataToMap.WT_Employees_Single_Site__c))
            {
                Integer employeeCount = null;
                try
                {
                    employeeCount = Integer.valueOf(thirdPartyDataToMap.WT_Employees_Single_Site__c);
                }
                catch(Exception ex)
                {
                    
                }
                
                if(employeeCount != null)
                {
                    accountToMap.WT_Employees_InfoUSA__c = employeeCount;
                }
            }
            accountToMap.WT_InfoUSA_Prospect_ID__c = thirdPartyDataToMap.WT_INFOUSAID__c;                    
            accountToMap.WT_Primary_Contact_Name_InfoUSA__c = thirdPartyDataToMap.WT_Contact_Name__c;
            accountToMap.WT_Primary_Email_InfoUSA__c = thirdPartyDataToMap.WT_Email__c;
        }
        if(String.isNotBlank(thirdPartyDataToMap.WT_D_U_N_S_Number__c))
        {
            accountToMap.WT_Annual_Revenue_DNB__c = thirdPartyDataToMap.WT_Revenue_USD__c;
            accountToMap.WT_Primary_Contact_Name_DNB__c = thirdPartyDataToMap.WT_Contact_Name__c;
            accountToMap.WT_Primary_Email_DNB__c = thirdPartyDataToMap.WT_Email__c;
            accountToMap.WT_DUNS_Number__c = thirdPartyDataToMap.WT_D_U_N_S_Number__c;
        }
        
        return accountToMap;
    }
    
    public static List<Account> GetAccountsMatchingAddress(Set<String> setAddressToCheck)
    {
        System.debug('setAddressToCheck: ' + setAddressToCheck);
        List<Account> listMatchingAccount = new List<Account>();
        String stringSearchCriteria = String.join(new List<String>(setAddressToCheck), ' OR ');
        List<List<SObject>> listOfListSearchedObject = [FIND :stringSearchCriteria IN ALL FIELDS
                                                        RETURNING Account (Id,
                                                                           Name,
                                                                           BillingStreet,
                                                                           BillingState,
                                                                           BillingPostalCode,
                                                                           BillingCity,
                                                                           Phone
                                                                           WHERE RecordTypeId = :BUSINESS_ACCOUNT_PROSPECT_RECORDTYPE_ID)];
        
        if(listOfListSearchedObject != null && !listOfListSearchedObject.isEmpty())
        {
            if(listOfListSearchedObject[0] != null && !listOfListSearchedObject[0].isEmpty())
            {
                listMatchingAccount = listOfListSearchedObject[0];
            }
        }
        
        return listMatchingAccount;
    }
    
    public static String GetNumericString(String stringToStripNonNumericsFrom)
    {
        String returnValue = '';
        
        if(String.isNotBlank(stringToStripNonNumericsFrom))
        {
            returnValue = stringToStripNonNumericsFrom.replaceAll('[^0-9]', '');    
        }
        
        return returnValue;
    }
    
    public static Boolean GetAreStrings85PercentFuzzyMatch(String valueToCompare, String valueToCompareWith)
    {
        Boolean areStringsMatching = false;
        
        if(String.isBlank(valueToCompare) && String.isBlank(valueToCompareWith))
        {
            areStringsMatching = true;
        }
        else
        {
            if(String.isNotBlank(valueToCompare) && String.isNotBlank(valueToCompareWith))
            {
                String[] arrayCharacterValueToCompare = valueToCompare.split('');
                String matchingCharacterString = '';
                Integer countCharacterNotFound = 0;
                
                for(Integer i = 0; i < arrayCharacterValueToCompare.size(); i++)
                {                    
                    if(valueToCompareWith.toLowerCase().contains(arrayCharacterValueToCompare[i].toLowerCase()))
                    {
                        //Check if the character has already been checked against the value to compare
                        //if it has, check the number of times a given character appears in the the value to compare
                        //if the count is less than the count already checked, then do not consider the character as a match
                        if(matchingCharacterString.contains(arrayCharacterValueToCompare[i].toLowerCase()))
                        {
                            Integer countAlreadyMatched = matchingCharacterString.countMatches(arrayCharacterValueToCompare[i].toLowerCase());
                            Integer countCharacterInStringToCompareWith = valueToCompareWith.toLowerCase().countMatches(arrayCharacterValueToCompare[i].toLowerCase());
                            
                            if(countCharacterInStringToCompareWith <= countAlreadyMatched)
                            {
                                countCharacterNotFound++;
                            }
                        }
                        else
                        {
                            matchingCharacterString += arrayCharacterValueToCompare[i].toLowerCase();
                        }
                    }
                    else
                    {
                        countCharacterNotFound++;
                    }
                }
                
                if(countCharacterNotFound == 0)
                {
                    areStringsMatching = true;
                }
                else
                {
                    Double percentUnmatched = ((Double)countCharacterNotFound/(Double)arrayCharacterValueToCompare.size()) * 100;
                    if(percentUnmatched <= 15)
                    {
                        areStringsMatching = true;    
                    }
                }
            }
        }
        
        return areStringsMatching;
    }
    
    public static Boolean GetIsAddressMatchingForThirdPartyDataAndAccount(WT_Third_Party_Data__c unmatchedThirdParty, Account accountToMatch, Boolean shouldFuzzyMatch85Percent)
    {
        Boolean isAddressMatching = false;
        //Check for zip, city & state match first
        //No need to go into Address Line 1,2 & 3 match if the first 3 attributes can rule out records
        if((String.isNotBlank(unmatchedThirdParty.WT_Primary_Zip_Code__c) && String.isNotBlank(accountToMatch.BillingPostalCode) && unmatchedThirdParty.WT_Primary_Zip_Code__c == accountToMatch.BillingPostalCode)
           && (String.isNotBlank(unmatchedThirdParty.WT_Primary_City__c) && String.isNotBlank(accountToMatch.BillingCity) && unmatchedThirdParty.WT_Primary_City__c == accountToMatch.BillingCity)
           && (String.isNotBlank(unmatchedThirdParty.WT_Primary_state__c) && String.isNotBlank(accountToMatch.BillingState) && unmatchedThirdParty.WT_Primary_state__c == accountToMatch.BillingState))
        {            
            if(String.isNotBlank(unmatchedThirdParty.WT_Primary_Address__c) && String.isNotBlank(accountToMatch.BillingStreet))
            {
                if(accountToMatch.BillingStreet.toLowerCase() == unmatchedThirdParty.WT_Primary_Address__c.toLowerCase())
                {
                	isAddressMatching = true;    
                }
                else
                {
                    if(shouldFuzzyMatch85Percent)
                    {
                        isAddressMatching = GetAreStrings85PercentFuzzyMatch(unmatchedThirdParty.WT_Primary_Address__c.toLowerCase(), accountToMatch.BillingStreet.toLowerCase());
                    }
                }
            }
        } 
        
        return isAddressMatching;
    }
    
    public static Set<String> GetSetOfAddressFromThirdPartyData(WT_Third_Party_Data__c newThirdPartyItem)
    {
        Set<String> setAddressLine = new Set<String>();
        if(String.isNotBlank(newThirdPartyItem.WT_Primary_Address__c))
        {
            setAddressLine.add('*' + newThirdPartyItem.WT_Primary_Address__c + '*');
        }
        
        return setAddressLine;
    }
}