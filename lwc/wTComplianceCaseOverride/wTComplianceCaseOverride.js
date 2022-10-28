import { LightningElement, api, wire, track } from 'lwc';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CASE_OBJECT from '@salesforce/schema/Case';
import { NavigationMixin } from 'lightning/navigation';
import setReportByDate from '@salesforce/apex/WT_CasesNewOverrideController.setReportByDate';
import calculateResolutionTarget from '@salesforce/apex/WT_CasesNewOverrideController.calculateResolutionTarget';
import setCaseTitle from '@salesforce/apex/WT_CasesNewOverrideController.setCaseTitle';

export default class WTComplianceCaseOverride extends NavigationMixin(LightningElement) {
    @api recordId;
    @api accountId;
    @track recordTypeId = '';
    @track recordType;
    @api loaded = false;
    @track prepopulated = false;
    @track userInfo = [];
    @track reportdate = [];
    @track titleName = '';
    @track customerName = '';
    @track nonCustomerName = '';
    @wire(getObjectInfo, { objectApiName: CASE_OBJECT })
    handleObjectInfo({ error, data }) {
        if (data) {
            const rtis = data.recordTypeInfos;
            this.recordTypeId = Object.keys(rtis).find(rti => rtis[rti].name === 'Compliance Complaint');
            if(this.accountId != undefined)
            {
            setCaseTitle({ CustomerId: this.accountId })
                .then(result => {
                    this.titleName = result;
                })
                .catch(error => {
                    console.log("Error Occured as" + error);
                });
            }
        }
    }
    returnToCaseMainPage(event) {
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
    handleLoad(event) {
        setReportByDate()
            .then(result => {
                this.reportdate = result;
            })
            .catch(error => {
                console.log("Error Occured as" + error);
            });
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
    handleRequestChange(event) {
        const exceptionType = event.target.value;
        if (exceptionType != null && exceptionType != '') {
            calculateResolutionTarget({ requestValue: exceptionType, recordType: 'Compliance Complaint' })
                .then(result => {
                    this.reportdate = result;
                })
                .catch(error => {
                    console.log("Error Occured as" + error);
                });
        }
    }
    updateCaseTitle(event) {
        const nonCustomerName = event.target.value;
        if (nonCustomerName != null && nonCustomerName != '') {
            this.titleName = nonCustomerName;
        }
    }
    setCustomerToTitle(event) {
        const customerName = event.target.value;
        if (customerName != null && customerName != '') {
            setCaseTitle({ CustomerId: customerName })
                .then(result => {
                    this.titleName = result;
                })
                .catch(error => {
                    console.log("Error Occured as" + error);
                });
        }
    }
}