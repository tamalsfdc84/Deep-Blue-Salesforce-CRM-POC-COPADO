import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldValue, getFieldDisplayValue } from 'lightning/uiRecordApi';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';

//  objects
import Application__c from '@salesforce/schema/tffa__Application__c';

//  fields
import RecordTypeId from '@salesforce/schema/tffa__Application__c.RecordTypeId';
import tffa__KYCApprovalReason__c from '@salesforce/schema/tffa__Application__c.tffa__KYCApprovalReason__c';
import tffa__KYCDeclinedReason__c from '@salesforce/schema/tffa__Application__c.tffa__KYCDeclinedReason__c';
import tffa__KYCDecisionOverrideComments__c from '@salesforce/schema/tffa__Application__c.tffa__KYCDecisionOverrideComments__c';
import tffa__KYCDecisionOutcome__c from '@salesforce/schema/tffa__Application__c.tffa__KYCDecisionOutcome__c';
import tffa__AutoKYCDecisionRemarks__c from '@salesforce/schema/tffa__Application__c.tffa__AutoKYCDecisionRemarks__c';
import tffa__Submission__c from '@salesforce/schema/tffa__Application__c.tffa__Submission__c';
import tffa__CounterOfferProduct__c from '@salesforce/schema/tffa__Application__c.tffa__CounterOfferProduct__c';
import tffa__CounterOfferComments__c from '@salesforce/schema/tffa__Application__c.tffa__CounterOfferComments__c';

// labels
import RECORD_SAVE_LABEL from '@salesforce/label/tffa.RECORD_SAVE_LABEL';
import RECORD_CANCEL_LABEL from '@salesforce/label/tffa.RECORD_CANCEL_LABEL';
import RECORD_STATUS_LABEL from '@salesforce/label/tffa.RECORD_STATUS_LABEL';
import KYC_DECISION_LABEL from '@salesforce/label/tffa.KYC_DECISION_LABEL';
import ACTION_REQUIRED_LABEL from '@salesforce/label/tffa.ACTION_REQUIRED_LABEL';
import OVERRIDE_KYC_DECISION_LABEL from '@salesforce/label/tffa.OVERRIDE_KYC_DECISION_LABEL';

// methods
import updateDecision from '@salesforce/apex/tffa.SubmissionController.updateDecision';

/**
 * Manages the KYC decision of the Application
 */
export default class processApplicationKYC extends LightningElement {
  labels = {
    RECORD_SAVE_LABEL,
    RECORD_CANCEL_LABEL,
    RECORD_STATUS_LABEL,
    KYC_DECISION_LABEL,
    ACTION_REQUIRED_LABEL,
    OVERRIDE_KYC_DECISION_LABEL
  };

  schema = {
    tffa__Application__c: {
      ...Application__c,
      tffa__KYCApprovalReason__c,
      tffa__KYCDeclinedReason__c,
      tffa__KYCDecisionOverrideComments__c,
      tffa__AutoKYCDecisionRemarks__c,
      tffa__CounterOfferProduct__c,
      tffa__CounterOfferComments__c
    }
  };

  /**
   * Record context
   */
  @api recordId;
  /**
   * Record type
   */
  @track recordTypeId;
  /**
   * Available actions on KYC decision
   */
  @track decisionOptions = [];
  /**
   * Selected KYC action
   */
  @track decision = null;
  /**
   * Current KYC decision
   */
  currentOutcome = null;

  pending = false;

  wiredApplication = null;

  @wire(getRecord, {
    recordId: '$recordId',
    fields: [RecordTypeId, tffa__KYCDecisionOutcome__c, tffa__Submission__c]
  })
  wireApplication(result) {
    if (result.error) {
      this.addErrorToast(this.translateAuraError(result.error));
    } else if (result.data) {
      this.recordTypeId = getFieldValue(result.data, RecordTypeId);
      this.currentOutcome = getFieldDisplayValue(result.data, tffa__KYCDecisionOutcome__c);
    }
    this.wiredApplication = result;
    this.decision = null;
  }

  @wire(getObjectInfo, { objectApiName: 'tffa__Submission__c' })
  userMetadata;

  @wire(getPicklistValues, { fieldApiName: tffa__KYCDecisionOutcome__c, recordTypeId: '$userMetadata.data.defaultRecordTypeId' })
  wireStatusPicklist({ data, error }) {
    if (data) {
      this.decisionOptions = [];
      const allowedSet = new Set(['APPROVED', 'DECLINED', 'COUNTER_OFFER']);
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

  get isDecisionCounterOffer() {
    return this.decision === 'COUNTER_OFFER';
  }

  get isCommentsRequired() {
    return this.decision === 'OTHER';
  }

  get isDirty() {
    return this.decision !== null;
  }

  onTabRefresh(_event) {
    if (this.wiredApplication) {
      refreshApex(this.wiredApplication);
    }
  }

  onSubmit(event) {
    // stop the form from submitting
    event.preventDefault();
    // build request
    this.pending = true;
    const app = { Id: this.recordId, tffa__KYCDecisionOutcome__c: this.decision, ...event.detail.fields };
    const subId = getFieldValue(this.wiredApplication.data, tffa__Submission__c);
    const sub = { Id: subId, Applications__r: [app] };
    const facts = { Type__c: 'KYC' };
    updateDecision({ ctx: { id: subId }, subJson: JSON.stringify(sub), factsJson: JSON.stringify(facts) })
      .then(() => {
        refreshApex(this.wiredApplication);
        // refresh view
        this.eval("$A.get('e.force:refreshView').fire();");
        this.pending = false;
      })
      .catch(error => {
        this.addErrorToast(error);
        this.pending = false;
      });
  }

  onCancel(_event) {
    this.decision = null;
  }

  onOverrideDecision(event) {
    this.decision = event.detail.value;
  }

  isDisclosureSigningRequired() {
    return this.wiredApplication.tffa__IsDisclosureSigningRequired__c;
  }
}