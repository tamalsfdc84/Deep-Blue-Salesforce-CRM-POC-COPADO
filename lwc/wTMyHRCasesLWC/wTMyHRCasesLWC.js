import { LightningElement,api,wire,track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { NavigationMixin } from 'lightning/navigation';
import setReportByDate from '@salesforce/apex/WT_CasesNewOverrideController.setReportByDate';
import calculateResolutionTarget from '@salesforce/apex/WT_CasesNewOverrideController.calculateResolutionTarget';
import setEmployeeDetails from '@salesforce/apex/WT_CasesNewOverrideController.setEmployeeDetails';

export default class WTMyHRCasesLWC extends NavigationMixin(LightningElement) {
    @api recordId;
    @api accountId;
    @track recordTypeId='';
    @track recordType;
    @track prepopulated= false;
    @api loaded = false;
    @track userInfo=[];
    @track reportdate=[];
    @track employeeId='';
    @track employeeName='';
    @track bankName='';
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
        handleObjectInfo({error, data}) {
            if (data) {
                const rtis = data.recordTypeInfos;
                this.recordTypeId = Object.keys(rtis).find(rti => rtis[rti].name === 'MyHR');
            }
    }
    handleSubmit(event) {
        this.loaded = false;
    }
    @api stopSpinnerAfterSaveSuccess() {
        this.loaded = true;
    }
    handleError(event) {
        this.loaded = true;
    }
    returnToCaseMainPage(event){
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
    returnToParentRefresh(event) {
        const lwcEvent = new CustomEvent('compliancerecordsave', {
            detail: { childlwcRecordId: null }
        });
        this.dispatchEvent(lwcEvent);
    }
    handleSuccess(event) {
        const createdRecord = event.detail.id;
        const lwcEvent = new CustomEvent('compliancerecordsave', {
            detail: { childlwcRecordId: createdRecord }
        });
        this.dispatchEvent(lwcEvent);
    }
    handleLoad(event)
    {
        setReportByDate()
        .then(result => {
            this.reportdate= result;
        })
        .catch(error => {
            console.log("Error Occured as"+error);
        }); 
    }

    handleRequestChange(event){
        const exceptionType = event.target.value;
        if(exceptionType != null && exceptionType !='')
        {
            calculateResolutionTarget({requestValue:exceptionType, recordType: 'Compliance Complaint'})
            .then(result => {
                this.reportdate= result;
            })
            .catch(error => {
                console.log("Error Occured as"+error);
            }); 
        }
    }
   
    updateCaseTitle(event)
    {
        const nonCustomerName = event.target.value;
        if(nonCustomerName!=null && nonCustomerName !='')
        {
            this.titleName=nonCustomerName;
        }
    }

    setEmployeeDetails(event)
    {
        const Employee = event.target.value;
        if(Employee != null && Employee !='')
        {
            setEmployeeDetails({EmployeeID:Employee})
            .then(result => {
                if(result.WT_Employee_ID__c != undefined && result.WT_Employee_ID__c != null){
                    this.employeeId= result.WT_Employee_ID__c;
                }
                if(result.WT_First_Name__c != undefined && result.WT_First_Name__c != null
                    && result.WT_Last_Name__c != undefined && result.WT_Last_Name__c != null){
                    this.employeeName=result.WT_First_Name__c+' '+result.WT_Last_Name__c;
                }
                else 
                {
                    if(result.WT_First_Name__c != undefined && result.WT_First_Name__c != null){
                        this.employeeName=result.WT_First_Name__c;
                    }
                    else{
                        if(result.WT_Last_Name__c != undefined && result.WT_Last_Name__c != null){
                            this.employeeName=result.WT_Last_Name__c;
                        }
                    }
                } 
                if(result.WT_Entity__c != undefined && result.WT_Entity__c != null){
                    this.bankName=result.WT_Entity__c;
                }
            })
            .catch(error => {
                console.log("Error Occured as"+error);
            }); 
        }
    }
   
}