import { LightningElement, api, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import search from '@salesforce/apex/WT_LookupController.Search';
import getRecentlyViewed from '@salesforce/apex/WT_LookupController.GetRecentlyViewed';

export default class WT_Utility_Lookup extends LightningElement {
    // Use alerts instead of toasts (LEX only) to notify user
    @api notifyViaAlerts = false;
    @api placeholder = '';
    @api queryName = '';
    isMultiEntry = false;
    maxSelectionSize = 1;
    @api initialSelection = [];
    errors = [];
    recentlyViewed = [];
    newRecordOptions = [];

    connectedCallback() {
        //this.getRecentlyViewedRecords();
    }

    getRecentlyViewedRecords(){
        getRecentlyViewed({queryName: this.queryName})
        .then((data) => {
            this.recentlyViewed = data;
            this.initLookupDefaultResults();
        })
        .catch((error) => {
            
        });
    }

    /**
     * Initializes the lookup default results with a list of recently viewed records (optional)
     */
    initLookupDefaultResults() {
        // Make sure that the lookup is present and if so, set its default results
        const lookup = this.template.querySelector('c-w-t_-utility_-lookup-base');
        if (lookup) {
            lookup.setDefaultResults(this.recentlyViewed);
        }
    }

    /**
     * Handles the lookup search event.
     * Calls the server to perform the search and returns the resuls to the lookup.
     * @param {event} event `search` event emmitted by the lookup
     */
    handleLookupSearch(event) {
        const lookupElement = event.target;
        // Call Apex endpoint to search for records and pass results to the lookup
        search(event.detail)
            .then((results) => {
                lookupElement.setSearchResults(results);
            })
            .catch((error) => {
                this.notifyUser('Lookup Error', 'An error occured while searching with the lookup field.', 'error');
                // eslint-disable-next-line no-console
                console.error('Lookup error', JSON.stringify(error));
                this.errors = [error];
            });
    }

    /**
     * Handles the lookup selection change
     * @param {event} event `selectionchange` event emmitted by the lookup.
     * The event contains the list of selected ids.
     */
    // eslint-disable-next-line no-unused-vars
    handleLookupSelectionChange(event) {
        this.checkForErrors();
        this.dispatchEvent(new CustomEvent('recordselectionchange', { detail: event.detail }));
    }

    // All functions below are part of the sample app form (not required by the lookup).

    handleLookupTypeChange(event) {
        this.initialSelection = [];
        this.errors = [];
        this.isMultiEntry = event.target.checked;
    }

    handleMaxSelectionSizeChange(event) {
        this.maxSelectionSize = event.target.value;
    }

    handleSubmit() {
        this.checkForErrors();
        if (this.errors.length === 0) {
            this.notifyUser('Success', 'The form was submitted.', 'success');
        }
    }

    handleClear() {
        this.initialSelection = [];
        this.errors = [];
    }

    checkForErrors() {
        this.errors = [];
        const selection = this.template.querySelector('c-w-t_-utility_-lookup-base').getSelection();
        // Custom validation rule
        if (this.isMultiEntry && selection.length > this.maxSelectionSize) {
            this.errors.push({ message: `You may only select up to ${this.maxSelectionSize} items.` });
        }
        // Enforcing required field
        if (selection.length === 0) {
            this.errors.push({ message: 'Please make a selection.' });
        }
    }

    notifyUser(title, message, variant) {
        if (this.notifyViaAlerts) {
            // Notify via alert
            // eslint-disable-next-line no-alert
            alert(`${title}\n${message}`);
        } else {
            // Notify via toast (only works in LEX)
            const toastEvent = new ShowToastEvent({ title, message, variant });
            this.dispatchEvent(toastEvent);
        }
    }

    get getContainerElementClass() {
        return this.errors.length > 0
            ? 'slds-form slds-form_stacked slds-m-bottom_x-large'
            : 'slds-form slds-form_stacked';
    }
}