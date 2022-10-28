public with sharing class CZSDBAddDeputyRequest extends FISCCDepositOriginationRequestBaseDTO {
  public CZSDBAddDeputyRequest() {
    this.boxDeputies = new CZSDBAddDeputyRequestDTO();
  }
  public CZSDBAddDeputyRequestDTO boxDeputies;
}