import { LightningElement, wire, api, track } from "lwc";
import getObjectFields from "@salesforce/apex/WT_GoalSettingController.getObjectFields";
import getIntegerFieldsFromObject from "@salesforce/apex/WT_GoalSettingController.getIntegerFieldsFromObject";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createGoalMetric from "@salesforce/apex/WT_GoalMetricCreation.createGoalMetric";

export default class WTGoalSettings extends NavigationMixin(LightningElement) {
    @api value;
    @track errorMsg = "";
    @api objectFieldsList = [];
    @api fieldSelected;
    @api operatorSelected;
    @api goalMetricName;
    @api goalMetricType;
    @api inputValue;
    @api combinationValue;
    @api dateFieldValue;
    @track objectName;
    @track goalMetricRecordId;
    @track inprogressValue;
    @track inprogressdateValue;
    @api recordId;
    isSumFieldRequired = false;
    shouldShowFieldToSum = false;
    fieldToSumOptions = [];
    fieldToSum = '';

    get metricTypeOptions() {
        return [
            { label: "SUM", value: "SUM" },
            { label: "COUNT", value: "COUNT" },
        ];
    }

    get objectOptions() {
        return [
            { label: "Account", value: "Account" },
            { label: "Opportunity", value: "Opportunity" },
            { label: "Event", value: "Event" },
            { label: "Task", value: "Task" },
            { label: "Referral", value: "Lead" },
            { label: "Financial Account", value: "FinServ__FinancialAccount__c"},
        ];
    }

    handleObjChange(event) {
        this.value = event.detail.value;
        if (!this.value) {
            this.errorMsg = "Please select object.";
            this.searchData = undefined;
            return;
        }
        this.populateFieldToSum(this.value);
        getObjectFields({ objectName: this.value })
            .then((result) => {
                if (result) {
                    for (const list of result) {
                        const option = {
                            label: list,
                            value: list,
                        };
                       
                        this.objectFieldsList = [
                            ...this.objectFieldsList, //Spread Array
                            option,
                        ];
                    }
                }
            })
            .catch((error) => {
                this.objectFieldsList = undefined;
                if (error) {
                    this.errorMsg = error.body.message;
                }
            });
    }

    populateFieldToSum(selectedObjectName){
        this.fieldToSumOptions = [];
        getIntegerFieldsFromObject({ objectApiName: selectedObjectName })
            .then((result) => {
                if (result) {
                    for (const item of result) {
                        const option = {
                            label: item.FieldLabel,
                            value: item.FieldApiName,
                        };
                       
                        this.fieldToSumOptions = [
                            ...this.fieldToSumOptions, //Spread Array
                            option,
                        ];
                    }
                }
            })
            .catch((error) => {
                this.fieldToSumOptions = undefined;
                if (error) {
                    this.errorMsg = error.body.message;
                }
            });
    }

    handleFieldChange(event) {
        this.fieldSelected = event.detail.value;
    }

    handleInProgressFdChange(event) {
        this.fieldSelected = event.detail.value;
    }

    get opertorOptions() {
        return [
            { label: "equals", value: "equals" },
            { label: "not equal to", value: "not equal to" },
            { label: "contains", value: "contains" },
            { label: "does not contains", value: "does not contains" },
            { label: "less than", value: "less than" },
            { label: "greater than", value: "greater than" },
            { label: "less or equal", value: "less or equal" },
            { label: "greater or equal", value: "greater or equal" },
        ];
    }

    handleOptChange(event) {
        this.operatorSelected = event.detail.value;
        console.log("Selected Field : " + this.operatorSelected);
    }

    handleInprogressOptChange(event) {
        this.operatorSelected = event.detail.value;
    }

    handleInProgressInpValChg(event){
        this.inputValue = event.target.value;
    }

    handleGoalNameChange(event) {
        this.goalMetricName = event.detail.value;
    }

    handleMetricTypeChange(event) {
        this.goalMetricType = event.target.value;
        if(this.goalMetricType === 'SUM'){
            this.shouldShowFieldToSum = true;
            this.isSumFieldRequired = true;
        }else{
            this.shouldShowFieldToSum = false;
            this.isSumFieldRequired = false;
            this.fieldToSum = '';
        }
    }

    handleFieldToSumChanged(event) {
        this.fieldToSum = event.target.value;
    }

    handleInputChange(event) {
        this.inputValue = event.target.value;
    }

    handleCombinationChange(event) {
        this.combinationValue = event.target.value;
    }

    handleDateFieldChange(event) {
        this.dateFieldValue = event.target.value;
    }

    handleInprogresChange(event) {
        this.inprogressValue = event.target.value;
    }

    handleInprogressDateChange(event) {
        this.inprogressdateValue = event.target.value;
    }

    keyIndex = 0;
    @track itemList = [
        {
            id: 0,
        },
    ];

    addRow() {
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        this.itemList = this.itemList.concat(newItem);
    }

    removeRow(event) {
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return (
                    parseInt(element.id) !== parseInt(event.target.accessKey)
                );
            });
        }
    }

    validate() {
        console.log("Test");
        const goalCriteriaSection =
            this.template.querySelector(".goalCriteria");
        const inprogressCriteriaSection = this.template.querySelector(
            ".inProgressCriteria"
        );
				
        return Boolean(
          
            Array.from(
                goalCriteriaSection.querySelectorAll("lightning-combobox")
            )
                .map((comboBox) => comboBox.value)
                .reduce((accumulator, curVal, index) => {
                    console.log(accumulator, curVal, index);
                    return accumulator && curVal;
                })
                ? true
                : Array.from(
                      inprogressCriteriaSection.querySelectorAll(
                          "lightning-combobox"
                      )
                  )
                      .map((comboBox) => comboBox.value)
                      .reduce((accumulator, curVal, index) => {
                          console.log(accumulator, curVal, index);
                          return accumulator && curVal;
                      })
                ? true
                : false
        );
    }

    returnToMainPage(){
        eval("$A.get('e.force:refreshView').fire();");
    }

    handleSubmit() {
        if (!this.validate()) {
           const evt = new ShowToastEvent({
            title: 'Toast Error',
            message: 'Please Enter Either GoalCriteriaSection OR InProgressCriteriaSection Below.',
            variant: 'error',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
            return;
        }

        const layouts = Array.from(
            this.template.querySelectorAll("lightning-layout")
        );

      
        let filterJson = layouts
            .filter(
                (layout) => layout.querySelector("[data-id=fieldId]")?.value
            )
            .map((layout) => {
                return {
                    field: layout.querySelector("[data-id=fieldId]")?.value,
                
                    operator: layout.querySelector("[data-id=operatorId]")
                        ?.value,
                    value: layout.querySelector("[data-id=valueId]")?.value,
                };
            });

       
        let iPfilterJson = layouts
            .filter(
                (layout) => layout.querySelector("[data-id=ipFieldId]")?.value
            )
            .map((layout) => {
                return {
                    field: layout.querySelector("[data-id=ipFieldId]")?.value,
                  
                    operator: layout.querySelector("[data-id=ipOperatorId]")
                        ?.value,
                    value: layout.querySelector("[data-id=ipValueId]")?.value,
                };
            });

        createGoalMetric({
            gmName: this.goalMetricName,
            gmType: this.goalMetricType,
            gmObject: this.value,
            gmActualResult:
                filterJson && filterJson.length > 0
                    ? JSON.stringify(filterJson)
                    : null,

            gmActualCriteriaLogic: this.combinationValue,
            gmActualDate: this.dateFieldValue,
          
            gmInPrgResult:
                iPfilterJson && iPfilterJson.length > 0
                    ? JSON.stringify(iPfilterJson)
                    : null,
            gmInPrgCriteriaLogic: this.inprogressValue,
            gmInPrgActualDate: this.inprogressdateValue,
            gmFieldToSum: this.fieldToSum
        })
           
            .then((result) => {
                window.console.log("result:" + JSON.stringify(result));
                this.goalMetricRecordId = result.Id;
                window.console.log(
                    "RecordId**" + this.goalMetricRecordId
                );
                const toastEvent = new ShowToastEvent({
                    title: "Success!",
                    message: "Record created successfully",
                    variant: "success",
                });
                this.dispatchEvent(toastEvent);
                window.close();
                /*Start Navigation*/
                this[NavigationMixin.Navigate]({
                    type: "standard__recordPage",
                    attributes: {
                        recordId: this.goalMetricRecordId,
                        objectApiName: "WT_Goal_Metric__c",
                        actionName: "view",
                    },
                });
                /*End Navigation*/
            })
            .catch((error) => {
                this.errorMsg = error.message;
                window.console.log(this.error);
            });
    }

  

    activeSections = ["GoalMetricDetails", "GoalCriteriaSection"];
    handleToggleSection(event) {
        console.log("Accordian Section");
    }
}