/**
* --------------------------------------------------------------------------------------------------------------
* @Name             WT_CalculateSLAController
* @Author           Anoop   <abattini@wintrust.com>
* @ModifiedBy       Anoop   <abattini@wintrust.com>
* @Version          v1.0
* @CreatedDate      07-04-2021
* @UsedBy           Wintrust Holidays Object
* --------------------------------------------------------------------------------------------------------------
* @Description
* This is controller class to calculate Business Days excluding Holidays and Weekends
* --------------------------------------------------------------------------------------------------------------
* @Changes
* vX.X
* MM-DD-YYYY
* --------------------------------------------------------------------------------------------------------------
**/
// Code Coverage: WT_CalculateSLAController_T
public class WT_CalculateSLAController 
{
    public static Date calculateWorkingDays(Date startDate, Integer daysToAdd)  
    {      
        //startDate = startDate+1;
        Date endDate = startDate;
        Set<Date> holidaysSet = new Set<Date>();           
        for(Holiday currHoliday : [Select ActivityDate from Holiday])  
        {  
            holidaysSet.add(currHoliday.ActivityDate);  
        }           
        Integer workingDays = 0;  
        Integer i=0; 
        while(workingDays <= daysToAdd) 
        {  
            Date dt = startDate + workingDays;  
            DateTime currDate = DateTime.newInstance(dt.year(), dt.month(), dt.day());  
            String todayDay = currDate.format('EEEE');  
            if(todayDay == 'Saturday' || todayDay == 'Sunday' || holidaysSet.contains(dt))  
            {  
                daysToAdd++; 
            }                
            workingDays++;
        }  
        endDate = endDate + daysToAdd;
        return endDate;  
    }     
}