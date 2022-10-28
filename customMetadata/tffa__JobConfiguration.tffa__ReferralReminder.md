<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>ReferralReminder</label>
    <protected>false</protected>
    <values>
        <field>tffa__ApexClass__c</field>
        <value xsi:type="xsd:string">ReferralReminderBatchJob</value>
    </values>
    <values>
        <field>tffa__BatchSize__c</field>
        <value xsi:type="xsd:double">200.0</value>
    </values>
    <values>
        <field>tffa__CronExpression__c</field>
        <value xsi:type="xsd:string">0 0 0 1/1 * ? *</value>
    </values>
    <values>
        <field>tffa__Description__c</field>
        <value xsi:type="xsd:string">Batch job to send reminder emails for to referees (or referred parties) of referrals (in `open` status under an `active` referral program) who have not acted upon the referral.</value>
    </values>
    <values>
        <field>tffa__Enabled__c</field>
        <value xsi:type="xsd:boolean">true</value>
    </values>
    <values>
        <field>tffa__ScheduleIntervalInMinutes__c</field>
        <value xsi:nil="true"/>
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
