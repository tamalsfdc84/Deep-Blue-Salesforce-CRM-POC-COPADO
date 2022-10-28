global with sharing class CZWTFCMXController extends tffa.AbstractController implements tffa.IController {
  private static tffa.IController controller;
  @TestVisible
  private static boolean testException = false;

  @TestVisible
  private static boolean setSubForTest = false;

  global CZWTFCMXController(tffa.IController p) {
    controller = p;
  }

  @RemoteAction
  global static tffa.Response ping(tffa.Context ctx) {
    tffa.Interaction.begin(ctx, CZWTFCMxController.class, 'ping');
    try {
      return tffa.Response.ok().build();
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * @description
   * @param tffa.Context ctx
   * @param Map<string, String> params
   * @return tffa.Response
   */
  @RemoteAction
  global static tffa.Response generateMxUrl(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCMxController.class, 'generateMxUrl');
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      if (!Test.isRunningTest()) {
        validateSession();
      }
      tffa.Logger.debug('Inside generateMxUrl');

      if (Test.isRunningTest() && setSubForTest) {
        ctx.id = params.get('subId');
      }

      CZWTFCIntegrationLogService.setIntegrationLog((String) ctx.id);

      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MXINTEGRATION);
      if (String.valueOf(params.get('isMXUserCreated')).equalsIgnoreCase('false')) {
        CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.CREATEUSER, true);
      }

      // step1 - generate User id
      String generatedUserId = CZWTFCMXCreateUserProvider.invokeCreateUserAPI(ctx.id, params);

      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.GENERATEURL, true);
      // step2 - pass generated user id in next API call
      return tffa.Response.ok(CZWTFCMXSoapApiProvider.generateURL(generatedUserId, params)).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  /**
   * @description
   * @param tffa.Context ctx
   * @param Map<string, String> params
   * @return tffa.Response
   */
  @RemoteAction
  global static tffa.Response openNexusSession(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCMxController.class, 'openNexusSession');
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      Map<String, String> param = params.clone();
      if (!Test.isRunningTest()) {
        validateSession();
      }
      tffa.Logger.debug('Inside openNexusSession');

      if (Test.isRunningTest() && setSubForTest) {
        ctx.id = params.get('subId');
      }

      CZWTFCIntegrationLogService.setIntegrationLog((String) ctx.id);

      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MXINTEGRATION);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.GETAPITOKEN, true);

      // step1 - generate API token
      String generatedToken = CZWTFCMXGetAPITokenProvider.getAPIToken(param);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.GETSESSIONTOKEN, true);
      // step2 - open nexus session
      String sessionToken = CZWTFCMXOpenNexusProvider.getSessionToken(generatedToken);
      param.put('sessionToken', sessionToken);
      return tffa.Response.ok(sessionToken).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  /**
   * @description
   * @param tffa.Context ctx
   * @param Map<string, String> params
   * @return tffa.Response
   */
  @RemoteAction
  global static tffa.Response checkVerificationStatus(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCMXController.class, 'checkVerificationStatus');
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      Map<String, String> param = params.clone();
      if (!Test.isRunningTest()) {
        validateSession();
      }

      if (Test.isRunningTest() && setSubForTest) {
        ctx.id = params.get('subId');
      }

      CZWTFCIntegrationLogService.setIntegrationLog((String) ctx.id);

      tffa.Logger.debug('Inside checkVerificationStatus');
      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MXINTEGRATION);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.CHECKVERIFICATIONSTATUS, true);
      // step3 - Check verification status
      CZWTFCMXCheckVerificationStatusRespDTO verificationStatusDTO = CZWTFCMXCheckVerificationStatusProvider.checkVerificationStatus(param);
      return tffa.Response.ok(verificationStatusDTO).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  /**
   * @description
   * @param tffa.Context ctx
   * @param Map<string, String> params
   * @return tffa.Response
   */
  @RemoteAction
  global static tffa.Response fetchAccountDetails(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCMXController.class, 'fetchAccountDetails');
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }

      Map<String, String> param = params.clone();
      if (!Test.isRunningTest()) {
        validateSession();
      }

      if (Test.isRunningTest() && setSubForTest) {
        ctx.id = params.get('subId');
      }

      tffa.Logger.debug('Inside fetchAccountDetails');

      CZWTFCIntegrationLogService.setIntegrationLog((String) ctx.id);

      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MXINTEGRATION);
      CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.FETCHIAVACCOUNTS, true);

      // step4 - fetch member accounts
      List<CZWTFCMXFetchMemberAccountResponseDTO.Account_numbers> accounts = CZWTFCMXFetchMemberAccountsProvider.fetchMemberAccountList(
        param
      );

      // step5 - read individual member account
      List<CZWTFCMXReadMemberAccountRespDTO.Account> accountDetails = new List<CZWTFCMXReadMemberAccountRespDTO.Account>();
      for (CZWTFCMXFetchMemberAccountResponseDTO.Account_numbers account : accounts) {
        param.put('accountGUID', String.valueOf(account.account_guid));
        CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.MX, FISCCIntegrationConstants.READIAVACCOUNTS, true);
        CZWTFCMXReadMemberAccountRespDTO.Account memberAccount = CZWTFCMXReadMemberAccountProvider.fetchMemberAccountDetails(param);
        // Read only Saving and Checking types of account
        if (memberAccount.account_type_name == 'SAVINGS' || memberAccount.account_type_name == 'CHECKING') {
          if (account != null && String.isNotBlank(account.routing_number) && String.isNotBlank(account.account_number)) {
            memberAccount.routing_number = account.routing_number;
            memberAccount.account_number = account.account_number;
            accountDetails.add(memberAccount);
          }
        }
      }

      if (accountDetails.isEmpty()) {
        throw new tffa.ApplicationException(CZWTFCConstants.NO_ACCOUNT_DETAILS);
      }

      tffa.Logger.debug('accountDetails ====> ' + accountDetails);

      return tffa.Response.ok(accountDetails).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }

  /**
   * @description
   * @param tffa.Context ctx
   * @param Map<string, String> params
   * @return tffa.Response
   */
  @RemoteAction
  global static tffa.Response fetchMicroDepositAccount(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCMXController.class, 'fetchMicroDepositAccount');
    try {
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      Map<String, String> param = params.clone();
      if (!Test.isRunningTest()) {
        validateSession();
      }

      if (Test.isRunningTest() && setSubForTest) {
        ctx.id = params.get('subId');
      }

      CZWTFCIntegrationLogService.setIntegrationLog((String) ctx.id);

      tffa.Logger.debug('Inside fetchMicroDepositAccount');
      CZWTFCIntegrationLogService.setCurrentLog(FISCCIntegrationConstants.MXINTEGRATION);
      CZWTFCIntegrationLogService.setCurrentLogItem(
        FISCCIntegrationConstants.MX,
        FISCCIntegrationConstants.FETCHMICRODEPOSITACCOUNTS,
        true
      );
      // step4 - fetch member accounts
      List<CZWTFCMXFetchMemberAccountResponseDTO.Account_verifications> accounts = CZWTFCMXFetchMicroDepoAccProvider.fetchMemberAccountList(
        param
      );
      String microDepositGUID = (String) params.get('microDepositGUID');
      //to check verifed microdepo
      for (CZWTFCMXFetchMemberAccountResponseDTO.Account_verifications accountVerif : accounts) {
        if (!String.isBlank(accountVerif.micro_deposit_guid)) {
          if ((accountVerif.micro_deposit_guid).equalsIgnoreCase(microDepositGUID)) {
            return tffa.Response.ok(accountVerif).build();
          }
        }
      }

      return tffa.Response.ok(CZWTFCConstants.ACCOUNT_NOT_FOUND).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      CZWTFCIntegrationLogService.persistIntegationLogs();
      tffa.Interaction.close();
    }
  }
}