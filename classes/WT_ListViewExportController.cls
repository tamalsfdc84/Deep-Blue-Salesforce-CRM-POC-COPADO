/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_ListViewExportController
* @Author           Francis Xavier     <fxavierd@wintrust.com> 
* @ModifiedBy       Francis Xavier     <fxavierd@wintrust.com> 
* @version          v1.0 
* @CreatedDate      04-20-2022
* @UsedBy           LWC_Component:  wT_ListViewExport_LWC
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/
// Test class: WT_ListViewExportController_T

public class WT_ListViewExportController
{
    
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates  
* @Changes          Name                Description
* 04/20/2022        Francis Xavier      Changes to 
* --------------------------------------------------------------------------------------------------------------
* @Param  objectName    String of Object Name
* --------------------------------------------------------------------------------------------------------------
**/
    
    @AuraEnabled(cacheable = true)
    public static SobjectListInfoData fetchRecords( String objectName )
    {
        try
        {
            List<ListView> listViews = [SELECT id, Name FROM ListView WHERE SobjectType =: objectName AND LastViewedDate != NULL ORDER BY LastViewedDate DESC LIMIT 1];
            
            WT_ListViewExportDescribeResponse response = WT_ListViewExportAPI.describeListView( listViews[0].Id, objectName );
            
            List<DataTableColumn> lstDataColumn = new List<DataTableColumn>();
            List<String> fieldLabels = New List<String>();
            List<String> fieldApis = New List<String>();
            
            for(WT_ListViewExportDescribeResponse.Columns column : response.columns)
            {
                if(!column.hidden)
                {
                    fieldLabels.add(column.label); 
                    fieldApis.add(column.fieldNameOrPath);
                    
                    DataTableColumn datacolumn = new DataTableColumn();
                    datacolumn.label = column.label;
                    datacolumn.fieldName = column.fieldNameOrPath;
                    
                    lstDataColumn.add(datacolumn);
                }
            }
            
            String query = response.query + ' LIMIT 10000';
            List<SObject> listSObject = Database.query(query);
            
            SobjectListInfoData listInfo = new SobjectListInfoData();
            listInfo.sObjectData = listSObject;
            listInfo.lstDataTableColumn = lstDataColumn;
            listInfo.labelNames = fieldLabels;
            listInfo.apiNames = fieldApis;
            listInfo.listViewName = listViews[0].Id;
            
            return listInfo;
        }
        catch(exception ex)
        {
            return null;
        }
    }
    
    public class SobjectListInfoData
    {
        @AuraEnabled
        public List<SObject> sObjectData { get; set; }
        @AuraEnabled
        public List<DataTableColumn> lstDataTableColumn {get;set;}
        @AuraEnabled
        public String listViewName {get;set;}
        @AuraEnabled
        public List<String> labelNames {get;set;}
        @AuraEnabled
        public List<String> apiNames {get;set;}
    }
    
    public class DataTableColumn
    {
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled       
        public String fieldName {get;set;}
    }
}