<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
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
