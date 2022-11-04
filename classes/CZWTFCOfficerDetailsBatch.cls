global inherited sharing class CZWTFCOfficerDetailsBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    tffa.Logger.debug('CZWTFCOfficerDetailsBatch Start() method');
    return Database.getQueryLocator(getQuery());
  }

  public void execute(Database.BatchableContext bc, List<SObject> brandsLst) {
    tffa.Logger.debug('CZWTFCOfficerDetailsBatch execute() method brandsLst : ' + brandsLst);
    tffa.Interaction.begin(CZWTFCOfficerDetailsBatch.class, 'execute');

    try {
      for (tffa__Brand__c brand : (List<tffa__Brand__c>) brandsLst) {
        tffa.logger.debug('CZWTFCOfficerDetailsBatch : Brand code: ' + brand.tffa__Code__c);

        CZWTFCOfficerDetailsResponse response = CZWTFCOfficerDetailsProvider.getOfficerDetails(brand.tffa__Code__c);
        tffa.logger.debug('CZWTFCOfficerDetailsBatch: Response: ' + response);

        if (response != null) {
          List<CZOfficerDetails__c> updatedOffDetails = getUpdatedOfficerDtls(brand.tffa__Code__c, response.officerDetailsLts);
          tffa.Logger.debug('CZWTFCOfficerDetailsBatch execute() method updatedOffDetails : ' + updatedOffDetails);

          List<CZOfficerDetails__c> fetchOfficerDetails = CZWTFCHelperRepository.fetchOfficerDetails(brand.tffa__Code__c);
          tffa.Logger.debug('CZWTFCOfficerDetailsBatch execute() method fetchOfficerDetails : ' + fetchOfficerDetails);

          Savepoint sp = Database.setSavepoint();
          try {
            if (!updatedOffDetails.isEmpty()) {
              if (!fetchOfficerDetails.isEmpty()) {
                CZWTFCHelperRepository.deleteOfficerList(fetchOfficerDetails);
              }
              WTFCObjectManagerRepository.doUpsertObjects(updatedOffDetails);
            }
          } catch (Exception ep) {
            Database.rollback(sp);
            tffa.Logger.error('CZWTFCOfficerDetailsBatch Exception : ' + ep.getMessage() + ' ' + ep.getStackTraceString());
            tffa.logger.debug('CZWTFCOfficerDetailsBatch: Rollback ');
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('CZWTFCOfficerDetailsBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
      tffa.Logger.flush();
    }
  }

  public void finish(Database.BatchableContext bc) {
    tffa.Logger.debug('CZWTFCOfficerDetailsBatch finish() method');
  }

  private static String getQuery() {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields(new List<String>{ 'tffa__Code__c' }).build().toQuery();
    tffa.Logger.debug(query);
    return query;
  }

  public static List<CZOfficerDetails__c> getUpdatedOfficerDtls(String brandCode, List<CZWTFCOfficerDetailsDTO> officerDetailsDTO) {
    List<CZOfficerDetails__c> officerDetailsList = new List<CZOfficerDetails__c>();

    for (CZWTFCOfficerDetailsDTO offDto : officerDetailsDTO) {
      CZOfficerDetails__c officerDetails = new CZOfficerDetails__c();
      officerDetails.BrandCode__c = brandCode;
      officerDetails.OfficerName__c = offDto.Nme;
      officerDetails.OfficerNumber__c = offDto.OfcrNbr;
      officerDetailsList.add(officerDetails);
    }
    return officerDetailsList;
  }
}