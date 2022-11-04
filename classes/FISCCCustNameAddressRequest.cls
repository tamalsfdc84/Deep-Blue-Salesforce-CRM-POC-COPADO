public with sharing class FISCCCustNameAddressRequest extends FISCCRequestBaseDTO {
  public CustAddress customerAddress;
  public FISCCCustNameAddressRequest() {
    this.customerAddress = new CustAddress();
  }

  public class CustAddress {
    public String CINmeAddrLne01;
    public String CINmeAddrLne02;
    public String CINmeAddrLne03;
    public String CINmeAddrLne04;
    public String CINmeAddrLneCde01;
    public String CINmeAddrLneCde02;
    public String CINmeAddrLneCde03;
    public String CINmeAddrLneCde04;
    public String OvrideAddrStddization;
    public String AddrOvrideInd;
    public String CINmeAddrOvrideStdInd;
  }
}