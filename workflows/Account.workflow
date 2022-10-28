<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOrganizationType</fullName>
        <field>WT_Organization_Type__c</field>
        <literalValue>Customer</literalValue>
        <name>UpdateOrganizationType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_Set_address_std</fullName>
        <field>WT_Address_Flag__c</field>
        <literalValue>Address Not Standardized</literalValue>
        <name>WT_Set_address_std</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT_Address_standardisation</fullName>
        <actions>
            <name>WT_Set_address_std</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>set the address standardization  when users modify to Non Standardized.</description>
        <formula>$Profile.Name != &apos;System Administrator&apos; &amp;&amp; ISCHANGED( BillingAddress )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WT_Organization_Type_On_Account</fullName>
        <actions>
            <name>UpdateOrganizationType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF( RecordType.Name = &apos;Business Account (Customer)&apos;, TRUE , FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
