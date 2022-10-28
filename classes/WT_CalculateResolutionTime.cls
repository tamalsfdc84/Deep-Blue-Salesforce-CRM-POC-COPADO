/**
* --------------------------------------------------------------------------------------------------------------
* @Name				WT_CalculateResolutionTime
* @Author			Swathi Ramesh	<sramesh1@wintrust.com>
* @ModifiedBy		Swaminathan E	<SEzhumal@wintrust.com>
* @Version			v1.0
* @CreatedDate		06-15-2021
* @UsedBy			Case Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is used for Calculate Resolution Time between Condact DateTime and ClosedOn DateTime.
* 
* --------------------------------------------------------------------------------------------------------------
* @Changes
* v2.0
* 06-18-2021
* --------------------------------------------------------------------------------------------------------------
**/
public class WT_CalculateResolutionTime
{
    @InvocableMethod
    public static void CalculateBuisnessHours(List<Id> recordId)
    {
        List<Case> listCaseRecord = [SELECT Id, WT_Contact_Date__c, WT_Closed_On__c, WT_Resolution_Time__c FROM Case WHERE Id = :recordId];
        for(Case caseRecord : listCaseRecord)
        {
            caseRecord.WT_Resolution_Time__c = getResolutionTime(caseRecord.WT_Contact_Date__c,caseRecord.WT_Closed_On__c);            
        }
        update listCaseRecord;       
    }
    public static Double getResolutionTime(DateTime startDate , DateTime endDate)
    {
        //calculating no. of holidays
        Set<Date> holidaySet = new Set<Date>();           
        for(Holiday currHoliday : [Select ActivityDate from Holiday])  
        {  
            holidaySet.add(currHoliday.ActivityDate);  
        }          
        //calculating inbetween days and including specified start and end day
        Integer totalDays = startDate.date().daysBetween(endDate.date());        
        Integer days = 0;
        Integer daysToRemove = 0;        
        //calculating no. of buisness days
        while(days <= totalDays)
        {
            DateTime dx = startDate + days;
            Date dt = Date.newInstance(dx.year(),dx.month(),dx.day());
            String currentDay = dx.format('EEEE');
            if(currentDay=='Saturday' || currentDay=='Sunday' || holidaySet.contains(dt))
            {
                daysToRemove++;  
            }
            days++;
        }        
        Integer totalWorkDays = (totalDays>daysToRemove) ? (totalDays-daysToRemove) : (daysToRemove-totalDays); 
            totalWorkDays = (totalWorkDays==0) ? (1-totalWorkDays) : (totalWorkDays-1);
        // calculating Buisness hours       
        DateTime startDateFirst = startDate>=Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 08, 30, 00)? (startDate<= Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 17, 00, 00)? startDate :Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 17, 00, 00)) :Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 08, 30, 00);
        DateTime startDateFinal = Datetime.newInstance(startDate.year(), startDate.month(), startDate.day(), 17, 00, 00);
        DateTime endDateFirst = Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 08, 30, 00);
        DateTime endDateFinal = endDate>=Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 08, 30, 00)? (endDate<= Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 17, 00, 00)? endDate :Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 17, 00, 00)) :Datetime.newInstance(endDate.year(), endDate.month(), endDate.day(), 08, 30, 00);
        Double resolutionTime = 0.00;   
        if(startDateFirst.date() == endDateFinal.date())
        {          
            Decimal timeinHours =  (((endDateFinal.getTime())/1000/60) - ((startDateFirst.getTime())/1000/60));
            Decimal timeimMinutes =  Math.mod((((endDateFinal.getTime())/1000/60) - ((startDateFirst.getTime())/1000/60)),60);
            resolutionTime = Math.floor(timeinHours.divide(60 , 2)) + timeimMinutes.divide(100,2) ;
        }      
        else 
        {  
            Decimal timeinHours =  (510*(totalWorkDays)) +(((endDateFinal.getTime())/1000/60) - ((endDateFirst.getTime())/1000/60)) +(((startDateFinal.getTime())/1000/60) - ((startDateFirst.getTime())/1000/60));
            Decimal timeimMinutes =  Math.mod(timeinHours.intValue(),60);
            resolutionTime = Math.floor(timeinHours.divide(60 , 2)) + timeimMinutes.divide(100,2);
        }
        return resolutionTime;      
    }
}