<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>FSCNewReferralNotification</fullName>
        <description>Email alert for a new referral</description>
        <protected>false</protected>
        <recipients>
            <field>FinServ__ReferredByContact__c</field>
            <type>contactLookup</type>
        </recipients>
        <recipients>
            <field>FinServ__ReferredByUser__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>FSCEmailTemplates/FSCNewReferralNotification</template>
    </alerts>
    <alerts>
        <fullName>WT_Send_Email_Referred_To_when_Referral_Overdue</fullName>
        <description>Send an Email to Referred To, when a Referral is Overdue.</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Referred_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/Overdue_Referral_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>WT_Send_Email_Referred_To_when_Referral_created</fullName>
        <description>Send an Email to Referred To, when a Referral is created.</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Referred_To__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/New_Referral_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>WT_Send_Email_Reffered_By_Status_Change</fullName>
        <description>Send an Email to Referred By, based on Referral Status change.</description>
        <protected>false</protected>
        <recipients>
            <field>FinServ__ReferredByUser__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/Referral_Status_Change_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Referral_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>Referral_Approvers</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Approved Referral Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Rejection_Action</fullName>
        <field>Status</field>
        <literalValue>Closed - Not Converted</literalValue>
        <name>Rejection Action</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_UpdateReferralStatus</fullName>
        <description>Referrals that are in a New - Not Contacted status after 14 days, should automatically change to a status of New - Overdue</description>
        <field>Status</field>
        <literalValue>New - Overdue</literalValue>
        <name>WT_UpdateReferralStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT_Referral_Workflow_Automation</fullName>
        <active>true</active>
        <description>Workflow Automation on Referral Object like Field Update.</description>
        <formula>AND(  OR(RecordType.Name = &apos;Standard&apos; , RecordType.Name = &apos;Wealth&apos; ) , ISPICKVAL(Status, &apos;New - Not Contacted&apos;) )</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>WT_UpdateReferralStatus</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Lead.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
