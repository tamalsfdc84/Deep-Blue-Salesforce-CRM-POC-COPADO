import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { getPicklistValues } from 'lightning/uiObjectInfoApi';
import Lead_OBJECT from '@salesforce/schema/Lead';
import Lead_FIELD from '@salesforce/schema/Lead.FinServ__ExpressedInterest__c';

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
    mapRecordType = [];
    @track currentUserId;
    @track firstName;
    @track lastName;
    @track middleName;
    @track isButton;
    @track referralToId;
    @track referredType='';
    @track standardPicklist=[];
    @track wealthPicklist=[];
    @track pickListOptions=[];
    @track standardRecordTypeId;
    @track wealthRecordTypeId;
    @track referredToSelected=false;

    @track originalPickListOptions=[];
    fieldLabelName='Referral Type';
    isAttributeRequired=true;

    connectedCallback(){       
        if (this.RelatedAccount != undefined) {
            this.isButton = true;           
        }
        else { 
            this.isButton = false; 
        }
    }
    @wire(getObjectInfo, { objectApiName: Lead_OBJECT })
    Function({error,data}){
       if(data){
         for(let i=0; i<Object.values(data.recordTypeInfos).length; i++){
           
            if(Object.values(data.recordTypeInfos)[i].name=='Standard'){
               
               this.standardRecordTypeId=Object.values(data.recordTypeInfos)[i].recordTypeId;
            }
            if(Object.values(data.recordTypeInfos)[i].name=='Wealth'){
               
                this.wealthRecordTypeId=Object.values(data.recordTypeInfos)[i].recordTypeId;
             }
        }
       }else if(error){
        console.log(error); 
        }
     };

    @wire(getPicklistValues, { fieldApiName: Lead_FIELD, recordTypeId: '$standardRecordTypeId' })
    
    picklistValuesForStandard({error, data}){
        if(data){
            this.standardPicklist=data;
            this.pickListOptions=this.standardPicklist.values;
            this.originalPickListOptions=this.standardPicklist.values;
            
        }else if(error){
            console.log(error);
        }
    }

    @wire(getPicklistValues, { fieldApiName: Lead_FIELD, recordTypeId:  '$wealthRecordTypeId' })
    
    picklistValuesforWealth({error, data}){
        if(data){
            this.wealthPicklist=data;
;
        }else if(error){
            console.log(error);
        }
    }

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
            if( this.SelectedRecordId== this.standardRecordTypeId){
                this.pickListOptions=this.standardPicklist.values;
                this.originalPickListOptions=this.standardPicklist.values;
             }else if(this.SelectedRecordId== this.wealthRecordTypeId){
                this.originalPickListOptions=this.wealthPicklist.values;
                 this.pickListOptions= this.wealthPicklist.values;
             }
            this.isNext = true;            
        }
        else if (error) {
            // eslint-disable-next-line no-console
            console.log("error occured" + error);
        }
    }
    handleButton() {
        this.isButton = false; 
    }
    recordTypeValue(event) {
        this.SelectedRecordId = event.detail.value;
        if( this.SelectedRecordId== this.standardRecordTypeId){
            this.pickListOptions=this.standardPicklist.values;
            this.originalPickListOptions=this.standardPicklist.values;
             
         }else if(this.SelectedRecordId== this.wealthRecordTypeId){
             
             this.pickListOptions= this.wealthPicklist.values;
             this.originalPickListOptions=this.wealthPicklist.values;
         }
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
        if (this.currentUserId != '' && this.isRecordFormWealth) {
            getPopulateBUId({ userId: this.currentUserId })
                .then(result => {
                    if (result != null) {
                        this.template.querySelector("[data-field='BusinessUnit']").reset();
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
        if (this.recordId !== undefined) {
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
            this.referralBUId = '';
            this.recordName = "Standard";
        }
        else if (formName === "Wealth") {
            this.isRecordFormWealth = true;
            this.recordName = "Wealth";
        }
    }
    handleSuccess(event) {
        this.isRecordFormStandard = false;
        this.isRecordFormWealth = false;
        const evt = new ShowToastEvent({
            title: 'Success',
            message: this.firstName + ' ' + this.middleName + ' ' + this.lastName + ' Referral is Created Successfully',
            variant: 'success'
        });
        if (this.RelatedAccount !== undefined) {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: this.RelatedAccount,
                    actionName: 'view'
                },
            }); this.isButton = true;
        }
        else {
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: this.varObjectApiName,
                    actionName: 'view'
                },
            });
        }
        this.dispatchEvent(evt);
        setTimeout(() => {
            this.isLoading = false;
        }, 1500);
        setTimeout(() => {
                    this.isNext = true;
                }, 3000);
    }
    handleError() {
        /* "Error on Validation Msg"+event.detail.output.fieldErrors[0]+"Error on General msg "+event.detail.message*/
        const evt = new ShowToastEvent({
            title: 'Error!',
            message: 'Review the following errors.',
            variant: 'error'
        });
        this.isLoading = false;
        this.dispatchEvent(evt);
    }
    handleSubmit() {
        this.isLoading = true;
    }
    handleLoad() {
        this.isLoading = false;
    }
    onAccountSelection(event) {
        this.referralToId = event.detail.selectedRecordId;
        if(event.detail.selectedRecordId==null){
            //this.referredType = '';
            this.referredToSelected=false;
         }else{
             this.referredToSelected=true;
         }
        if(event.detail.referralType!=null){
            this.pickListOptions=[];
            for(let i=0; i<this.originalPickListOptions.length; i++){
                if(event.detail.referralType.includes(this.originalPickListOptions[i].value)){
                    this.pickListOptions.push(this.originalPickListOptions[i]);
                }
            }
            console.log(this.pickListOptions);
        }
        if(event.detail.selectedRecordId==null){
            this.pickListOptions =this.originalPickListOptions;
         }
    }
    populateReferredTo(event) {
        this.referredType = event.detail.value;
        if(this.referredToSelected==false){
            this.template.querySelector("c-w-t_-custom-lookup-component").removeRecordSelection();
        }
        this.template.querySelector("c-w-t_-custom-lookup-component").assignfilterValue(event.target.value);
    }
}