<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>CONVERGE_CCDELETE</label>
    <protected>false</protected>
    <values>
        <field>EndPoint__c</field>
        <value xsi:type="xsd:string">callout:Converge/VirtualMerchant/processxml.do</value>
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
        <field>Method__c</field>
        <value xsi:type="xsd:string">POST</value>
    </values>
    <values>
        <field>RequestTimeout__c</field>
        <value xsi:type="xsd:string">120000</value>
    </values>
    <values>
        <field>TransactionType__c</field>
        <value xsi:type="xsd:string">ccdelete</value>
    </values>
</CustomMetadata>
