public with sharing class CZWTFCFISHolidayResponse extends FISCCResponseBaseDTO {
  public ControlData controlData;
  public List<CZWTFCFISHolidayDTO> holidayList;

  public CZWTFCFISHolidayResponse() {
    this.controlData = new ControlData();
    this.holidayList = new List<CZWTFCFISHolidayDTO>();
  }

  public class ControlData {
    public String Tue;
    public String Thur;
    public String Wed;
    public String Sat;
    public String WkDaySegEffDte;
    public String Fri;
    public String Sun;
    public String Mon;
    public String HolSegEffDte;
  }
}