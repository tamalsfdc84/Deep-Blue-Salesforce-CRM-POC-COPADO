/* eslint-disable no-undef */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchRecordTypeID from '@salesforce/apex/WT_TaskTMCallController.fetchRecordTypeID';
import getTMcallType from '@salesforce/apex/WT_TaskTMCallController.TMcallType';
import updateTask from '@salesforce/apex/WT_TaskTMCallController.updateTask';
import fetchTaskDetails from '@salesforce/apex/WT_TaskTMCallController.returnTaskDetails';

export default class WT_TMCallActivityLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;
    @track activityExtId;
    @track taskRecordTypeName;
    @track recordTypeId='';
    @track recordType;
    @track showRecordTypeSelection= false;
    @track showTMCallEditLayout=false;
    @track showTMCallViewLayout=false;
    @track displayTMCallLayout=false;
    @track callType;
    @track display14DaySection = false;
    @track display60DaySection = false;
    @track displayAllSection = false;
    @track display14DaySectionEdit = false;
    @track display60DaySectionEdit = false;
    @track showEditSection = false;
    @track showReadOnlySection = false;
        
        connectedCallback() {
            fetchTaskDetails({taskrecordId: this.recordId})
            .then(result => {
                window.console.log("result:"+JSON.stringify(result));
                //window.console.log("activity id:"+result.WT_TM_Activity_Lkp__c);
                window.console.log("task record type name:"+result.RecordType.DeveloperName);
                if(result.WT_TM_Activity_Lkp__c != undefined && result.WT_TM_Activity_Lkp__c != null)
                {
                    window.console.log('enetred now----'+this.showReadOnlySection);
                    this.showReadOnlySection = true;
                    window.console.log('enetred after read----'+this.showReadOnlySection);
                    this.showEditSection = false;
                    window.console.log('enetred after edit----'+this.showEditSection);
                    window.console.log("activity id:"+result.WT_TM_Activity_Lkp__c);
                    this.activityExtId=result.WT_TM_Activity_Lkp__c;
                    //if the activity already exists, display only the 14 Day/60 Day sections 
                    getTMcallType({activityExtensionId: this.activityExtId})
                    .then(resultCall => {
                        window.console.log("Activity record details:"+resultCall);
                        if(resultCall == '14 Days')
                        {
                            this.display14DaySectionEdit = true;
                        } else if(resultCall == '60 Days'){
                            this.display60DaySectionEdit = true;
                        }
                        //this.recordTypeId=resultCall;
                        })
                        /*.catch(errorResult => {
                            window.console.log("Error Occured as"+errorResult);          
                        });*/
                }
                window.console.log('enetred');                            
                this.taskRecordTypeName = result.RecordType.DeveloperName;
                window.console.log("activityExtId:"+this.activityExtId);
                if(this.activityExtId != undefined || this.activityExtId != null)
                {
                    this.showTMCallViewLayout=true; 
                    this.showTMCallEditLayout=false;
                }
               if((this.activityExtId == undefined || this.activityExtId == null)){
                    this.showTMCallEditLayout=true;
                    this.showTMCallViewLayout=false; 
                }
                window.console.log("taskRecordTypeName--"+this.taskRecordTypeName);
                if(this.taskRecordTypeName != undefined && this.taskRecordTypeName != null
                    && this.taskRecordTypeName == 'TM_Call'){
                    this.displayTMCallLayout = true;
                }
              })
        }

        handleTMChange(event){
            window.console.log('test=-'+event.target.value);
            this.callType= event.target.value;
            if(this.callType == '14 Days')
            {
                this.display14DaySection = true;
                this.display60DaySection = false;
            }
            else if (this.callType == '60 Days')
            {
                this.display14DaySection = false;
                this.display60DaySection = true;
            }
            window.console.log('14 Day--'+this.display14DaySection );
            window.console.log('60 Day--'+this.display60DaySection );
        }
          
        getRecordTypeID(event){
            this.recordType= event.detail.value;
           
            fetchRecordTypeID({recordTypeName: this.recordType})
            .then(result => {
                window.console.log("Task record type Id:"+result);
                this.recordTypeId=result;
              })
                .catch(error => {
                    window.console.log("Error Occured as"+error);          
                });
        }

        //update
        handleUpdateModal(event){            
            this.showReadOnlySection = false;
            this.showEditSection = true;
            /*if(this.callType == '14 Days')
            {
                this.display14DaySection = true;
                this.display60DaySection = false;
            }
            else if (this.callType == '60 Days')
            {
                this.display14DaySection = false;
                this.display60DaySection = true;
            }
            window.console.log('14 Day--'+this.display14DaySection );
            window.console.log('60 Day--'+this.display60DaySection );*/
        }

        prePopulateValue(event){
                this.prepopulated=true;
                this.showRecordTypeSelection= false;
                if(this.recordType == 'TM Call'){
                    this.showTMCallEditLayout = true;
                }            
        }
        handleCloseModal(event) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                        objectApiName: 'Task',
                        actionName: 'view'
                },
            });
        }
        handleSuccess(event) {
            var id; 
          //  activityExtId = event.detail.id;    
            
           // fetchTaskID({ activityExtensionId: event.detail.id , accountId: this.recordId })
           updateTask({ activityExtensionId: event.detail.id , taskId: this.recordId })
            .then(result => {
                window.console.log("Task Id =<"+ result); 
                id = result; 
                window.console.log("Task Id =>"+ id); 
                this.showTMCallViewLayout = false;             
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: this.recordId,
                        objectApiName: 'Task',
                        actionName: 'view'
                    },
                });
              })
                .catch(error => {
                window.console.log("Error Occured as"+error);          
                });
            const evt = new ShowToastEvent({
                title: 'Success',
                message:' TM Call is Saved Successfully ',
                variant: 'success'
            });
            this.dispatchEvent(evt);
                                   
        }                  
}