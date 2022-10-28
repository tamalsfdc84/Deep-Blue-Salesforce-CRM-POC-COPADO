import { LightningElement, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOpportunityDetails from '@salesforce/apex/WT_OpportunityPageController.returnOpportunityDetails';
import getIsCurrentUserSmallBusinessOperationUser from '@salesforce/apex/WT_OpportunityTeamMemberController.GetIsCurrentUserSmallBusinessOperationUser';
import addOpportunityTeamMember from '@salesforce/apex/WT_OpportunityTeamMemberController.AddOpportunityTeamMember';
import getOpportunityTeamMember from '@salesforce/apex/WT_OpportunityTeamMemberController.GetOpportunityTeamMember';
import deleteOpportunityTeamMember from '@salesforce/apex/WT_OpportunityTeamMemberController.DeleteOpportunityTeamMember';
const OBJECTAPINAME = 'OpportunityTeamMember';

const actions = [
    { label: 'Delete', name: 'delete' }
];

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Member Role', fieldName: 'TeamMemberRole' },
    { label: 'Access Level', fieldName: 'OpportunityAccessLevel' },
    {
        type: 'action',
        typeAttributes: { rowActions: actions },
    },
];

export default class WT_AddOpportunityTeamMemberLWC extends LightningElement {
    @api recordId;
    listOpportunityTeamMember = [];
    columns = columns;
    lookupQueryName = '';
    access;
    isLoading = true;
    isError = true;
    errorMessage = '';
    objectApiNames = OBJECTAPINAME;
    selectedUserId = '';
    isValidForSubmit = false;
    selectedTeamRole = '';
    initialSelection = [];
    listTeamRole = [
        {label: '--None--', value: ''},
        {label: 'Closer', value: 'Closer'},
        {label: 'Credit Analyst', value: 'Credit Analyst'},
        {label: 'Processor', value: 'Processor'},
        {label: 'Product Partner', value: 'Product Partner'},
        {label: 'Share Credit', value: 'Share Credit'}
    ];
    currentRecordType = '';
    isSmallBusinessOperationsUser = false;
    shouldShowNewTeamMemberCreationForm = false;

    connectedCallback() {        
        getOpportunityDetails({ opportunityId: this.recordId })
        .then(result => {
            if ((result != undefined && result != null)) {
                if(result.WT_Record_Type_Name__c == 'Easy Access Loan'){
                    this.listTeamRole = [
                        {label: '--None--', value: ''},
                        {label: 'Closer', value: 'Closer'},
                        {label: 'Credit Analyst', value: 'Credit Analyst'},
                        {label: 'Processor', value: 'Processor'},
                        {label: 'Product Partner', value: 'Product Partner'},
                        {label: 'Share Credit', value: 'Share Credit'}
                    ];
                }else{
                    this.listTeamRole = [
                        {label: '--None--', value: ''},
                        {label: 'Product Partner', value: 'Product Partner'},
                        {label: 'Share Credit', value: 'Share Credit'}
                    ];
                }
            }
        });

        getIsCurrentUserSmallBusinessOperationUser({})
        .then(result => {
            if(result){
                this.isSmallBusinessOperationsUser = true;
            }
        });

        getOpportunityTeamMember({ opportunityId: this.recordId })
        .then(result => {
            this.listOpportunityTeamMember = result;
            this.isLoading = false;
        });
    } 

    handleNewButtonClick(event){
        this.shouldShowNewTeamMemberCreationForm = true;
    }

    handleCancelClick(event){
        this.shouldShowNewTeamMemberCreationForm = false;
        this.initialSelection = [];
        this.selectedTeamRole = '';
        this.template.querySelector("[data-field='User']").reset();
    }

    handleRowAction(event) {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
        switch (actionName) {
            case 'delete':
                this.deleteRow(row);
                break;
            default:
        }
    }

    deleteRow(row) {
        if(row.Id){  
            this.isLoading = true;          
            deleteOpportunityTeamMember({ opportunityTeamMemberId: row.Id })
            .then(result => {
                if(result){
                    getOpportunityTeamMember({ opportunityId: this.recordId })
                    .then(result => {
                        this.listOpportunityTeamMember = result;
                        this.isLoading = false;
                        this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Opportunity Team Member Deleted', variant: 'success' }));
                    });
                }else{
                    //Show error
                    this.isLoading = false;
                    const evt = new ShowToastEvent({ title: 'Error!', message: 'Unable to delete Role', variant: 'error' });
                    this.dispatchEvent(evt);
                }
            });
        }
    }
    
    handleTeamRoleChange(event){
        const role = event.target.value;
        this.lookupQueryName = 'Opportunity_Team_Member_User';
        if (role == 'Product Partner') {
            if(this.selectedTeamRole == 'Processor' || this.selectedTeamRole == 'Closer' || this.selectedTeamRole == 'Credit Analyst'){
                this.initialSelection = [];
                this.selectedUserId = '';
            }
            this.access = 'Edit';
        }
        else if(role == 'Processor'){
            if(this.selectedTeamRole == 'Product Partner' || this.selectedTeamRole == 'Share Credit' || this.selectedTeamRole == 'Closer' 
                || this.selectedTeamRole == 'Credit Analyst'){
                this.initialSelection = [];
                this.selectedUserId = '';
            }
            this.lookupQueryName = 'Opportunity_Team_Member_Processor_User';
            this.access = 'Edit';
        }
        else if(role == 'Credit Analyst'){
            if(this.selectedTeamRole == 'Product Partner' || this.selectedTeamRole == 'Share Credit' || this.selectedTeamRole == 'Processor'
                || this.selectedTeamRole == 'Closer'){
                this.initialSelection = [];
                this.selectedUserId = '';
            }
            this.lookupQueryName = 'Credit_Analyst_User';
            this.access = 'Edit';
        }
        else if(role == 'Closer'){
            if(this.selectedTeamRole == 'Product Partner' || this.selectedTeamRole == 'Share Credit' || this.selectedTeamRole == 'Processor'
                || this.selectedTeamRole == 'Credit Analyst'){
                this.initialSelection = [];
                this.selectedUserId = '';
            }
            this.lookupQueryName = 'Opportunity_Team_Member_Closer_User';
            this.access = 'Edit';
        }
        else {
            if(this.selectedTeamRole == 'Processor' || this.selectedTeamRole == 'Credit Analyst' || this.selectedTeamRole == 'Closer'){
                this.initialSelection = [];
                this.selectedUserId = '';
            }
            this.access = 'Read';
            this.isError = false;
        }

        this.selectedTeamRole = event.target.value;

        if(this.selectedTeamRole !== '' && this.selectedUserId !== ''){
            this.isValidForSubmit = true;
        }else{
            this.isValidForSubmit = false;
        }
    }

    handleLoad(event) {
        this.isLoading = false;
    }
    handleSubmit(event) {
        this.isLoading = true;
        this.isError = true;

        if(this.isSmallBusinessOperationsUser){
            event.preventDefault();
            const fields = event.detail.fields;
            addOpportunityTeamMember({ opportunityId: fields.OpportunityId, teamMemberRole: fields.TeamMemberRole,
                                        userId: fields.UserId, opportunityAccessLevel: fields.OpportunityAccessLevel })
            .then(result => {
                if (result) {                    
                    this.handleSuccess(null);
                }else{
                    this.handleError();
                }
            });

        }else{
            this.template.querySelector('lightning-record-edit-form').submit();
        }
    }
    handleError() {
        /* "Error on Validation Msg"+event.detail.output.fieldErrors[0]+"Error on General msg "+event.detail.message*/
        const evt = new ShowToastEvent({ title: 'Error!', message: 'Unable to add a new role', variant: 'error' });
        this.isLoading = false;
        this.dispatchEvent(evt);
    }
    handleSuccess(event) {
        this.shouldShowNewTeamMemberCreationForm = false;
        this.initialSelection = [];
        this.selectedTeamRole = '';
        this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Opportunity Team Member Added', variant: 'success' }));
        this.template.querySelector("[data-field='User']").reset();
        this.isLoading = false;
        eval("$A.get('e.force:refreshView').fire();");

        if(this.selectedTeamRole !== '' && this.selectedUserId !== ''){
            this.isValidForSubmit = true;
        }else{
            this.isValidForSubmit = false;
        }

        getOpportunityTeamMember({ opportunityId: this.recordId })
        .then(result => {
            this.listOpportunityTeamMember = result;
        });
    }

    handleLookupRecordSelectionChange(event){
        const listSelectedId = event.detail;
        if(listSelectedId != null && listSelectedId.length > 0){
            this.selectedUserId = listSelectedId[0];
        }else{
            this.selectedUserId = '';
        }

        if(this.selectedTeamRole !== '' && this.selectedUserId !== ''){
            this.isValidForSubmit = true;
        }else{
            this.isValidForSubmit = false;
        }
    }
}