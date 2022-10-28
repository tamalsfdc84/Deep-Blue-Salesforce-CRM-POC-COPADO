<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WT_Task_Assigned_Email_Template</fullName>
        <description>Task Assigned Email Template</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Task_Assigned_Email_Deposit_Applications</template>
    </alerts>
    <alerts>
        <fullName>WT_Task_Completed_Email_Alert</fullName>
        <description>Task Completed Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Case_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Task_Completed_Email_Deposit_Applications</template>
    </alerts>
    <fieldUpdates>
        <fullName>WT_UpdateActivityCompletedDate</fullName>
        <description>Update Activity Completed Date When Status is Completed.</description>
        <field>WT_Activity_Completed_Date__c</field>
        <formula>Today()</formula>
        <name>UpdateActivityCompletedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT Task Assigned</fullName>
        <actions>
            <name>WT_Task_Assigned_Email_Template</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.WT_Send_Email__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WT_TaskCompletedDate</fullName>
        <actions>
            <name>WT_UpdateActivityCompletedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c ,   ISPICKVAL(Status , &apos;Completed&apos;) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
