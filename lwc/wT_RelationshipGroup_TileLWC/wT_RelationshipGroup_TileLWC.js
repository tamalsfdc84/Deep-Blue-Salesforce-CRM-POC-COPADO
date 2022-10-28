import { LightningElement, api } from 'lwc';

const PERSONICON = 'standard:person_account';
const BUSINESSICON = 'standard:account';
const ACTION = [
    { label: 'Edit Relationship', value: 'edit', iconName: 'action:edit' },
    { label: 'Remove Member', value: 'remove', iconName: 'action:remove_relationship' },
    { label: 'Delete Relationship', value: 'delete', iconName: 'action:delete' },   ];
   
export default class WT_RelationshipGroup_TileLWC extends LightningElement {
    @api relatedAccount; 
    actions = ACTION;
       
        get fetchIconName()
        {
            const recordName = this.relatedAccount.WT_RelatedAccount__r.RecordType.Name;
            if(recordName.includes('Person Account'))
              {  return PERSONICON; }
           return BUSINESSICON;
        }
        get fetchURL()
        {
            return '/lightning/r/' + this.relatedAccount.WT_RelatedAccount__c + '/view';
        }
        handleButtonMenu(event) {
            // Get the value of the selected action
            const tileAction = event.detail.action.value;
            const recordId = this.relatedAccount.Id;  
            const buttonEvent = new CustomEvent('button',{ detail:{name : tileAction, id : recordId}});             
            this.dispatchEvent(buttonEvent);
        }
}