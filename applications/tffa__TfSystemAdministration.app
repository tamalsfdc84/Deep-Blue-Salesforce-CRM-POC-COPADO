<?xml version="1.0" encoding="UTF-8"?>
<CustomApplication xmlns="http://soap.sforce.com/2006/04/metadata">
    <actionOverrides>
        <actionName>Tab</actionName>
        <content>tffa__SystemAdministrationHome</content>
        <formFactor>Large</formFactor>
        <skipRecordTypeSelect>false</skipRecordTypeSelect>
        <type>Flexipage</type>
        <pageOrSobjectType>standard-home</pageOrSobjectType>
    </actionOverrides>
    <brand>
        <headerColor>#0070D2</headerColor>
        <shouldOverrideOrgTheme>false</shouldOverrideOrgTheme>
    </brand>
    <description>Administer and monitor the Terafina Application.</description>
    <formFactors>Large</formFactors>
    <isNavAutoTempTabsDisabled>false</isNavAutoTempTabsDisabled>
    <isNavPersonalizationDisabled>false</isNavPersonalizationDisabled>
    <isNavTabPersistenceDisabled>false</isNavTabPersistenceDisabled>
    <label>Terafina System Administration</label>
    <navType>Standard</navType>
    <tabs>standard-home</tabs>
    <tabs>tffa__DebugLog__c</tabs>
    <tabs>tffa__PerformanceLog__c</tabs>
    <tabs>tffa__WebFraudEventStore__c</tabs>
    <tabs>tffa__Batch_Job_Logs</tabs>
    <tabs>tffa__EnvironmentConfigurationTab</tabs>
    <uiType>Lightning</uiType>
    <utilityBar>tffa__TfSystemAdministration_UtilityBar</utilityBar>
</CustomApplication>
