import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import updateCase from '@salesforce/apex/WT_CaseOwnerUpdate.setOwnerId';

export default class WT_AssignCaseOwnerTo_HR_Queue extends LightningElement {
    @api recordId;

    @api invoke() {
        updateCase({'recordId' : this.recordId})
        .then(result => {
            if(result) {
                this.dispatchEvent(
                    new ShowToastEvent( {
                        title: 'Success',
                        message: 'Owner updated successfully',
                        variant: 'success'
                    } )
                );
            }
        })
        .catch(error => {
            this.dispatchEvent(
                new ShowToastEvent( {
                    title: 'Error',
                    message: error,
                    variant: 'error'
                } )
            );
        });
    }
}