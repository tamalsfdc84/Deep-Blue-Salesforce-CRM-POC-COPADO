<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Assignment_Email_Notificationn</fullName>
        <description>Case Assignment Email Notificationn</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Compliance_Case_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>WT_CCPA_Request_Cancelled_Notification</fullName>
        <description>CCPA Request Cancelled Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Ticket_Cancelled_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>WT_CCPA_Request_Resolved_Notification</fullName>
        <description>CCPA Request Resolved Notification</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Request_Completed_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>WT_CCPA_Request_Submitted_Notification</fullName>
        <description>CCPA Request Submitted Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Ticket_Submitted_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>WT_Case_Cancelled_Email_Deposit_Application</fullName>
        <description>Case Cancelled Email Deposit Application</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Consumer_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>WT_Requester_s_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Cancelled_Email_Deposit_Applications</template>
    </alerts>
    <alerts>
        <fullName>WT_Case_Deposit_Application_SLA_Tracking</fullName>
        <description>Deposit Application - SLA Tracking</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Post_Due_SLA_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>WT_Compliance_Case_Assignment_Email</fullName>
        <description>Compliance Case Assignment Email</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Compliance_Case_Assignment_Notification</template>
    </alerts>
    <alerts>
        <fullName>WT_Deposit_Application_Active_Notification</fullName>
        <description>Deposit Application Active Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Consumer_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>WT_Requester_s_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Active_Request_Email_Deposit_Application</template>
    </alerts>
    <alerts>
        <fullName>WT_Deposit_Application_Active_Notification_Queue</fullName>
        <description>Deposit Application Active Notification - (Queue)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Assigned_Email_Deposit_Applicaiton_Team</template>
    </alerts>
    <alerts>
        <fullName>WT_Deposit_Application_Active_Notification_User</fullName>
        <description>Deposit Application Active Notification - (User)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Assigned_Email_Deposit_Applicaiton</template>
    </alerts>
    <alerts>
        <fullName>WT_Deposit_Application_Fulfilled_Notification</fullName>
        <description>Deposit Application Fulfilled Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Requester_s_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Fulfilled_Request_Email_Deposit_Application</template>
    </alerts>
    <alerts>
        <fullName>WT_Deposit_Application_Submitted_Notification</fullName>
        <description>Deposit Application Submitted Notification</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Consumer_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>WT_Requester_s_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_New_Request_Email_Deposit_Applications</template>
    </alerts>
    <alerts>
        <fullName>WT_Reminder_No_Case_Status_Change_35_Days</fullName>
        <description>Reminder No Case Status Change 35 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Reminder_Email_Notification_Template_After_35_Working_Days</template>
    </alerts>
    <alerts>
        <fullName>WT_Reminder_No_Case_Status_Change_45_Days</fullName>
        <description>Reminder No Case Status Change 45 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Reminder_Email_Notification_Template_After_45_Working_Days</template>
    </alerts>
    <alerts>
        <fullName>WT_Waiting_for_Customer_Email_Deposit_Applications</fullName>
        <description>Waiting for Customer Email Deposit Applications</description>
        <protected>false</protected>
        <recipients>
            <field>WT_Consumer_Email_Address__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>WT_Requester_s_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>WT_Retail_Banking/WT_Waiting_for_Customer_Email_Deposit_Applications</template>
    </alerts>
    <fieldUpdates>
        <fullName>WT_Update_Created_On_Field</fullName>
        <field>WT_Created_On__c</field>
        <formula>DATEVALUE(CreatedDate)</formula>
        <name>Update Created On Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_Update_Status_Date</fullName>
        <field>WT_Status_Date__c</field>
        <formula>TODAY()</formula>
        <name>WT Update Status Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>WT Compliance Case Created on</fullName>
        <actions>
            <name>WT_Update_Created_On_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c ,RecordType.Name==&apos;Compliance Complaint&apos;, ISNULL(WT_Created_On__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>WT Compliance Case Status Modified Date</fullName>
        <actions>
            <name>WT_Update_Status_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c ,RecordType.Name==&apos;Compliance Complaint&apos;,ISCHANGED(Status))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>WT_Compliance_Case_Notification</fullName>
        <actions>
            <name>Case_Assignment_Email_Notificationn</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>AND($Setup.WT_Switch_Settings__c.WT_Is_Workflow_Rule_Active__c,(RecordType.Name=&apos;Compliance Complaint&apos;),ISCHANGED(OwnerId), ($User.Id!= OwnerId),NOT(ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
