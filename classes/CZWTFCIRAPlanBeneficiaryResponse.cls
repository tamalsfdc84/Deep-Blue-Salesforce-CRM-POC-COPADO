public with sharing class CZWTFCIRAPlanBeneficiaryResponse extends FISCCTransactionResponseBaseDTO {
  public List<CZWTFCIRAPlanBeneficiaryDTO> planBeneficiariesDataLst;

  public CZWTFCIRAPlanBeneficiaryResponse() {
    this.planBeneficiariesDataLst = new List<CZWTFCIRAPlanBeneficiaryDTO>();
  }
}