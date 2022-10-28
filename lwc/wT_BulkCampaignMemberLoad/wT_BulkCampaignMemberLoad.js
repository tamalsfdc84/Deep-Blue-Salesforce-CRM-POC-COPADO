import { LightningElement, wire, track } from 'lwc';
import runCampaignMembersLoadBatch  from '@salesforce/apex/WT_CampaignMembersLoadBatchExecute.runCampaignMembersLoadBatch';
import { NavigationMixin } from 'lightning/navigation';
import PROFILE_NAME from '@salesforce/schema/User.Profile.Name';
import USER_ID from '@salesforce/user/Id';
import {getRecord} from 'lightning/uiRecordApi';
export default class WT_BulkCampaignMemberLoad extends NavigationMixin(LightningElement){
    @track message;
    @track isModalOpen = true;
    @track errorMessage;
    @track profileName;
    @wire(getRecord, {recordId:USER_ID, fields:[PROFILE_NAME]}) userData({data, error})
    {
        if(data)
        {
            this.profileName=data.fields.Profile.value.fields.Name.value;
            if(this.profileName.includes('Administrator'))
            { 
                this.message = 'Batch subimitted successfully - Will receive emails with further details';
                runCampaignMembersLoadBatch();            
            }
            else 
            {
                this.message = 'No Access - Only System Admin can submit bulk load';
            }
        }
        else if (error) 
        {
            this.errorMessage = 'Unable to get User Data';
            this.message ='';
            if (Array.isArray(error.body)) 
            {
                this.errorMessage = error.body.map(e => e.message).join(', ');
            }
            else if (typeof error.body.message === 'string') 
            {
                this.errorMessage = error.body.message;
            }
        }
    }
    closeModal() {
        this.isModalOpen = false;
        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'Campaign',
                actionName: 'list',
            },
            state: {
                filterName: 'Recent'
            },
        });
    }
}