<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Knowledge_Approval_Approved</fullName>
        <description>Knowledge Approval Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EmailAlertArticleApproval</template>
    </alerts>
    <alerts>
        <fullName>Knowledge_Approval_Rejected</fullName>
        <description>Knowledge Approval Rejected</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/EmailAlertForArticleRejection</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approval_Status_Submitted</fullName>
        <field>WT_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>Approval Status Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approval_Submitted_DateTime</fullName>
        <field>WT_Approval_Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Approval Submitted DateTime</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Approved_Date_Time</fullName>
        <field>WT_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>Set Approved Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Rejected_Count</fullName>
        <field>WT_Compliance_Rejected_Count__c</field>
        <formula>WT_Compliance_Rejected_Count__c + 1</formula>
        <name>Set Rejected Count</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <field>WT_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approved_Date_Time</fullName>
        <field>WT_Approved_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Approved Date Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_Approval_Status_Approved</fullName>
        <field>WT_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_Approval_Status_Recalled</fullName>
        <field>WT_Approval_Status__c</field>
        <literalValue>Recalled</literalValue>
        <name>Approval Status Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>WT_Approval_Status_Rejected</fullName>
        <field>WT_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>false</reevaluateOnChange>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Knowledge</fullName>
        <action>PublishAsNew</action>
        <description>This Knowledge Article publish automatically once it is approved.</description>
        <label>PublishArticle</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <knowledgePublishes>
        <fullName>WT_Publish_Approval</fullName>
        <action>Publish</action>
        <label>Publish Approval</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
</Workflow>
