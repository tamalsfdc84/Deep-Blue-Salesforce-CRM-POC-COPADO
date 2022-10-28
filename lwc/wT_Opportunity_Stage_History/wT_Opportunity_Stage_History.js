import { LightningElement ,api, wire, track} from 'lwc';
import getHistroyList from '@salesforce/apex/WT_OpportunityStageHistoryController.getOpportunityHistoryLoadList';
export default class LightningDatatableLWCExample extends LightningElement {
    @api recordId;
    @track columns = [{
            label: 'Stage Name',
            fieldName: 'StageName',
            type: 'text'
        },
       /* {
            label: 'Amount',
            fieldName: 'Amount',
            type: 'Currency'
        },*/
        {
            label: 'Estimated Close Date',
            fieldName: 'CloseDate',
            type: 'Date'  
        },
        {
            label: 'Probability',
            fieldName: 'Probability',
            type: 'text'
        },
        {
            label: 'LastModifiedBy',
            fieldName: 'LastModifiedBy',
            type: 'text'
        },
        {
            label: 'LastModifiedDate',
            fieldName: 'LastModifiedDate',
            type: 'date', typeAttributes: {  
                day: 'numeric',  
                month: 'short',  
                year: 'numeric',  
                hour: '2-digit',  
                minute: '2-digit',  
                second: '2-digit',  
                hour12: true}
        }
    ];
    @track error;
    @track historyList ;
    @wire(getHistroyList, {oppId: '$recordId'})    
    WireHistoryRecords({error, data}){
       
        if(data){
            this.historyList = data;
            this.error = undefined;
        }else{
            this.error = error;
            this.historyList = undefined;
        }       
    }    
}