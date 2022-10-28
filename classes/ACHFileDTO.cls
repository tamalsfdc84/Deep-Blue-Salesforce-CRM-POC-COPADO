/**
   @author			Sagar Padhye
   @description	The class is used to send email notifications
   @version		1.0  4 April, 2019

   @author      Girish Suvarna
   @description The class is modified for handling request as per momentum
   @version   2.0   13-02, 2019
 */
public with sharing class ACHFileDTO {
  public Datetime buildDate = Datetime.now();
  public Datetime effectiveDate = Datetime.now().addDays(ACHConstants.ADDITIONAL_DAYS_FOR_EFFECTIVE_DATE);

  static List<ACHConfigurations__mdt> achConfig; // This implementation will change as there will be a switch case or something here
  //= CZWTFCACHRepository.getMetaData();

  public String companyId;
  public String companyName;
  public String immediateOrigin;
  public String immediateOriginName;
  public String immediateDestination;
  public String immediateDestinationName;
  public String odfiId;
  public String brandCode;
  public String originatorStatusCode;

  //public List<APPSDVData__c> sdvs;
  public List<tffa__FundingRequest__c> abtAccts;
  //public static List<TF4SF__debug_logs__c> logs = new List<TF4SF__debug_logs__c>();
  public ACHFileType filesType;
  public String achFileName;
  public String achFilePrefix;
  public String reportFileName;
  public String folderName;
  public String serviceCode;
  public String entryClassDesc;
  public String fileDesc;
  public final String reportFileDesc = 'ReportFile';
  public Integer fileNo;
  public Integer batchNo = 0;
  public ID folderId;
  public String region;

  /**
   * Constructor instantiates the DTO for file creation
   * @param    filesType    Type of the files to be generated SDV/ACH
   * pass one more argument List<SObject> assign it to abtaccount or sdv based on ACHFileType
   * @see    ACHConstants for ACHFileType constants
   */
  public ACHFileDTO(ACHFileType filesType, List<SObject> ojbs, String brandCode) {
    // and here we are suppose to add th ebrand code to populate proper config and we also need to call a method internally like populate proper config based on the input brand code

    //let us check if brand code can be fetched from this point
    this.brandCode = brandCode;

    this.filesType = filesType;

    achConfig = CZWTFCACHRepository.getMetaData(brandCode);

    //we will be fetching name prefix for ACH file also

    if (ACHFileType.ACH == filesType) {
      this.serviceCode = ACHConstants.FIELD_SERVICECODE_DEBITS;
      this.abtAccts = (List<tffa__FundingRequest__c>) ojbs;

      if (achConfig != null && achConfig.size() > 0) {
        for (ACHConfigurations__mdt achConfigs : achConfig) {
          //this.entryClassDesc = String.isNotBlank(achConfigs.ACH_Description__c) ? achConfigs.ACH_Description__c : 'FUNDING';
          this.entryClassDesc = 'FUNDING';
          this.companyId = achConfigs.CompanyId__c;
          this.companyName = achConfigs.CompanyName__c;
          this.immediateOrigin = achConfigs.ImmediateOrigin__c;
          if (achConfigs.ImmediateOriginName__c.length() > 23) {
            this.immediateOriginName = achConfigs.ImmediateOriginName__c.subString(0, 23);
          } else {
            this.immediateOriginName = achConfigs.ImmediateOriginName__c;
          }
          this.immediateDestination = achConfigs.ImmediateDestination__c;
          this.immediateDestinationName = achConfigs.ImmediateDestinationName__c;
          this.odfiId = achConfigs.ODFI__c;
          this.originatorStatusCode = achConfigs.OriginatorStatusCode__c;
        }
        this.achFilePrefix = achConfig[0].ACHFileNamePrefix__c;
      }
    } else if (ACHFileType.SDV == filesType) {
      this.serviceCode = ACHConstants.FIELD_SERVICECODE_MIXEDTXNS;
      //	this.entryClassDesc = String.isNotBlank(achConfigs.SDVDescription) ? achConfigs.SDVDescription : 'VALIDATION';
      //this.sdvs = (List<APPSDVData__c>)ojbs;

      /* this.companyId = achConfigs.SDVCompanyId;
        this.companyName = achConfigs.SDVCompanyName;
        this.immediateOrigin = achConfigs.SDVImmediateOrigin;
        this.immediateOriginName = achConfigs.SDVImmediateOriginName;
        this.immediateDestination = achConfigs.SDVImmediateDestination;
        this.immediateDestinationName = achConfigs.SDVImmediateDestinationName; */
    }

    //fileDesc would be ACHFile/SDVFile
    this.fileDesc = filesType + 'File';
    //folderName would be ACHFiles/SDVFiles
    this.folderName = filesType + '_FILES';
    /* Folder f = [id from Folder where name =: folderName];
     folderId = f.id; */
    Integer fileCounterForToday;
    List<ContentVersion> docs = CZWTFCACHRepository.getContentVersion();
    if (docs == null) {
      fileCounterForToday = 1;
    } else {
      fileCounterForToday = docs.size() + 1;
    }

    this.achFileName = 'TRFACH_' + this.achFilePrefix + ACHFieldFormatter.getDateTimeString(buildDate) + '_' + fileCounterForToday;

    /* set fileNo to count of file per charter as it is a single digit counter in file header */
    this.fileNo = 1;
    for (ContentVersion cv : docs) {
      if (cv.title.contains('TRFACH_' + this.achFilePrefix))
        this.fileNo++;
    }

    //New File name need to be implemented
    //this.achFileName = brandCode + '_' + filesType + '_Debit_' + ACHFieldFormatter.getDateTimeString(buildDate) + '_' + this.fileNo;

    this.reportFileName = brandCode + '_' + filesType + '_Report_' + ACHFieldFormatter.getDateTimeString(buildDate) + '_' + this.fileNo;
  }
}