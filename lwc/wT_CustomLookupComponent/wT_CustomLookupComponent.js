import { LightningElement, track, wire, api } from "lwc";
import findRecords from "@salesforce/apex/WT_ReferralNewOverrideController.findRecords";
const DELAY = 1500;
export default class WT_CustomLookupComponent extends LightningElement {
  @track recordsList;
  @track searchKey = "" ;
  @api filterValue;
  @api selectedValue;
  @api selectedRecordId;
  @api objectApiName;
  @api iconName;
  @api lookupLabel;
  @track message;
  @track isRequired = false;
  @track recordVisible = false;
  @wire(findRecords,{ searchKey: '$searchKey', objectName: '$objectApiName', filterValue: '$filterValue' })
  responseMethod({error,data}){
    if(data){
      if (data.length === 0) {
        this.recordsList = [];
        this.message = "No Records Found";
      } else {
        this.recordsList = data;
        this.message = "";
      }
    }
    else if(error){
      this.error = error;
      this.recordsList = undefined;
    }
  }
  activeAction(event){
    this.recordVisible = true;
  }
  handleKeyChange(event) {
    window.clearTimeout(this.delayTimeout);
    const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
            this.searchKey = searchKey;
        }, DELAY);
  }
  @api removeRecordSelection(){
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
  onSeletedRecordUpdate() {
    const passEventr = new CustomEvent('recordselection', {
      detail: { selectedRecordId: this.selectedRecordId, selectedValue: this.selectedValue }
    });
    this.dispatchEvent(passEventr);
  }
}