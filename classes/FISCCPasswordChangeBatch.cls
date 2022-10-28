global with sharing class FISCCPasswordChangeBatch extends tffa.AbstractBatchJob implements Database.Batchable<sObject>, Database.AllowsCallouts {
  @TestVisible
  private static boolean calledFromTestCls = false;

  Map<String, List<String>> mailData = new Map<String, List<String>>();

  global List<FISIBSAuthConfig__c> start(Database.BatchableContext batchableCntx) {
    tffa.Logger.debug('FISCCPasswordChangeBatch Job started');

    List<FISIBSAuthConfig__c> fisIbsAuthList = FISCCIntegrationLogRepository.findFisAuthforPassChange();

    if (Test.isRunningTest()) {
      fisIbsAuthList = FISCCIntegrationLogRepository.findFisAuthforPassChangeForTest();
    }
    tffa.Logger.flush();
    return fisIbsAuthList;
  }

  global void execute(Database.BatchableContext batchableCntx, List<SObject> fisAuthObj) {
    tffa.Interaction.begin(FISCCPasswordChangeBatch.class, 'execute');
    try {
      Boolean isSuccess;
      String password;
      FISIBSAuthConfig__c oldFisAuth = new FISIBSAuthConfig__c();
      FISIBSAuthConfig__c fisAuth = new FISIBSAuthConfig__c();
      List<FISIBSAuthConfig__c> updatedAuthConfigList = new List<FISIBSAuthConfig__c>();
      List<FISIBSAuthConfig__c> fisAuthList = (List<FISIBSAuthConfig__c>) fisAuthObj;
      Decimal seqValue = FISCCIntegrationLogRepository.findSeqNbrforPassChange();
      if (fisAuthList != null && !fisAuthList.isEmpty()) {
        fisAuth = fisAuthList[0];
      }
      password = FISCCPasswordChangeBatch.generatePassword(seqValue);
      isSuccess = FISCCPasswordChangeProvider.processPasswordChange(fisAuth, password);

      List<String> passChangeData = new List<String>();
      String successStatus = isSuccess ? 'Success' : 'Failure';
      passChangeData.add(successStatus);
      if (fisAuth.FailedReason__c != null) {
        passChangeData.add(fisAuth.FailedReason__c);
      } else {
        passChangeData.add(' ');
      }
      mailData.put(fisAuth.UserId__c, passChangeData);
      if (isSuccess) {
        String ibsEncodedKey = encodePassword(fisAuth.UserId__c, password);
        fisAuth.IBSAuthorization__c = ibsEncodedKey;
        fisAuth.LastUpdatedDate__c = Datetime.now();
        fisAuth.IsActive__c = true;
        updatedAuthConfigList.add(fisAuth);

        oldFisAuth = FISCCIntegrationLogRepository.findAuthByBrandandActiveState(fisAuth.BrandCode__c, true);
        oldFisAuth.IsActive__c = false;
        updatedAuthConfigList.add(oldFisAuth);
      } else {
        updatedAuthConfigList.add(fisAuth);
        tffa.Logger.error('Password update failed for ' + fisAuth.UserId__c + ' brandCode ' + fisAuth.BrandCode__c);
      }
      FISCCIntegrationLogRepository.saveFisAuthConfig(updatedAuthConfigList);
    } catch (Exception ex) {
      tffa.Logger.error('Exception in execute passBatch' + ex.getStackTraceString());
    } finally {
      tffa.Interaction.close();
    }
  }

  global void finish(Database.BatchableContext batchableCntx) {
    try {
      sendMail(mailData);
      tffa.Logger.debug('FISCCPasswordChangeBatch execute Completed at  : ' + String.valueOf(Datetime.now()));
    } catch (Exception ex) {
      tffa.Logger.error('Exception in finish passBatch' + ex.getStackTraceString());
    } finally {
      FISCCIntegrationLogRepository.updateSeqNbr();
      tffa.Logger.flush();
    }
  }

  public static String generatePassword(Decimal sequenceNbr) {
    Date startDate = system.today();
    Datetime dt = DateTime.newInstance(startDate, Time.newInstance(0, 0, 0, 0));
    Integer month = dt.month();
    String formattedmnth = String.valueof(month);
    if (formattedmnth.length() == 1) {
      formattedmnth = '0' + formattedmnth;
    }
    Integer year = dt.year();
    String formattedYear = String.valueof(year).right(2);
    Integer intConvertedValue = sequenceNbr.intValue();
    String password = 'Tf' + String.fromCharArray(new List<integer>{ intConvertedValue }) + formattedmnth + '@' + formattedYear;
    tffa.Logger.debug('FIS Password ' + password);
    return password;
  }

  public static String encodePassword(String userId, String password) {
    String encodedValue = '';
    Blob blobValue = Blob.valueOf(userId + ':' + password);
    encodedValue = EncodingUtil.base64Encode(blobValue);
    tffa.Logger.debug('encodedValue ' + encodedValue);
    return encodedValue;
  }

  public void sendMail(Map<String, List<String>> mailData) {
    List<tffa.NotificationDTO> notifications = new List<tffa.NotificationDTO>();
    WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();
    String emailid = wintrustEnvConfig.PassChangeNotifyMail__c;
    tffa.Logger.debug('emailid:' + emailid);
    List<String> emailIdList = emailid.split(',');

    String htmlBody = '';

    htmlBody = 'Hi,<br/>Batch job to change passwords for FIS CodeConnect RACF IDs has completed.<br/>Below are the RACF IDs for which password change was attempted:<br/><br/>';
    htmlBody += '<table border="1" style="border-collapse: collapse"><tr><th>UserId</th><th>&nbsp;Password changed&nbsp;</th><th>Message</th></tr>';
    for (String key : mailData.keySet()) {
      List<String> mailDataList = mailData.get(key);
      if (!mailDataList.isEmpty()) {
        htmlBody += '<tr><td>&nbsp;' + key + '&nbsp;</td>';
        htmlBody += '<td>&nbsp;' + mailDataList[0] + '&nbsp;</td>';
        htmlBody += '<td>&nbsp;' + mailDataList[1] != null ? mailDataList[1] : '' + '&nbsp;</td></tr>';
      }
    }
    htmlBody += '</table><br/><br/>';

    if (htmlBody != '' && !emailIdList.isEmpty() && !mailData.isEmpty()) {
      Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
      mail.ToAddresses = emailIdList;
      mail.HTMLBody = htmlBody;
      mail.Subject = 'FIS CodeConnect RACF ID Password Change';
      Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{ mail };
      Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
    }
  }
}