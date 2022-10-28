public inherited sharing class FISIDAVerifyRequestDTO extends FISCCRequestBaseDTO {
  public FISIDAVerifyRequestDTO() {
    this.idaIdentification = new IdaIdentification();
    this.ans = new IdaAnswers();
  }

  public IdaIdentification idaIdentification;
  public IdaAnswers ans;

  public class IdaIdentification {
    public String acquirerid = '';
    public String configkey = '';
    public String customerid = '';
    public String locationid = '';
    public String productcd = '';
    public String productversion = '';
    public boolean staging;
    public String userdefinedtransactiontext1 = '';
    public String userdefinedtransactiontext2 = '';
    public String userdefinedtransactiontext3 = '';
    public String aqrcustomerid = '';
    public String aqr = '';
    public String instancecd = '';
    public String msguuid = '';
  }

  public class IdaAnswers {
    public String answer1QuestionId;
    public String answer1ResponseId;
    public String answer2QuestionId;
    public String answer2ResponseId;
    public String answer3QuestionId;
    public String answer3ResponseId;
    public String answer4QuestionId;
    public String answer4ResponseId;
    public String answer5QuestionId;
    public String answer5ResponseId;
    public String answer6QuestionId;
    public String answer6ResponseId;
    public String quizId;
    public String transId;
    public String userDefinedTransactionText1;
    public String userDefinedTransactionText2;
    public String userDefinedTransactionText3;
    public String answer7QuestionId;
    public String answer7ResponseId;
    public String answer8QuestionId;
    public String answer8ResponseId;
    public String answer9QuestionId;
    public String answer9ResponseId;
  }
}