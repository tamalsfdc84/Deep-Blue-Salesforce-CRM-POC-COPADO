import { LightningElement, track, wire, api } from 'lwc';
import { deleteRecord, updateRecord } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getRecordDetails from '@salesforce/apex/WT_RelationshipGroupMemberController.getRelationshipRecord';
import updateRecordDetails from '@salesforce/apex/WT_RelationshipGroupMemberController.updateRelationshipRecord';
import { publish, MessageContext } from 'lightning/messageService';
import RGChannel from '@salesforce/messageChannel/RGMessageChannel__c';
import NAME_FIELD from '@salesforce/schema/WT_RelationshipGroup_Relation__c.WT_RelatedAccount__c';
import FDC_FIELD from '@salesforce/schema/Account.WT_First_Date_Of_Contact__c';
import LDC_FIELD from '@salesforce/schema/Account.WT_Last_Date_Of_Contact__c';
import TFA_FIELD from '@salesforce/schema/Account.FinServ__TotalFinancialAccounts__c';
import RGSTARTDATE_FIELD from '@salesforce/schema/Account.FinServ__RelationshipStartDate__c';
import ERRORMSGPRIMARY from '@salesforce/label/c.WT_ErrorMsgonPrimaryMember';

const BADGELABEL = ' Who Are the Members of This Group?';
const OBJECTNAME = 'WT_RelationshipGroup_Relation__c';
export default class WT_RelationshipGroup_MembersLWC extends LightningElement {
  @api recordId;
  @api objectApiName;
  @api title;
  @track recordsList = [];
  listOfResult = [];
  objectApiNames = OBJECTNAME;
  relatedAccountField = NAME_FIELD;
  lastDateOfContactField = LDC_FIELD;
  firstDateOfContactField = FDC_FIELD;
  startDateField = RGSTARTDATE_FIELD;
  totalFinancialAccountField = TFA_FIELD;
  labelBadge = BADGELABEL;
  numberOfRecords = 0;
  isModal = false;
  isAddRow = false;
  isRowActive = false;
  isLoading = true;
  isModalLoading = false;
  isRowLoading = false;
  errorMessage;

  get titleHeader() {
    return this.title + ' (' + this.numberOfRecords + ')';
  }
  // wired message context
  @wire(MessageContext) messageContext;
  @wire(getRecordDetails, { accountId: '$recordId' }) wiredBoats(result) {
    this.listOfResult = result;
    if (result.data) {
      this.recordsList = result.data;
      this.numberOfRecords = this.recordsList.length;
      this.isLoading = false;
      this.isModalLoading = false;
    }
    else {
      this.recordsList = undefined;
      this.numberOfRecords = 0;
      this.isLoading = false;
      this.isModalLoading = false;
    }
  }
  sendMessageService(accountRecordId) {
    // explicitly pass Account recordId to the parameter recordId
    const payload = { recordId: accountRecordId };
    try {
      publish(this.messageContext, RGChannel, payload);
    }
    catch (error) {
      console.error("Error refreshing progress bars", error);
    }
  }
  handleEditGroup() {
    this.isModal = true;
    this.isModalLoading = false;
  }
  handleCloseModal() {
    this.isModal = false;
    this.isAddRow = false;
    this.isRowLoading = false;
    this.errorMessage = '';
    this.isRowActive = false;
    this.sendMessageService(this.recordId);
    eval("$A.get('e.force:refreshView').fire();");
  }
  handleAddRow() {
    this.isAddRow = true;
    this.isRowLoading = true;
  }
  handleRowLoad() {
    this.isRowLoading = false;
  }
  handleRowSubmit() {
    this.isModalLoading = true;
  }
  handleRowSuccess(event) {
    this.isAddRow = false;
    this.isRowActive = false;
    refreshApex(this.listOfResult);
  }
  handleRowError(event) {
    this.isModalLoading = false;
    //this.errorMessage = event.detail.output.fieldErrors[0] +' '+event.detail.message;
    /* "Error on Validation Msg"+event.detail.output.fieldErrors[0]+"Error on General msg "+event.detail.message*/
    /* const evt = new ShowToastEvent({ title: 'Error!', message: 'Review the following errors.', variant: 'error'});
    this.dispatchEvent(evt);*/
  }
  handleRowActive(event) {
    this.isRowActive = event.target.checked;
  }
  handleSaveModal() {
    this.isModalLoading = true;
    let mapToogle = new Map();
    var count = 0;
    var varMessage;
    let updateRelationRecord = [];
    for (let x of this.template.querySelectorAll("[data-field='Primary']")) {
      mapToogle.set(x.name, x.checked);
      if (x.checked) { count = count + 1; }
    }
    if (count > 1) {
      this.errorMessage = ERRORMSGPRIMARY;
      this.isModalLoading = false;
      return null;
    }
    else { this.errorMessage = ''; }
    for (let x of this.recordsList) {
      if (x.WT_Primary__c != mapToogle.get(x.Id)) {
        updateRelationRecord.push(JSON.parse(JSON.stringify(x)));
      }
    }
    if (updateRelationRecord.length > 0) {
      updateRecordDetails({ relationRecords: updateRelationRecord })
        .then(result => {
          varMessage = result;
          if (varMessage === 'Member was updated.') {
            this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: varMessage, variant: 'success' }));
            refreshApex(this.listOfResult);
            this.handleCloseModal();
            return null;
          }
          else {
            this.dispatchEvent(new ShowToastEvent({ title: 'Error updating record', message: varMessage, variant: 'error' }));
            this.isModalLoading = false;
          }
        })
        .catch(error => {
          if (error) {
            if (Array.isArray(error.body)) {
              varMessage = error.body.map(e => e.message).join(', ');
              this.errorMessage = varMessage;
            }
            else if (typeof error.body.message === 'string') {
              varMessage = error.body.message;
              this.errorMessage = varMessage;
            }
            varMessage = 'Please contact Administrator';
            this.dispatchEvent(new ShowToastEvent({ title: 'Error updating record', message: varMessage, variant: 'error' }));
            this.isModalLoading = false;
          }
        });
    }
    else {
      refreshApex(this.listOfResult);
      this.handleCloseModal();
    }
  }
  handleDeleteRelation(event) {
    const containerId = event.target.value;
    var unSelectedRecords = [];
    this.isLoading = true;
    this.isModalLoading = true;
    deleteRecord(containerId)
      .then(() => {
        this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Relationship was deleted.', variant: 'success' }));
        for (let x of this.recordsList) {
          if (containerId != x.Id) {
            unSelectedRecords.push(JSON.parse(JSON.stringify(x)));
          }
        }
        this.numberOfRecords = this.numberOfRecords - 1;
        this.recordsList = unSelectedRecords;
        this.isLoading = false;
        this.isModalLoading = false;
      })
      .catch(error => {
        this.dispatchEvent(new ShowToastEvent({ title: 'Error deleting record', message: error.body.message, variant: 'error' }));
        this.isLoading = false;
        this.isModalLoading = false;
      });
  }
  handleTileButton(event) {
    const menuName = event.detail.name;
    const containerId = event.detail.id;
    var unSelectedRecords = [];
    if (menuName == 'remove') {
      this.isLoading = true;
      const recordInput = { "fields": { "Id": containerId, "WT_Active__c": false } };
      updateRecord(recordInput)
        .then(() => {
          this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Member was removed.', variant: 'success' }));
          for (let x of this.recordsList) {
            if (containerId != x.Id) {
              unSelectedRecords.push(JSON.parse(JSON.stringify(x)));
            }
          }
          this.numberOfRecords = this.numberOfRecords - 1;
          this.recordsList = unSelectedRecords;
          this.isLoading = false;
          this.handleCloseModal();
        })
        .catch(error => {
          this.dispatchEvent(new ShowToastEvent({ title: 'Error updating record', message: error.body.message, variant: 'error' }));
          this.isLoading = false;
        });
    } else if (menuName == 'edit') {
      this.handleEditGroup();
    } else if (menuName == 'delete') {
      this.isLoading = true;
      this.isModalLoading = true;
      deleteRecord(containerId)
        .then(() => {
          this.dispatchEvent(new ShowToastEvent({ title: 'Success', message: 'Relationship was deleted.', variant: 'success' }));
          for (let x of this.recordsList) {
            if (containerId != x.Id) {
              unSelectedRecords.push(JSON.parse(JSON.stringify(x)));
            }
          }
          this.numberOfRecords = this.numberOfRecords - 1;
          this.recordsList = unSelectedRecords;
          this.isLoading = false;
          this.isModalLoading = false;
          this.handleCloseModal();
        })
        .catch(error => {
          this.dispatchEvent(new ShowToastEvent({ title: 'Error deleting record', message: error.body.message, variant: 'error' }));
          this.isLoading = false;
          this.isModalLoading = false;
        });
    }
  }
}