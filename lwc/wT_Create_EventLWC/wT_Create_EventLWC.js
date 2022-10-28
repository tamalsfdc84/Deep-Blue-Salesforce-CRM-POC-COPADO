import { LightningElement, api, wire, track } from 'lwc';
import createEventRecord from '@salesforce/apex/WT_EventController.createEventRecord';
import relatedToRecord from '@salesforce/apex/WT_EventController.relatedToRecord';
const DELAY = 1500;
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import EVENT_OBJECT from '@salesforce/schema/Event';

export default class WT_Create_EventLWC extends LightningElement {
  @api subject;
  @api recordType;
  eventId;
  startValue;
  endValue;
  activityTypeValue = 'Appointment';
  objectApiNames = EVENT_OBJECT.objectApiName;
  isLoading = true;
  @track recordsList;
  searchKey = "";
  selectedValue;
  selectedRecordId;
  objectApiName = 'Account';
  iconName = 'standard:account';
  lookupLabel = 'Related To';
  message;
  isRequired = false;
  recordVisible = false;
  get title() {
    if (this.recordType == 'WT_Wintrust_Event') { return 'Wintrust Event'; }
    else { return 'CRA Event'; }
  }
  get options() {
    return [
      { label: 'Appointment', value: 'Appointment' },
      { label: 'Email', value: 'Email' },
      { label: 'Task', value: 'Task' },
    ];
  }
  @wire(relatedToRecord, { searchKey: '$searchKey', objectName: '$objectApiName' })
  responseMethod({ error, data }) {
    if (data) {
      if (data.length === 0) {
        this.recordsList = [];
        this.message = "No Records Found";
      } else {
        this.recordsList = data;
        this.message = "";
      }
    }
    else if (error) {
      this.error = error;
      this.recordsList = undefined;
    }
  }
  activeAction(event) {
    this.recordVisible = true;
  }
  handleKeyChange(event) {
    window.clearTimeout(this.delayTimeout);
    const searchKey = event.target.value;
    this.delayTimeout = setTimeout(() => {
      this.searchKey = searchKey;
    }, DELAY);
  }
  @api removeRecordSelection() {
    this.searchKey = "";
    this.selectedValue = null;
    this.selectedRecordId = null;
    this.recordsList = null;
    this.isRequired = true;
    this.onSeletedRecordUpdate();
  }
  onLeave(event) {
    setTimeout(() => {
      this.searchKey = "";
      this.recordsList = null;
    }, 300);
  }
  onRecordSelection(event) {
    this.selectedRecordId = event.currentTarget.dataset.id;
    this.selectedValue = event.currentTarget.dataset.name;
    this.searchKey = "";
    this.isRequired = false;
    this.onSeletedRecordUpdate();
  }
  removeRecordOnLookup(event) {
    this.searchKey = "";
    this.selectedValue = null;
    this.selectedRecordId = null;
    this.recordsList = null;
    this.isRequired = true;
    this.onSeletedRecordUpdate();
  }
  handleTypeChange(event) {
    this.activityTypeValue = event.detail.value;
  }
  handleStartChange(event) {
    this.startValue = event.detail.value;
  }
  handleEndChange(event) {
    this.endValue = event.detail.value;
  }
  createEvent() {

    createEventRecord({
      subject: this.subject, activityTypeValue: this.activityTypeValue, recordType: this.recordType,
      startValue: this.startValue, endValue: this.endValue, relatedTo: this.selectedRecordId
    })
      .then(event => {
        this.dispatchEvent(
          new ShowToastEvent({ title: 'Success', message: 'Event created', variant: 'success', }),
        );
      })
      .catch(error => {
        this.dispatchEvent(
          new ShowToastEvent({ title: 'Error creating record', message: error.body.message, variant: 'error', }),
        );
      });
  }
}