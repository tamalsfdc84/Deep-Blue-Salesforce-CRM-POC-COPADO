<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>GCPTokenRefresh</label>
    <protected>false</protected>
    <values>
        <field>tffa__ApexClass__c</field>
        <value xsi:type="xsd:string">GCPTokenRefreshBatchJob</value>
    </values>
    <values>
        <field>tffa__BatchSize__c</field>
        <value xsi:type="xsd:double">50.0</value>
    </values>
    <values>
        <field>tffa__CronExpression__c</field>
        <value xsi:type="xsd:string">0 0 * * * ?</value>
    </values>
    <values>
        <field>tffa__Description__c</field>
        <value xsi:type="xsd:string">Refreshes google cloud platform access token based on the configured retention period.</value>
    </values>
    <values>
        <field>tffa__Enabled__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>tffa__ScheduleIntervalInMinutes__c</field>
        <value xsi:type="xsd:double">30.0</value>
    </values>
    <values>
        <field>tffa__System__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>tffa__Type__c</field>
        <value xsi:type="xsd:string">SCHEDULED</value>
    </values>
</CustomMetadata>
