import { LightningElement, wire } from 'lwc';
import getBlockedUserData from '@salesforce/apex/WT_BlockedUserAutoProvisionController.GetBlockedUserData';
import getLicenseUsageData from '@salesforce/apex/WT_BlockedUserAutoProvisionController.GetLicenseUsageData';
import releaseBlockedUser from '@salesforce/apex/WT_BlockedUserAutoProvisionController.ReleaseBlockedUser';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

const blockedUserColumns = [
    { label: 'User Name', fieldName: 'UserFullName', type: 'text' },
    { label: 'User Email', fieldName: 'UserEmail', type: 'text' },
    { label: 'Date Blocked', fieldName: 'DateBlocked', type: 'date', typeAttributes:{
                                                                        year: "numeric",
                                                                        month: "long",
                                                                        day: "2-digit",
                                                                        hour: "2-digit",
                                                                        minute: "2-digit"
                                                                    }
    },
    { label: 'User Profile', fieldName: 'UserProfileName', type: 'text' },
    { label: 'User License', fieldName: 'UserLicenseName', type: 'text' },
    {type: "button", typeAttributes: {  
        label: 'Release',  
        name: 'release',  
        title: 'Release',  
        disabled: false,  
        value: 'Release',  
        iconPosition: 'left',
        variant: 'brand'
    }}
];

export default class WT_BlockedUserAutoProvision extends LightningElement {
    blockedUserColumns = blockedUserColumns;
    licenseUsageData;
    listProfileLicenseUsageResponseModel;
    shouldShowSpinner = true;
    blockedUserData;

    @wire(getLicenseUsageData)
    wiredLicenseData({ error, data }) {
        if (data) {
            this.licenseUsageData = data;
            this.listProfileLicenseUsageResponseModel = data.ListProfileLicenseUsageResponseModel;
            this.getBlockedUserDataFromController();            
        } else if (error) {
            
        }
    }

    getBlockedUserDataFromController(){
        getBlockedUserData()
        .then(result => {
            if(result){
                this.blockedUserData = result;
                this.shouldShowSpinner = false;
            }
        })
        .catch(error => {
            this.shouldShowSpinner = false;
        });
    }

    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'release':
                this.shouldShowSpinner = true;
                this.releaseUser(row.AutoProvisionedBlockedUserId);
                break;
        }
    }

    releaseUser(autoProvisionedBlockedUserId){
        releaseBlockedUser({ autoProvisionedBlockedUserId: autoProvisionedBlockedUserId})
            .then(result => {
                if(result){
                    this.showToast(true);
                    this.refreshComponentData();
                }
            })
            .catch(error => {
                this.shouldShowSpinner = false;
            });
    }

    refreshComponentData(){
        getLicenseUsageData()
        .then(result => {
            this.licenseUsageData = result;
            this.listProfileLicenseUsageResponseModel = result.ListProfileLicenseUsageResponseModel;
        })
        .catch(error => {
            this.shouldShowSpinner = false;
        });

        this.getBlockedUserDataFromController();
    }

    showToast(isSuccess) {
        let title = 'Success!';
        let variant = 'success';
        let message = 'User successfully released.';
        if(!isSuccess){
            title = 'Error!';
            variant = 'error';
            message = 'Error. Something went wrong. User wasn\'t successfully released.';
        }
        const event = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(event);
    }
}