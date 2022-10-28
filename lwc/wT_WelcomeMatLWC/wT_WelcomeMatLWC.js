/* eslint-disable no-undef */
import { LightningElement, api, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import profileDetails from '@salesforce/apex/WT_WelcomeMatController.userProfile';

export default class wT_WelcomeMatLWC extends NavigationMixin(LightningElement){
    @track isWealth = false;
    @track isRetail = false;
    connectedCallback() {
        profileDetails({})
        .then(result => {
            if(result == 'WT Retail'){
                this.isRetail = true;
            }
            else if(result == 'WT Wealth' || result == 'WT Mortgage'){
                this.isWealth = true;
            }
          })
    }
    handleClickDB()
    {
        window.open("https://wintrust.sharepoint.com/:w:/g/frontline/CRMSite/ES4MR9vYs4RCt9qaN4fLYvkBdlT9NmwYKZGRQHRJSPBQfA");
    }

    handleClickSearch()
    {        
        if(this.isRetail){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Locate%20a%20Customer%20or%20Prospect%20-%20Salesforce%20Go%20Live%20Support.pdf");
        }
        if(this.isWealth){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Locate%20a%20Customer%20or%20Prospect%20-%20Salesforce%20Go%20Live%20Support.pdf");   
        }
    }

    handleCreateProspect()
    {
        if(this.isRetail){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Create%20a%20Prospect%20-%20Salesforce%20Go%20Live%20Support.pdf");
        }
        if(this.isWealth){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Create%20a%20Prospect%20-%20Salesforce%20Go%20Live%20Support.pdf");   
        }
    }

    handleCreateReferral()
    {
        if(this.isRetail){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Create%20a%20Referral%20-%20Salesforce%20Go%20Live%20Support.pdf");
        }
        if(this.isWealth){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Create%20a%20Referral%20-%20Salesforce%20Go%20Live%20Support.pdf");   
        }
    }

    handleQualifyReferral()
    {
        if(this.isRetail){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Qualifying%20a%20Referral%20-%20Salesforce%20Go%20Live%20Support.pdf");
        }
        if(this.isWealth){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Qualifying%20a%20Referral%20-%20Salesforce%20Go%20Live%20Support.pdf");   
        }
    }

    handleActivity()
    {
        if(this.isRetail){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Log%20a%20Phone%20Call%20-%20Salesforce%20Go%20Live%20Support.pdf");
        }
        if(this.isWealth){
            window.open("https://wintrust.sharepoint.com/Initiatives/DEEPBLUE/Shared%20Documents/Log%20a%20Phone%20Call%20-%20Salesforce%20Go%20Live%20Support.pdf");   
        }
    }

}