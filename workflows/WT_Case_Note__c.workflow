<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>WT_Deposit_Application_Fulfilled_Notification</fullName>
        <description>Deposit Application Fulfilled Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Fulfilled_Request_Email_Deposit_Application</template>
    </alerts>
    <alerts>
        <fullName>WT_Send_Email_related_to_Note</fullName>
        <description>Send Email related to Note</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Case_Notes_Email_Deposit_Application</template>
    </alerts>
</Workflow>
