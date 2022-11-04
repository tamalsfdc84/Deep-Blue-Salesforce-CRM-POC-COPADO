import { LightningElement, api, wire } from 'lwc';
import getEmbeddingDataForReport from '@salesforce/apex/WT_PowerBiEmbedManager.getEmbeddingDataForReport';
import getNonDefaultReportDataForEmbedding from '@salesforce/apex/WT_PowerBiEmbedManager.getNonDefaultReportDataForEmbedding';
import getPowerBIRecordDetails from '@salesforce/apex/WT_PowerBiEmbedManager.getPowerBIRecordDetails';
import powerbijs from '@salesforce/resourceUrl/WT_PowerBI_JS';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
export default class WT_PowerBiReportsPage extends LightningElement {  
    testUrl = '';
    @api recordId;
    @api PBWorkSpaceId;
    @api PBReportId;
    @api PBReportType;
    @api PBUserFilter;
    @api PBiIsMMScoreCard = false;
    @api PBiIsCREScoreCard = false;
    @api isAccountRecord = false;
    @api reportContainerTitle = null;
    report = null;
    
    @wire(getPowerBIRecordDetails,{ recordId: '$recordId'})
    wiredRecord({ error, data }) {
        if(data){          
            if(!data.IsAccountRecord){
                this.PBWorkSpaceId = data.PowerBiReportWorkspaceId;
                this.PBReportId = data.PowerBiReportId;
                this.PBReportType = data.PowerBiReportType;
                this.PBUserFilter = data.PowerBiReportUserFilter;
                this.PBiIsCREScoreCard = data.IsCreScorecard;
                this.PBiIsMMScoreCard = data.IsMMScorecard;
                this.isAccountRecord = data.IsAccountRecord;            
                this.error = undefined;
                this.reportContainerTitle = 'Embedded Power BI Report';
                this.getEmbedData();
            }
            else{
                this.getEmbedDataForNonDefaultReport();
            }
        }
        else{
            this.error = error;
        }
    }

    getEmbedDataForNonDefaultReport(){
        getNonDefaultReportDataForEmbedding(
            { 
                WorkspaceId: this.PBWorkSpaceId, 
                ReportId: this.PBReportId,
                ReportType: this.PBReportType,
                UserFilter: this.PBUserFilter,
                CREScoreCard: this.PBiIsCREScoreCard,
                MMScoreCard: this.PBiIsMMScoreCard,
                isAccountRecord: this.isAccountRecord,
                recordId: this.recordId
            })
            .then(result => {
                this.report = result;
                this.renderPowerBiReport();
            })
            .catch(error => {
                this.error = error;
            });
    }

    getEmbedData(){
        getEmbeddingDataForReport(
            { 
                WorkspaceId: this.PBWorkSpaceId, 
                ReportId: this.PBReportId,
                ReportType: this.PBReportType,
                UserFilter: this.PBUserFilter,
                CREScoreCard: this.PBiIsCREScoreCard,
                MMScoreCard: this.PBiIsMMScoreCard
            })
            .then(result => {
                this.report = result;
                this.renderPowerBiReport();
            })
            .catch(error => {
                this.error = error;
            });
    }

    renderPowerBiReport(){
        if(this.report){ 
            Promise.all([loadScript(this, powerbijs)]).then(() => 
            { 
                this.testUrl = this.report.embedUrl;
                if(this.report.embedUrl && this.report.embedToken){
                    var reportContainer = this.template.querySelector('[data-id="embed-container"');
                    if(reportContainer){
                        var reportId = this.report.reportId;
                        var embedUrl = this.report.embedUrl;
                        var token = this.report.embedToken;                    
                    
                        var config = {
                            type: 'report',
                            id: reportId,
                            embedUrl: embedUrl,
                            accessToken: token,
                            tokenType: 1,
                            settings: {
                                panes: {
                                    filters: { expanded: false, visible: true },
                                    pageNavigation: { visible: false }
                                }
                            }
                        };                

                        // Embed the report and display it within the div container.
                        var report = powerbi.embed(reportContainer, config); 
                    }
                }
                else{
                    console.log('no embedUrl or embedToken');
                }
            }); 
        }
        else{
            console.log('no report.data yet');
        }   
    }
}