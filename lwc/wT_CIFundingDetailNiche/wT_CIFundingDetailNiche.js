import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import DONATION_FIELD from '@salesforce/schema/Account.WT_CI_Donation_CRA_Eligible__c';
import FUNDED_FIELD from '@salesforce/schema/Account.WT_CI_Funded_Organization__c';
import SEEKS_FIELD from '@salesforce/schema/Account.WT_CI_Seeks_Board_Member__c';
import VOLUNTEER_FIELD from '@salesforce/schema/Account.WT_CI_Volunteer_Opportunities__c';
import MISSION_FIELD from '@salesforce/schema/Account.WT_CI_Mission__c';
import getFundingList from '@salesforce/apex/WT_CIFundingController.getFundingList';

import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
const actions = [
    { label: 'View', name: 'view' },
    { label: 'Edit', name: 'edit' },
];
const columns = [
    { label: 'Funding Amount', fieldName: 'WT_Funding_Amount__c' },
    { label: 'Date of Payment', fieldName: 'WT_Date_of_Payment__c' },
    { label: 'Split Payment', fieldName: 'WT_Split_Payment__c' },
    {
        type: 'action',
        typeAttributes: {
            rowActions: actions,
        }
    }
];

const fields = [MISSION_FIELD];
export default class WT_CIFundingDetailNiche extends NavigationMixin(LightningElement)
{
    @api recordId;
    fundingList = [];
    isLoaded = true;
    @track isModalOpen = false;
    column = columns;
    fields = [DONATION_FIELD, FUNDED_FIELD, SEEKS_FIELD, VOLUNTEER_FIELD, MISSION_FIELD];
    isData = false;
    isSave = false;
    location = '#';
    term = '#';
    userName = '#';

    // New Changes START
    objectApiName = 'Account';
    showPencilIconAndDisableFields = true;
    showAllFieldsAndHidePencilIcon() 
    {
        this.showPencilIconAndDisableFields = false;
    }
    handleSubmit(event) 
    {
        event.preventDefault();
        const fields = event.detail.fields;
        this.isLoaded = true;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    showSuccessMessage(event) 
    {
        this.isLoaded = false;
        this.isModalOpen = false;
        this.showPencilIconAndDisableFields = true;
        this.showNotificationMessage('Success', 'Record Successfully saved', 'success', 'dismissible');
    }
    showErrorMessage(event) 
    {
        this.isLoaded = false;
        this.showPencilIconAndDisableFields = true;
        const errorMessage = event.detail.detail;
        this.showNotificationMessage('Error Occured', errorMessage, 'error', 'dismissible');
    }
    resetFields(event)
    {
        this.showPencilIconAndDisableFields = true;
        const fieldsToReset = this.template.querySelectorAll('.fields-to-reset');
        if (fieldsToReset)
        {
            fieldsToReset.forEach(field => 
                {
                field.reset();
            });
        }
    }
    @wire(getRecord, { recordId: '$recordId', fields })
    account;
    get ciMIsssionField() 
    {
        return getFieldValue(this.account.data, MISSION_FIELD);
    }

    get sldsClassesForCheckboxFields() 
    {
        return this.showPencilIconAndDisableFields ? 'slds-col slds-size_5-of-12 custom-bottom-border-non-tabular-fields zero-right-and-left-padding' : 
            'slds-col slds-size_5-of-12 zero-right-and-left-padding';
    }

    get sldsClassesForTextBoxField() 
    {
        return this.showPencilIconAndDisableFields ? 'slds-col slds-size_12-of-12 custom-bottom-border-non-tabular-fields zero-right-and-left-padding' :
            'slds-col slds-size_12-of-12 zero-right-and-left-padding';
    }
    /**
     * 
     * @param {string} title Title of the Toast Message 
     * @param {string} message Description of the message
     * @param {string} variant [success, error, info, warning]
     * @param {string} mode [dismissible, sticky]
     */
    showNotificationMessage(title, message, variant, mode) 
    {
        const notifiction = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            mode: mode
        });
        this.dispatchEvent(notifiction);
    }
    // New Changes END
    wiredFundingData;
    @wire(getFundingList, { accountId: '$recordId' })
    wiredFundingHistory(wireResult)
    {
        const { data, error } = wireResult;
        this.wiredFundingData = wireResult;
        if (data) 
        {
            this.fundingList = data;
            console.log('funding list size ', this.fundingList.length);
            this.isData = this.fundingList.length > 0 ? true : false;
            this.isLoaded = false;
        }
        if (error) 
        {
            console.error(error)
            this.fundingList = [];
            this.isLoaded = false;
        }
    }
    handleRowActions(event) 
    {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'view':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes:
                     {
                        recordId: row.Id,
                        actionName: 'view'
                    }
                });
                break;
            case 'edit':
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: 
                    {
                        recordId: row.Id,
                        objectApiName: 'Account',
                        actionName: 'edit'
                    }
                });
                break;
        }
    }
    openModal() 
    {
        this.isModalOpen = true;
    }
    closeModal() 
    {
        this.isModalOpen = false;
    }
    handleSuccess(event) 
    {
        const ev = new ShowToastEvent({
            title: 'CI Funding History',
            message: 'Record created successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(ev);
        this.isLoaded = true;
        this.isModalOpen = false;
        refreshApex(this.wiredFundingData);
        this.isLoaded = false;
    }
    navigateRelatedListView() 
    {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: 'Account',
                relationshipApiName: 'CI_Funding_Histories1__r',
                actionName: 'view'
            },
        });
    }
    handleChange(event) 
    {
        this.isSave = true;
    }
    handleSave() 
    {
        const ev = new ShowToastEvent({
            title: 'Fields',
            message: 'updated successfully',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(ev);
        this.isSave = false;
    }
    handleFinal(event)
     {
        event.preventDefault();
        // Get data from submitted form
        const fields = event.detail.fields;
        if (this.location != '#') {
            fields.WT_Location__c = this.location;
        }
        if (this.term != '#') {
            fields.WT_Term__c = this.term;
        }
        if (this.userName != '#') {
            fields.WT_CI_Board_Member_Name__c = this.userName;
        }
        // submit the form after modifications
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    handleChangeUser(event) 
    {
        this.userName = event.currentTarget.value;
    }
    handleChangeTerm(event)
    {
        this.term = event.currentTarget.value;
    }
    handleChangeLocation(event) 
    {
        this.location = event.currentTarget.value;
    }
}