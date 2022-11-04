public with sharing class FISCCFetchDueDiligenceRespDTO extends FISCCTransactionResponseBaseDTO {
  public FISCCFetchDueDiligenceRespDTO() {
    this.Entity = new Entity();
  }

  public Entity Entity;
  public class Entity {
    public DueDiligenceDemographics dueDiligenceDemographics;
    public List<IncomingCountry> incomingCountry;
    public List<OutgoingCountry> outgoingCountry;
    public Entity() {
      this.incomingCountry = new List<IncomingCountry>();
      this.outgoingCountry = new List<OutgoingCountry>();
      this.dueDiligenceDemographics = new DueDiligenceDemographics();
    }
  }
  public class DueDiligenceDemographics {
    public String userDefLblInd;
    public String custType;
    public String lstMaintOper;
    public String lstMaintDte;
    public String initDp;
    public String typOfFunds;
    public String srcOfFunds;
    public String nbrOfDp;
    public String totDpAmt;
    public String nbrCashDp;
    public String cashDpAmt;
    public String nbrOfCashWthdrwl;
    public String cashWthdrwlAmt;
    public String nbrOfChkWritn;
    public String ckAmtWritn;
    public String antWireAct;
    public String domInWireAct;
    public String nbrDomWire;
    public String domInWireAmt;
    public String domOutWireAct;
    public String nbrDomOutWire;
    public String domOutWireAmt;
    public String frgnInWireAct;
    public String nbrFrgnInWire;
    public String frgnInWireAmt;
    public String frgnOutWireAct;
    public String nbrFrgnOutWire;
    public String frgnOutWireAmt;
    public String polExpsedOrg;
    public String polRel;
    public String prsnlRlt;
    public String prsnlRltTyp;
    public String cmmt;
    public String custRsk;
    public String aCHPymt;
    public String origACHPymt;
    public String infoObtnBy;
    public String cmpltDte;
    public String usrDefFld1;
    public String usrDefFldLbl1;
    public String usrDefFld2;
    public String usrDefFldLbl2;
    public String usrDefFld3;
    public String usrDefFldLbl3;
    public String usrDefFld4;
    public String usrDefLbl4;
    public String usrDefFld5;
    public String usrDefFldLbl5;
    public String usrDefFld6;
    public String usrDefFldLbl6;
    public String usrDefFld7;
    public String usrDefFldLbl7;
    public String usrDefFld8;
    public String usrDefFldLbl8;
    public String usrDefFld9;
    public String usrDefFldLbl9;
    public String usrDefFld10;
    public String usrDefFldLbl10;
    public String usrDefFld11;
    public String usrDefFldLbl11;
    public String usrDefFld12;
    public String usrDefFldLbl12;
    public String usrDefFldLbl13;
    public String usrDefFld13;
    public String usrDefFld14;
    public String usrDefFldLbl14;
    public String usrDefFld15;
    public String usrDefFldLbl15;
    public String usrDefFld16;
    public String usrDefFldLbl16;
    public String usrDefFld17;
    public String usrDefFldLbl17;
    public String usrDefFld18;
    public String usrDefFldLbl18;
    public String usrDefFld19;
    public String usrDefFldLbl19;
    public String usrDefFld20;
    public String usrDefFldLbl20;
    public String usrDefFld21;
    public String usrDefFldLbl21;
    public String usrDefFld22;
    public String usrDefFldLbl22;
    public String usrDefFld23;
    public String usrDefFldLbl23;
    public String usrDefFld24;
    public String usrDefFldLbl24;
    public String usrDefFld25;
    public String usrDefFldLbl25;
    public String usrDefFld26;
    public String usrDefFldLbl26;
    public String usrDefFld27;
    public String usrDefFldLbl27;
    public String usrDefFld28;
    public String usrDefFldLbl28;
    public String usrDefFld29;
    public String usrDefFldLbl29;
    public String usrDefFld30;
    public String usrDefFldLbl30;
    public String usrDefFld31;
    public String usrDefFldLbl31;
    public String usrDefFld32;
    public String usrDefFldLbl32;
    public String usrDefFld33;
    public String usrDefFldLbl33;
    public String usrDefFld34;
    public String usrDefFldLbl34;
    public String usrDefFld35;
    public String usrDefFldLbl35;
    public String usrDefFld36;
    public String usrDefFldLbl36;
    public String usrDefFld37;
    public String usrDefFldLbl37;
    public String usrDefFld38;
    public String usrDefFldLbl38;
    public String usrDefFld39;
    public String usrDefFldLbl39;
    public String usrDefFld40;
    public String usrDefFldLbl40;
    public String cntryCtznshp;
    public String cntryDualCtznshp;
    public String rsdntPrsn;
    public String scndyEmplr;
    public String occpnDesc;
    public String title;
    public String fullTime;
    public String descBus;
    public String highRisk;
    public String mnySrvBus;
    public String mnyOrdr;
    public String mnyOrdrReg;
    public String mnyOrdrCnfmID;
    public String mnyOrdrActAgnt;
    public String mnyOrdrMaxDailyAmt;
    public String mnyOrdrMthlySales;
    public String mnyOrdrPrcntIncm;
    public String trvlrCk;
    public String trvlrCkReg;
    public String trvlrCkCnfrmID;
    public String trvlrCkActAgnt;
    public String trvlrCkMaxAmt;
    public String trvlrCkMthlySales;
    public String trvlrCkPrcntIncome;
    public String mnyTrn;
    public String mnyTxnReg;
    public String mnyTrnRegConfrmID;
    public String mnyTrnActAgnt;
    public String mnyTrnMaxDailyAmt;
    public String mnyTrnMthlySales;
    public String mnyTrnPrcntIncome;
    public String ckCash;
    public String ckCashReg;
    public String ckCashRegCnfrmID;
    public String ckCashActAgnt;
    public String ckCashMaxAmt;
    public String ckCashMthlySales;
    public String ckCashPrcntIncome;
    public String crncyExchg;
    public String crncyExchgReg;
    public String crncyExchgCnfmID;
    public String crncyExchgActAgnt;
    public String crncyExchgMaxAmt;
    public String crncyExchgMthlySale;
    public String crncyExchgPrcntIncome;
    public String crncyDeal;
    public String crncyDealReg;
    public String crncyDealRegCnfmID;
    public String crncyDealActAgnt;
    public String crncyDealMaxAmt;
    public String crncyDealMthlySales;
    public String crncyDealPrcntIncome;
    public String strVal;
    public String strValReg;
    public String strValRegCnfmID;
    public String strValActAgnt;
    public String strValMaxAmt;
    public String strValMthlySale;
    public String strValPrcntIncome;

    public String getValue(String fieldname) {
      switch on fieldname {
        when 'InitDp' {
          return InitDp;
        }
        when 'TypOfFunds' {
          return TypOfFunds;
        }
        when 'SrcOfFunds' {
          return SrcOfFunds;
        }
        when 'NbrOfDp' {
          return NbrOfDp;
        }
        when 'TotDpAmt' {
          return TotDpAmt;
        }
        when 'NbrCashDp' {
          return NbrCashDp;
        }
        when 'CashDpAmt' {
          return CashDpAmt;
        }
        when 'NbrOfCashWthdrwl' {
          return NbrOfCashWthdrwl;
        }
        when 'CashWthdrwlAmt' {
          return CashWthdrwlAmt;
        }
        when 'NbrOfChkWritn' {
          return NbrOfChkWritn;
        }
        when 'CkAmtWritn' {
          return CkAmtWritn;
        }
        when 'AntWireAct' {
          return AntWireAct;
        }
        when 'DomInWireAct' {
          return DomInWireAct;
        }
        when 'NbrDomWire' {
          return NbrDomWire;
        }
        when 'DomInWireAmt' {
          return DomInWireAmt;
        }
        when 'DomOutWireAct' {
          return DomOutWireAct;
        }
        when 'NbrDomOutWire' {
          return NbrDomOutWire;
        }
        when 'DomOutWireAmt' {
          return DomOutWireAmt;
        }
        when 'FrgnInWireAct' {
          return FrgnInWireAct;
        }
        when 'NbrFrgnInWire' {
          return NbrFrgnInWire;
        }
        when 'FrgnInWireAmt' {
          return FrgnInWireAmt;
        }
        when 'FrgnOutWireAct' {
          return FrgnOutWireAct;
        }
        when 'NbrFrgnOutWire' {
          return NbrFrgnOutWire;
        }
        when 'FrgnOutWireAmt' {
          return FrgnOutWireAmt;
        }
        when 'PolExpsedOrg' {
          return PolExpsedOrg;
        }
        when 'PolRel' {
          return PolRel;
        }
        when 'PrsnlRlt' {
          return PrsnlRlt;
        }
        when 'PrsnlRltTyp' {
          return PrsnlRltTyp;
        }
        when 'Cmmt' {
          return Cmmt;
        }
        when 'CustRsk' {
          return CustRsk;
        }
        when 'ACHPymt' {
          return ACHPymt;
        }
        when 'OrigACHPymt' {
          return OrigACHPymt;
        }
        when 'InfoObtnBy' {
          return InfoObtnBy;
        }
        when 'CmpltDte' {
          return CmpltDte;
        }
        when 'UsrDefFld1' {
          return UsrDefFld1;
        }
        when 'UsrDefFld2' {
          return UsrDefFld2;
        }
        when 'UsrDefFld3' {
          return UsrDefFld3;
        }
        when 'UsrDefFld4' {
          return UsrDefFld4;
        }
        when 'UsrDefFld5' {
          return UsrDefFld5;
        }
        when 'UsrDefFld6' {
          return UsrDefFld6;
        }
        when 'UsrDefFld7' {
          return UsrDefFld7;
        }
        when 'UsrDefFld8' {
          return UsrDefFld8;
        }
        when 'UsrDefFld9' {
          return UsrDefFld9;
        }
        when 'UsrDefFld10' {
          return UsrDefFld10;
        }
        when 'UsrDefFld11' {
          return UsrDefFld11;
        }
        when 'UsrDefFld12' {
          return UsrDefFld12;
        }
        when 'UsrDefFld13' {
          return UsrDefFld13;
        }
        when 'UsrDefFld14' {
          return UsrDefFld14;
        }
        when 'UsrDefFld15' {
          return UsrDefFld15;
        }
        when 'UsrDefFld16' {
          return UsrDefFld16;
        }
        when 'UsrDefFld17' {
          return UsrDefFld17;
        }
        when 'UsrDefFld18' {
          return UsrDefFld18;
        }
        when 'UsrDefFld19' {
          return UsrDefFld19;
        }
        when 'UsrDefFld20' {
          return UsrDefFld20;
        }
        when 'UsrDefFld21' {
          return UsrDefFld21;
        }
        when 'UsrDefFld22' {
          return UsrDefFld22;
        }
        when 'UsrDefFld23' {
          return UsrDefFld23;
        }
        when 'UsrDefFld24' {
          return UsrDefFld24;
        }
        when 'UsrDefFld25' {
          return UsrDefFld25;
        }
        when 'UsrDefFld26' {
          return UsrDefFld26;
        }
        when 'UsrDefFld27' {
          return UsrDefFld27;
        }
        when 'UsrDefFld28' {
          return UsrDefFld28;
        }
        when 'UsrDefFld29' {
          return UsrDefFld29;
        }
        when 'UsrDefFld30' {
          return UsrDefFld30;
        }
        when 'UsrDefFld31' {
          return UsrDefFld31;
        }
        when 'UsrDefFld32' {
          return UsrDefFld32;
        }
        when 'UsrDefFld33' {
          return UsrDefFld33;
        }
        when 'UsrDefFld34' {
          return UsrDefFld34;
        }
        when 'UsrDefFld35' {
          return UsrDefFld35;
        }
        when 'UsrDefFld36' {
          return UsrDefFld36;
        }
        when 'UsrDefFld37' {
          return UsrDefFld37;
        }
        when 'UsrDefFld38' {
          return UsrDefFld38;
        }
        when 'UsrDefFld39' {
          return UsrDefFld39;
        }
        when 'UsrDefFld40' {
          return UsrDefFld40;
        }
        when 'CntryCtznshp' {
          return CntryCtznshp;
        }
        when 'CntryDualCtznshp' {
          return CntryDualCtznshp;
        }
        when 'RsdntPrsn' {
          return RsdntPrsn;
        }
        when 'ScndyEmplr' {
          return ScndyEmplr;
        }
        when 'OccpnDesc' {
          return OccpnDesc;
        }
        when 'Title' {
          return Title;
        }
        when 'FullTime' {
          return FullTime;
        }
        when 'DescBus' {
          return DescBus;
        }
        when 'HighRisk' {
          return HighRisk;
        }
        when 'MnySrvBus' {
          return MnySrvBus;
        }
        when 'MnyOrdr' {
          return MnyOrdr;
        }
        when 'MnyOrdrReg' {
          return MnyOrdrReg;
        }
        when 'MnyOrdrCnfmID' {
          return MnyOrdrCnfmID;
        }
        when 'MnyOrdrActAgnt' {
          return MnyOrdrActAgnt;
        }
        when 'MnyOrdrMaxDailyAmt' {
          return MnyOrdrMaxDailyAmt;
        }
        when 'MnyOrdrMthlySales' {
          return MnyOrdrMthlySales;
        }
        when 'MnyOrdrPrcntIncm' {
          return MnyOrdrPrcntIncm;
        }
        when 'TrvlrCk' {
          return TrvlrCk;
        }
        when 'TrvlrCkReg' {
          return TrvlrCkReg;
        }
        when 'TrvlrCkCnfrmID' {
          return TrvlrCkCnfrmID;
        }
        when 'TrvlrCkActAgnt' {
          return TrvlrCkActAgnt;
        }
        when 'TrvlrCkMaxAmt' {
          return TrvlrCkMaxAmt;
        }
        when 'TrvlrCkMthlySales' {
          return TrvlrCkMthlySales;
        }
        when 'TrvlrCkPrcntIncome' {
          return TrvlrCkPrcntIncome;
        }
        when 'MnyTrn' {
          return MnyTrn;
        }
        when 'MnyTxnReg' {
          return MnyTxnReg;
        }
        when 'MnyTrnRegConfrmID' {
          return MnyTrnRegConfrmID;
        }
        when 'MnyTrnActAgnt' {
          return MnyTrnActAgnt;
        }
        when 'MnyTrnMaxDailyAmt' {
          return MnyTrnMaxDailyAmt;
        }
        when 'MnyTrnMthlySales' {
          return MnyTrnMthlySales;
        }
        when 'MnyTrnPrcntIncome' {
          return MnyTrnPrcntIncome;
        }
        when 'CkCash' {
          return CkCash;
        }
        when 'CkCashReg' {
          return CkCashReg;
        }
        when 'CkCashRegCnfrmID' {
          return CkCashRegCnfrmID;
        }
        when 'CkCashActAgnt' {
          return CkCashActAgnt;
        }
        when 'CkCashMaxAmt' {
          return CkCashMaxAmt;
        }
        when 'CkCashMthlySales' {
          return CkCashMthlySales;
        }
        when 'CkCashPrcntIncome' {
          return CkCashPrcntIncome;
        }
        when 'CrncyExchg' {
          return CrncyExchg;
        }
        when 'CrncyExchgReg' {
          return CrncyExchgReg;
        }
        when 'CrncyExchgCnfmID' {
          return CrncyExchgCnfmID;
        }
        when 'CrncyExchgActAgnt' {
          return CrncyExchgActAgnt;
        }
        when 'CrncyExchgMaxAmt' {
          return CrncyExchgMaxAmt;
        }
        when 'CrncyExchgMthlySale' {
          return CrncyExchgMthlySale;
        }
        when 'CrncyExchgPrcntIncome' {
          return CrncyExchgPrcntIncome;
        }
        when 'CrncyDeal' {
          return CrncyDeal;
        }
        when 'CrncyDealReg' {
          return CrncyDealReg;
        }
        when 'CrncyDealRegCnfmID' {
          return CrncyDealRegCnfmID;
        }
        when 'CrncyDealActAgnt' {
          return CrncyDealActAgnt;
        }
        when 'CrncyDealMaxAmt' {
          return CrncyDealMaxAmt;
        }
        when 'CrncyDealMthlySales' {
          return CrncyDealMthlySales;
        }
        when 'CrncyDealPrcntIncome' {
          return CrncyDealPrcntIncome;
        }
        when 'StrVal' {
          return StrVal;
        }
        when 'StrValReg' {
          return StrValReg;
        }
        when 'StrValRegCnfmID' {
          return StrValRegCnfmID;
        }
        when 'StrValActAgnt' {
          return StrValActAgnt;
        }
        when 'StrValMaxAmt' {
          return StrValMaxAmt;
        }
        when 'StrValMthlySale' {
          return StrValMthlySale;
        }
        when 'StrValPrcntIncome' {
          return StrValPrcntIncome;
        }
        when else {
          return '';
        }
      }
    }
  }

  public class IncomingCountry {
    public String InCtryCde;
  }

  public class OutgoingCountry {
    public String OutCtryCde;
  }
}