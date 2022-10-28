import { LightningElement, api, track, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getActivityRecord from '@salesforce/apex/WT_RelationshipGroupMemberController.getRelationshipActivityRecord';
import { subscribe, unsubscribe, APPLICATION_SCOPE, MessageContext } from 'lightning/messageService';
import RGChannel from '@salesforce/messageChannel/RGMessageChannel__c';
//import { NavigationMixin } from 'lightning/navigation';

export default class WT_RG_Related_ListLWC extends LightningElement {
    @api title;
    @api sObjectName;
    @api parentFieldName;
    @api childRelatedName;
    @api iconName;
    @api field1;
    @api field2;
    @api field3;
    @api recordId;
    @track listRecords = [];
    wiredActivities = [];
    subscription = null;
    accountRecordId;
    get isRecordExist() {
        if (this.listRecords.length > 0)
            return true;
        else
            return false;
    }
    get titleName() {
        let size = this.listRecords.length;
        return this.title + ' (' + size + ')';
    }
    // Initialize messageContext for Message Service
    @wire(MessageContext) messageContext;
    @wire(getActivityRecord, { recordId: '$recordId', sObjectName: '$sObjectName', parentField: '$parentFieldName' })
    wiredFetchRecord(result) {
        this.wiredActivities = result;
        if (result.data) {
            let listOfRecord = [];
            result.data.forEach(element => {
                const record = {};
                record.Subject = element.Subject;
                record.urlId = '/lightning/r/' + element.Id + '/view';
                record.RelatedName = element.What.Name;
                record.urlRelatedId = '/lightning/r/' + element.WhatId + '/view';
                // Changes by START *** //
                record.ActivityDate = element.ActivityDate;
                record.AssignedToId = element.OwnerId;
                record.AssignedToName = element.Owner.Name;
                // Changes by END *** //
                if (element.WhoId) {
                    record.Attendee = element.Who.Name;
                    record.urlAttendeeId = '/lightning/r/' + element.WhoId + '/view';
                }
                else { record.Attendence = null; record.urlAttendeeId = null; }
                if ((element.RecordType != null) && (element.RecordType.Name.includes('Event') || element.RecordType.Name.includes('Annual Review'))) { record.isTask = false; }
                else { record.isTask = true; }
                listOfRecord.push(record);
            });
            this.listRecords = listOfRecord;
        }
        else if (result.error) {
            console.log('error ', result.error);
        }
    }
    handleSubscribe(event) {
        this.accountRecordId = event.recordId;
        refreshApex(this.wiredActivities);
    }
    // Subscribes to the message channel
    subscribeMC() {
        if (this.subscription) {
            return;
        }
        if (!this.subscription) {
            this.subscription = subscribe(this.messageContext, RGChannel, (message) => { this.handleSubscribe(message); }, { scope: APPLICATION_SCOPE });
        }
    }
    // Calls subscribeMC()
    connectedCallback() {
        this.subscribeMC();
    }
    /*viewRelatedList(event) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordRelationshipPage',
            attributes: {
                recordId: this.recordId,
                objectApiName: this.sObjectName,
                relationshipApiName: this.childRelatedName,
                actionName: 'view'
            },
        });
    }*/
}