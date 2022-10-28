import { LightningElement, wire, track } from 'lwc'; 
import getReferralRecords from '@salesforce/apex/WT_DatePaidController.getDatePaidDetails';
import updateDataPaidDetails from '@salesforce/apex/WT_DatePaidController.updateDatePaidDetails';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Referral Status', fieldName: 'Status' },
    { label: 'Date Qualified', fieldName: 'WT_Date_Qualified__c', type: 'date-local' }
];
export default class wt_DataPaidAutomation extends NavigationMixin(LightningElement) {
    columns = columns;
    @track leads = [];
    @track errorMessage;
    @track isEmpty;
    @track isLoad = true;
    selectedRows = [];    
    @wire(getReferralRecords) referralRecord({ data, error }) {
        if (data) {
            this.leads = data;
            this.errorMessage = undefined;
            this.isLoad = false;
            if (data.length > 0) {
                this.isEmpty = true;
            }
            else {
                this.isEmpty = false;
            }            
        }
        else if (error) {
            this.errorMessage = 'Unknown error';
            if (Array.isArray(error.body)) {
                this.errorMessage = error.body.map(e => e.message).join(', ');
            }
            else if (typeof error.body.message === 'string') {
                this.errorMessage = error.body.message;
            }
            this.leads = undefined;
        }
    }
    updatePaid() {
        var selectedRowId = [];
        var unSelectedLeads = [];
        const selectRow = this.selectedRows;
        if (selectRow.length > 0) {           
            updateDataPaidDetails({ updateLeadRecord: selectRow })
                .then(result => {
                    if ('success' === result) { 
                        const evt = new ShowToastEvent({ title: 'Success', message: 'You have successfully Updated', variant: 'success' });
                        this.dispatchEvent(evt);                        
                        for (let x of selectRow) {
                            selectedRowId.push(x.Id);
                        }
                        for (let x of this.leads) {
                            if (!selectedRowId.includes(x.Id)) {
                                unSelectedLeads.push(JSON.parse(JSON.stringify(x)));
                            }
                        } 
                        if (unSelectedLeads.length <= 0) { 
                            this.isEmpty = false;
                        }                                           
                        this.leads = unSelectedLeads;
                    }
                    else {
                        this.errorMessage = result;
                        const evt = new ShowToastEvent({ title: '!Error', message: 'You do not have Permission to Update', variant: 'error' });
                        this.dispatchEvent(evt);
                    }                    
                })
                .catch(error => {
                    if (error) {
                        this.errorMessage = 'Unknown error';
                        if (Array.isArray(error.body)) {
                            this.errorMessage = error.body.map(e => e.message).join(', ');
                        }
                        else if (typeof error.body.message === 'string') {
                            this.errorMessage = error.body.message;
                        }
                        this.leads = undefined;
                        const evt = new ShowToastEvent({ title: 'Error', message: 'Please contact Administrator', variant: 'error' });
                        this.dispatchEvent(evt);
                    }
                });                                                
            return true;
        }
        // eslint-disable-next-line no-else-return
        else {          
            const evt = new ShowToastEvent({ title: 'Error', message: 'Select at atleast one record and try again.', variant: 'error' });
                        this.dispatchEvent(evt);           
            return false;
        }
    }
    closeModal() {
        this.errorMessage = undefined;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Lead',
                actionName: 'list',
            },
            state: {
                filterName: 'Recent'
            },
        });
    }
    getSelectedRows(event) {
        this.selectedRows = event.detail.selectedRows;
    }
}