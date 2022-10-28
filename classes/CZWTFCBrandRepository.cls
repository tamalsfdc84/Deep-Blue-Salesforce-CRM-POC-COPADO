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
        mp.put(brandObj.tffa__Code__c, brandObj.Name);
      }
    }

    return mp;
  }
}