import { LightningElement, api, track, wire } from 'lwc';
import getRecordTypesInfo from '@salesforce/apex/WT_ActivityTimeLineController.getRecordTypesInfo';
import getActivites from '@salesforce/apex/WT_ActivityTimeLineController.getActivites';
import getTestRecordTestTypeInfo from '@salesforce/apex/WT_ActivityTimeLineController.getTestRecordTestTypeInfo';
import { refreshApex } from '@salesforce/apex';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class ActivityTimelineComp extends NavigationMixin(LightningElement)
{
    @track isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
    @track btnName = "utility:chevronright";
    @api recordId;
    @track allTypes = [];
    @track tasks;
    @track events;
    activeSections = ['C','A','B'];
    @track upcomingList = [];
    @track completedList = [];
    @track overdueList = [];
    @track evtState = false;
    @track taskState = false;
    @track allTestType=[];
    isLoading = true;
    allData;
    UpMore = false;
    UpLess = false;
    OvMore = false;
    OvLess = false;
    ComMore = false;
    ComLess = false;
    isExpand = true;
    isAllCom = false;
    intialUpList = [];
    intialOvList = [];
    intialComList = [];

    @wire(getRecordTypesInfo, { recId: '$recordId' })
    wiredRecInfo({ data, error }) 
    {
        if (data)
        {
            this.allTypes = [];
            this.allTypes = JSON.parse(JSON.stringify(data));
            for (let i = 0; i < this.allTypes.length; i++)
            {
                this.allTypes[i].label = ' New ' + this.allTypes[i].name;
            }
            console.log('record types are--->', data);
        }
        else if (error)
        {
            console.log('error', error);
        }
    }
    @wire(getTestRecordTestTypeInfo)
    wiredRecTestInfo({ data, error }) 
    {
        if (data)
        {
            this.allTestType = [];
            this.allTestType = JSON.parse(JSON.stringify(data));
            console.log('record test types are--->', data);
        }
        else if (error)
        {
            console.log('error', error);
        }
    }
    @wire(getActivites, { recId: '$recordId' })
    EventTasks(result)
    {
        this.allData = result;
        if (result.data)
        {
            this.intialUpList = [];
            this.intialOvList = [];
            this.intialComList = [];
            this.upcomingList = [];
            this.completedList = [];
            this.overdueList = [];
            this.isLoading = true;
            this.tasks = JSON.parse(JSON.stringify(result.data.tasks));
            this.events = JSON.parse(JSON.stringify(result.data.events));
            //Comparing time and Activity Date
            let rightNow = new Date();
            let yyyyMmDd = rightNow.toISOString().slice(0,10);
            var taskDate = new Date(yyyyMmDd);
            //filtering out tasks
            for (let i = 0; i < this.tasks.length; i++) 
            {
                this.tasks[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                this.tasks[i].btnName = "utility:chevrondown";
                this.tasks[i].IsTask = true;
                this.tasks[i].IsEvent = false;
                this.tasks[i].icn = "standard:task";
               //filtering activity type to display Phone icon
                if (this.tasks[i].WT_Activity_Type__c != undefined || this.tasks[i].WT_Activity_Type__c != null) 
                {
                    if (this.tasks[i].WT_Activity_Type__c.includes('Phone Call')) 
                    {
                        this.tasks[i].icn = "standard:log_a_call";
                    }
                }
                 //displaying recordtypename and Subject line on all sections
                this.tasks[i].newSub = this.tasks[i].RecordType.Name + ' - ' + this.tasks[i].Subject;
                if (this.tasks[i].Status == 'Completed') 
                {
                    this.completedList.push(this.tasks[i]);
                }
                else if ((this.tasks[i].Status != 'Completed') && (new Date(this.tasks[i].ActivityDate) < new Date(taskDate)))
                {
                    this.overdueList.push(this.tasks[i]);
                }
                else 
                {
                    this.upcomingList.push(this.tasks[i]);
                }
            }
               //filtering out events
            for (let i = 0; i < this.events.length; i++)
            {
                this.events[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                this.events[i].btnName = "utility:chevrondown";
                this.events[i].IsTask = false;
                this.events[i].IsEvent = true;
                this.events[i].icn = "standard:event";

                //checking null values for lookup fields to avoid exceptions 
                if (this.events[i].WhoId == undefined) 
                {
                    this.events[i].Who = { Name: ' ' };
                }
                if (this.events[i].WT_Organizer_User__c == undefined)
                {
                    this.events[i].WT_Organizer_User__r = { Name: ' ' };
                }
                this.events[i].newSub = this.events[i].RecordType.Name + ' - ' + this.events[i].Subject;
                if (this.events[i].WT_Status__c == 'Completed')
                {
                    this.completedList.push(this.events[i]);
                }
                else if ((this.events[i].WT_Status__c != 'Completed') && (new Date(this.events[i].EndDateTime) < new Date()))
                {
                    this.overdueList.push(this.events[i]);
                }
                else 
                {
                    this.upcomingList.push(this.events[i]);
                }
            }
                 //sorting task and events
                 this.completedList.sort(function (a, b) 
               {
                return new Date(b.ActivityDate) - new Date(a.ActivityDate);
               });

                 this.upcomingList.sort(function (a, b) 
                {
                return new Date(b.ActivityDate) - new Date(a.ActivityDate);
               });

               this.overdueList.sort(function (a, b)
               {
                return new Date(b.ActivityDate) - new Date(a.ActivityDate);
            });
               //less records for upcoming
               if (this.upcomingList.length > 15)
               {
                this.UpMore = true;
                this.intialUpList = this.upcomingList.slice(0, 15);
               }
               else 
               {
                this.intialUpList = this.upcomingList;
               }
                //less records for completed
               if (this.completedList.length > 15) 
               {
                this.ComMore = true;
                this.intialComList = this.completedList.slice(0, 15);
               }
               else 
               {
                this.intialComList = this.completedList;
               }

               //less records for overdue
              if (this.overdueList.length > 15) 
              {
                this.OvMore = true;
                this.intialOvList = this.overdueList.slice(0, 15);
              }
              else
              {
                this.intialOvList = this.overdueList;
               }
              this.isLoading = false;
        }
        else if (result.error)
        {
                this.isLoading = false;
        }
    }
     //handling Upcoming events
    handleOpen(event) 
    {
        this.isLoading = true;
        var currentId = event.currentTarget.dataset.id;
        for (let i = 0; i < this.intialUpList.length; i++) 
        {
            if (this.intialUpList[i].Id == currentId) 
            {
                if (this.intialUpList[i].isOpen.includes('slds-is-open'))
                 {
                    this.intialUpList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                    this.intialUpList[i].btnName = "utility:chevrondown";
                }
                else 
                {
                    this.intialUpList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task slds-is-open";
                    this.intialUpList[i].btnName = "utility:switch";
                }
                break;
            }
        }
        this.isLoading = false;
    }
   //handling overdue events
    handleOverdue(event) 
    {
        this.isLoading = true;
        var currentId = event.currentTarget.dataset.id;
        for (let i = 0; i < this.intialOvList.length; i++) 
        {
            if (this.intialOvList[i].Id == currentId) 
            {
                if (this.intialOvList[i].isOpen.includes('slds-is-open'))
                {
                    this.intialOvList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                    this.intialOvList[i].btnName = "utility:chevrondown";
                }
                else
                {
                    this.intialOvList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task slds-is-open";
                    this.intialOvList[i].btnName = "utility:switch";
                }
                break;
            }
        }
        this.isLoading = false;
    }
    //handle completed events
    handleCompleted(event) 
    {
        this.isLoading = true;
        var currentId = event.currentTarget.dataset.id;
        for (let i = 0; i < this.intialComList.length; i++) 
        {
            if (this.intialComList[i].Id == currentId) 
            {
                if (this.intialComList[i].isOpen.includes('slds-is-open'))
                {
                    this.intialComList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                    this.intialComList[i].btnName = "utility:chevrondown";
                }
                else 
                {
                    this.intialComList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task slds-is-open";
                    this.intialComList[i].btnName = "utility:switch";
                }
                break;
            }
        }
        this.isLoading = false;
    }
    //this is for navigating to the standard view page of task/event
    navigateToRecordEditPage(event)
    {
        this[NavigationMixin.Navigate]
        ({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.recid,
                objectApiName: 'Event',
                actionName: 'view'
            }
        });
    }
    navigateToAccount(event)
     {
        this[NavigationMixin.Navigate]
        ({
            type: 'standard__recordPage',
            attributes:
             {
                recordId: event.currentTarget.dataset.con,
                objectApiName: 'Account',
                actionName: 'view'
            }
           });
    }
    handleViewMoreUpcoming() 
    {
        this.isLoading = true;
        this.intialUpList = this.upcomingList;
        this.UpLess = true;
        this.UpMore = false;
        this.isLoading = false;
    }
    handleViewLessUpcoming()
     {
        this.isLoading = true;
        this.intialUpList = this.upcomingList.slice(0, 15);
        this.UpLess = false;
        this.UpMore = true;
        this.isLoading = false;
    }
    handleViewMoreCompleted()
     {
        this.isLoading = true;
        this.intialComList = this.completedList;
        this.ComLess = true;
        this.ComMore = false;
        this.isLoading = false;
    }
    handleViewLessCompleted() 
    {
        this.isLoading = true;
        this.intialComList = this.completedList.slice(0, 15);
        this.ComLess = false;
        this.ComMore = true;
        this.isLoading = false;
    }
    handleViewMoreOverdue() 
    {
        this.isLoading = true;
        this.intialOvList = this.overdueList;
        this.OvLess = true;
        this.OvMore = false;
        this.isLoading = false;
    }
    handleViewLessOverdue()
    {
        this.isLoading = true;
        this.intialOvList = this.overdueList.slice(0, 15);
        this.OvLess = false;
        this.OvMore = true;
        this.isLoading = false;
    }
    refreshData()
     {
        refreshApex(this.allData);
        const evt = new ShowToastEvent({
            title: 'Refreshed Successfully',
            message: 'Task and Events are refreshed',
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(evt);
    }
     expand()
     {
        this.isLoading = true;
        if (this.isExpand == false)
        {
            this.isExpand = true;
        }
        else 
        {
            this.isExpand = false;
        }
        for (let i = 0; i < this.intialComList.length; i++)
        {
            if (this.intialComList[i].isOpen.includes('slds-is-open')) 
            {
                this.intialComList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                this.intialComList[i].btnName = "utility:chevrondown";
            }
            else
            {
                this.intialComList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task slds-is-open";
                this.intialComList[i].btnName = "utility:switch";
            }
        }
        for (let i = 0; i < this.intialOvList.length; i++) 
        {
            if (this.intialOvList[i].isOpen.includes('slds-is-open')) 
            {
                this.intialOvList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                this.intialOvList[i].btnName = "utility:chevrondown";
            }
            else 
            {
                this.intialOvList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task slds-is-open";
                this.intialOvList[i].btnName = "utility:switch";
            }
        }
        for (let i = 0; i < this.intialUpList.length; i++)
         {

            if (this.intialUpList[i].isOpen.includes('slds-is-open'))
            {
                this.intialUpList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task";
                this.intialUpList[i].btnName = "utility:chevrondown";
            }
            else {
                this.intialUpList[i].isOpen = "slds-timeline__item_expandable slds-timeline__item_task slds-is-open";
                this.intialUpList[i].btnName = "utility:switch";
            }
        }
        this.isLoading = false;
    }
    todayDateActivity()
    {
       let ActivityDueDate=new Date().toISOString().substring(0, 10);
        return ActivityDueDate;
    }
    createTask(event)
    {
        var recTypeId = event.currentTarget.dataset.id;
        var recTypeName = event.currentTarget.dataset.name;
        var dueDate = this.todayDateActivity();
        for (let i = 0; i < this.allTestType.length; i++)
            {
                if(this.allTestType[i].name.includes(recTypeName))
                {
                    
                    recTypeId = this.allTestType[i].id;
                    break;
                }
            }
        const defaultValues = encodeDefaultFieldValues
        ({
            WhatId: this.recordId,
            ActivityDate : dueDate
        });
        this[NavigationMixin.Navigate]
        ({
            type: 'standard__objectPage',
            attributes: 
            {
                objectApiName: 'Task',
                actionName: 'new'
            },
            state: 
            {
                recordTypeId: recTypeId,
                defaultFieldValues: defaultValues
            }
        });
    }
    createEvent(event)
     {
        var recTypeId = event.currentTarget.dataset.id;
        var recTypeName = event.currentTarget.dataset.name;
         for (let i = 0; i < this.allTestType.length; i++)
             {
                 if(this.allTestType[i].name.includes(recTypeName))
                 {
                     recTypeId = this.allTestType[i].id;
                      break;
                 }
             }
        const defaultValues = encodeDefaultFieldValues
        ({
            WhatId: this.recordId
        });
        this[NavigationMixin.Navigate]
        ({
            type: 'standard__objectPage',
            attributes:
             {
                objectApiName: 'Event',
                actionName: 'new'
            },
            state:
             {
                recordTypeId: recTypeId,
                defaultFieldValues: defaultValues
            }
        });
    }
    get completed() 
    {
        return (this.intialComList.length == 0 ? true : false);
    }
    get overDue() 
    {
        return (this.intialOvList.length == 0 ? true : false);
    }
    get upcoming()
    {
        return (this.intialUpList.length == 0 ? true : false);
    }
    filterTask() 
    {
        this.isLoading = true;
        this.taskState = !this.taskState;
        this.multiFilter();
        this.isLoading = false;
    }
    filterEvent()
    {
        this.isLoading = true;
        this.evtState = !this.evtState;
        this.multiFilter();
        this.isLoading = false;
    }
    clearFilter() 
    {
        this.isLoading = true;
        this.UpMore = false;
        this.UpLess = false;
        this.OvMore = false;
        this.OvLess = false;
        this.ComMore = false;
        this.ComLess = false;

        if (this.upcomingList.length > 15) 
        {
            this.UpMore = true;
            this.intialUpList = this.upcomingList.slice(0, 15);
        }
        else
        {
            this.intialUpList = this.upcomingList;
        }
        //less records for completed
        if (this.completedList.length > 15)
        {
            this.ComMore = true;
            this.intialComList = this.completedList.slice(0, 15);
        }
        else
        {
            this.intialComList = this.completedList;
        }

        //less records for overdue
        if (this.overdueList.length > 15)
        {
            this.OvMore = true;
            this.intialOvList = this.overdueList.slice(0, 15);
        }
        else 
        {
            this.intialOvList = this.overdueList;
        }
        this.isLoading = false;
    }
    //selection of multi filters
     multiFilter()
     {
        let upList = [];
        let ovList = [];
        let comList = [];
        this.UpMore = false;
        this.UpLess = false;
        this.OvMore = false;
        this.OvLess = false;
        this.ComMore = false;
        this.ComLess = false;
        if (this.evtState == false && this.taskState == false)
        {
            this.clearFilter();
        }
        else
         {
            for (let i = 0; i < this.upcomingList.length; i++)
            {
                if (this.evtState == true && this.taskState == true)
                {
                    if (this.upcomingList[i].IsTask == false || this.upcomingList[i].IsTask == true)
                    {
                        upList.push(this.upcomingList[i]);
                    }
                }
                else if (this.evtState == true && this.taskState == false) 
                {
                    if (this.upcomingList[i].IsTask == false)
                    {
                        upList.push(this.upcomingList[i]);
                    }
                }
                else if (this.evtState == false && this.taskState == true)
                {
                    if (this.upcomingList[i].IsTask == true) 
                    {
                        upList.push(this.upcomingList[i]);
                    }
                }
            }
            //Overdue tasks
            for (let i = 0; i < this.overdueList.length; i++) 
            {
                if (this.evtState == true && this.taskState == true)
                {
                    if (this.overdueList[i].IsTask == false || this.overdueList[i].IsTask == true)
                    {
                        ovList.push(this.overdueList[i]);
                    }
                }
                else if (this.evtState == true && this.taskState == false) 
                {
                    if (this.overdueList[i].IsTask == false) 
                    {
                        ovList.push(this.overdueList[i]);
                    }
                }
                else if (this.evtState == false && this.taskState == true) 
                {
                    if (this.overdueList[i].IsTask == true) 
                    {
                        ovList.push(this.overdueList[i]);
                    }
                }
            }           
            // Completed tasks
            for (let i = 0; i < this.completedList.length; i++) 
            {
                if (this.evtState == true && this.taskState == true) 
                {
                    if (this.completedList[i].IsTask == false || this.completedList[i].IsTask == true)
                    {
                        comList.push(this.completedList[i]);
                    }
                }
                else if (this.evtState == true && this.taskState == false) 
                {
                    if (this.completedList[i].IsTask == false)
                     {
                        comList.push(this.completedList[i]);
                    }
                }
                else if (this.evtState == false && this.taskState == true) 
                {
                    if (this.completedList[i].IsTask == true) 
                    {
                        comList.push(this.completedList[i]);
                    }
                }
            }
            this.intialComList = comList;
            this.intialOvList = ovList;
            this.intialUpList = upList;
        }
    }
}