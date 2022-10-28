public class WT_EmployeeDuplicateRecordsSchedule implements schedulable
{   
    public void execute(SchedulableContext SC)
    {
        List<DuplicateRecordSet> employeeDuplicates = [SELECT Id, Name, DuplicateRuleId, CreatedDate, LastReferencedDate, LastViewedDate, RecordCount, 
                                                       (SELECT Id, Name, RecordId
                                                        FROM DuplicateRecordItems) 
                                                       FROM DuplicateRecordSet
                                                       WHERE RecordCount > 1 AND CreatedDate = LAST_QUARTER AND DuplicateRule.DeveloperName = 'WT_Merge_Employee_Duplicate'];
        
        Set<Id> employeeIds = New Set<Id>();
        for(DuplicateRecordSet duplicateRecord : employeeDuplicates)
        {
            for(DuplicateRecordItem duplicateRecordItem : duplicateRecord.DuplicateRecordItems)
            {
                employeeIds.add(duplicateRecordItem.RecordId);
            }
        }
        
        Map<Id, WT_Employee__c> employeesMap = 
            New Map<Id, WT_Employee__c>([SELECT Id, Name, WT_First_Name__c, WT_Last_Name__c, WT_Middle_Initial__c, WT_Bank__c,
                                             WT_Branch__c, WT_Charter__c, WT_Division__c, WT_Email__c, WT_Employee_ID__c, 
                                             WT_Employee_Status__c, WT_Location__c, WT_Entity__c, WT_Company_Code__c, CreatedDate
                                         FROM WT_Employee__c
                                         WHERE Id IN: employeeIds]);
        string header =
            'Duplicate Record Set Name,'+
            'Duplicate Record Item Name,'+
            'Count,'+
            'Employee Name,'+
            'First Name,'+
            'Last Name,'+
            'Middle Initial,'+
            'Bank,'+
            'Branch,'+
            'Charter,'+
            'Division,'+
            'Email,'+
            'Employee ID,'+
            'Employee Status,'+
            'Location,'+
            'Entity,'+
            'Company Code,'+
            'Created Date \n';
        String finalString = header;
        
        for(DuplicateRecordSet duplicateRecord : employeeDuplicates)
        {
            for(DuplicateRecordItem duplicateRecordItem : duplicateRecord.DuplicateRecordItems)
            {
                String recordString = 
                    duplicateRecord.Name +','+ 
                    duplicateRecordItem.Name +','+ 
                    duplicateRecord.RecordCount +','+
                    employeesMap.get(duplicateRecordItem.RecordId).Name +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_First_Name__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Last_Name__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Middle_Initial__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Bank__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Branch__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Charter__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Division__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Email__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Employee_ID__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Employee_Status__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Location__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Entity__c +','+
                    employeesMap.get(duplicateRecordItem.RecordId).WT_Company_Code__c +','+
                    String.valueOf(employeesMap.get(duplicateRecordItem.RecordId).CreatedDate.date()) +'\n';
                finalString = finalString + recordString;
                finalString = finalString.replaceAll('null', ''); 
            }
        }
        
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        
        blob excel = blob.valueOf(finalString);
        attachment.setBody(excel);
        attachment.setFileName('Employee Duplicate Records.csv');
        
        String subject = 'Employee Duplicate Records';
        String body = 'Employee Duplicate Records';
        
        List<String> toAddress = new List<String>();
        for(WT_EmployeeDuplicateJobRecipients__mdt recipient : [SELECT Id, Email__c 
                                                                 FROM WT_EmployeeDuplicateJobRecipients__mdt
                                                                 WHERE Email__c != ''])
        {
            toAddress.add(recipient.Email__c);
        }
            
        Messaging.singleEmailMessage emailWithAttachment = new Messaging.singleEmailMessage();
        
        emailWithAttachment.setSubject(subject);
        emailWithAttachment.setToaddresses(toAddress);
        emailWithAttachment.setPlainTextBody(body);
        emailWithAttachment.setFileAttachments(new Messaging.EmailFileAttachment[]{attachment});
        
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {emailWithAttachment});
        
        Date quarterMonth = [SELECT StartDate FROM Period WHERE type = 'Quarter' and StartDate = NEXT_QUARTER].StartDate;
        
        String day = string.valueOf(quarterMonth.day());
        String month = string.valueOf(quarterMonth.month());
        String year = string.valueOf(quarterMonth.year());
        String hour = string.valueOf(system.now().hour());
        String minute = string.valueOf(system.now().minute());
        String second = string.valueOf(system.now().second());
        
        String jobName = 'Job-' + second + '_' + minute + '_' + hour + '_' + day + '_' + month + '_' + year;
        WT_EmployeeDuplicateRecordsSchedule employeeScheduleJob = new WT_EmployeeDuplicateRecordsSchedule();
        String scheduleTime = '0 0 1 1 JAN,APR,JUL,OCT ?';
        String jobID = System.schedule(jobName, scheduleTime, employeeScheduleJob); 
    }
}