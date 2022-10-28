/* eslint-disable no-undef */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordTypeDetails from '@salesforce/apex/WT_ReferralNewOverrideController.getPrePopulateValue';
import getPopulateBUId from '@salesforce/apex/WT_ReferralNewOverrideController.populateBusinessReferralUnit';
import getPopulateName from '@salesforce/apex/WT_ReferralNewOverrideController.populateName';
export default class Wt_ReferralNewOverride extends NavigationMixin(LightningElement) {
@api varObjectApiName;
@api recordId;
@api RelatedAccount;
@track recordName;
@track SelectedRecordId;
@track getRecordId;
@track isNext;
@track isLoading;
@track isRecordFormStandard;
@track isRecordFormWealth;
@track referralBUId;
@track currentUserId;
@track firstName;
@track lastName;
@track middleName; 
@track isButton;
mapRecordType = [];
@wire(getRecordTypeDetails) getRecordType({ data, error }) {
    if (data) {
        for (let key in data) {
            if (key === "BUId") {
                this.referralBUId = data[key];
            }
            else if (key === "CurrentUser") {
                this.currentUserId = data[key];
            }
            else {
                this.mapRecordType.push({ label: key, value: data[key] });
            }
        }
        this.SelectedRecordId = data.Standard;
        if (this.RelatedAccount != undefined) { 
            this.isButton=true;
            this.isNext=true;
        }
        else {
            this.isButton=false;
            this.isNext=true;
        }
    }
    else if (error) {
        // eslint-disable-next-line no-console
        console.log("error occured" + error);
    }
}
handleButton(){
    this.isButton = false;
}
recordTypeValue(event) {
    this.SelectedRecordId = event.detail.value;
}
handleCloseModal() {        
    this.isLoading = false;
    this.isRecordFormStandard = false;
    this.isRecordFormWealth = false;
    if (this.RelatedAccount != undefined) {                    
        this.isButton = true;         
    }
    else {
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: this.varObjectApiName,
                actionName: 'list',
            },
            state: {
                filterName: 'Recent'
            },
        });
    }
    this.isNext = true;
}
populteNameFieldValue(event) {
    const referredAccId = event.target.value;
    getPopulateName({ referredAccountId: referredAccId })
        .then(result => {
            if (result.FirstName !== undefined) {
                this.firstName = result.FirstName;
            }
            else {
                this.firstName = '';
            }
            if (result.MiddleName !== undefined) {
                this.middleName = result.MiddleName;
            }
            else {
                this.middleName = '';
            }
            if (result.LastName !== undefined) {
                this.lastName = result.LastName;
            }
            else {
                this.lastName = '';
            }
        });
}
changeOnReferredBy(event) {
    this.currentUserId = event.target.value;
    if (this.template.querySelector("[data-field='BusinessUnit']").value === '' && this.currentUserId === '') {
        getPopulateBUId({ userId: this.currentUserId })
            .then(result => {
                if (result != null) {
                    this.template.querySelector("[data-field='BusinessUnit']").value = result;
                    this.referralBUId = result;
                }
            });
    }
}
handleNextModal() {
    var formName;
    this.isNext = false;
    this.getRecordId = this.SelectedRecordId;
    this.isLoading = true;
    for (let key in this.mapRecordType) {
        if (this.mapRecordType[key].value === this.SelectedRecordId) {
            formName = this.mapRecordType[key].label;
        }
    } 
    if(this.recordId !== undefined) {
    getPopulateName({ referredAccountId: this.recordId })
        .then(result => {
            if (result.FirstName !== undefined) {
                this.firstName = result.FirstName;
            }
            else {
                this.firstName = '';
            }
            if (result.MiddleName !== undefined) {
                this.middleName = result.MiddleName;
            }
            else {
                this.middleName = '';
            }
            if (result.LastName !== undefined) {
                this.lastName = result.LastName;
            }
            else {
                this.lastName = '';
            }
        });
    }
    if (formName === "Standard") {
        this.isRecordFormStandard = true;
        this.recordName = "Standard";
    }
    else if (formName === "Wealth") {
        this.isRecordFormWealth = true;
        this.recordName = "Wealth";
    }
}
handleSuccess(event) {
    this.isLoading = false;
    this.isRecordFormStandard = false;
    this.isRecordFormWealth = false;
    const evt = new ShowToastEvent({
        title: 'Success',
        message: this.firstName + ' ' + this.middleName + ' ' + this.lastName + ' Referral is Created Successfully',
        variant: 'success'
    });
    this.dispatchEvent(evt);
    if(this.RelatedAccount !== undefined)
    {
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: this.recordId,
            objectApiName: this.RelatedAccount,
            actionName: 'view'
        },
    });  this.isButton = true; 
} 
else{
    this[NavigationMixin.Navigate]({
        type: 'standard__recordPage',
        attributes: {
            recordId: event.detail.id,
            objectApiName: this.varObjectApiName,
            actionName: 'view'
        },
    }); 
}     
    this.isNext = true;
}
handleError() {
    /* "Error on Validation Msg"+event.detail.output.fieldErrors[0]+"Error on General msg "+event.detail.message*/
    const evt = new ShowToastEvent({
        title: 'Error!',
        message: 'Review the following errors.',
        variant: 'error'
    });
    this.dispatchEvent(evt);
}
handleLoad() {
    this.isLoading = false;
}
}