public with sharing class FISDSSService {
  /**
   * @description stores the IDA related fields
   * @param IDAResponseDTO idaResp
   * @return tffa__DueDiligence__c
   */
  @TestVisible
  private static tffa__DueDiligence__c buildIDADueDiligence(FISIDAResponseDTO idaResp) {
    tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
    List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
    Integer counter = 0;
    try {
      if (idaResp != null) {
        dueDiligence.Name = 'FIS OOW';
        dueDiligence.tffa__Type__c = 'IDA';
        dueDiligence.tffa__Status__c = 'CHALLENGED';
        dueDiligence.tffa__Provider__c = 'FIS IDA';
        dueDiligence.tffa__ExternalQuestionnaireId__c = String.valueOf(idaResp.quizId);
        dueDiligence.tffa__ConversationId__c = String.valueOf(idaResp.transId);

        tffa.SObjectAssembler asm = new tffa.SObjectAssembler(dueDiligence);
        if (idaResp.idaQuestion1 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion1, counter++));
        if (idaResp.idaQuestion2 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion2, counter++));
        if (idaResp.idaQuestion3 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion3, counter++));
        if (idaResp.idaQuestion4 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion4, counter++));
        if (idaResp.idaQuestion5 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion5, counter++));
        if (idaResp.idaQuestion6 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion6, counter++));
        if (idaResp.idaQuestion7 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion7, counter++));
        if (idaResp.idaQuestion8 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion8, counter++));
        if (idaResp.idaQuestion9 != null)
          ddItems.add(FISDSSService.createDueDiligencItem(idaResp.idaQuestion9, counter++));
        asm.addChildObjects('Items__r', ddItems);
        dueDiligence = (tffa__DueDiligence__c) asm.assemble();
      }
    } catch (Exception e) {
      tffa.Logger.error('Exception in processKBAQuestions ' + e.getStackTraceString() + e.getLineNumber() + e.getMessage());
    }
    return dueDiligence;
  }

  /**
   * @description remove old due diligence from salesforce
   * @param tffa__Party__c partyObj
   * @return tffa__Party__c
   **/
  public static void removeExistingDueDiligence(tffa__Party__c partyObj, List<String> typeList) {
    CZWTFCHelperRepository.removeDDByPartyId(partyObj.id, typeList);
  }

  /**
   * @description stores the DueDiligenceItem related to DueDiligence
   * @param IdaQuestion idaQuestion, Integer counter
   * @return tffa__DueDiligenceItem__c
   */
  @TestVisible
  private static tffa__DueDiligenceItem__c createDueDiligencItem(FISIDAResponseDTO.IdaQuestion idaQuestion, Integer counter) {
    counter++;
    tffa__DueDiligenceItem__c item = new tffa__DueDiligenceItem__c(
      Name = idaQuestion.questionText.left(80),
      tffa__Label__c = idaQuestion.questionText,
      tffa__Code__c = String.valueOf(idaQuestion.id),
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = counter
    );
    List<Object> choices = new List<Object>();
    if (!String.isBlank(idaQuestion.answer1Text) && !String.isBlank(idaQuestion.answer1Id)) {
      choices.add(new Map<String, String>{ 'name' => idaQuestion.answer1Text, 'value' => String.valueOf(idaQuestion.answer1Id) });
    }
    if (!String.isBlank(idaQuestion.answer2Text) && !String.isBlank(idaQuestion.answer2Id)) {
      choices.add(new Map<String, String>{ 'name' => idaQuestion.answer2Text, 'value' => String.valueOf(idaQuestion.answer2Id) });
    }
    if (!String.isBlank(idaQuestion.answer3Text) && !String.isBlank(idaQuestion.answer3Id)) {
      choices.add(new Map<String, String>{ 'name' => idaQuestion.answer3Text, 'value' => String.valueOf(idaQuestion.answer3Id) });
    }
    if (!String.isBlank(idaQuestion.answer4Text) && !String.isBlank(idaQuestion.answer4Id)) {
      choices.add(new Map<String, String>{ 'name' => idaQuestion.answer4Text, 'value' => String.valueOf(idaQuestion.answer4Id) });
    }
    if (!String.isBlank(idaQuestion.answer5Text) && !String.isBlank(idaQuestion.answer5Id)) {
      choices.add(new Map<String, String>{ 'name' => idaQuestion.answer5Text, 'value' => String.valueOf(idaQuestion.answer5Id) });
    }
    if (!String.isBlank(idaQuestion.answer6Text) && !String.isBlank(idaQuestion.answer6Id)) {
      choices.add(new Map<String, String>{ 'name' => idaQuestion.answer6Text, 'value' => String.valueOf(idaQuestion.answer6Id) });
    }
    item.tffa__Choices__c = JSON.serialize(choices);
    return item;
  }

  public static tffa__Party__c upsertDueDiligence(tffa__Party__c partyObj, FISIDAResponseDTO idaResp) {
    List<tffa__DueDiligence__c> ddList = new List<tffa__DueDiligence__c>();
    tffa.SObjectAssembler asm;

    if (idaResp != null && idaResp.errorCd == null && idaResp.idaQuestion1 != null) {
      partyObj.tffa__IDAStatus__c = 'CHALLENGED';
      tffa__DueDiligence__c idaDD = FISDSSService.buildIDADueDiligence(idaResp);
      ddList.add(idaDD);
    } else if (idaResp != null && idaResp.errorCd != null) {
      tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
      dueDiligence.Name = 'FIS OOW';
      dueDiligence.tffa__Type__c = 'IDA';
      dueDiligence.tffa__Score__c = '0';
      dueDiligence.tffa__Status__c = 'FAILED';
      dueDiligence.tffa__Provider__c = 'FIS IDA';
      String response = 'ErrorCode: ' + idaResp.errorCd + ' Text: ' + idaResp.errorTxt;
      dueDiligence.tffa__Response__c = response.replace('null', '');
      partyObj.tffa__IDAStatus__c = 'FAILED';
      ddList.add(dueDiligence);
    }

    // Update Party And Insert IDA DD

    if (!ddList.isEmpty()) {
      if (!Test.isRunningTest()) {
        tffa.DueDiligenceService.createOrUpdate(partyObj.Id, ddList);
      }
      List<tffa__Party__c> partyList = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
      asm = new tffa.SObjectAssembler(partyList[0]);
      asm.addChildObjects('DueDiligences__r', ddList);
    } else {
      List<tffa__Party__c> partyList = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
      asm = new tffa.SObjectAssembler(partyList[0]);
    }
    tffa.Logger.debug('parseIDAResponse Flow Completed');
    return (tffa__Party__c) asm.assemble();
  }

  public static tffa__Party__c doAnswersCheckAndBuildDD(
    tffa__Party__c partyObj,
    FISIDAResponseDTO idaDecision,
    tffa__DueDiligence__c idaDD
  ) {
    tffa.Logger.debug('inside doAnswersCheckAndBuildDD response : ' + idaDecision);
    List<tffa__DueDiligence__c> ddList = new List<tffa__DueDiligence__c>();
    tffa.SObjectAssembler asm;

    if (idaDecision != null) {
      idaDD.tffa__Score__c = (idaDecision.score != null) ? String.valueOf(idaDecision.score) : '';
      idaDD.tffa__ProviderStatus__c = (idaDecision.decision != null) ? String.valueOf(idaDecision.decision) : '';
      if (idaDecision.decision != null && idaDecision.decision.containsIgnoreCase('Pass')) {
        partyObj.tffa__IDAStatus__c = 'PASSED';
        idaDD.tffa__Status__c = 'PASSED';
      } else if (idaDecision.decision != null && idaDecision.decision.containsIgnoreCase('Fail')) {
        partyObj.tffa__IDAStatus__c = 'DECLINED';
        partyObj.tffa__OFACStatus__c = 'FAILED';
        partyObj.tffa__DebitBureauStatus__c = 'FAILED';
        partyObj.tffa__IDVStatus__c = 'FAILED';
        idaDD.tffa__Status__c = 'DECLINED';
      } else {
        partyObj.tffa__IDAStatus__c = 'FAILED';
        partyObj.tffa__OFACStatus__c = 'FAILED';
        partyObj.tffa__DebitBureauStatus__c = 'FAILED';
        partyObj.tffa__IDVStatus__c = 'FAILED';
        String response = 'Error code: ' + idaDecision.errorCd + ' Text: ' + idaDecision.errorTxt;
        idaDD.tffa__Response__c = response.replace('null', '');
        idaDD.tffa__Status__c = 'FAILED';
      }
      asm = new tffa.SObjectAssembler(idaDD);
      if (idaDecision.idaOid != null) {
        String wrongAnswer = String.valueOf(idaDecision.base - idaDecision.score);
        Map<String, String> ddItemMap = new Map<String, String>{
          'Result' => String.valueOf(idaDecision.decision),
          'Ida Oid ' => String.valueOf(idaDecision.idaOid),
          'Number of Wrong Answers' => wrongAnswer,
          'Provider' => 'FIS OOW'
        };
        for (String code : ddItemMap.keySet()) {
          tffa__DueDiligenceItem__c ddItem = new tffa__DueDiligenceItem__c();
          ddItem.Name = code;
          ddItem.tffa__Code__c = code;
          ddItem.tffa__Value__c = ddItemMap.get(code);
          asm.addChildObject('tffa__Items__r', ddItem);
        }
      }
      idaDD = (tffa__DueDiligence__c) asm.assemble();
      ddList.add(idaDD);
    } else {
      idaDD.tffa__Score__c = '';
      idaDD.tffa__ProviderStatus__c = '';
      idaDD.tffa__Status__c = 'FAILED';
      partyObj.tffa__IDAStatus__c = 'FAILED';
      partyObj.tffa__OFACStatus__c = 'FAILED';
      partyObj.tffa__DebitBureauStatus__c = 'FAILED';
      partyObj.tffa__IDVStatus__c = 'FAILED';
      String response = 'ErrorCode: ' + idaDecision.errorCd + ' Text: ' + idaDecision.errorTxt;
      idaDD.tffa__Response__c = response.replace('null', '');
      asm = new tffa.SObjectAssembler(idaDD);
      idaDD = (tffa__DueDiligence__c) asm.assemble();
      ddList.add(idaDD);
    }

    if (!ddList.isEmpty()) {
      if (!Test.isRunningTest()) {
        tffa.DueDiligenceService.createOrUpdate(partyObj.Id, ddList);
      }
      List<tffa__Party__c> partyList = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
      asm = new tffa.SObjectAssembler(partyList[0]);
      asm.addChildObjects('DueDiligences__r', ddList);
    } else {
      List<tffa__Party__c> partyList = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
      asm = new tffa.SObjectAssembler(partyList[0]);
    }
    tffa.Logger.debug('doAnswersCheckAndBuildDD Flow Completed');
    return (tffa__Party__c) asm.assemble();
  }

  @TestVisible
  public static tffa__Party__c processIDVResult(tffa__Party__c partyObj, FISIDVResponseDTO idvResp) {
    try {
      List<tffa__DueDiligence__c> ddList = new List<tffa__DueDiligence__c>();
      tffa.SObjectAssembler asm;

      tffa__DueDiligence__c idvDD = new tffa__DueDiligence__c();
      tffa__SubmissionPartyXref__c subPartyObj = CZWTFCPartyRepository.findSubPartyById(partyObj.Id);
      String reportName = 'idv_report.html';
      if (idvResp != null && String.isBlank(idvResp.consumer.errorCd)) {
        try {
          if (idvResp.consumer != null && idvResp.consumer.chexsystemsResponse != null) {
            if (idvResp.consumer.chexsystemsResponse.consumerPreviousInquiry != null) {
              if (String.isNotBlank(idvResp.consumer.chexsystemsResponse.consumerPreviousInquiry.previousInquiryTotalQty)) {
                String noOfInq = idvResp.consumer.chexsystemsResponse.consumerPreviousInquiry.previousInquiryTotalQty;
                partyObj.NumberOfInquires__c = Integer.valueof(noOfInq);
              } else {
                partyObj.NumberOfInquires__c = 0;
              }
            }

            partyObj.KYCFraudText__c = idvResp.consumer.chexsystemsResponse.fraudFinderResponseTxt;

            if (
              idvResp.consumer.chexsystemsResponse.closureInformation != null &&
              idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure != null &&
              !idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure.isEmpty()
            ) {
              Decimal totalChrgAmnt = 0;
              for (Integer idx = 0; idx < idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure.size(); idx++) {
                if (
                  String.isNotBlank(idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure[idx].originalChargeOffAmt) &&
                  String.isNotBlank(idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure[idx].settlementPaidCd) &&
                  idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure[idx].settlementPaidCd.equalsIgnoreCase('N')
                ) {
                  String chrgAmnt = idvResp.consumer.chexsystemsResponse.closureInformation.reportedClosure[idx].originalChargeOffAmt;
                  totalChrgAmnt += Decimal.valueof(chrgAmnt.replaceAll(',', ''));
                } else {
                  totalChrgAmnt += 0;
                }
              }
              partyObj.TotalAmountApplicantOwes__c = totalChrgAmnt;
            }
          }
        } catch (Exception ex) {
          tffa.Logger.error(
            'Exception in processing charge amnt and NumberOfInquires from Response DTO ' +
            ex.getStackTraceString() +
            ex.getLineNumber() +
            ' ' +
            ex.getMessage()
          );
        }

        if (
          idvResp.consumer.identityManagerResponse != null &&
          idvResp.consumer.identityManagerResponse.validationsResult != null &&
          String.isBlank(idvResp.consumer.identityManagerResponse.errorCd) &&
          String.isBlank(idvResp.consumer.identityManagerResponse.errorInformation)
        ) {
          partyObj.IsDobMatch__c = idvResp.consumer.identityManagerResponse.validationsResult.dobCheckOk;
          partyObj.IsSsnMatch__c = idvResp.consumer.identityManagerResponse.validationsResult.ssnCheckOk;
          partyObj.tffa__IDVStatus__c = idvResp.consumer.identityManagerResponse.validationsResult.idCheckOk ? 'PASSED' : 'DECLINED';

          idvDD.Name = 'FIS IDV';
          idvDD.tffa__Type__c = 'IDV';
          idvDD.tffa__Status__c = idvResp.consumer.identityManagerResponse.validationsResult.idCheckOk ? 'PASSED' : 'DECLINED';
          idvDD.DueDiligenceResponse__c = String.valueof(idvResp.consumer.identityManagerResponse);
          tffa.Logger.debug('idvDD ' + idvDD);
          ddList.add(idvDD);
        } else {
          partyObj.IsDobMatch__c = false;
          partyObj.IsSsnMatch__c = false;
          partyObj.tffa__IDVStatus__c = 'FAILED';

          idvDD.Name = 'FIS IDV';
          idvDD.tffa__Type__c = 'IDV';
          idvDD.tffa__Status__c = 'FAILED';
          idvDD.DueDiligenceResponse__c = String.valueof(idvResp.consumer.identityManagerResponse);
          tffa.Logger.debug('idvDD -' + idvDD);
          ddList.add(idvDD);
        }

        tffa__DueDiligence__c ofacDD = new tffa__DueDiligence__c();
        if (idvResp.consumer.ofacResponse != null && idvResp.consumer.ofacResponse.ofacValidationsResult != null) {
          partyObj.tffa__OFACStatus__c = idvResp.consumer.ofacResponse.ofacValidationsResult.ofacHit ? 'DECLINED' : 'PASSED';

          ofacDD.Name = 'FIS OFAC';
          ofacDD.tffa__Type__c = 'OFAC';
          ofacDD.tffa__Status__c = idvResp.consumer.ofacResponse.ofacValidationsResult.ofacHit ? 'DECLINED' : 'PASSED';
          ofacDD.DueDiligenceResponse__c = String.valueof(idvResp.consumer.ofacResponse);
          tffa.Logger.debug('ofacDD ' + ofacDD);
          ddList.add(ofacDD);
        } else {
          partyObj.tffa__OFACStatus__c = 'FAILED';

          ofacDD.Name = 'FIS OFAC';
          ofacDD.tffa__Type__c = 'OFAC';
          ofacDD.tffa__Status__c = 'FAILED';
          ofacDD.DueDiligenceResponse__c = String.valueof(idvResp.consumer.ofacResponse);
          tffa.Logger.debug('ofacDD- ' + ofacDD);
          ddList.add(ofacDD);
        }

        tffa__DueDiligence__c qualifileDD = new tffa__DueDiligence__c();
        if (
          idvResp.consumer.qualifileResponse != null &&
          idvResp.consumer.qualifileResponse.accountActionInfo != null &&
          String.isBlank(idvResp.consumer.qualifileResponse.errorCd) &&
          String.isBlank(idvResp.consumer.qualifileResponse.errorInformation) &&
          String.isBlank(idvResp.consumer.qualifileResponse.errorTxt)
        ) {
          String score = idvResp.consumer.qualifileResponse.qualifileInformation.scoreNbr;

          if (idvResp.consumer.qualifileResponse.accountActionInfo.accountAcceptanceTxt.equalsIgnoreCase('ACCEPT')) {
            partyObj.tffa__DebitBureauStatus__c = 'PASSED';
            qualifileDD.tffa__Status__c = 'PASSED';
            qualifileDD.tffa__Score__c = score;
          } else if (idvResp.consumer.qualifileResponse.accountActionInfo.accountAcceptanceTxt.equalsIgnoreCase('REVIEW')) {
            partyObj.tffa__DebitBureauStatus__c = 'REVIEW';
            qualifileDD.tffa__Status__c = 'REVIEW';
            qualifileDD.tffa__Score__c = score;
          } else if (idvResp.consumer.qualifileResponse.accountActionInfo.accountAcceptanceTxt.equalsIgnoreCase('DECLINE')) {
            partyObj.tffa__DebitBureauStatus__c = 'DECLINED';
            qualifileDD.tffa__Status__c = 'DECLINED';
            qualifileDD.tffa__Score__c = score;
          } else if (
            idvResp.consumer.complianceInfo != null &&
            idvResp.consumer.complianceInfo.debitBureauComplianceInfo != null &&
            !String.isBlank(idvResp.consumer.complianceInfo.debitBureauComplianceInfo.debitFreezeMessage)
          ) {
            partyObj.tffa__DebitBureauStatus__c = 'DECLINED';
            qualifileDD.tffa__Status__c = 'DECLINED';
            qualifileDD.tffa__Score__c = score;
          } else {
            partyObj.tffa__DebitBureauStatus__c = 'FAILED';
            qualifileDD.tffa__Status__c = 'FAILED';
            qualifileDD.tffa__Score__c = '0';
          }
          partyObj.tffa__DebitBureauScore__c = Decimal.valueOf(score);

          qualifileDD.Name = 'FIS DEBIT BUREAU';
          qualifileDD.tffa__Type__c = 'DEBIT_BUREAU';
          qualifileDD.DueDiligenceResponse__c = String.valueof(idvResp.consumer.qualifileResponse);
          qualifileDD.tffa__ReportName__c = 'DebitBureau_Report';
        } else {
          partyObj.tffa__DebitBureauStatus__c = 'FAILED';
          partyObj.tffa__DebitBureauScore__c = Decimal.valueOf(0);

          qualifileDD.Name = 'FIS Qualifile';
          qualifileDD.tffa__Type__c = 'DEBIT_BUREAU';
          qualifileDD.tffa__Status__c = 'FAILED';
          qualifileDD.DueDiligenceResponse__c = String.valueof(idvResp.consumer.qualifileResponse);
          tffa.Logger.debug('qualifileDD- ' + qualifileDD);
          //ddList.add(qualifileDD);
        }

        List<tffa__DueDiligenceItem__c> ddItems = FISDSSService.createQualifileDDItems(idvResp);
        if (ddItems != null && !ddItems.isEmpty()) {
          tffa.SObjectAssembler asmQDD = new tffa.SObjectAssembler(qualifileDD);
          asmQDD.addChildObjects('Items__r', ddItems);
          ddList.add((tffa__DueDiligence__c) asmQDD.assemble());
        } else {
          ddList.add(qualifileDD);
        }
      } else {
        partyObj.tffa__DebitBureauStatus__c = 'FAILED';
        partyObj.IsDobMatch__c = false;
        partyObj.IsSsnMatch__c = false;
        partyObj.tffa__IDVStatus__c = 'FAILED';
        partyObj.tffa__OFACStatus__c = 'FAILED';
      }

      // Update Party And Insert DD
      if (!ddList.isEmpty()) {
        if (!Test.isRunningTest()) {
          tffa.DueDiligenceService.createOrUpdate(partyObj.Id, ddList);
        }
        List<tffa__Party__c> partyList = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
        asm = new tffa.SObjectAssembler(partyList[0]);
        asm.addChildObjects('DueDiligences__r', ddList);
      } else {
        List<tffa__Party__c> partyList = CZWTFCPartyRepository.save(new List<tffa__Party__c>{ partyObj });
        asm = new tffa.SObjectAssembler(partyList[0]);
      }

      try {
        String reportId = partyObj.Id + ':' + reportName;
        tffa__DueDiligence__c qualfileDDObj = CZWTFCHelperRepository.getDueDiligenceObj('DEBIT_BUREAU', partyObj.id);
        if (idvResp != null && String.isBlank(idvResp.consumer.errorCd) && String.isNotBlank(idvResp.txtReport)) {
          tffa.DocumentMetadataDTO report = new tffa.DocumentMetadataDTO(
            qualifyReportName(reportName, partyObj),
            Blob.valueOf(idvResp.txtReport),
            partyObj.id,
            'OTHER'
          );
          report.participants.add(new tffa.DocumentParticipantDTO(null, (String) subPartyObj.tffa__Submission__c));

          if (qualfileDDObj != null) {
            report.participants.add(new tffa.DocumentParticipantDTO(null, (String) qualfileDDObj.Id));
          }
          tffa.ContentService.createContentWithParticipant(report);
        }
      } catch (Exception excep) {
        tffa.Logger.error(
          'Exception in generating Document Report ' +
          excep.getStackTraceString() +
          excep.getLineNumber() +
          ' ' +
          excep.getMessage()
        );
      }

      tffa.Logger.debug('parseIDAResponse Flow Completed');
      return (tffa__Party__c) asm.assemble();
    } catch (Exception ex) {
      tffa.Logger.error('Exception in processIDVResult ' + ex.getStackTraceString() + ex.getLineNumber() + ex.getMessage());
      return partyObj;
    }
  }

  public static List<tffa__DueDiligenceItem__c> createQualifileDDItems(FISIDVResponseDTO idvResp) {
    Integer counter = 0;
    List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
    FISIDVResponseDTO.QualiFileInformation qualifileResp = new FISIDVResponseDTO.QualiFileInformation();

    if (idvResp.consumer.qualifileResponse != null && idvResp.consumer.qualifileResponse.qualifileInformation != null) {
      qualifileResp = idvResp.consumer.qualifileResponse.qualifileInformation;
    } else if (
      idvResp.consumer.chexsystemsResponse != null &&
      !String.isBlank(idvResp.consumer.chexsystemsResponse.errorCd) &&
      !String.isBlank(idvResp.consumer.chexsystemsResponse.errorTxt)
    ) {
      counter += 1;
      ddItems.add(
        FISDSSService.createQualifileDDItem(
          idvResp.consumer.chexsystemsResponse.errorCd,
          idvResp.consumer.chexsystemsResponse.errorTxt,
          'TechnicalFailure',
          counter
        )
      );
    }

    if (
      qualifileResp != null &&
      qualifileResp.qualifileReason1 != null &&
      qualifileResp.qualifileReason1.reasonCd != null &&
      qualifileResp.qualifileReason1.reasonTxt != null
    ) {
      counter += 1;
      ddItems.add(
        FISDSSService.createQualifileDDItem(
          qualifileResp.qualifileReason1.reasonCd,
          qualifileResp.qualifileReason1.reasonTxt,
          'QualifileReasonOne',
          counter
        )
      );
    }

    if (
      qualifileResp != null &&
      qualifileResp.qualifileReason2 != null &&
      qualifileResp.qualifileReason2.reasonCd != null &&
      qualifileResp.qualifileReason2.reasonTxt != null
    ) {
      counter += 1;
      ddItems.add(
        FISDSSService.createQualifileDDItem(
          qualifileResp.qualifileReason2.reasonCd,
          qualifileResp.qualifileReason2.reasonTxt,
          'QualifileReasonTwo',
          counter
        )
      );
    }

    if (
      qualifileResp != null &&
      qualifileResp.qualifileReason3 != null &&
      qualifileResp.qualifileReason3.reasonCd != null &&
      qualifileResp.qualifileReason3.reasonTxt != null
    ) {
      counter += 1;
      ddItems.add(
        FISDSSService.createQualifileDDItem(
          qualifileResp.qualifileReason3.reasonCd,
          qualifileResp.qualifileReason3.reasonTxt,
          'QualifileReasonThree',
          counter
        )
      );
    }

    if (
      qualifileResp != null &&
      qualifileResp.qualifileReason4 != null &&
      qualifileResp.qualifileReason4.reasonCd != null &&
      qualifileResp.qualifileReason4.reasonTxt != null
    ) {
      counter += 1;
      ddItems.add(
        FISDSSService.createQualifileDDItem(
          qualifileResp.qualifileReason4.reasonCd,
          qualifileResp.qualifileReason4.reasonTxt,
          'QualifileReasonFour',
          counter
        )
      );
    }

    if (
      qualifileResp != null &&
      qualifileResp.qualifileReason5 != null &&
      qualifileResp.qualifileReason5.reasonCd != null &&
      qualifileResp.qualifileReason5.reasonTxt != null
    ) {
      counter += 1;
      ddItems.add(
        FISDSSService.createQualifileDDItem(
          qualifileResp.qualifileReason5.reasonCd,
          qualifileResp.qualifileReason5.reasonTxt,
          'QualifileReasonFive',
          counter
        )
      );
    }
    if (counter == 0) {
      if (
        idvResp.consumer.complianceInfo != null &&
        idvResp.consumer.complianceInfo.debitBureauComplianceInfo != null &&
        !String.isBlank(idvResp.consumer.complianceInfo.debitBureauComplianceInfo.debitFreezeMessage)
      ) {
        counter += 1;
        ddItems.add(
          FISDSSService.createQualifileDDItem(
            'SecurityFreeze',
            idvResp.consumer.complianceInfo.debitBureauComplianceInfo.debitFreezeMessage,
            'CheckxSystemsSecurityFreeze',
            counter
          )
        );
      }
    }

    return ddItems;
  }

  @TestVisible
  private static tffa__DueDiligenceItem__c createQualifileDDItem(
    String reasonCd,
    String reasonTxt,
    String qualifileReason,
    Integer counter
  ) {
    tffa__DueDiligenceItem__c item = new tffa__DueDiligenceItem__c(
      Name = qualifileReason,
      tffa__Label__c = qualifileReason,
      tffa__Code__c = reasonCd,
      tffa__Required__c = false,
      tffa__SortOrder__c = counter,
      tffa__Type__c = 'RESPONSE',
      tffa__Value__c = reasonTxt
    );
    return item;
  }

  /**
   * Builds report name from party name
   */
  @TestVisible
  public static String qualifyReportName(String reportName, tffa__Party__c party) {
    // build report name reflecting the concerned party
    String prefix = party.Name.toLowerCase().replaceAll('\\s+', '_');
    if (prefix.length() > 18) {
      prefix = prefix.substring(0, 18);
    }
    return prefix + '_' + reportName;
  }
}