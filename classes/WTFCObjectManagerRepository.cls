global with sharing class WTFCObjectManagerRepository extends tffa.AbstractRepository {
  //Below all are generic methods. Note: Supports homogeneous list of records, meaning records of same type.

  public WTFCObjectManagerRepository() {
  }

  public static List<sObject> doUpsertObject(sObject entity) {
    return doUpsert(new List<sObject>{ entity });
  }

  public static List<sObject> doUpsertObjects(List<sObject> entities) {
    return doUpsert(entities);
  }

  public static void doDeleteObjects(List<sObject> entities) {
    doDelete(entities);
  }
}