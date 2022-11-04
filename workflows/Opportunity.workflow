<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WT_Update_Opportunity_Name</fullName>
        <field>Name</field>
        <formula>Account.Name +&apos; &apos;+ WT_Product__r.Name</formula>
        <name>Update Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_Update_Person_Opportunity</fullName>
        <field>Name</field>
        <formula>Account.FirstName + &apos; &apos; + Account.MiddleName + &apos; &apos; +  Account.LastName + &apos; &apos; + WT_Product__r.Name</formula>
        <name>Update Opportunity Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT_Update_Opportunity</fullName>
        <actions>
            <name>WT_Update_Opportunity_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>created as part of DBSFCRM-1287</description>
        <formula>AND( $Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c , ISBLANK( Account.LastName) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WT_Update_Opportunity_Person</fullName>
        <actions>
            <name>WT_Update_Person_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>created part of DBSFCRM-2735</description>
        <formula>AND( $Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c ,NOT(  ISBLANK( Account.LastName) ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
