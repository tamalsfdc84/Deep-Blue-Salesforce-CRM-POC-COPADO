import { LightningElement, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
import UploadFile from '@salesforce/apex/WT_FileUploadController.UploadFile';
import GetFailedRecordFromProcessLog from '@salesforce/apex/WT_FileUploadController.GetFailedRecordFromProcessLog';

const columns = 
[
    { label: 'Excel Row #', fieldName: 'WT_Excel_Row_Number__c', type: 'text',sortable: "true"},
    { label: 'Error Message', fieldName: 'WT_Message__c', type: 'text',sortable: "true"}
];

export default class WT_FileUploadCompLWC extends LightningElement 
{
    data;
    error;
    listOfGoalImportLog = [];
    isLoading = false;
    isDisable = true;
    fileData;
    displayRecords = false;
    countOfRecordsToProcess;
    queueableJobId;
    hasStartedProcessingFile = false;
    hasProcessedFile = false;
    countOfRecordsProcessedSuccessfully;
    countOfRecordsFailedToProcess;
    showFailureRecords = false;
    columns = columns; 
    channelName = '/event/FileUploadToGoalEvent__e';
    subscription = {};

    connectedCallback() 
    {
        this.registerErrorListener();
    }
    // function to refresh the page
    returnToMainPage()
    {
        eval("$A.get('e.force:refreshView').fire();");
    }
    // function to upload the file
    openFileUpload(event) 
    {
        const file = event.target.files[0]; 
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.fileData = {
                'fileName': file.name,
                'fileFormatInBase64': base64,
            }
            let fileName = this.fileData.fileName;  
            fileName = fileName.toLowerCase();
            let isCSV = fileName.includes(".csv");
            if (this.fileData.fileName != null && isCSV) 
            {
                this.isDisable = false;
            }
            else 
            {
                const evt = new ShowToastEvent({
                    title: 'Toast Error',
                    message: 'You cannot upload the file other than .csv',
                    variant: 'error'
                });
                this.dispatchEvent(evt);
                this.isDisable = true;
            }
        }
        reader.readAsDataURL(file) 
    }
    get acceptedCSVFormats() 
    {
        return ['.csv'];
    }

    // function for Submit button
    handleClick() 
    {
        const {fileFormatInBase64,fileName} = this.fileData
        UploadFile({fileFormatInBase64,fileName}).then(result => {

            this.fileData = null;
            this.displayRecords = true;
            this.countOfRecordsToProcess = result.countRecordToProcess;
            this.queueableJobId = result.queueableJobId;
            this.hasStartedProcessingFile = true;
            this.isLoading = true;
            this.handlePlatformEventResultSubscribe(this.queueableJobId);
        })
    }

    //function to fire the platform Event 
    handlePlatformEventResultSubscribe(jobId)
    {
        const messageCallback = (response) => { 
        if (response != null && response.data != null && response.data.payload != null && response.data.payload.JobId__c == jobId) 
        {
            this.hasProcessedFile = true;
            this.isLoading = false;
            this.countOfRecordsProcessedSuccessfully = response.data.payload.WT_Count_of_Success_Record__c;
            console.log('SuccessRecords' + this.countOfRecordsProcessedSuccessfully);
            this.countOfRecordsFailedToProcess = response.data.payload.WT_Count_of_Failure_Record__c;
            console.log('FailedRecords**' + this.countOfRecordsFailedToProcess);
            if (this.countOfRecordsFailedToProcess != null && this.countOfRecordsFailedToProcess > 0) 
            {
                this.showFailureRecords = true;
                console.log('countOfRecordsFailedToProcess**' + this.countOfRecordsFailedToProcess);
                GetFailedRecordFromProcessLog({ jobId }).then(result => {
                    this.data = result;
                    this.listOfGoalImportLog = result;
                    console.log('listofGoalImpot**' + JSON.stringify(this.listOfGoalImportLog[0]));
                })
            }
        }
    };
        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then((response) => {
            // Response contains the subscription information on subscribe call
            console.log(
                'Subscription request sent to: ',
                JSON.stringify(response.channel)
            );

        });
    }

    registerErrorListener() {
        onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
        });
    }
}