import { LightningElement, track, api } from 'lwc';
import getSobjectList from '@salesforce/apex/WT_ListViewExportController.fetchRecords';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class WT_ListViewExport_LWC extends LightningElement {
    @track DataTableResponseWrappper;
    @track SObjectDataWrapper;
    @track listViewName;
    @track labelNames;
    @track apiNames;
    @track baseURL;
    @track error;
    @track isSpinner = true;
    @track columns = [];
    @api objectName;

    connectedCallback(){
        this.baseURL = window.location.origin;
        this.getSobjectListData();
    }

    getSobjectListData(){
        getSobjectList({objectName: this.objectName})
        .then(results => {
                this.columns = results.lstDataTableColumn;
                this.labelNames = results.labelNames;
                this.apiNames = results.apiNames;

                this.SObjectDataWrapper = results;
                this.listViewName = results.listViewName;
                this.formatData();
            })
            .catch(error => {
                this.isSpinner = false;
                const evt = new ShowToastEvent({
                    title: 'error',
                    message: 'Please reach out to the support team',
                    variant: 'error',
                });
                this.dispatchEvent(evt);
                window.history.back();
            }
        );
    }

    formatData(){
        if(this.SObjectDataWrapper.sObjectData) {
           let sObjectRelatedFieldListValues = [];
           for (let row of this.SObjectDataWrapper.sObjectData) {
                const finalSobjectRow = {}
                let rowIndexes = Object.keys(row);
                rowIndexes.forEach((rowIndex) => {
                    const relatedFieldValue = row[rowIndex];
                    if(relatedFieldValue.constructor === Object) {
                        this._flattenTransformation(relatedFieldValue, finalSobjectRow, rowIndex)
                    }
                    else {
                        finalSobjectRow[rowIndex] = relatedFieldValue;
                    }
                });
                sObjectRelatedFieldListValues.push(finalSobjectRow);
            }
            this.DataTableResponseWrappper = this.SObjectDataWrapper;
            this.finalSObjectDataList = sObjectRelatedFieldListValues;
            this.handleDownload();
        }
    }

    _flattenTransformation = (fieldValue, finalSobjectRow, fieldName) => {
        let rowIndexes = Object.keys(fieldValue);
        rowIndexes.forEach((key) => {
            let finalKey = fieldName + '.'+ key;
            finalSobjectRow[finalKey] = fieldValue[key];
        })
    }

    handleDownload(){
        var status = this.exportToCSV();
        if(status == 'downloaded') {
            var redirectURL = this.baseURL+'/lightning/o/'+this.objectName+'/list?filterName'+this.listViewName;
            window.open(redirectURL, "_self");
        }
    }

    exportToCSV() {
        let columnHeader = this.labelNames;
        let jsonKeys = this.apiNames;
        var jsonRecordsData = this.finalSObjectDataList;
        let csvIterativeData;
        let csvSeperator;
        let newLineCharacter;
        csvSeperator = ",";
        newLineCharacter = "\n";
        csvIterativeData = "";
        csvIterativeData += columnHeader.join(csvSeperator);
        csvIterativeData += newLineCharacter;
        for (let i = 0; i < jsonRecordsData.length; i++) {
          let counter = 0;
          for (let iteratorObj in jsonKeys) {
            let dataKey = jsonKeys[iteratorObj];
            if (counter > 0) {
                csvIterativeData += csvSeperator;
            }
            if (jsonRecordsData[i][dataKey] !== null && jsonRecordsData[i][dataKey] !== undefined) {
                csvIterativeData += '"' + jsonRecordsData[i][dataKey] + '"';
            }
            else {
                csvIterativeData += '""';
            }
            counter++;
          }
          csvIterativeData += newLineCharacter;
        }

        let downloadElement = document.createElement('a');
        downloadElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(csvIterativeData);
        downloadElement.target = '_self';
        downloadElement.download = this.objectName+'.csv';
        document.body.appendChild(downloadElement);
        downloadElement.click();
        return 'downloaded';
    }
}