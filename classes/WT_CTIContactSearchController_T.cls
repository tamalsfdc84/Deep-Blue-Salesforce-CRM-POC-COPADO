@isTest
public class WT_CTIContactSearchController_T
{
    @TestSetup
    static void makeData(){
        Contact contact = new Contact();
        contact.FirstName = 'Test';
        contact.LastName = 'Contact';
        contact.HomePhone = '2622692764';
        insert contact;
    }

    @isTest
    static void getContactsForPhoneTest()
    {
        List<Contact> contacts = WT_CTIContactSearchController.getContactsForPhone('2622692764');
        System.assertNotEquals(null, contacts,'No contacts found');
    }
}