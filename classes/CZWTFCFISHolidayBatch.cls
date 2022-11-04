global inherited sharing class CZWTFCFISHolidayBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  public Database.QueryLocator start(Database.BatchableContext bc) {
    tffa.Logger.debug('CZWTFCFISHolidayBatch Start() method');
    return Database.getQueryLocator(getQuery());
  }

  public void execute(Database.BatchableContext bc, List<SObject> brandsLst) {
    tffa.Interaction.begin(CZWTFCFISHolidayBatch.class, 'execute');
    try {
      tffa.Logger.debug('CZWTFCFISHolidayBatch execute() method brandsLst : ' + brandsLst);
      for (tffa__Brand__c brand : (List<tffa__Brand__c>) brandsLst) {
        tffa.logger.debug('CZWTFCFISHolidayBatch : Brand code: ' + brand.tffa__Code__c);

        CZWTFCFISHolidayResponse response = CZWTFCFISHolidayProvider.getHolidayDetails(brand.tffa__Code__c);
        tffa.logger.debug('CZWTFCFISHolidayBatch: Response: ' + response);

        if (response != null) {
          List<CZFISHolidayList__c> updatedHolidayDetails = getUpdatedHolidayDtls(brand.tffa__Code__c, response.holidayList);
          tffa.Logger.debug('CZWTFCFISHolidayBatch execute() method updatedHolidayDetails : ' + updatedHolidayDetails);

          List<CZFISHolidayList__c> fetchHolidayDetails = CZWTFCHelperRepository.fetchFISHolidayDetails(brand.tffa__Code__c);
          tffa.Logger.debug('CZWTFCFISHolidayBatch execute() method fetchHolidayDetails : ' + fetchHolidayDetails);

          Savepoint sp = Database.setSavepoint();
          try {
            if (!updatedHolidayDetails.isEmpty()) {
              if (!fetchHolidayDetails.isEmpty()) {
                CZWTFCHelperRepository.deleteFISHolidayList(fetchHolidayDetails);
              }
              WTFCObjectManagerRepository.doUpsertObjects(updatedHolidayDetails);
            }
          } catch (Exception ep) {
            Database.rollback(sp);
            tffa.Logger.error('CZWTFCFISHolidayBatch Exception : Rollback -' + ep.getMessage() + ' ' + ep.getStackTraceString());
          }
        }
      }
    } catch (Exception ex) {
      tffa.Logger.error('CZWTFCFISHolidayBatch Exception msg : ' + ex.getMessage() + ' ' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  public void finish(Database.BatchableContext bc) {
    tffa.Logger.debug('CZWTFCFISHolidayBatch finish() method');
  }

  private static String getQuery() {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields(new List<String>{ 'tffa__Code__c' }).build().toQuery();
    tffa.Logger.debug(query);
    return query;
  }

  public static List<CZFISHolidayList__c> getUpdatedHolidayDtls(String brandCode, List<CZWTFCFISHolidayDTO> holidayDetailsDTO) {
    List<CZFISHolidayList__c> holidayDetailsList = new List<CZFISHolidayList__c>();

    for (CZWTFCFISHolidayDTO holidayDto : holidayDetailsDTO) {
      CZFISHolidayList__c holidayDetails = new CZFISHolidayList__c();
      holidayDetails.name = brandCode + ' - ' + holidayDto.HolDesc;
      holidayDetails.BrandCode__c = brandCode;
      holidayDetails.HolidayCurYrDt__c = Date.parse(holidayDto.HolCurYrDte);
      holidayDetails.HolidayNxtYrDt__c = Date.parse(holidayDto.HolNxtYrDte);
      holidayDetails.HolidayDesc__c = holidayDto.HolDesc;
      holidayDetailsList.add(holidayDetails);
    }
    return holidayDetailsList;
  }
}