/**
 * Copyright (c) 2019 Terafina Inc
 * @description     Extension to main controller, for any custom service implementations
 * @group   Controller
 **/
global with sharing class CZWTFCCustomController extends tffa.AbstractController implements tffa.IController {
  @TestVisible
  private static boolean testException = false;

  private static tffa.IController controller;

  public String tagManagerSource { get; set; }

  public String cssFontSrc { get; set; }

  global static WintrustEnvConfig__mdt wintrustEnvConfig = CZWTFCHelperRepository.fetchWintrustEnvConfig();

  global CZWTFCCustomController(tffa.IController p) {
    if (wintrustEnvConfig != null) {
      tagManagerSource = wintrustEnvConfig.AdobeAnalyticsScript__c;
      cssFontSrc = wintrustEnvConfig.CssFontSrc__c;
    }
    controller = p;
  }

  @RemoteAction
  /**
   * @description ping test . do nothing
   * @param Context ctx
   * @return Response
   */
  global static tffa.Response ping(tffa.Context ctx) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'ping');
    try {
      return tffa.Response.ok().build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Returns Brand Object
   * @return Response
   */
  global static tffa.Response fetchBrand(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'fetchBrand');
    try {
      if (false) {
        validateSession();
        validateRecordAccess(params);
      }

      tffa__Brand__c brandObj = new tffa__Brand__c();

      if (params.containsKey('brandCode')) {
        // Fetch brand and sub brand details
        CZWTFCCustomService customService = new CZWTFCCustomService();
        brandObj = customService.fetchBrand(params.get('brandCode'));

        // Fetch Officers
        List<CZOfficerDetails__c> officerList = customService.fetchOfficerList(params.get('brandCode'));

        // Fetch location details
        CZBrandResponseDTO responseDTO = customService.fetchBrandLocations(params.get('brandCode'));

        responseDTO.Brand = brandObj;
        responseDTO.officers = officerList;

        if (brandObj.CZCostCenterList__c != null) {
          responseDTO.CostCenterList = brandObj.CZCostCenterList__c.split(',');
        }

        return tffa.Response.ok(responseDTO).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Returns if CEB enrollment was successful or not
   * @return Response
   */
  global static tffa.Response enrollForOLB(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'enrollForOLB');
    Map<String, Object> result = new Map<String, Object>();
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      //partyID, userName, password
      if (params.containsKey('partyID') && params.containsKey('userName') && params.containsKey('password')) {
        FISCCCEBEnrollmentService customService = new FISCCCEBEnrollmentService();
        result = customService.enrollForOLB(params);
        if (result != null) {
          return tffa.Response.ok(result).build();
        } else {
          throw new IllegalArgumentException('Invalid response recieved by controller');
        }
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      tffa.logger.debug(' Exception in controller enrollForOLB  :::' + ex.getMessage() + ' Exception:::' + ex.getStackTraceString());
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Returns Submission Object
   * @return Response
   */
  global static tffa.Response processSubmission(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'processSubmission');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      tffa__Submission__c subObj = new tffa__Submission__c();
      if (params.containsKey('submissionId')) {
        tffa__Submission__c submissionObj = CZWTFCSubmissionRepository.findOne(params.get('submissionId'));
        tffa.Logger.debug('submissionObj.tffa__Status__c ' + submissionObj.tffa__Status__c);
        if (submissionObj != null && submissionObj.tffa__Status__c.equalsIgnoreCase(CZWTFCConstants.SUBMITTED)) {
          subObj = FISCCSubmissionExecutor.processApplication(params.get('submissionId'));
        }
        return tffa.Response.ok(subObj).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  global static tffa.Response fetchConvergeSessionToken(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'fetchConvergeSessionToken');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, Object> data = params.clone();
      data.put('SubmissionId', (String) ctx.id);
      return tffa.Response.ok(CZWTFCConvergeService.fetchSessionToken(data)).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Returns Acount Details
   * @return Response
   */
  global static tffa.Response getAccountDetails(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'getAccountDetails');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      if (params.containsKey('charterCode') && params.containsKey('accountNumber')) {
        Object result = CZWTFCCustomService.getAccountDetails(params);

        if (result == null) {
          throw new IllegalArgumentException('Invalid Account Number');
        }

        return tffa.Response.ok(result).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCCustomController' + ex.getMessage() + ex.getStackTraceString());
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * Inititate Remote Funding for the selected party in Dropdown on Acc-Details page
   */
  global static tffa.Response initiateRemoteFunding(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(CZWTFCCustomController.class, 'initiateRemoteFunding');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      if (params.containsKey('Submission__c') && params.containsKey('Party__c')) {
        CZWTFCCustomService.initiateRemoteFunding(params);

        return tffa.Response.ok().build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCCustomController.initiateRemoteFunding ' + ex.getMessage() + ex.getStackTraceString());
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * Fetch Promotion code list for the application
   */
  global static tffa.Response fetchPromoCodeList(tffa.Context ctx, Map<String, Object> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'fetchPromoCodeList');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      Map<String, Object> data = params.clone();
      if (Test.isRunningTest() && testException) {
        throw new tffa.ApplicationException('Called through test class');
      }
      if (data.containsKey('Submission__c') && data.containsKey('Application__c')) {
        List<CZPromoCodeResponse> promoCodeLst = CZWTFCCustomService.fetchPromotionCodes(data);
        return tffa.Response.ok(promoCodeLst).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      tffa.Logger.error('Exception in CZWTFCCustomController.fetchPromoCodeList ' + ex.getMessage() + ex.getStackTraceString());
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  /**
   * @Description Returns officerList
   * @return Response
   */
  global static tffa.Response fetchOfficerList(Map<String, String> params) {
    tffa.Interaction.begin(CZWTFCCustomController.class, 'fetchOfficerList');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      List<CZOfficerDetails__c> officerList = new List<CZOfficerDetails__c>();

      if (params.containsKey('brandCode')) {
        CZWTFCCustomService customService = new CZWTFCCustomService();
        officerList = customService.fetchOfficerList(params.get('brandCode'));
        tffa.Logger.debug('CZWTFCCustomController fetchOfficerList officerList : ' + officerList);
        return tffa.Response.ok(officerList).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  global static tffa.Response fetchTermDepositRate(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'fetchTermDepositRate');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      if (
        params.containsKey('BrandCode') &&
        params.containsKey('Amount') &&
        params.containsKey('ProductCode') &&
        params.containsKey('Term')
      ) {
        return tffa.Response.ok(CZWTFCCustomService.fetchTermDepositRate(params)).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  global static tffa.Response calculateAPY(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'calculateAPY');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }

      Map<String, String> facts = params.clone();

      if (
        params.containsKey('InterestPayoutFrequency') &&
        params.containsKey('TermUnit') &&
        params.containsKey('InterestRate') &&
        params.containsKey('Term')
      ) {
        return tffa.Response.ok(CZWTFCCustomService.calculateAPY(params)).build();
      } else {
        throw new IllegalArgumentException('Invalid Request Parameters');
      }
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  global static tffa.Response sendAdverseActionMail(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'sendAdverseActionMail');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, String> facts = params.clone();
      if (facts.containsKey('partyId')) {
        tffa__Party__c party = CZWTFCPartyRepository.fetchPartyById(facts.get('partyId'));
        CZWTFCPartyEventExtension eventExt = new CZWTFCPartyEventExtension('Application_Declined_Adverse');
        if (facts.containsKey('productName')) {
          eventExt.productName = facts.get('productName');
        }
        eventExt.post(party);
      }
      return tffa.Response.ok(null).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  global static tffa.Response fetchAllBrands(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'fetchAllBrands');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, String> facts = params.clone();

      return tffa.Response.ok(CZWTFCBrandRepository.fetchAllBrands()).build();
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }

  @RemoteAction
  global static tffa.Response fetchApplicantRoles(tffa.Context ctx, Map<String, String> params) {
    tffa.Interaction.begin(ctx, CZWTFCCustomController.class, 'fetchApplicantRoles');
    try {
      if (!Test.isRunningTest()) {
        validateSession();
        validateRecordAccess(params);
      }
      Map<String, String> facts = params.clone();
      CZWTFCApplicationRepository.updateAccountPurpose(facts.get('ApplicationId'), facts.get('AccountPurpose'));
      String jsonReq = '{\"Application__c\":"' + facts.get('ApplicationId') + '"}';
      return tffa.ApplicationController.resolveApplicantRoles(tffa.Context.get(), jsonReq);
    } catch (Exception ex) {
      return tffa.Response.fail(ex).build();
    } finally {
      tffa.Interaction.close();
    }
  }
}