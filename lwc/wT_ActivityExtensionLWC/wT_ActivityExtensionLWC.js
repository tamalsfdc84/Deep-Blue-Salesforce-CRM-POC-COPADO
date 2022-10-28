/* eslint-disable no-undef */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchRecordTypeID from '@salesforce/apex/WT_ActivityExtensionController.fetchRecordTypeID';
import fetchTaskDetails from '@salesforce/apex/WT_ActivityExtensionController.returnTaskDetails';
import fetchEventDetails from '@salesforce/apex/WT_ActivityExtensionController.returnEventDetails';
export default class wT_ActivityExtensionLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @track activityExtId;
    @track taskRecordTypeName;
    @track eventRecordTypeName;
    @track recordTypeId = '';
    @track eventRecordTypeId = '';
    @track errorMessage;
    @track showTMCallEditLayout = false;
    @track showTMCallViewLayout = false;
    @track displayTMCallLayout = false;
    @track callType;
    @track display14DaySection = false;
    @track display60DaySection = false;
    @track display14DaySectionEdit = false;
    @track display60DaySectionEdit = false;
    @track showEditSection = false;
    @track showReadOnlySection = false;
    @track displayWFGlayout = false;
    @track showWFGEditSection = false;
    @track showReadOnlyWFGSection = false;
    @track displayEventLayout = false;
    @track showEditEventDetail = false;
    @track displayStdCraWinLayout = false;
    @track showEditTaskDetail = false;

    connectedCallback() {
        if (this.objectApiName == 'Event') {
            fetchEventDetails({ eventRecordId: this.recordId })
                .then(result => {
                    if ((result != undefined && result != null)) {
                        this.activityExtId = result.Id;
                        this.showEditEventDetail = false;
                        this.displayEventLayout = true;
                        this.eventRecordTypeName = result.WT_Record_Type_Name__c;
                        fetchRecordTypeID({ recordTypeName: this.eventRecordTypeName })
                            .then(result => {
                                this.eventRecordTypeId = result;
                            })
                            this.displayTMCallLayout = true;
                            this.displayWFGlayout = true;
                    }
                    else {
                        this.errorMessage = 'Please Contact Your Administrator'; 
                        }
                })
        }
        else {
            fetchTaskDetails({ taskRecordId: this.recordId })
                .then(result => {
                    if ((result.Id != undefined && result.Id != null)) 
                    {
                        this.showReadOnlySection = true;
                        this.showReadOnlyWFGSection = true;
                        this.showEditSection = false;
                        this.showWFGEditSection = false;
                        this.activityExtId = result.Id;
                        this.taskRecordTypeName = result.WT_Record_Type_Name__c;
                        //if the activity already exists, display only the 14 Day/60 Day sections                        
                            if (result.WT_TM_Onboarding_Call__c == '14 Days') {
                                this.display14DaySectionEdit = true;
                            } else if (result.WT_TM_Onboarding_Call__c == '60 Days') {
                                this.display60DaySectionEdit = true;
                            }                                                                 
                    if (this.taskRecordTypeName == 'TM_Call') {
                        this.showTMCallViewLayout = true;
                        this.showTMCallEditLayout = false;
                        this.displayTMCallLayout = true;
                    }           
                    if (this.taskRecordTypeName == 'WT_WFG_Call') {                      
                        this.displayWFGlayout = true;
                    }                   
                    if (this.taskRecordTypeName == 'WT_CRA_Call' || this.taskRecordTypeName == 'WT_Task' || this.taskRecordTypeName == 'WT_Standard_Call' || this.taskRecordTypeName == 'WT_Wintrust_Task') {
                        this.displayStdCraWinLayout = true;
                        this.showEditTaskDetail = false;                       
                    }
                    fetchRecordTypeID({ recordTypeName: this.taskRecordTypeName })
                        .then(result => {
                            this.recordTypeId = result;
                        })
                    }
                    else if(this.activityExtId == undefined || this.activityExtId == null) {
                        this.errorMessage = 'Please Contact Your Administrator'; 
                        if ( this.taskRecordTypeName == 'WT_WFG_Call') {                          
                            this.displayWFGlayout = false;
                        }
                        if (this.taskRecordTypeName == 'TM_Call') {
                            this.showTMCallEditLayout = true;
                            this.showTMCallViewLayout = false;
                        }
                    }
                })
        }
    }
    handleTMChange(event) {
        this.callType = event.target.value;
        if (this.callType == '14 Days') {
            this.display14DaySection = true;
            this.display60DaySection = false;
        }
        else if (this.callType == '60 Days') {
            this.display14DaySection = false;
            this.display60DaySection = true;
        }
    }
    handleTMModal(event) {
        this.showReadOnlySection = false;
        this.showEditSection = true;
    }
    handleEditEvent(event) {
        this.showEditEventDetail = true;
    }
    handleEditTask(event) {
        this.showEditTaskDetail = true;
    }
    handleWFGModal(event) {
        this.showWFGEditSection = true;
        this.showReadOnlyWFGSection = false;
    }
    prePopulateValue(event) {
        if (this.taskRecordTypeName == 'TM Call') {
            this.showTMCallEditLayout = true;
        }
    }
    handleSuccessWFGModal(event){
        this.showWFGEditSection = false;
        this.showReadOnlyWFGSection = true;
        const evt = new ShowToastEvent({
            title: 'Success',
            message: ' Record is Saved Successfully ',
            variant: 'success'
        });
        this.dispatchEvent(evt);
    }
    handleCloseWFGModal(event){
        this.showWFGEditSection = false;
        this.showReadOnlyWFGSection = true;
    }
    handleSuccess(event) {
        this.showReadOnlySection = true;
        this.showEditSection = false;
        const evt = new ShowToastEvent({
            title: 'Success',
            message: ' Record is Saved Successfully ',
            variant: 'success'
        });
        this.dispatchEvent(evt);
    }
    handleCloseModal(event) {
        this.showReadOnlySection = true;
        this.showEditSection = false;
    }
    handleSuccessTask(event) {
        this.showEditTaskDetail = false;
        const evt = new ShowToastEvent({
            title: 'Success',
            message: ' Record is Saved Successfully ',
            variant: 'success'
        });
        this.dispatchEvent(evt);
    }
    handleCloseModalTask(event){
        this.showEditTaskDetail = false;
    }
    handleSuccessEvent(event) {
        this.showEditEventDetail = false;
        const evt = new ShowToastEvent({
            title: 'Success',
            message: ' Record is Saved Successfully ',
            variant: 'success'
        });
        this.dispatchEvent(evt);
    }
    handleCloseModalEvent(event) {
        this.showEditEventDetail = false;
    }
}