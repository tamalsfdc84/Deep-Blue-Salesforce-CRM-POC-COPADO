<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>WT_Attendee_Name_Update</fullName>
        <description>created as part of DBSFCRM-138</description>
        <field>WT_Attendee_Name_Formula__c</field>
        <formula>WT_Attendee__r.FirstName+&apos; &apos;+WT_Attendee__r.MiddleName+&apos; &apos;+WT_Attendee__r.LastName</formula>
        <name>Attendee Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT_Attendee_Name_Update</fullName>
        <actions>
            <name>WT_Attendee_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>WT_Attendee_Junction__c.WT_Attendee__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
