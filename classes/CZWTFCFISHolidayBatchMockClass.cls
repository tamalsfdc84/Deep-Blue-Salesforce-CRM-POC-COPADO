global with sharing class CZWTFCFISHolidayBatchMockClass implements HttpCalloutMock {
  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"Entity":{"processing-schedules-weekdays":{"Tue":"Y","Thur":"Y","Wed":"Y","Sat":"N","WkDaySegEffDte":"1996-08-08","Fri":"Y","Sun":"N","Mon":"Y","HolSegEffDte":"2021-12-10"},"processing-schedules-holidaysLst":[{"HolPrevYrDte":"01/01/2021","HolCurYrDte":"01/01/2022","HolDesc":"NEW YEARS DAY","HolNxtYrDte":"01/02/2023"},{"HolPrevYrDte":"01/18/2021","HolCurYrDte":"01/17/2022","HolDesc":"MARTIN LUTHER KING","HolNxtYrDte":"01/16/2023"},{"HolPrevYrDte":"02/15/2021","HolCurYrDte":"02/21/2022","HolDesc":"PRESIDENTS DAY","HolNxtYrDte":"02/20/2023"},{"HolPrevYrDte":"05/31/2021","HolCurYrDte":"05/30/2022","HolDesc":"MEMORIAL DAY","HolNxtYrDte":"05/29/2023"},{"HolPrevYrDte":"06/19/2021","HolCurYrDte":"06/20/2022","HolDesc":"JUNETEENTH DAY","HolNxtYrDte":"06/19/2023"},{"HolPrevYrDte":"07/05/2021","HolCurYrDte":"07/04/2022","HolDesc":"INDEPENDENCE DAY","HolNxtYrDte":"07/04/2023"},{"HolPrevYrDte":"09/06/2021","HolCurYrDte":"09/05/2022","HolDesc":"LABOR DAY","HolNxtYrDte":"09/04/2023"},{"HolPrevYrDte":"10/11/2021","HolCurYrDte":"10/10/2022","HolDesc":"COLUMBUS DAY","HolNxtYrDte":"10/09/2023"},{"HolPrevYrDte":"11/11/2021","HolCurYrDte":"11/11/2022","HolDesc":"VETERANS DAY","HolNxtYrDte":"11/11/2023"},{"HolPrevYrDte":"11/25/2021","HolCurYrDte":"11/24/2022","HolDesc":"THANKSGIVING DAY","HolNxtYrDte":"11/23/2023"},{"HolPrevYrDte":"12/25/2021","HolCurYrDte":"12/26/2022","HolDesc":"CHRISTMAS DAY","HolNxtYrDte":"12/25/2023"}]},"Metadata":{"MsgLst":[{"Type":"Informational Message","Text":"Success","Severity":"Info","Code":"0"}]}}';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}