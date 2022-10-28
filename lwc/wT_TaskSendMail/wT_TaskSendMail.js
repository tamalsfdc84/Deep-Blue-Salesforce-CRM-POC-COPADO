import { LightningElement,track,api,wire } from 'lwc';
import fetchSendEmailToTaskOwner from '@salesforce/apex/WT_TaskSendEmailController.fetchSendEmailToTaskOwner';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class WT_TaskSendMail extends LightningElement {
    @api recordId;
    @track showUserMessage=false;
    @track userMessage='';
    handleSendMail(event){
        console.log('record id: '+ this.recordId);
        console.log('calling fetch send email to task owner');
        fetchSendEmailToTaskOwner({recordID: this.recordId})
        .then(result => {
                console.log('result:'+result);
                if(result == 'Success'){
                    this.userMessage = null;
                    const closeQA = new CustomEvent('close');
                    this.dispatchEvent(closeQA);
                    const event = new ShowToastEvent({
                        title: 'Toast Success',
                        message: 'Email Sent Successfully',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                }
                else if(result !='Success'){
                    this.showUserMessage = true;
                    this.userMessage = result;
                }
        }).catch(error => {
                console.log("Error Occured as"+error);
            });
    }   
}