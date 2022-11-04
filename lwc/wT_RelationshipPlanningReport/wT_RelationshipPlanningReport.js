import { LightningElement,api,wire,track } from 'lwc';
import getAccountTasks from '@salesforce/apex/WT_AccountTasksAndEventsController.getAccountTasks';
import getAccountEvents from '@salesforce/apex/WT_AccountTasksAndEventsController.getAccountEvents';
//import { getRecord } from 'lightning/uiRecordApi';
const columns = [
    { label: 'Subject', fieldName: 'Subject', type: 'String'}, 
    { label: 'Due Date', fieldName: 'ActivityDate', type:'Date'}, 
    { label: 'Assigned To', fieldName: 'assignedTo', type:'String'}  
];
export default class WT_AccountGeneralInformation extends LightningElement {
    @api recordId;
    @track WrapTask= [];
    @track WrapEvent= [];
    @track errorMessage;
    @wire (getAccountTasks, {accountId : '$recordId'}) accountTasks({ data, error }) 
    {     
        if (data)
        {   
            this.WrapTask = JSON.parse(data);
            this.errorMessage = undefined;            
        }
        else if (error) {            
            this.errorMessage = 'Unknown error';
            if (Array.isArray(error.body)) 
            {
                this.errorMessage = error.body.map(e => e.message).join(', ');
            }
            else if (typeof error.body.message === 'string') 
            {
                this.errorMessage = error.body.message;
            }
            this.tasks = undefined;
        }
    };
    @wire (getAccountEvents, {accountId : '$recordId'}) accountEvents({ data, error }) 
    {
        if (data) 
        {
            this.WrapEvent = JSON.parse(data);
            this.errorMessage = undefined;
        }
        else if (error) 
        {
            this.errorMessage = 'Unknown error';
            if (Array.isArray(error.body)) 
            {
                this.errorMessage = error.body.map(e => e.message).join(', ');
            }
            else if (typeof error.body.message === 'string') 
            {
                this.errorMessage = error.body.message;
            }
            this.events = undefined;
        }
    };   
}