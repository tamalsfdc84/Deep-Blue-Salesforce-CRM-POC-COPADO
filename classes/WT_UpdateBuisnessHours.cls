/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_UpdateBuisnessHours
* @Author			Swathi Ramesh	<sramesh1@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		06-15-2021
* @UsedBy			Case Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used for Calculate Business Working Time based on Priority.
* 
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 06-18-2021
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_UpdateBuisnessHours 
{
	@InvocableMethod
    public static void getBusinessHours( List<Id> recordId )
    {
        List<Case> listCaseRecord = [SELECT Id,Priority,WT_Contact_Date__c,WT_Respond_By__c,WT_Business_Hours_To_Complete__c FROM Case WHERE Id = :recordId];
        List<MYHR_Business_Hours__mdt> listHRCase = [SELECT Id, WT_Business_Hours__c, WT_Priority__c  FROM MYHR_Business_Hours__mdt];
        Map<String,Decimal> mapBusinessHour = new  Map<String,Decimal>();
        Double getBussinessHours = 0.00;
        for(MYHR_Business_Hours__mdt businessHours : listHRCase )
        {
            mapBusinessHour.put(businessHours.WT_Priority__c,businessHours.WT_Business_Hours__c);            
        }
        for(Case caseRecord : listCaseRecord)
        {
            if(caseRecord.Priority != null)
            {  
            getBussinessHours = mapBusinessHour.get(caseRecord.Priority);
            caseRecord.WT_Business_Hours_To_Complete__c = getBussinessHours;
            caseRecord.WT_Respond_By__c = getBusinessHoursDate(caseRecord.WT_Contact_Date__c, getBussinessHours);
            }
            else
            {
                caseRecord.WT_Business_Hours_To_Complete__c = 0;
            }
        }   
        update listCaseRecord;
    }
    public static Boolean getHoliday(DateTime currentDate,set<Date> holidaySet)
    {       
        DateTime dx = currentDate;
        Date dt = Date.newInstance(dx.year(),dx.month(),dx.day());
        String currentDay = dx.format('EEEE');
        if(currentDay=='Saturday' || currentDay=='Sunday' || holidaySet.contains(dt))
        {
            return true; 
        }
        return false;
    }
    public static DateTime getBusinessHoursDate(DateTime startDate , Double businessHour)
    {
        if (startDate == null)
        {
            startDate = system.now();
        }
        DateTime endDate = startDate >= Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 08, 30, 00) ? 
            (startDate <= Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 17, 00, 00) ? 
             startDate : Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 17, 00, 00)) : Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 08, 30, 00);     
        Set<Date> holidaySet = new Set<Date>();           
        for(Holiday currHoliday : [Select ActivityDate from Holiday])  
        {  
            holidaySet.add(currHoliday.ActivityDate);  
        } 
        Double addingHours = businessHour*60;
        DateTime endDateTime = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 17, 00, 00);
        //Loop
        while(addingHours != 0 && addingHours > 0)
        {                   
            if((!getHoliday(endDate,holidaySet)) && (endDate <= endDateTime))
            {
                endDate = endDate.addMinutes(Integer.ValueOf(addingHours));          
                if(endDate > endDateTime && endDate.date() == endDateTime.date())
                {	
                    addingHours = (((endDate.getTime())/1000/60) - ((endDateTime.getTime())/1000/60));
                }
                else if(endDate > endDateTime)
                {
                    Integer totalWorkDays = endDateTime.date().daysBetween(endDate.date());
                    addingHours =  (((endDate.getTime()-endDateTime.getTime())/60000));
                    endDate = endDate - totalWorkDays;
                }
                else
                {
                    addingHours =0;
                }          
            }       
            if(addingHours>0) 
            {   
                endDate = endDate.addDays(1);
                endDate = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 08, 30, 00);
                endDateTime =  Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 17, 00, 00);
            }
        }    
        return endDate;      
    } 
}