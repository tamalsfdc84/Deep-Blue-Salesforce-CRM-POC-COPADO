/**
* -------------------------------------------------------------------------------------------------------------------------------------------------
* @Name             WT_ListViewExportAPI
* @Author           Francis Xavier     <fxavierd@wintrust.com> 
* @ModifiedBy       Francis Xavier     <fxavierd@wintrust.com> 
* @version          v1.0 
* @CreatedDate      04-20-2022
* @UsedBy           Apex Class :  WT_ListViewExportController
* ---------------------------------------------------------------------------------------------------------------------------------------------------
**/

public class WT_ListViewExportAPI 
{
    
/**
* --------------------------------------------------------------------------------------------------------------
* @Description
* This method updates  
* @Changes          Name                Description
* 04/20/2022        Francis Xavier      Changes to 
* --------------------------------------------------------------------------------------------------------------
* @Param  listViewId    Id of ListView
* @Param  objectName       String of Object Name
* --------------------------------------------------------------------------------------------------------------
**/
    public static WT_ListViewExportDescribeResponse describeListView( Id listViewId, String objectName )
    {
        Http http = new Http();
        HTTPRequest request = new HTTPRequest();
        String endpoint =  '/services/data/v50.0/sobjects/' + objectName + '/listviews/' + listViewId + '/describe';
        request.setEndpoint('callout:ListViewExport'+endpoint);
        request.setMethod( 'GET' );
        request.setHeader( 'Content-Type', 'application/json' );
        request.setHeader( 'Accept', 'application/json' );
        HTTPResponse response = http.send( request ); 
        
        WT_ListViewExportDescribeResponse listViewDescResp = ( WT_ListViewExportDescribeResponse ) JSON.deserialize( response.getBody(), WT_ListViewExportDescribeResponse.class );
        return listViewDescResp;
    }
}