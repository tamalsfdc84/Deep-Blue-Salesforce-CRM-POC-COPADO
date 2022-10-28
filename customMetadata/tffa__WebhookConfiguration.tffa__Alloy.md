<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>Alloy</label>
    <protected>false</protected>
    <values>
        <field>tffa__Description__c</field>
        <value xsi:type="xsd:string">Webhook for Alloy events</value>
    </values>
    <values>
        <field>tffa__Enabled__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>tffa__Path__c</field>
        <value xsi:type="xsd:string">/alloy</value>
    </values>
    <values>
        <field>tffa__WebhookHandlerClass__c</field>
        <value xsi:type="xsd:string">CZWTFCAlloyWebhookHandler</value>
    </values>
</CustomMetadata>
