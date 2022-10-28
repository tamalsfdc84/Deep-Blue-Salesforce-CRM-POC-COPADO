<?xml version="1.0" encoding="UTF-8"?>
<CustomMetadata xmlns="http://soap.sforce.com/2006/04/metadata" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
    <label>POBoxBlocklist</label>
    <protected>false</protected>
    <values>
        <field>tffa__Description__c</field>
        <value xsi:type="xsd:string">A list of po box terms to blocklist</value>
    </values>
    <values>
        <field>tffa__Disabled__c</field>
        <value xsi:type="xsd:boolean">false</value>
    </values>
    <values>
        <field>tffa__ErrorCode__c</field>
        <value xsi:type="xsd:string">poboxaddress</value>
    </values>
    <values>
        <field>tffa__ErrorMessage__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>tffa__Items1__c</field>
        <value xsi:type="xsd:string">[&quot;/^ *(#\\d+)/&quot;,&quot;/^ *((box|bin)[-. \\/\\\\]?\\d+)/&quot;,&quot;/^ *(.*p[ \\.]? ?(o|0)[-. \\/\\\\]? *-?((box|bin)|b|(#|num)?\\d+))/&quot;,&quot;/^ *(p(ost)? *(o(ff(ice)?)?)? *((box|bin)|b)? *\\d+)/&quot;,&quot;/^ *(p *-?\\/?(o)? *-?box)/&quot;,&quot;/^ *post office box/&quot;]</value>
    </values>
    <values>
        <field>tffa__Items2__c</field>
        <value xsi:type="xsd:string">[&quot;/^ *((box|bin)|b) *(number|num|#)? *\\d+/&quot;,&quot;/^ *(num|number|#) *\\d+/&quot;]</value>
    </values>
    <values>
        <field>tffa__Items3__c</field>
        <value xsi:nil="true"/>
    </values>
    <values>
        <field>tffa__Items4__c</field>
        <value xsi:nil="true"/>
    </values>
</CustomMetadata>
