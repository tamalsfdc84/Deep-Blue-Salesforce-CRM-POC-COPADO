import { LightningElement, api, wire, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord } from 'lightning/uiRecordApi';
import UserId from '@salesforce/user/Id';
import UserProfileId from '@salesforce/schema/User.ProfileId';
import UserProfileName from '@salesforce/schema/User.Profile.Name';
import getOportunityEditAccess from '@salesforce/apex/WT_OpportunityPageController.checkOpportunityEditAccess';
import getOpportunityDetails from '@salesforce/apex/WT_OpportunityPageController.returnOpportunityDetails';
export default class WT_OpportunityPage extends NavigationMixin(LightningElement) 
{
    @api recordId;
    @api objectApiName;
    @track objectInfo;
    @track record;
    @track error;
    @track errorMessage;
    @api showReadOnlySection = false;
    @api showEditSection = false;     
    @api isEditButtonClick = false;
    bShowModal = false;   
    isFeeInvalid = false;
    isInitialAmountDrawnInvalid = false;
    isEstimatedCloseDateAndProbabilityInvalid = false;   
    showTMDetailsLayout = false;
    showLoanProductPartnerDetailsLayout = false;
    showDepositOpportunityDetailsLayout = false;    
    showDepositProductPartnerDetailsLayout = false;
    showCommonOpportunityDetailsLayout = false;
    showLeasingOpportunityDetailsLayout = false;
    showInternationalOpportunityDetailsLayout = false;
    showInvestmentOpportunityDetailsLayout = false;    
    showLoanOpportunityDetailsLayout = false;
    showEditButton = false;
    currentUserProfileId;
    currentUserProfileName;
    error;
    isEasyAccessLoan = false;
    @track isSaving = false;
    @wire(getRecord, { recordId: UserId, fields: [UserProfileId,UserProfileName]}) 
    userDetails({error, data}) {
        if (data)
        {            
            this.currentUserProfileId = data.fields.ProfileId.value;
            this.currentUserProfileName = data.fields.Profile.value.fields.Name.value;
        }
        else if (error)
        {
            this.error = error;
        }
    }
    connectedCallback() {        
        if (this.objectApiName == 'Opportunity') {
            getOpportunityDetails({ opportunityId: this.recordId })
                .then(result => {
                    if ((result != undefined && result != null)) {
                        this.record = result;
                        if(result.WT_Record_Type_Name__c == 'Easy Access Loan'){
                            this.isEasyAccessLoan = true;
                        }else{
                            this.isEasyAccessLoan = false;
                        }
                        this.setRecordTypeLayout(result.WT_Record_Type_Name__c);
                        this.checkOpportunityEditAccess();                       
                    }
                    else {
                        this.errorMessage = 'Please Contact Your Administrator';
                    }
                })
        }
    } 
   //function to check Opportunity Edit Access
    checkOpportunityEditAccess()
    {
        getOportunityEditAccess({ opportunityId: this.recordId })
            .then(result => {            
                this.showEditButton = result;            
                //Display Message If User does not have Edit access and click on Edit Button 
                if (this.isEditButtonClick == true)
                {
                    if (result == true) //if User has Edit access
                    {
                        this.showReadOnlySection = false;
                        this.showEditSection = true;                        
                    }
                    else if (result == false) //if User does not have Edit access
                    { 
                        const evt = new ShowToastEvent({
                            title: 'Warning!',
                            message: ' You do not have access to edit this Opportunity. ',
                            variant: 'error'
                        });
                        this.dispatchEvent(evt);                          
                        //Redirect to View mode
                        this.redirectToViewForEditButton();                      
                    } 
                }
                else
                {
                    this.showReadOnlySection = true;
                }
        })        
    } 
    //function to set Record Type specific Layouts
    setRecordTypeLayout(recordType)
    {
        if (recordType != null && recordType != undefined)
        {
            if (recordType == 'TM')
            {
                this.showCommonOpportunityDetailsLayout = true;
                this.showTMDetailsLayout = true;
            }
            else if (recordType == 'Loan' || recordType == 'Easy Access Loan')
            {
                this.showLoanOpportunityDetailsLayout = true;
                this.showLoanProductPartnerDetailsLayout = true;    
            }
            else if (recordType == 'Deposit')
            {
                this.showDepositOpportunityDetailsLayout = true;
                this.showDepositProductPartnerDetailsLayout = true;    
            }  
            else if (recordType == 'Leasing')
            {                
                this.showLeasingOpportunityDetailsLayout = true;    
            }  
            else if (recordType == 'International')
            {             
                this.showInternationalOpportunityDetailsLayout = true;    
            }  
            else if (recordType == 'Investment')
            {             
                this.showInvestmentOpportunityDetailsLayout = true;    
            }  
            else if (recordType == 'Letter of Credit (Standby)')
            {             
                this.showDepositOpportunityDetailsLayout = true;    
            }  
            else
            {
                this.showCommonOpportunityDetailsLayout = true;
            }
        }        
    }
    //function for Save Button Click
    handleSubmit(event)
    {   
        event.preventDefault(); // stop the form from submitting
        const fields = event.detail.fields;
        this.validateOpportunityFields(this.currentUserProfileName, fields.WT_Fee__c, fields.WT_Initial_Amount_Drawn__c, fields.CloseDate, fields.WT_Probability__c,false);      
        if (this.isFeeInvalid == false && this.isInitialAmountDrawnInvalid == false && this.isEstimatedCloseDateAndProbabilityInvalid == false)
        {
            //Show Spinner
            this.isSaving = true;
            //Save the data
            this.template.querySelector('lightning-record-edit-form').submit();             
            
            // window.setTimeout(() => { this.redirectToView(event); }, 1000);
        }    
    }
    //Redirect to View mode for Edit Button if User does not have Edit Accesss
    redirectToViewForEditButton()
    {     
        let recordPageUrl = '';
        this[NavigationMixin.GenerateUrl]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                actionName: 'view',
            },
        }).then((url) => {
            recordPageUrl = url;
            window.location.href = recordPageUrl;
        });
    }
    //Redirect to View mode for Cancel Button
    redirectToView(event)
    {
        this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    objectApiName: this.objectApiName,
                    actionName: 'view'
                },
            }); 
    }
    handleSuccess(event)
    {
        this.redirectToView(event);
    }

    handleError(event){
        this.isSaving = false;
        const scrollOptions = {
            left: 0,
            top: 0,
            behavior: 'smooth'
        }
        window.scrollTo(scrollOptions);
    }

    //function to open modal window by setting property as true
    openModal()
    {
        this.bShowModal = true;
    }  
    //function to close modal window by setting property as false 
    closeModal()
    {
        this.bShowModal = false;
    }
    //function to close modal window by setting property as false
    saveModal(event)
    {      
        this.template.querySelector('lightning-record-edit-form').submit();
        this.closeModal();
        //Show Spinner
        this.isSaving = true;
        window.setTimeout(() => { this.redirectToView(event); }, 1000);
    }
    //function for Cancel button
    handleCloseModal(event)
    {
        //Redirect to View mode
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: this.objectApiName,
                actionName: 'view'
            },
        });
    }
    //function for Edit button
    handleUpdateModal(event)
    {
        this.showReadOnlySection = false;
        this.showEditSection = true;
    }    
    //function to validate Opportunity data
    validateOpportunityFields(profileName,fee,initialamountDrawn,closeDate,probability,onload)
    {
        //We need to reset to False for each Submit click
        this.isFeeInvalid = false;            
        this.isInitialAmountDrawnInvalid = false;
        this.isEstimatedCloseDateAndProbabilityInvalid = false;             
        if (profileName == 'System Administrator' || profileName == 'WT Business Administrator' || profileName == 'WT Technical Administrator' || profileName == 'WT Commercial')
        {
            //Check If Fee $ >= 1 million
            if (fee != null && fee >= 1000000)
            {            
                this.isFeeInvalid = true;            
            }         
            //Check If Estimated Close Date >= 6months from current date and Probability is 50% or 75% or 90%
            if (closeDate != null && probability != null)
            {            
                var closeDateOnly = this.parseDate(closeDate);
                closeDateOnly.setHours(0, 0, 0, 0);
                var todayDate = new Date();
                var currentDateWith6Months = new Date(todayDate.setMonth(todayDate.getMonth() + 6));
                currentDateWith6Months.setHours(0, 0, 0, 0);               
                if (closeDateOnly >= currentDateWith6Months && (probability == '50' || probability == '75' || probability == '90'))
                {
                    this.isEstimatedCloseDateAndProbabilityInvalid = true;
                }
            }      
            //Check If Initial Amount Drawn $ >= 10 million
            if (initialamountDrawn != null && initialamountDrawn >= 10000000)
            {            
                this.isInitialAmountDrawnInvalid = true;            
            }   
            //Show Model Popup If validation matches
            if (this.isFeeInvalid == true || this.isInitialAmountDrawnInvalid == true || this.isEstimatedCloseDateAndProbabilityInvalid == true)
            {
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
}