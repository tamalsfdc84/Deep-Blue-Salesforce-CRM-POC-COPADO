/**
 * ----------------------------------------------------------------------------------------------------------------------
 * @Name           WT_CTIContactSearchController
 * @Author         Anh Phan
 * @ModifiedBy     Anh Phan
 * @Version        v1.0
 * @CreatedDate    11-03-2021
 * @UsedBy         wT_CTIContactSearch(LWC) 
 * @TestClass      WT_CTIContactSearchController_T
 * ----------------------------------------------------------------------------------------------------------------------
 * @Description
 * Server side controller for wT_CTIContactSearch(LWC)
 * ----------------------------------------------------------------------------------------------------------------------
 * @Changes
 * ----------------------------------------------------------------------------------------------------------------------
**/
public without sharing class WT_CTIContactSearchController
{
 private static final String CONTACTQUERY = 'SELECT FinServ__MotherMaidenName__c,Email,Birthdate,FinServ__MailingAddress__c,FinServ__LastFourDigitSSN__c,Id,Name,HomePhone,AssistantPhone,Phone,MobilePhone,OtherPhone FROM Contact WHERE HomePhone = :phoneNumber OR AssistantPhone = :phoneNumber OR Phone = :phoneNumber OR MobilePhone = :phoneNumber OR OtherPhone = :phoneNumber';
 
  /**
   * ----------------------------------------------------------------------------------------------------------------------
   * @Description
   * Method to retrieve contact details based on user input 
   * ----------------------------------------------------------------------------------------------------------------------
   * @param     phoneNumber     String input for phone number to search
   * @return    List<Contact>   A list of contacts that matches the entered phone number
   * ----------------------------------------------------------------------------------------------------------------------
  **/
  @AuraEnabled
  public static List<Contact> getContactsForPhone(String phoneNumber)
  {
      List<Contact> listContact;
      try
      {
        listContact = Database.query(CONTACTQUERY);
      }
      catch (Exception e) 
      {throw new AuraHandledException(e.getMessage());
      }
      return listContact;
  }

}