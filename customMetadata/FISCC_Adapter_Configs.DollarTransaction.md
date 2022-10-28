<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>DollarTransaction</label>
    <protected>false</protected>
    <values>
        <field>AccountNumber__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>ApplicationId__c</field>
        <value xsi:type="xsd:string">DP</value>
    </values>
    <values>
        <field>ContentType__c</field>
        <value xsi:type="xsd:string">application/json</value>
    </values>
    <values>
        <field>HTTPMethod__c</field>
        <value xsi:type="xsd:string">POST</value>
    </values>
    <values>
        <field>IsEncrypted__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>IsIBSAuthRequired__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>LogRequest__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>LogResponse__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>ResponseBuilderClass__c</field>
        <value xsi:type="xsd:string">FISCCDollarTransResponseBuilder</value>
    </values>
    <values>
        <field>ServiceURL__c</field>
        <value xsi:type="xsd:string">/rest/IBSDP/v2/online-dollar-transactions</value>
    </values>
    <values>
        <field>Timeout__c</field>
        <value xsi:type="xsd:double">120000.0</value>
    </values>
</CustomMetadata>
