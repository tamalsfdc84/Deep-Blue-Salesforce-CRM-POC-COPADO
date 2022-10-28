import { LightningElement, track, api } from 'lwc';

export default class WT_FinancialAccountRelatedList extends LightningElement 
{
    @track financialAccountColumns = [
        { label: 'Financial Account Name', fieldName: 'LinkName', type: 'url', sortable: true, 
            typeAttributes: {label: { fieldName: 'Name' }, target: '_top', tooltip: { fieldName : 'Name'} } },
        { label: 'Relationship Type', fieldName: 'WT_Customer_Relationship_Type__c', type:"text", sortable: true },
        { label: 'Account Number', fieldName: 'FinServ__FinancialAccountNumber__c', type:"text", sortable: true },
        { label: 'Type', fieldName: 'FinServ__FinancialAccountType__c', type:"text", sortable: true },
        { label: 'Bank', fieldName: 'WT_Bank__c', type: "text", sortable: true },
        { label: 'Owner Name', fieldName: 'LinkOwnerName', type: 'url', sortable: true, 
            typeAttributes: {label: { fieldName: 'WT_Owner_Name__c' }, target: '_top', tooltip: { fieldName : 'WT_Owner_Name__c'} } },
        { label: 'Date Opened', fieldName: 'FinServ__OpenDate__c', type:"text", sortable: true },
        { label: 'Balance $', fieldName: 'FinServ__CurrentPostedBalance__c', type: "currency", sortable: true, 
            cellAttributes: {alignment: 'left'} },
        { label: 'Record Type', fieldName: 'FinServ__RecordTypeName__c', type:"text", sortable: true }
    ]
     
    @api recordId;
    customActions = [{ label: 'Edit', name: 'edit' },{ label: 'Delete', name: 'delete' }]
}