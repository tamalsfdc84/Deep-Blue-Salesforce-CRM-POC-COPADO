import initDataMethod from "@salesforce/apex/WT_RelatedListController.initData";
import State from "@salesforce/schema/User.State";

export default class RelatedListHelper 
{

    fetchData(state) 
    {
        let jsonData = Object.assign({}, state)
        jsonData.numberOfRecords = state.numberOfRecords + 1
        jsonData = JSON.stringify(jsonData)
        return initDataMethod({ jsonData })
            .then(response => {
                const data = JSON.parse(response)
                return this.processData(data, state)
            })
            .catch(error => {
                console.log(error);
            });
    }

    processData(data, state)
    {
        const records = data.records;
        this.lookupData(records)
        this.generateLinks(records)
        if (records.length > state.numberOfRecords) 
        {
            records.pop()
            data.title = `${data.sobjectLabelPlural} (${state.numberOfRecords}+)`
        } 
        else 
        {
            data.title = `${data.sobjectLabelPlural} (${Math.min(state.numberOfRecords, records.length)})`
        }     
        return data
    }


    initColumnsWithActions(columns, customActions) 
    {
        return [...columns, { type: 'action', typeAttributes: { rowActions: customActions } }]
    }

    lookupData(records) 
    {
        records.forEach(record => {
            record.Name =  record.FinServ__FinancialAccount__r.Name
            if(record.WT_Customer_Relationship_Type__c != undefined)
            {
                record.WT_Customer_Relationship_Type__c = record.FinServ__Role__c + ' (' + record.WT_Customer_Relationship_Type__c + ')'
            }
            else 
            {
                record.WT_Customer_Relationship_Type__c = record.FinServ__Role__c 
            }
            record.FinServ__FinancialAccountNumber__c =  record.FinServ__FinancialAccount__r.FinServ__FinancialAccountNumber__c
            record.FinServ__Type__c = record.FinServ__FinancialAccount__r.FinServ__Type__c
            record.FinServ__FinancialAccountType__c =  record.FinServ__FinancialAccount__r.FinServ__FinancialAccountType__c
            record.WT_Bank__c = record.FinServ__FinancialAccount__r.WT_Bank__c
            record.WT_Owner_Name__c = record.FinServ__FinancialAccount__r.WT_Owner_Name__c
            record.FinServ__OpenDate__c =  record.FinServ__FinancialAccount__r.FinServ__OpenDate__c
            record.FinServ__CurrentPostedBalance__c = record.FinServ__FinancialAccount__r.FinServ__CurrentPostedBalance__c
            record.FinServ__RecordTypeName__c =  record.FinServ__FinancialAccount__r.FinServ__RecordTypeName__c
        });
    }

    generateLinks(records) 
    {
        records.forEach(record => {
            record.LinkName = '/' + record.FinServ__FinancialAccount__r.Id
            record.LinkOwnerName = '/' + record.FinServ__FinancialAccount__r.OwnerId
        });
    }
}