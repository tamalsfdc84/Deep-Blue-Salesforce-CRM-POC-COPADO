<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WT_Annual_Review_Email_Reminder</fullName>
        <description>Annual Review Email Reminder</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>DefaultWorkflowUser</senderType>
        <template>WT_Retail_Banking/WT_Annual_Review_Activity_Email_Reminder</template>
    </alerts>
    <fieldUpdates>
        <fullName>WT_UpdateEventCompletedDate</fullName>
        <field>WT_Activity_Completed_Date__c</field>
        <formula>Today()</formula>
        <name>UpdateEventCompletedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT_Email Reminder for the Annual Review Activity</fullName>
        <active>true</active>
        <formula>AND($Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c, NOT(ISNULL(WT_Next_Follow_Up_Date__c)),(DATEVALUE(WT_Next_Follow_Up_Date__c)&gt;Today()),(RecordType.Name=&quot;Annual Review&quot;))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WT_Annual_Review_Email_Reminder</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Event.WT_Next_Follow_Up_Date__c</offsetFromField>
            <timeLength>-24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>WT_EventCompletedDate</fullName>
        <actions>
            <name>WT_UpdateEventCompletedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c , ISPICKVAL( WT_Status__c , &apos;Completed&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
