/**
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Name           GoalSettingController
* @Author         Krupa Chinthakindi
* @ModifiedBy     Krupa Chinthakindi
* @Version        v1.0
* @CreatedDate    12/10/2021
* @TestClass      WT_TestGoalSettingController
* -----------------------------------------------------------------------------------------------------------------------------------------
* @Description
* This class is used to return the list of fields for an object. 
* -----------------------------------------------------------------------------------------------------------------------------------------
* 
**/
public class WT_GoalSettingController {

    //This method is used to sort all fields for a given object. And it is used in GoalSettings LWC comp.
    @AuraEnabled(cacheable=true)
    public static List<String> getObjectFields(String objectName){
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String,Schema.SObjectField> mfields = objectType.getDescribe().fields.getMap();
        List<String> sObjectDetailsList = new List<String>();
        for(String s : mfields.keySet()){
            sObjectDetailsList.add(String.valueOf(mfields.get(s)));
        }
        sObjectDetailsList.sort();

        return sObjectDetailsList;
    }
    // This method is used to get Numeric Field datatype(to show up as FieldToSum in UI) and is used in GoalSettings LWC comp.
    @AuraEnabled
    public static List<IntegerFieldOnObject> getIntegerFieldsFromObject(String objectApiName)
    {
        List<IntegerFieldOnObject> listIntegerField = new List<IntegerFieldOnObject>();
        try {
            Map<String, Schema.SObjectField> mapField = Schema.getGlobalDescribe().get(objectApiName).getDescribe().fields.getMap();
            for (String fieldApiName: mapField.keySet()) 
            {
                Schema.DisplayType fieldDataType = mapField.get(fieldApiName).getDescribe().getType();
                if(fieldDataType == Schema.DisplayType.Integer || fieldDataType == Schema.DisplayType.Currency ||
                    fieldDataType == Schema.DisplayType.Double || fieldDataType == Schema.DisplayType.Long) 
                {
                    String fieldLabel = mapField.get(fieldApiName).getDescribe().getLabel();
                    String concatenatedLabel = fieldLabel + ' (' + fieldApiName + ')';

                    IntegerFieldOnObject newField = new IntegerFieldOnObject();
                    newField.FieldLabel = concatenatedLabel;
                    newField.FieldApiName = fieldApiName;

                    listIntegerField.add(newField);
                }
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }

        return listIntegerField;
    }
    //This method is to get the field datatype for an object
    public static Schema.DisplayType fieldType(String objectName,String fdName) {
        SObjectType objectType = Schema.getGlobalDescribe().get(objectName);
        Map<String, Schema.SObjectField> fieldMap = objectType.getDescribe()
            .fields.getMap();
        Schema.DisplayType dt;
        for (String fieldName : fieldMap.keySet()) {
            if (fieldName == fdName) {
                
                Schema.DisplayType fielddataType = fieldMap.get(fieldName)
                    .getDescribe()
                    .getType();
                dt = fielddataType;
            }
        }
        system.debug('dt**' + dt);
        return dt;
    }


    public class IntegerFieldOnObject
    {
        @AuraEnabled public String FieldLabel;
        @AuraEnabled public String FieldApiName;
    }
}