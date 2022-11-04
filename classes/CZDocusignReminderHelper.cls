public with sharing class CZDocusignReminderHelper {
  public static Boolean sendReminderMail(CZWTFCSignersStatusDTO signerStatusDTO, tffa__DisclosureEnvelope__c discEnv) {
    tffa.Logger.debug('In CZDocusignReminderHelper.sendReminderMail');
    Boolean isPending = false;
    Integer totalMailSent = 0;
    tffa__Submission__c sub = CZWTFCSubmissionRepository.findSubmissionById(discEnv.tffa__Submission__c);
    Map<String, tffa__Party__c> partyMap = CZWTFCPartyRepository.findAllPartiesWithChildByIds(sub);
    Date envCreatedDate;
    if (!Test.isRunningTest()) {
      envCreatedDate = date.newinstance(discEnv.createdDate.year(), discEnv.createdDate.month(), discEnv.createdDate.day());
    } else {
      envCreatedDate = System.today();
    }

    // Get mail frequency from config
    List<Integer> docusignReminderSchedule = new List<Integer>();
    for (String schedule : CZWTFCHelperRepository.fetchWintrustEnvConfig().CZDocusignReminderSchedule__c.split(';')) {
      docusignReminderSchedule.add(Integer.valueof(schedule));
    }

    for (CZWTFCSignersStatusDTO.SignersDTO signer : signerStatusDTO.signers) {
      //check if signing is pending for the party
      if ((signer.status != null && !signer.status.equalsIgnoreCase('Completed'))) {
        tffa__Party__c party = partyMap.get(signer.clientUserId);
        if (discEnv.tffa__ReminderDate__c == null) {
          discEnv.tffa__ReminderDate__c = envCreatedDate.addDays(docusignReminderSchedule[0]);
        }
        if (party != null && party.CZDocusignReminderDate__c == null) {
          party.CZDocusignReminderDate__c = envCreatedDate;
        }

        //To check if any reminder mail is sent today for the party
        if ((party != null && party.CZDocusignReminderDate__c != Date.today() && envCreatedDate != Date.today()) || Test.isRunningTest()) {
          //First reminder mail
          if (discEnv.tffa__ReminderCount__c == 0 && discEnv.tffa__ReminderDate__c <= Date.today()) {
            discEnv.tffa__ReminderDate__c = envCreatedDate.addDays(docusignReminderSchedule[1]);
            party.CZDocusignReminderDate__c = Date.today();
            sendEmail(sub, party, discEnv);
            totalMailSent++;
          }

          if (
            discEnv.tffa__ReminderCount__c != 0 &&
            discEnv.tffa__ReminderDate__c != null &&
            discEnv.tffa__ReminderDate__c <= Date.today() &&
            discEnv.tffa__ReminderCount__c < docusignReminderSchedule.size()
          ) {
            Integer index = integer.valueOf(discEnv.tffa__ReminderCount__c);
            // Update the date to next date only if maximum attempt is not reached.
            if (index + 1 < docusignReminderSchedule.size()) {
              discEnv.tffa__ReminderDate__c = envCreatedDate.addDays(docusignReminderSchedule[index + 1]);
              party.CZDocusignReminderDate__c = Date.today();
            }
            sendEmail(sub, party, discEnv);
            totalMailSent++;
          }
        }
        isPending = true;
      }
    }
    if (totalMailSent != 0) {
      discEnv.tffa__ReminderCount__c++;
    }
    // WTFCObjectManagerRepository.doUpsertObject(discEnv);
    WTFCObjectManagerRepository.doUpsertObjects(partyMap.Values());
    return isPending;
  }

  public static void sendEmail(tffa__Submission__c sub, tffa__Party__c party, tffa__DisclosureEnvelope__c discEnv) {
    String q;
    Map<String, String> urlParams = new Map<String, String>();
    urlParams.put('Submission__c', sub.id);
    urlParams.put('OTPStatus__c', 'CHALLENGED');
    urlParams.put('EventName__c', 'DisclosureRemoteSigningInitiated');
    urlParams.put('Party__c', party.Id);
    if (!Test.isRunningTest()) {
      q = tffa.Cipher.encrypt(JSON.serialize(urlParams));

      tffa.OTPProvider provider = tffa.OTPProvider.getInstance();
      provider.generate(
        new Map<String, Object>{ 'Party__c' => party.Id, 'UrlFragment__c' => q, 'EventName__c' => 'DisclosureRemoteSigningInitiated' }
      );
      new CZWTFCPartyEventExtension('Party_OTP_Generated').post(party);
      CZWTFCPartyEventExtension partyEventExt = new CZWTFCPartyEventExtension('Disclosure_Reminder');
      if (discEnv != null) {
        User userObj = tffa.UserService.read(discEnv.CreatedById);
        if (userObj != null) {
          partyEventExt.bankerName = userObj.Name;
        }
      }

      partyEventExt.post(party);
    }
  }
}