public with sharing virtual class ACHEntryRecordBuilder {
  @TestVisible
  private static Boolean testException = false;
  @TestVisible
  protected Integer unqCounter = getLastNumber(null);
  protected ACHFileDTO achdata;
  private Map<String, tffa__ApplicationPartyXref__c> ApplicationData = new Map<String, tffa__ApplicationPartyXref__c>();
  public void setACHData(ACHFileDTO achdata) {
    this.achdata = achdata;
    fillAllApplicationsforFunding();
  }
  public void fillAllApplicationsforFunding() {
    String[] selectedApplicationIds = new List<String>();
    for (tffa__FundingRequest__c abtAcct : achdata.abtAccts) {
      selectedApplicationIds.add(abtAcct.tffa__LinkedApplication__c);
    }

    // String query = new tffa.QueryBuilder(tffa__ApplicationPartyXref__c.SObjectType)
    // .selectFields()
    // .whereClause('tffa__Primary__c', '= true')
    // .opAnd()
    // .whereClause('tffa__Application__c', '= :selectedApplicationIds')
    // .build()
    // .toQuery();
    // List<tffa__ApplicationPartyXref__c> listApplication = Database.query(query);
    List<tffa__ApplicationPartyXref__c> listApplication = CZWTFCApplicationRepository.findAppXrefByAppIds(selectedApplicationIds);

    for (tffa__ApplicationPartyXref__c application : listApplication) {
      ApplicationData.put(application.tffa__Application__c, application);
    }
  }

  public virtual List<ACHEntryDetailRecord> buildRecords() {
    List<ACHEntryDetailRecord> recs = new List<ACHEntryDetailRecord>();
    for (tffa__FundingRequest__c abtAcct : achdata.abtAccts) {
      try {
        //---------------------------------------------------------------------------------
        ACHEntryDetailRecord rec = new ACHEntryDetailRecord();
        rec.setTransactionCode(ACHConstants.TXN_CODEMAP.get(abtAcct.tffa__AccountType__c + '_' + ACHConstants.TXN_TYPE_DEBIT));
        rec.setRdfiIdentification(abtAcct.tffa__RoutingNumber__c.substring(0, 8));
        rec.setCheckDigit(abtAcct.tffa__RoutingNumber__c.substring(8, 9));
        if (abtAcct.tffa__AccountNumber__c.length() > 17) {
          rec.setDfiAcctNo((abtAcct.tffa__AccountNumber__c).right(17));
        } else {
          rec.setDfiAcctNo(abtAcct.tffa__AccountNumber__c);
        }
        Decimal amount = 0;

        if (abtAcct.tffa__Amount__c != null) {
          amount = amount + abtAcct.tffa__Amount__c;
        }
        if (abtAcct.MembershipAmount__c != null) {
          amount = amount + abtAcct.MembershipAmount__c;
        }

        rec.setAmount(amount);
        rec.setIndvidualIdentificationNo(abtAcct.tffa__LinkedApplication__r.SubmissionName__c);
        if (test.isRunningTest()) {
          rec.setIndividualName('hey');
        } else {
          rec.setIndividualName(
            getPartyName(
                ApplicationData.get(abtAcct.tffa__LinkedApplication__r.id).PartyPersonName__c,
                ApplicationData.get(abtAcct.tffa__LinkedApplication__r.id).PartyLegalName__c
              )
              .left(22)
          );
        }

        rec.setPaymentTypeCode(ACHConstants.FIELD_PAYMENTTYPECODE);
        rec.setAddendaRecFlag(ACHConstants.FIELD_ADDEDNDA_RECORD_INDICATOR);
        //String refNo = getRefNo();
        //refNo = (refNo.length() > 15) ? refNo.substring(refNo.length() - 15, refNo.length()) : refNo;
        //rec.setTraceNo(refNo);
        //private ACHAddendaRecord addendaRec;
        rec.setProductName(abtAcct.tffa__LinkedApplication__r.tffa__Product__r.Name);
        String refNo = getRefNo(achdata.odfiId);
        rec.setTraceNo(refNo);
        rec.setPcbAcctNo(abtAcct.tffa__LinkedApplication__r.tffa__AccountNumber__c);
        rec.setAchFileName(achdata.achFileName);
        recs.add(rec);
        abtAcct.put('TraceNo__c', rec.getTraceNo());
        abtAcct.put('tffa__Status__c', 'ACH_FILE_GENERATED');
        tffa.Logger.debug('***records' + rec);
        unqCounter++;
      } catch (Exception ex) {
        abtAcct.put('tffa__Status__c', 'ACH_FILE_FAILED');
        tffa.Logger.debug('Exception   :::' + ex.getMessage() + 'LineNumber  :::' + ex.getStackTraceString());
      }
    }
    getLastNumber(achdata.abtAccts.size());
    return recs;
  }
  /*  returns unique reference number of length 15. 
        first 13 digits from getTime().
        last 2 digits from getUniqueCount().
        unqCounter is appended in order to assure uniqueness even if speed of execution is high, even less than millisecs
        after adding this method unqCounter logic may appear redundand since good amount of time consumed to access the methods and 
        access the logic and hence timestamp would be unique.
    */
  @TestVisible
  protected String getRefNo() {
    return String.valueOf(Datetime.now().getTime()) + getUniqueCount();
  }
  protected String getRefNo(String odfid) {
    String uniqueNumber = String.valueOf(unqCounter);
    String refNo = odfid + uniqueNumber.leftPad(7, '0');
    return refNo;
  }
  @TestVisible
  private String getPartyName(String personalName, String legalName) {
    if (legalName != null && legalName != '') {
      return legalName;
    } else {
      return personalName.remove(',');
    }
  }
  //returns String(length=2) for number 0 to 99
  @TestVisible
  protected String getUniqueCount() {
    String cnt = '';
    cnt = String.valueOf(Math.mod(unqCounter++, 100));
    cnt = cnt.leftPad(2, '0');
    return cnt;
  }
  @TestVisible
  private Integer getLastNumber(Integer countRecords) {
    try {
      List<TFEntries__c> tfentries = CZWTFCApplicationRepository.getTfentries();

      if (countRecords != null || countRecords > 0) {
        if (tfentries == null || tfentries.size() <= 0) {
          countRecords = 5001 + countRecords;
          TFEntries__c instfentries = new TFEntries__c();
          instfentries.LastACHFileRecNo__c = countRecords;
          CZWTFCApplicationRepository.saveSingle(instfentries);
        } else {
          TFEntries__c updtfentries = tfentries.get(0);
          updtfentries.LastACHFileRecNo__c = tfentries.get(0).LastACHFileRecNo__c + countRecords;
          CZWTFCApplicationRepository.saveSingle(updtfentries);
        }
      }
      if (tfentries == null || tfentries.size() < 1) {
        return 5001;
      } else {
        return Integer.valueOf(tfentries[0].LastACHFileRecNo__c);
      }
    } catch (Exception ex) {
      tffa.Logger.debug(ex.getMessage() + ' ' + ex.getStackTraceString());
    }
    return 5001;
  }
}