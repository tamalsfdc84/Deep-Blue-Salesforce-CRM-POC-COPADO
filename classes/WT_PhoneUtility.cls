//Code Coverage: WT_PhoneUtility_T
public without sharing class WT_PhoneUtility {
    public static String FormatPhoneForFrontEnd(String phoneNumber)
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

    public static String FormatPhoneTo10Digit(String phoneNumber)
    {
        String returnValue = '';
        
        if(String.isNotBlank(phoneNumber))
        {
            if (phoneNumber.length() >= 12 && phoneNumber.startsWith('+'))
            {
                phoneNumber = phoneNumber.substring(2);
            }
            else if(phoneNumber.startsWith('1'))
            {
                phoneNumber = phoneNumber.substring(1);
            }
            
            for(String character : phoneNumber.split('(?!^)'))
            {
                if(character.isNumeric())
                {
                    returnValue += character;
                }
            }
        }
        
        return returnValue;   
    }
    
    public static String FormatPhoneWithHyphen(String phoneNumber)
    {
        String formattedPhone = '';
        String phoneNumberReplaced = phoneNumber.replaceAll('\\D','');
        
        if(String.isNotBlank(phoneNumber))
        {
            phoneNumberReplaced = FormatPhoneTo10Digit(phoneNumber);
        }
        
        if (phoneNumberReplaced.length() == 10)
        {
            phoneNumberReplaced = phoneNumberReplaced.substring(0, 3) + '-' + phoneNumberReplaced.substring(3, 6) + '-' + phoneNumberReplaced.substring(6);
            formattedPhone = phoneNumberReplaced;
        }
        else
        {
            formattedPhone = phoneNumber;
        }

        return formattedPhone; 
    }
}