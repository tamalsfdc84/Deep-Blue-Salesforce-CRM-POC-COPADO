/**
 *
 * @description FIS response DTO used by FIS IDA (Id Authentication)
 */
public inherited sharing class FISIDAResponseDTO extends FISCCTransactionResponseBaseDTO {
  public FISIDAResponseDTO() {
    this.idaQuestion = new IdaQuestion();
    this.idaQuestion1 = new IdaQuestion();
    this.idaQuestion2 = new IdaQuestion();
    this.idaQuestion3 = new IdaQuestion();
    this.idaQuestion4 = new IdaQuestion();
    this.idaQuestion5 = new IdaQuestion();
    this.idaQuestion6 = new IdaQuestion();
    this.idaQuestion7 = new IdaQuestion();
    this.idaQuestion8 = new IdaQuestion();
    this.idaQuestion9 = new IdaQuestion();
  }

  public IdaQuestion idaQuestion;
  public IdaQuestion idaQuestion1;
  public IdaQuestion idaQuestion2;
  public IdaQuestion idaQuestion3;
  public IdaQuestion idaQuestion4;
  public IdaQuestion idaQuestion5;
  public IdaQuestion idaQuestion6;
  public IdaQuestion idaQuestion7;
  public IdaQuestion idaQuestion8;
  public IdaQuestion idaQuestion9;
  public String quizId;
  public String quizRemain;
  public String quizTime;
  public String transId;
  public String userReferenceText1;
  public String userReferenceText2;
  public String userReferenceText3;
  public String errorCd;
  public String errorTxt;

  // for verification
  public long base;
  public String decision;
  public String idaOid;
  public long score;

  public class IdaQuestions {
    public IdaQuestions() {
      this.idaQuestion1 = new IdaQuestion();
      this.idaQuestion2 = new IdaQuestion();
      this.idaQuestion3 = new IdaQuestion();
      this.idaQuestion4 = new IdaQuestion();
      this.idaQuestion5 = new IdaQuestion();
      this.idaQuestion6 = new IdaQuestion();
      this.idaQuestion7 = new IdaQuestion();
      this.idaQuestion8 = new IdaQuestion();
      this.idaQuestion9 = new IdaQuestion();
    }

    public IdaQuestion idaQuestion1;
    public IdaQuestion idaQuestion2;
    public IdaQuestion idaQuestion3;
    public IdaQuestion idaQuestion4;
    public IdaQuestion idaQuestion5;
    public IdaQuestion idaQuestion6;
    public IdaQuestion idaQuestion7;
    public IdaQuestion idaQuestion8;
    public IdaQuestion idaQuestion9;
    public String quizId;
    public String quizRemain;
    public String quizTime;
    public String transId;
    public String userReferenceText1;
    public String userReferenceText2;
    public String userReferenceText3;
    public String errorCd;
    public String errorTxt;
  }

  public class IdaDecision {
    public IdaDecision() {
      this.idaQuiz = new IdaQuestions();
    }

    public long base;
    public String decision;
    public String idaOid;
    public IdaQuestions idaQuiz;
    public long score;
    public String userReferenceText1;
    public String userReferenceText2;
    public String userReferenceText3;
    public String errorCd;
    public String errorTxt;
  }

  public class IdaQuestion {
    public String answer1Id;
    public String answer1Text;
    public String answer2Id;
    public String answer2Text;
    public String answer3Id;
    public String answer3Text;
    public String answer4Id;
    public String answer4Text;
    public String answer5Id;
    public String answer5Text;
    public String answer6Id;
    public String answer6Text;
    public String id;
    public String questionText;
  }
}