import { LightningElement, api, track, wire } from 'lwc';
import { getRecord, getFieldDisplayValue } from 'lightning/uiRecordApi';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import { refreshApex } from '@salesforce/apex';

//  objects
import Submission__c from '@salesforce/schema/tffa__Submission__c';

//  fields
import tffa__KYCApprovalReason__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCApprovalReason__c';
import tffa__KYCDeclinedReason__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCDeclinedReason__c';
import tffa__KYCDecisionOverrideComments__c from '@salesforce/schema/tffa__Submission__c.tffa__KYCDecisionOverrideComments__c';
import totalApplications from '@salesforce/schema/tffa__Submission__c.tffa__NumberOfApplications__c';
import CZApplicationProcessingStatus__c from '@salesforce/schema/tffa__Submission__c.CZApplicationProcessingStatus__c';

// labels
import RECORD_SAVE_LABEL from '@salesforce/label/tffa.RECORD_SAVE_LABEL';
import RECORD_CANCEL_LABEL from '@salesforce/label/tffa.RECORD_CANCEL_LABEL';
import RECORD_STATUS_LABEL from '@salesforce/label/tffa.RECORD_STATUS_LABEL';
import KYC_DECISION_LABEL from '@salesforce/label/tffa.KYC_DECISION_LABEL';
import ACTION_REQUIRED_LABEL from '@salesforce/label/tffa.ACTION_REQUIRED_LABEL';
import OVERRIDE_KYC_DECISION_LABEL from '@salesforce/label/tffa.OVERRIDE_KYC_DECISION_LABEL';
import OPENACCOUNT_LABEL from '@salesforce/label/tffa.DECISION_RERUN_LABEL';

// methods
import updateSubWidgetStatus from '@salesforce/apex/FISCCSubmissionExecutor.updateSubmissionWidgetStatus';
import processApplication from '@salesforce/apex/FISCCSubmissionExecutor.processSubmission';
//import getApplicationList from '@salesforce/apex/FISCCSubmissionExecutor.getApplicationList';

/**
 * Manages the KYC decision of the Submission
 */
export default class retryApplicationOpening extends LightningElement {
  labels = {
    RECORD_SAVE_LABEL,
    RECORD_CANCEL_LABEL,
    RECORD_STATUS_LABEL,
    KYC_DECISION_LABEL,
    ACTION_REQUIRED_LABEL,
    OVERRIDE_KYC_DECISION_LABEL,
    OPENACCOUNT_LABEL
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
  @track subWidgetStatus = null;

  @track submission = {};

  @track applications = [];

  /**
   * Current KYC decision
   */
  labelValue = null;
  totalApps = null;
  currentStatus = null;
  totalAppValue = null;
  applicationsList = [];
  wiredSubmission = null;

  @wire(getRecord, {
    recordId: '$recordId',
    fields: [totalApplications, CZApplicationProcessingStatus__c]
  })
  wireApplication(result) {
    console.log('result ', result);
    if (result.error) {
      this.addErrorToast(this.translateAuraError(result.error));
    } else if (result.data) {
      this.subWidgetStatus = result.data.fields.CZApplicationProcessingStatus__c.value;
      this.currentStatus = getFieldDisplayValue(
        result.data.fields.CZApplicationProcessingStatus__c.displayValue,
        CZApplicationProcessingStatus__c
      );
      this.totalApps = getFieldDisplayValue(result.data.fields.tffa__NumberOfApplications__c.value, totalApplications);
      this.labelValue = 'Application Summary';
    }
    this.wiredSubmission = result;
    // getApplicationList({ subId: this.recordId })
    //   .then(data => {
    //     if (data) {
    //       console.log('data1 ', data);
    //       this.applicationsList = data;
    //     }
    //   })
    //   .catch(error => console.log(error));
  }

  @wire(getObjectInfo, { objectApiName: 'tffa__Submission__c' })
  userMetadata;

  get checkSubWidgetStatus() {
    if (this.subWidgetStatus === 'IN_PROGRESS' || this.subWidgetStatus === 'COMPLETED') {
      return true;
    }
    return false;
  }

  get showProcessButton() {
    if (this.subWidgetStatus === 'IN_PROGRESS' || this.subWidgetStatus === 'PENDING' || this.subWidgetStatus === 'FAILED') {
      return true;
    }
    return false;
  }

  onTabRefresh(_event) {
    if (this.wiredSubmission) {
      refreshApex(this.wiredSubmission);
    }
  }

  onSubmit(event) {
    // stop the form from submitting
    event.preventDefault();
    updateSubWidgetStatus({ id: this.recordId })
      .then(data => {
        processApplication({ id: this.recordId })
          .then(resp => {
            if (resp) {
              console.log('resp ', resp);
              this.submission = data;
            }
          })
          .catch(error => console.log(error));
        refreshApex(this.wiredSubmission);
        this.eval("$A.get('e.force:refreshView').fire();");
      })
      .catch(error => console.log(error));
  }

  refreshWindow() {
    //refreshApex(this.wiredSubmission);
    window.location.reload();
    //this.eval("$A.get('e.force:refreshView').fire();");
  }
}