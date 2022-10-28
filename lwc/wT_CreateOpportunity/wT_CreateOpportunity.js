import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOpportunityMetadata from "@salesforce/apex/WT_CreateOpportunityController.GetOpportunityMetadata";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class WT_CreateOpportunity extends NavigationMixin(LightningElement) {
    @api recordId;
    @api isCreatedFromOpportunityPageDirectly = false;
    isLoading = true;
    componentTitle = 'Create New Opportunity';
    shouldShowStep2 = false;
    hasAccountIdValue = false;
    hasProductValue = false;
    listProduct = [];
    mapProductIdAndOpportunityRecordTypeId = [];
    isEasyAccessPilotUser = false;
    newOpportunityRecordTypeId = '';
    currentUserId = '';
    mapOpportunityRecordTypeIdAndRecordTypeName = [];
    recordTypeName = '';
    isDepositRecordType = true;
    isInternationalRecordType = false;
    isLeasingRecordType = false;
    isLoanRecordType = false;
    isLetterOfCreditRecordType = false;
    isInvestmentRecordType = false;
    isEasyAccessLoanRecordType = false;
    isTMLoanRecordType = false;
    isOtherLoanRecordType = false;
    shouldShowFranchiseQuestions = false;
    franchiseComponentValue = 'No';
    shouldShowSyndicationQuestions = false;
    syndicationComponentValue = 'No';
    shouldShowWealthQuestions = false;
    wealthComponentValue = 'No';
    defaultProbabilityValue = '10';
    defaultStageValue = 'Stage 1 - Opportunity Identified';
    shouldShowABLQuestions = false;
    ablComponentValue = 'No';
    shouldShowSBAQuestions = false;
    sbaComponentValue = 'No';
    sbaTypeValue = 'SBA 504 Loan';
    shouldShowSwapQuestions = false;
    swapComponentValue = 'No';
    syndicationWtfcRoleValue = 'Underwritten';
    currentRunningUserProfileName = '';
    isFeeInvalid = false;            
    isInitialAmountDrawnInvalid = false;
    isEstimatedCloseDateAndProbabilityInvalid = false;  
    showWarningModal = false;
    shouldDisableCreateButton = false;
    shouldShowNewOpportunityCreationForm = false;

    connectedCallback(){
        this.getOpportunityMetadataOnLoad();
    }

    getOpportunityMetadataOnLoad(){
        getOpportunityMetadata()
            .then((data) => {
                this.listProduct = data.ListProduct;
                this.isEasyAccessPilotUser = data.IsEasyAccessPilotUser;
                if(data.MapProductIdAndOpportunityRecordTypeId){
                    for(var key in data.MapProductIdAndOpportunityRecordTypeId){
                        this.mapProductIdAndOpportunityRecordTypeId.push({key:key, value:data.MapProductIdAndOpportunityRecordTypeId[key]});
                    }
                }
                if(data.MapOpportunityRecordTypeIdAndRecordTypeName){
                    for(var key in data.MapOpportunityRecordTypeIdAndRecordTypeName){
                        this.mapOpportunityRecordTypeIdAndRecordTypeName.push({key:key, value:data.MapOpportunityRecordTypeIdAndRecordTypeName[key]});
                    }
                }
                this.currentUserId = data.CurrentRunningUserId;
                this.currentRunningUserProfileName = data.CurrentRunningUserProfileName;
                this.isLoading = false;
            })
            .catch((error) => {
                this.isLoading = false;
            });
    }

    handleNewButtonClick(event){
        this.shouldShowNewOpportunityCreationForm = true;
    }

    handleCancelClick(event){
        this.resetAllDefaultFlagsAndValues();
        this.shouldShowNewOpportunityCreationForm = false;
    }

    handleProductChange(event){
        this.setFieldValue('WT_Product__c', event.detail.value);
        if(event.detail.value != null && event.detail.value != ''){
            this.hasProductValue = true;  
            this.setRecordTypeId(event.detail.value); 
        }else{
            this.hasProductValue = false;
        }
        this.evaluateAccountIdField();
        this.evaluateStep2Visibility();
    }

    evaluateAccountIdField(){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.name === 'AccountId'){
                    if(field.value != null && field.value != ''){
                        this.hasAccountIdValue = true;  
                    }else{
                        this.hasAccountIdValue = false;  
                    }
                }
            });
        }
    }

    handleAccountIdChange(event){
        if(event.target.fieldName == 'AccountId'){
            if(event.detail.value != null && event.detail.value != ''){
                this.hasAccountIdValue = true;   
            }else{
                this.hasAccountIdValue = false;
            }
        }
        this.evaluateStep2Visibility();
    }

    evaluateStep2Visibility(){
        if(this.hasAccountIdValue && this.hasProductValue){
            this.shouldShowStep2 = true;
        }else {
            if(this.shouldShowStep2){
                this.resetAllDefaultFlagsAndValues();
            }
        }
    }

    resetAllDefaultFlagsAndValues(){
        this.shouldShowStep2 = false;
        this.shouldShowABLQuestions = false;
        this.ablComponentValue = 'No';
        this.shouldShowFranchiseQuestions = false;
        this.franchiseComponentValue = 'No';
        this.shouldShowSBAQuestions = false;
        this.sbaComponentValue = 'No';
        this.shouldShowSwapQuestions = false;
        this.swapComponentValue = 'No';
        this.shouldShowSyndicationQuestions = false;
        this.syndicationComponentValue = 'No';
        this.shouldShowWealthQuestions = false;
        this.wealthComponentValue = 'No';
        this.resetFields(['AccountId', 'WT_Product__c']);
    }

    setRecordTypeId(productId){
        let recordTypeId = '';
        if(this.mapProductIdAndOpportunityRecordTypeId){
            this.mapProductIdAndOpportunityRecordTypeId.forEach(item => {
                if(productId === item.key){
                    if(this.newOpportunityRecordTypeId != null && this.newOpportunityRecordTypeId != '' && this.newOpportunityRecordTypeId != item.value){
                        this.resetAllDefaultFlagsAndValues();
                    }
                    this.newOpportunityRecordTypeId = item.value;
                    recordTypeId = item.value;
                }
            });
        }

        if(this.mapOpportunityRecordTypeIdAndRecordTypeName){
            this.mapOpportunityRecordTypeIdAndRecordTypeName.forEach(item => {
                if(recordTypeId === item.key){                  
                    this.recordTypeName = item.value;
                    this.setFieldValue('WT_Record_Type_Name__c', this.recordTypeName);
                    if(this.recordTypeName === 'Deposit'){
                        this.isDepositRecordType = true;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'International'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = true;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'Leasing'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = true;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'Loan'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = true;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'Letter of Credit (Standby)'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = true;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'Investment'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = true;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'Easy Access Loan'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = true;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = false;
                        this.defaultStageValue = '1. Opportunity Identified';
                    } else if(this.recordTypeName === 'TM'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = true;
                        this.isOtherLoanRecordType = false;
                    } else if(this.recordTypeName === 'Other'){
                        this.isDepositRecordType = false;
                        this.isInternationalRecordType = false;
                        this.isLeasingRecordType = false;
                        this.isLoanRecordType = false;
                        this.isLetterOfCreditRecordType = false;
                        this.isInvestmentRecordType = false;
                        this.isEasyAccessLoanRecordType = false;
                        this.isTMLoanRecordType = false;
                        this.isOtherLoanRecordType = true;
                    }
                }
            });
        }
    }

    setFieldValue(fieldName, fieldValue){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.name === fieldName){
                    field.value = fieldValue;
                }
            });
        }
    }

    resetFields(listFieldToNotReset){
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(!listFieldToNotReset.includes(field.name)){
                    field.reset();
                }
            });
        }
    }

    handleInvolvesProductPartnerChange(event){
        let fieldValue = event.detail.value;

        this.shouldShowABLQuestions = false;
        this.ablComponentValue = 'No';
        this.shouldShowFranchiseQuestions = false;
        this.franchiseComponentValue = 'No';
        this.shouldShowSBAQuestions = false;
        this.sbaComponentValue = 'No';
        this.shouldShowSwapQuestions = false;
        this.swapComponentValue = 'No';
        this.shouldShowSyndicationQuestions = false;
        this.syndicationComponentValue = 'No';
        this.shouldShowWealthQuestions = false;
        this.wealthComponentValue = 'No';
        
        if(fieldValue){
            if(fieldValue.includes('ABL')){
                this.shouldShowABLQuestions = true;
                this.ablComponentValue = 'Yes';
            }
            if(fieldValue.includes('Franchise')){
                this.shouldShowFranchiseQuestions = true;
                this.franchiseComponentValue = 'Yes';
            }
            if(fieldValue.includes('SBA')){
                this.shouldShowSBAQuestions = true;
                this.sbaComponentValue = 'Yes';
            }
            if(fieldValue.includes('Swap')){
                this.shouldShowSwapQuestions = true;
                this.swapComponentValue = 'Yes';
            }
            if(fieldValue.includes('Syndication')){
                this.shouldShowSyndicationQuestions = true;
                this.syndicationComponentValue = 'Yes';
            }
            if(fieldValue.includes('Wealth')){
                this.shouldShowWealthQuestions = true;
                this.wealthComponentValue = 'Yes';
            }
        }
    }

    handleSuccess(event){
        if(this.isCreatedFromOpportunityPageDirectly){
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: event.detail.id,
                    objectApiName: 'Opportunity',
                    actionName: 'view'
                },
            }); 
        }else{
            eval("$A.get('e.force:refreshView').fire();");
            this.isLoading = false;
            this.shouldDisableCreateButton = false;
            this.shouldShowNewOpportunityCreationForm = false;
            this.resetAllDefaultFlagsAndValues();
            this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Opportunity has been successfully created', variant: 'success' }));
        }        
    }

    handleError(event){
        this.isLoading = false;
        this.shouldDisableCreateButton = false;
        this.dispatchEvent(new ShowToastEvent({ title: 'Error', message: 'Unable to create a new opportunity', variant: 'error' }));
    }

    handleSubmit(event){
        event.preventDefault();
        this.shouldDisableCreateButton = true;
        const fields = event.detail.fields;
        let fee;
        let initialAmountDrawm;
        let closeDate;
        let probability;
        const inputFields = this.template.querySelectorAll(
            'lightning-input-field'
        );
        if (inputFields) {
            inputFields.forEach(field => {
                if(field.name === 'WT_Fee__c'){
                    fee = field.value;
                } else if(field.name === 'WT_Initial_Amount_Drawn__c'){
                    initialAmountDrawm = field.value;
                } else if(field.name === 'CloseDate'){
                    closeDate = field.value;
                } else if(field.name === 'WT_Probability__c'){
                    probability = field.value;
                }
            });
        }
        this.validateOpportunityFields(this.currentRunningUserProfileName, fee, initialAmountDrawm, closeDate, probability);
        if (!this.isFeeInvalid && !this.isInitialAmountDrawnInvalid && !this.isEstimatedCloseDateAndProbabilityInvalid){
            this.isLoading = true;
            this.template.querySelector('lightning-record-edit-form').submit(fields);             
        }else{
            event.stopPropagation();
        }
    }

    validateOpportunityFields(profileName, fee, initialamountDrawn, closeDate, probability){
        this.isFeeInvalid = false;            
        this.isInitialAmountDrawnInvalid = false;
        this.isEstimatedCloseDateAndProbabilityInvalid = false;             
        if (profileName == 'System Administrator' || profileName == 'WT Business Administrator' 
            || profileName == 'WT Technical Administrator' || profileName == 'WT Commercial'){
            //Check If Fee $ >= 1 million
            if (fee != null && fee >= 1000000){            
                this.isFeeInvalid = true;            
            }         
            //Check If Estimated Close Date >= 6months from current date and Probability is 50% or 75% or 90%
            if (closeDate != null && probability != null){            
                let closeDateOnly = this.parseDate(closeDate);
                closeDateOnly.setHours(0, 0, 0, 0);
                let todayDate = new Date();
                let currentDateWith6Months = new Date(todayDate.setMonth(todayDate.getMonth() + 6));
                currentDateWith6Months.setHours(0, 0, 0, 0);               
                if (closeDateOnly >= currentDateWith6Months && (probability == '50' || probability == '75' || probability == '90')){
                    this.isEstimatedCloseDateAndProbabilityInvalid = true;
                }
            }      
            //Check If Initial Amount Drawn $ >= 10 million
            if (initialamountDrawn != null && initialamountDrawn >= 10000000){            
                this.isInitialAmountDrawnInvalid = true;            
            }   
            //Show Model Popup If validation matches
            if (this.isFeeInvalid == true || this.isInitialAmountDrawnInvalid == true || this.isEstimatedCloseDateAndProbabilityInvalid == true){
                this.openModal();    
            }
        }
    }
    //function to parse a date in yyyy-mm-dd format
    parseDate(input)
    {
        let parts = input.split('-');  
        // new Date(year, month [, day [, hours[, minutes[, seconds[, ms]]]]])
        return new Date(parts[0], parts[1]-1, parts[2]); // Note: months are 0-based
    }

    openModal(){
        this.showWarningModal = true;
    }  
    //function to close modal window by setting property as false 
    closeModal(){
        this.showWarningModal = false;
    }

    saveModal(){
        this.isLoading = true;
        this.template.querySelector('lightning-record-edit-form').submit();
        this.closeModal();
    }
}