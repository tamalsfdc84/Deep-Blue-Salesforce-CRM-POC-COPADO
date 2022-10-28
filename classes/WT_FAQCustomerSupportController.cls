public class WT_FAQCustomerSupportController 
{
    @AuraEnabled
    public static List<CustomerSupportResponseModel> GetCustomerSupportInformation()
    {
        List<CustomerSupportResponseModel> responseModel = new List<CustomerSupportResponseModel>();
        
        for(WT_FAQ_Customer_Support__c customerSupportItem : [SELECT Id,
                                                              WT_Bank_Name__c,
                                                              WT_Customer_Support_Phone__c
                                                              FROM WT_FAQ_Customer_Support__c
                                                              ORDER BY WT_Display_Order__c])
        {
            responseModel.add(new CustomerSupportResponseModel(customerSupportItem.WT_Bank_Name__c, customerSupportItem.WT_Customer_Support_Phone__c));
        }
        
        return responseModel;
    }
    
    public class CustomerSupportResponseModel
    {
        @AuraEnabled public String BankName;
        @AuraEnabled public String BankPhoneNumber;
        @AuraEnabled public String BankPhoneNumberLink;
        
        public CustomerSupportResponseModel(String bankName, String bankPhoneNumber)
        {
            this.BankName = bankName;
            this.BankPhoneNumber = WT_PhoneUtility.FormatPhoneWithHyphen(bankPhoneNumber);
            this.BankPhoneNumberLink = 'tel:' + WT_PhoneUtility.FormatPhoneTo10Digit(bankPhoneNumber);
        }
    }
}