import { LightningElement,api,track,wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordTypeDetails from '@salesforce/apex/WT_CasesNewOverrideController.getRecordTypeDetails';
import fetchUser from '@salesforce/apex/WT_CasesNewOverrideController.fetchUser';
import fetchChangedUser from '@salesforce/apex/WT_CasesNewOverrideController.fetchChangedUser';
import fetchMailingAddress from '@salesforce/apex/WT_CasesNewOverrideController.fetchMailingAddress';
import runCaseAssignmentRule from '@salesforce/apex/WT_CasesNewOverrideController.runCaseAssignmentRule';
import calculateResolutionTarget from '@salesforce/apex/WT_CasesNewOverrideController.calculateResolutionTarget';

export default class wT_CaseNewOverrideLWC extends NavigationMixin(LightningElement) {    
    @track mapRecordType = [];
    @api recordId;
    @api accountId;
    @track recordTypeId='';
    @track recordType;
    @track prepopulated= false;
    @track userInfo=[];
    @track mailingAddress='';
    @track reportdate=[];
    @track showRecordTypeSelection = true;
    @track showDepositApplicationLayout= false;
    @track showCCPALayout= false;
    @track showComplianceComplaintLayout=false;
    @track showComplianceComplaintError=false;
    @track loaded= false;
    connectedCallback() {
        getRecordTypeDetails()
        .then(result =>{
            if (result) {
                for (let key in result) {    
                        this.mapRecordType.push({ label: key, value: result[key] });
                    }                              
            }
            else if (error) {
                console.log("error occured call bacl"+error);
            }
            this.loaded= true; 
        })
      }      
    prePopulateValue(event){
        fetchUser()
        .then(result => {
            var formName;
            this.userInfo=result;
            this.prepopulated=true;
            this.showRecordTypeSelection= false;
            for (let key in this.mapRecordType) {
                if (this.mapRecordType[key].value === this.recordTypeId) {
                    formName = this.mapRecordType[key].label;
                }
            }
            this.recordType   = formName;
            
            if(formName == 'Deposit Application'){
                this.showDepositApplicationLayout = true;
                this.showCCPALayout= false;
            }
            if(formName == 'CCPA'){
                this.showDepositApplicationLayout = false;
                this.showCCPALayout= true;
            }
            if(formName == 'Compliance Complaint'){              
                    this.showDepositApplicationLayout = false;
                    this.showCCPALayout= false;
                    this.showComplianceComplaintLayout=true;
                    this.showComplianceComplaintError=false;               
               }
              
          })
            .catch(error => {
            console.log("Error Occured as toggle"+error);          
            });
    }
    getRecordTypeID(event){
        this.recordTypeId= event.detail.value;
    }
    returnToCaseMainPage(event){
        eval("$A.get('e.force:refreshView').fire();");
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Case',
                actionName: 'list',
            },
            state: {
                filterName: 'Recent'
            },
        });
    }
    handleChildSave(event){
        if(event.detail.childlwcRecordId == null){
            eval("$A.get('e.force:refreshView').fire();");
            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Case',
                    actionName: 'list',
                },
                state: {
                    filterName: 'Recent'
                },
            });
        }
        else{
        const createdRecord = event.detail.childlwcRecordId;
        if(createdRecord !='')
        {
            runCaseAssignmentRule({caseRecordID: createdRecord, recordType: this.recordType})
            .then(result => {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: ' Case Created Successfully',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: event.detail.childlwcRecordId,
                        objectApiName: 'Case',
                        actionName: 'view'
                    },
                });
                setTimeout(() => {
                    this.showRecordTypeSelection= true;
                    this.showComplianceComplaintError= false;
                    this.showComplianceComplaintLayout= false;
                    this.showDepositApplicationLayout= false;
                    this.showCCPALayout= false;
                    this.recordTypeId= '';
                    this.loaded= true;
                    this.template.querySelector("c-w-t-compliance-case-override").stopSpinnerAfterSaveSuccess();
                }, 3000);
              })
                .catch(error => {
                console.log("Error Occured as handle success"+error);          
                });
        } 
    }
    }
    handleSuccess(event){
        const createdRecord = event.detail.id;
        if(createdRecord !='')
        {
            runCaseAssignmentRule({caseRecordID: createdRecord, recordType: this.recordType})
            .then(result => {
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: ' Case Created Successfully',
                    variant: 'success'
                });
                this.dispatchEvent(evt);
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: event.detail.id,
                        objectApiName: 'Case',
                        actionName: 'view'
                    },
                });
                this.recordTypeId= '';
                setTimeout(() => {
                    this.showRecordTypeSelection= true;
                    this.showComplianceComplaintError= false;
                    this.showComplianceComplaintLayout= false;
                    this.showDepositApplicationLayout= false;
                    this.showCCPALayout= false;
                    this.loaded= true;
                }, 3000);
              })
                .catch(error => {
                console.log("Error Occured as handle success"+error);          
                });
        }
    }
    handleSubmit(event){
        this.loaded= false;
    }
    handleError(event){
        this.loaded= true;
    }
    changePrepopulatedValue(event){
        const changedUser= event.target.value;
        if(changedUser != null && changedUser !='')
        {
            fetchChangedUser({ userRecordParameter:  changedUser.toString()})
                .then(result => {
                    this.userInfo= result;
                })
                    .catch(error => {
                    console.log("Error Occured as change pre po value"+error);
                });
        }
    }
    getMailingAddress(event){
        var accountDetails = this.template.querySelector("[data-field='accountDetail']").value;
        var reportValue = this.template.querySelector("[data-field='report']").value;
        if(accountDetails != null && accountDetails !='' && reportValue =='USPS Mail')
        {
            fetchMailingAddress({accountRecordID: accountDetails.toString()})
            .then(result => {
                this.mailingAddress= result;
            })
            .catch(error => {
                console.log("Error Occured as mail add"+error);
            }); 
        }
    }
    handleRequestChange(event){
        const requestType = event.target.value;
        if(requestType != null && requestType !='')
        {
            calculateResolutionTarget({requestValue:requestType, recordType:this.recordType})
            .then(result => {
                this.reportdate= result;
            })
            .catch(error => {
                console.log("Error Occured as handle change req"+error);
            }); 
        }
    }
}