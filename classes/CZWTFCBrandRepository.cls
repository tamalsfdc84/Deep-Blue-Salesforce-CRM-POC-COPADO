public inherited sharing class CZWTFCBrandRepository extends tffa.AbstractRepository {
  /**
   * returns Brand Object
   */
  public static tffa__Brand__c fetchBrandByCode(String brandCode) {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType)
      .selectFields()
      .selectChildObject('SubBrand__r')
      .selectFields()
      .build()
      .selectObject('DefaultLocation__r')
      .selectFields()
      .build()
      .whereClause('tffa__Code__c', '=:attr1')
      .build()
      .toQuery();

    List<tffa__Brand__c> brandList = doQuery(query, new List<Object>{ brandCode });

    return brandList.isEmpty() ? null : brandList[0];
  }

  /**
   * returns Brand Object
   */
  public static List<SubBrand__c> fetchSubBrandByBrandId(String brandId) {
    String query = new tffa.QueryBuilder(SubBrand__c.SObjectType).selectFields().whereClause('Brand__c', '=:attr1').build().toQuery();

    List<SubBrand__c> brandList = doQuery(query, new List<Object>{ brandId });

    return brandList.isEmpty() ? null : brandList;
  }

  /**
   * Returns Map with BrandCode as key and Brand Name as Value
   */
  public static Map<String, String> fetchBrandCodeAndName() {
    Map<String, String> mp = new Map<String, String>();
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields().build().toQuery();

    List<tffa__Brand__c> brandList = doQuery(query, new List<Object>{});
    if (!brandList.isEmpty()) {
      for (tffa__Brand__c brandObj : brandList) {
        mp.put(brandObj.tffa__Code__c, brandObj.BankShortName__c);
      }
    }

    return mp;
  }

  public static List<tffa__BrandLocation__c> fetchLocationByCodes(String brandCode) {
    tffa__Brand__c brandObj = CZWTFCBrandRepository.fetchBrandByCode(brandCode);
    List<tffa__BrandLocation__c> result = new List<tffa__BrandLocation__c>();
    String q = new tffa.QueryBuilder(tffa__BrandLocation__c.SObjectType)
      .selectFields()
      .selectObject('tffa__Location__r')
      .selectFields()
      .selectObject('tffa__Address__r')
      .selectFields()
      .build()
      .build()
      .whereClause('tffa__Brand__c', '= :attr1')
      .build()
      .toQuery();

    if (brandObj != null) {
      result = (List<tffa__BrandLocation__c>) doQuery(q, new List<Object>{ brandObj.Id });
    }
    return result.isEmpty() ? new List<tffa__BrandLocation__c>() : result;
  }

  /**
   * Returns Map with BrandCode as key and Brand Name as Value
   */
  public static Map<String, tffa__Brand__c> fetchBrandCodeAndBrandInfo() {
    Map<String, tffa__Brand__c> mp = new Map<String, tffa__Brand__c>();
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields().build().toQuery();

    List<tffa__Brand__c> brandList = doQuery(query, new List<Object>{});
    if (!brandList.isEmpty()) {
      for (tffa__Brand__c brandObj : brandList) {
        mp.put(brandObj.tffa__Code__c, brandObj);
      }
    }

    return mp;
  }

  /**
   * Returns Map with BrandCode as key and Brand Name as Value
   */
  public static List<Date> fetchBrandHolidays(String brandCode) {
    List<Date> holidayList = new List<Date>();
    String query = new tffa.QueryBuilder(CZFISHolidayList__c.SObjectType)
      .selectFields()
      .whereClause('BrandCode__c', '=:attr1')
      .build()
      .toQuery();

    List<CZFISHolidayList__c> objList = doQuery(query, new List<Object>{ brandCode });
    if (!objList.isEmpty()) {
      for (CZFISHolidayList__c obj : objList) {
        holidayList.add(obj.HolidayCurYrDt__c);
        holidayList.add(obj.HolidayNxtYrDt__c);
      }
    }
    return holidayList;
  }

  /**
   * returns Brand Object
   */
  public static List<tffa__Brand__c> fetchAllBrands() {
    String query = new tffa.QueryBuilder(tffa__Brand__c.SObjectType).selectFields().build().toQuery();

    List<tffa__Brand__c> brandList = doQuery(query, new List<Object>{});

    return brandList.isEmpty() ? new List<tffa__Brand__c>() : brandList;
  }
}