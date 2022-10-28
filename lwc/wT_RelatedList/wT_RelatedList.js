import { LightningElement, track, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import RelatedListHelper from "./wT_RelatedListHelper";
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils'

export default class WT_RelatedList extends NavigationMixin(LightningElement) 
{
    @track state = {}
    @api sobjectApiName;
    @api relatedFieldApiName;
    @api isAdminProfile;
    @api numberOfRecords = 1000;
    @api rowActionHandler;
    @api fields;
    @api columns;
    @api iconName;
    @api whereConditions = '';
    @api customActions = [];
    @api isLoaded = false;
    sortedBy;
    defaultSortDirection = 'asc';
    sortDirection = 'asc';
    helper = new RelatedListHelper()

    @api
    get recordId() 
    {
        return this.state.recordId;
    }

    set recordId(value) 
    {
        this.state.recordId = value;
        this.init();
    }

    get hasRecords() 
    {
        return this.state.records != null && this.state.records.length;
    }

    async init() 
    {
        this.isLoaded = true;
        this.state.showRelatedList = this.recordId != null;
        if (! (this.recordId
            && this.sobjectApiName
            && this.relatedFieldApiName
            && this.fields
            && this.columns
            && this.iconName)) {
            this.state.records = [];
            return;
        }

        this.state.fields = this.fields
        this.state.relatedFieldApiName = this.relatedFieldApiName
        this.state.isAdminProfile = this.isAdminProfile
        this.state.recordId = this.recordId
        this.state.numberOfRecords = this.numberOfRecords
        this.state.sobjectApiName = this.sobjectApiName
        this.state.customActions = this.customActions
        this.state.iconName = this.iconName;
        this.state.whereConditions = this.whereConditions;

        const data = await this.helper.fetchData(this.state);
        this.state.records = data.records;
        this.state.sobjectLabel = data.sobjectLabel;
        this.state.sobjectLabelPlural = data.sobjectLabelPlural;
        this.state.title = data.title;
        this.state.isAdminProfile = data.isAdminProfile;
        this.state.parentRelationshipApiName = data.parentRelationshipApiName;
        if(this.state.isAdminProfile)
        {
            this.state.columns = this.helper.initColumnsWithActions(this.columns, this.customActions)
        }
        else
        {
            this.state.columns = this.columns
        }
        this.isLoaded = false;
    }

    handleRowAction(event) 
    {
        const actionName = event.detail.action.name;
        const row = event.detail.row;
            switch (actionName) 
            {
                case "delete":
                    this.handleDeleteRecord(row);
                    break;
                case "edit":
                    this[NavigationMixin.Navigate]
                    ({
                        type: 'standard__recordPage',
                        attributes: 
                        {
                            recordId: row.Id,
                            objectApiName: this.sobjectApiName,
                            actionName: 'edit'
                        }
                    });
                    break;
                default:
            }
    }

    handleGotoRelatedList() 
    {
        this[NavigationMixin.Navigate]
        ({
            type: "standard__recordRelationshipPage",
            attributes: 
            {
                recordId: this.recordId,
                relationshipApiName: this.state.parentRelationshipApiName,
                actionName: "view",
                objectApiName: this.sobjectApiName
            }
        });
    }

    handleDeleteRecord( row ) 
    {
        const newEditPopup = this.template.querySelector("c-w-t_-related-list-delete-pop-up");
        newEditPopup.recordId = row.Id;
        newEditPopup.recordName = row.Name;
        newEditPopup.sobjectLabel = this.state.sobjectLabel;
        newEditPopup.show();
    }

    onHandleSort( event ) 
    {
        const { fieldName: sortedBy, sortDirection } = event.detail;
        const cloneData = [...this.state.records];
        cloneData.sort( this.sortBy( sortedBy, sortDirection === 'asc' ? 1 : -1 ) );
        this.state.records = cloneData;
        this.sortDirection = sortDirection;
        this.sortedBy = sortedBy;

    }

    sortBy( field, reverse, primer ) 
    {
        const key = primer
            ? function( x ) 
              {
                  return primer(x[field]);
              }
            : function( x ) 
              {
                  return x[field];
              };

        return function( a, b ) 
        {
            a = key(a);
            b = key(b);
            return reverse * ( ( a > b ) - ( b > a ) );
        };
    }

    handleRefreshData() 
    {
        this.init();
    }
}