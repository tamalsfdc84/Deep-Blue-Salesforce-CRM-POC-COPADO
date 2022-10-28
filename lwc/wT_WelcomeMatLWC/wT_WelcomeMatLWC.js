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
    handleClickSharepointLink()
    {
        window.open("https://wintrust.sharepoint.com/sites/Salesforce");
    }

   
   

}