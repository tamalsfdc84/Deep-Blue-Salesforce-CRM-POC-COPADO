/**
 * Copyright (c) 2019 Terafina Inc
 * @description     Extension to main controller, for any custom service implementations
 * @group   Controller
 **/
global with sharing class CZWTFCCustomController extends tffa.AbstractController implements tffa.IController {
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
  global static tffa.Response fetchBrand(Map<String, String> params) {
    tffa.Interaction.begin(CZWTFCCustomController.class, 'fetchBrand');
    try {
      tffa__Brand__c brandObj = new tffa__Brand__c();

      if (params.containsKey('brandCode')) {
        CZWTFCCustomService customService = new CZWTFCCustomService();
        brandObj = customService.fetchBrand(params.get('brandCode'));
        return tffa.Response.ok(brandObj).build();
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
  global static tffa.Response enrollForOLB(Map<String, String> params) {
    tffa.Interaction.begin(CZWTFCCustomController.class, 'enrollForOLB');
    Map<String, Object> result = new Map<String, Object>();
    try {
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
  global static tffa.Response processSubmission(Map<String, String> params) {
    tffa.Interaction.begin(CZWTFCCustomController.class, 'processSubmission');
    try {
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
  global static tffa.Response getAccountDetails(Map<String, Object> params) {
    tffa.Interaction.begin(CZWTFCCustomController.class, 'getAccountDetails');
    try {
      if (params.containsKey('charterCode') && params.containsKey('accountNumber')) {
        Object result = CZWTFCCustomService.getAccountDetails(params);

        if(result == null){
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
}