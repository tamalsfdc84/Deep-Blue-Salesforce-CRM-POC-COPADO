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
        <fullName>MyHr_Case_Redirect_to_Access_Management_Alert</fullName>
        <ccEmails>accessmanagement@wintrust.com</ccEmails>
        <description>MyHr Case Redirect to Access Management Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Access_Management</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_Accounts_Payable_Alert</fullName>
        <ccEmails>accountspayable@wintrust.com</ccEmails>
        <description>MyHr Case Redirect to Accounts Payable Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Accounts_Payable</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_Equifax_Alert</fullName>
        <ccEmails>karan.jugtawat@tcs.com</ccEmails>
        <description>MyHr Case Redirect to Equifax Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Equifax</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_IT_Support_Alert</fullName>
        <ccEmails>ITProductionSupportm@wintrust.com</ccEmails>
        <description>MyHr Case Redirect to IT Support Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_IT_Support</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_Learning_and_Development_Alert</fullName>
        <ccEmails>wintrustuniversity@wintrust.com</ccEmails>
        <description>MyHr Case Redirect to Learning and Development Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Learning_and_Development</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_Payroll_Alert</fullName>
        <ccEmails>payroll@wintrust.com</ccEmails>
        <description>MyHr Case Redirect to Payroll Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Payroll</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_Recruiting_Alert</fullName>
        <ccEmails>Recruiting@wintrust.com</ccEmails>
        <description>MyHr Case Redirect to Recruiting Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Recruiting</template>
    </alerts>
    <alerts>
        <fullName>MyHr_Case_Redirect_to_Security_Alert</fullName>
        <ccEmails>WINTRUSTSECURITY@AUS.COM</ccEmails>
        <description>MyHr Case Redirect to Security Alert</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>MyHr/WT_Security</template>
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
    <fieldUpdates>
        <fullName>WT_update_case_title</fullName>
        <description>Created as part of DBSFCRM-375</description>
        <field>WT_Case_Title__c</field>
        <formula>WT_Employee__r.WT_First_Name__c +&apos;-&apos;+ WT_Employee__r.WT_Last_Name__c +&apos;-&apos;+  WT_EmployeeIDs__c +&apos;-&apos;+  TEXT(WT_Topic__c) +&apos;-&apos;+ TEXT(WT_Action__c)</formula>
        <name>update case title</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>update_Closed_on</fullName>
        <field>WT_Closed_On__c</field>
        <formula>NOW()</formula>
        <name>update Closed on</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Case Title Change- HR Case</fullName>
        <actions>
            <name>WT_update_case_title</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>MyHR</value>
        </criteriaItems>
        <description>Created as part of story 375</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Populate Case Closed Date</fullName>
        <actions>
            <name>update_Closed_on</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved,Cancelled</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
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
