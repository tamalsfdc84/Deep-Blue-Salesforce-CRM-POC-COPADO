<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Credit Analyst User</label>
    <protected>false</protected>
    <values>
        <field>WT_Component_Unique_Name__c</field>
        <value xsi:type="xsd:string">Credit_Analyst_User</value>
    </values>
    <values>
        <field>WT_Object_1_API_Name__c</field>
        <value xsi:type="xsd:string">User</value>
    </values>
    <values>
        <field>WT_Object_1_Icon_Name__c</field>
        <value xsi:type="xsd:string">standard:user</value>
    </values>
    <values>
        <field>WT_Object_1_Query__c</field>
        <value xsi:type="xsd:string">User(Id, Name, WT_Operations_Role__c WHERE id NOT IN :selectedIds AND WT_Operations_Role__c = &apos;Credit Analyst&apos; AND IsActive = true)</value>
    </values>
    <values>
        <field>WT_Object_1_Subtitle__c</field>
        <value xsi:type="xsd:string">User • {{WT_Operations_Role__c}}</value>
    </values>
    <values>
        <field>WT_Object_1_Title__c</field>
        <value xsi:type="xsd:string">{{Name}}</value>
    </values>
    <values>
        <field>WT_Object_2_API_Name__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_2_Icon_Name__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_2_Query__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_2_Subtitle__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_2_Title__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_3_API_Name__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_3_Icon_Name__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_3_Query__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_3_Subtitle__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>WT_Object_3_Title__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
