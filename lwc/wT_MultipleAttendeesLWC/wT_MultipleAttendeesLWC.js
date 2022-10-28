import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import fetchAttendees from '@salesforce/apex/WT_MultipleAttendeesLWCController.FetchAttendees';
import removeAttendees from '@salesforce/apex/WT_MultipleAttendeesLWCController.RemoveAttendees';
import getAttendeeName from '@salesforce/apex/WT_MultipleAttendeesLWCController.GetAttendeeName';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns = [
    { label: 'Attendee Name', fieldName: 'WT_Attendee_Name_Formula__c', type: 'text' },
    { label: 'Attendee Type', fieldName: 'WT_Attendee_Type__c', type: 'text' }, 
];
const editColumns = [
    { label: 'Attendee Name', fieldName: 'WT_Attendee_Name_Formula__c', type: 'text' },
    { label: 'Optional', fieldName: 'WT_Optional__c', type: 'boolean' },
    { label: 'Attendee type', fieldName: 'WT_Attendee_Type__c', type: 'text'}, 
    {type: "button", 
        typeAttributes: {
            label: 'Delete',
            name: 'Delete',
            title: 'Delete',
            disabled: false,
            value: 'Delete',
            iconPosition: 'left'
        }
    },   
];
export default class WT_MultipleAttendeesLWC extends NavigationMixin(LightningElement){
    
    columns = columns;
    editColumns= editColumns;
    @track newData=[];
    @track removedData=[];
    @track data=[];
    @track mainData =[];
    @track requiredMainData=[];
    @track optionalMainData=[];
    @api objectApiName;
    @api recordId;
    @track openEditAttendees = false;
    @track showUserLookup = true;
    @track showAccountLookup = false;
    @track showContactLookup = false;
    connectedCallback() {
        fetchAttendees({ eventID: this.recordId})
        .then(result => {
          this.data= result;
          this.mainData= result;
        if(result){
            let optionalData=[];
            let requiredData=[];
          for(var i=0 ; i<result.length; i++){
                if(result[i].WT_Optional__c == true)
                {
                    optionalData.push(result[i]);
                }
                else{
                    requiredData.push(result[i]);
                }
            }
            this.requiredMainData= requiredData;
            this.optionalMainData=optionalData; 
        }
          
        })
            .catch(error => {
            console.log("Error Occured as"+error);          
            });
    }
    onAttendeeTypeChange(event){
        const attendeeType = event.target.value;
        console.log("type:"+attendeeType);
        if(attendeeType =='Users'){
            this.showUserLookup = true;
            this.showAccountLookup = false;
            this.showContactLookup = false;
        }
        else if(attendeeType=='Persons'){
            this.showContactLookup = true;
            this.showUserLookup= false;
            this.showAccountLookup = false;
        }
        else if(attendeeType=='Accounts'){
            this.showAccountLookup = true;
            this.showContactLookup = false;
            this.showUserLookup= false;
        }
    }
    updateChangesToMainTable(event){
        this.mainData = this.data;
        let result= this.data;
        if(result){
            let optionalData=[];
            let requiredData=[];
          for(var i=0 ; i<result.length; i++){
                if(result[i].WT_Optional__c == true)
                {
                    optionalData.push(result[i]);
                }
                else{
                    requiredData.push(result[i]);
                }
            }
            this.requiredMainData= requiredData;
            this.optionalMainData=optionalData; 
        }
        this.openEditAttendees = false;
    }
    handleError(){
        const evt = new ShowToastEvent({
             title: 'Error!',
             message: 'Review the following errors.',
             variant: 'error'
         });
         this.dispatchEvent(evt);
     }
    handleEditAttendees(event){
        this.mainData = this.data;
        this.showUserLookup = true;
        this.showAccountLookup = false;
        this.showContactLookup = false;
        this.openEditAttendees = true;
    }
    handleCloseModal(event){
        this.openEditAttendees = false;
    }
    handleAddAction(event){
        getAttendeeName({ attendeeRecordID: event.detail.id})
                        .then(result => {
                            this.data = [...this.data,{ WT_Attendee_Name_Formula__c : result.WT_Attendee_Name_Formula__c,
                                                        WT_Optional__c : result.WT_Optional__c, 
                                                        WT_Attendee_Type__c: result.WT_Attendee_Type__c}];
                            this.newData.push(event.detail.id);
                        })
                        .catch(error => {
                            console.log("Error Occured as"+error);          
                        });
    }
    handleRowAction(event){
        const row = event.detail.row;
        const rowIndex = this.findRowIndexById(row.Id);
        if (rowIndex !== -1) {
            this.data = this.data
                .slice(0, rowIndex)
                .concat(this.data.slice(rowIndex + 1));
        }
        removeAttendees({ attendees: row})
        .then(result => {
            })
            .catch(error => {
                console.log("Error Occured as"+error);
            });
        }
        findRowIndexById(Id) {
            let ret = -1;
            this.data.some((row, index) => {
                if (row.Id === Id) {
                    ret = index;
                    return true;
                }
                return false;
            });
            return ret;
        }
    }