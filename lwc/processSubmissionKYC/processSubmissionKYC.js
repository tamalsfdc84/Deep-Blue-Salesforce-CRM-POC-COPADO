import { LightningElement,api, track, wire } from 'lwc';
import { getRecord, getFieldDisplayValue } from 'lightning/uiRecordApi';
import { getPicklistValues ,getObjectInfo} from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';

//  objects
import Submission__c from '@salesforce/schema/tffa__Submission__c';

//  fields
import tffa__KYCApprovalReason__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCApprovalReason__c';
import tffa__KYCDeclinedReason__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCDeclinedReason__c';
import tffa__KYCDecisionOverrideComments__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCDecisionOverrideComments__c';
import tffa__KYCDecisionOutcome__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCDecisionOutcome__c';

// labels
import RECORD_SAVE_LABEL from '@salesforce/label/tffa.RECORD_SAVE_LABEL';
import RECORD_CANCEL_LABEL from '@salesforce/label/tffa.RECORD_CANCEL_LABEL';
import RECORD_STATUS_LABEL from '@salesforce/label/tffa.RECORD_STATUS_LABEL';
import KYC_DECISION_LABEL from '@salesforce/label/tffa.KYC_DECISION_LABEL';
import ACTION_REQUIRED_LABEL from '@salesforce/label/tffa.ACTION_REQUIRED_LABEL';
import OVERRIDE_KYC_DECISION_LABEL from '@salesforce/label/tffa.OVERRIDE_KYC_DECISION_LABEL';
import DECISION_RERUN_LABEL from '@salesforce/label/tffa.DECISION_RERUN_LABEL';

// methods
import updateDecision from '@salesforce/apex/tffa.SubmissionController.updateDecision';
import doDecision from '@salesforce/apex/tffa.SubmissionController.doDecision';

/**
 * Manages the KYC decision of the Submission
 */
export default class processSubmissionKYC extends LightningElement {
  labels = {
    RECORD_SAVE_LABEL,
    RECORD_CANCEL_LABEL,
    RECORD_STATUS_LABEL,
    KYC_DECISION_LABEL,
    ACTION_REQUIRED_LABEL,
    OVERRIDE_KYC_DECISION_LABEL,
    DECISION_RERUN_LABEL
  };

  schema = {
    tffa__Submission__c: {
      ...Submission__c,
      tffa__KYCApprovalReason__c,
      tffa__KYCDeclinedReason__c,
      tffa__KYCDecisionOverrideComments__c
    }
  };

  /**
   * Record context
   */
  @api recordId;

  /**
   * If true, Re-run action is not displayed
   */
  @api disableRerun = false;

  /**
   * Available actions on KYC decision
   */
  @track decisionOptions = [];
  /**
   * Selected KYC action
   */
  @track decision = null;

  @track submission = {};

  @track applications = [];
  /**
   * Current KYC decision
   */
  currentOutcome = null;

  wiredSubmission = null;

  @wire(getRecord, {
    recordId: '$recordId',
    fields: [tffa__KYCDecisionOutcome__c]
  })
  wireApplication(result) {
    if (result.error) {
      this.addErrorToast(this.translateAuraError(result.error));
    } else if (result.data) {
      this.currentOutcome = getFieldDisplayValue(result.data, tffa__KYCDecisionOutcome__c);
    }
    this.wiredSubmission = result;
    this.decision = null;
  }

  @wire(getObjectInfo, { objectApiName: 'tffa__Submission__c' })
userMetadata;

  @wire(getPicklistValues, { fieldApiName: tffa__KYCDecisionOutcome__c,recordTypeId: '$userMetadata.data.defaultRecordTypeId' })
  wireStatusPicklist({ data, error }) {
    if (data) {
      this.decisionOptions = [];
      const allowedSet = new Set(['APPROVED', 'DECLINED']);
      this.decisionOptions = data.values.filter(e => allowedSet.has(e.value));
    } else if (error) {
      console.error(error);
    }
  }

  get isDecisionApproved() {
    return this.decision === 'APPROVED';
  }

  get isDecisionDeclined() {
    return this.decision === 'DECLINED';
  }

  get isCommentsRequired() {
    return this.decision === 'OTHER';
  }

  get isDirty() {
    return this.decision !== null;
  }

  onTabRefresh(_event) {
    if (this.wiredSubmission) {
      refreshApex(this.wiredSubmission);
    }
  }

  onSubmit(event) {
    // stop the form from submitting
    event.preventDefault();
   
    // build request
    const sub = { Id: this.recordId, tffa__KYCDecisionOutcome__c: this.decision, ...event.detail.fields };
    const facts = { Type__c: 'KYC' };
  
    updateDecision({ ctx: { id: this.recordId }, subJson: JSON.stringify(sub), factsJson: JSON.stringify(facts) })
      .then(data => {
        if (data) {
         // console.log('data ',data);
          refreshApex(this.wiredSubmission);
          this.eval("$A.get('e.force:refreshView').fire();");
          // refresh view
       
          this.submission = data;
        }
      })
      .catch(error => this.addErrorToast(error)
      );
      
  }

  onCancel(_event) {
    this.decision = null;
  }

  onOverrideDecision(event) {
    this.decision = event.detail.value;
  }

  isDisclosureSigningRequired(data) {
    return data.some(app => app.IsDisclosureSigningRequired__c);
  }

  onRerun(_event) {
    const facts = { Type__c: 'KYC' };
    doDecision({ ctx: { id: this.recordId }, factsJson: JSON.stringify(facts) })
      .then(data => {
        refreshApex(this.wiredSubmission);
        this.eval("$A.get('e.force:refreshView').fire();");
        // refresh view
      
        this.submission = data;
      })
      .catch(error => this.addErrorToast(error));
  }
}