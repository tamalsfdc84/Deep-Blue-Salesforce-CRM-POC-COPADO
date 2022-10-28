public with sharing class CZWTFCDocusignAdapter {
  private CZWTFCDocusignRequestDTO request;
  private String AUTH_HEADER;
  public static String accountId;
  public static String baseUrl;
  public static String token;

  public CZWTFCDocusignAdapter() {
  }
  public CZWTFCDocusignAdapter(CZWTFCDocusignRequestDTO request) {
    this.request = request;
    AUTH_HEADER = Json.serialize(request.authHeader, true);
  }

  public CZWTFCDocusignResponseDTO processRequestforApplicationDocusign() {
    CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();
    try {
      if (!Test.isRunningTest()) {
        doLogin();
      }

      CZWTFCIntegrationLogService.setCurrentLogItem('Generate Enevelope', request.envelope.status, true);
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(Json.serialize(request.envelope, true), null);
      HttpResponse hresp1 = createEnvelope(accountId, request);

      if (HTTPCalloutConstants.HTTP_STATUS_CREATED != hresp1.getStatusCode()) {
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, hresp1.getBody());
        CZWTFCIntegrationLogService.setLogItemFailed('Failure');
        throw new CZWTFCCustomService.CZDocumentException(
          'Failure while creating envelope with status code => ' +
          hresp1.getStatusCode() +
          ' response body => ' +
          hresp1.getBody()
        );
      } else {
        tffa.Logger.debug('hresp1.getBody =>' + hresp1.getBody());
        CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, hresp1.getBody());
        CZWTFCIntegrationLogService.setLogItemOk('Success');
        resp.envelopeResp = (CZWTFCDocusignResponseDTO.EnvelopeResponseDTO) Json.deserialize(
          hresp1.getBody(),
          Type.forname('CZWTFCDocusignResponseDTO.EnvelopeResponseDTO')
        );
      }
    } catch (Exception e) {
      String errorMsg = e.getMessage() + ' ' + e.getStackTraceString();
      tffa.Logger.debug('xx Exception while calling docusign xx \n' + e.getLineNumber());
      resp.status = CZWTFCResultStatus.Failure;
      resp.statusMsg += 'Exception => ' + errorMsg;
    }

    return resp;
  }

  //method for creating url for each party
  public static String getSigningUrl(Map<String, String> params) {
    String accNbr;
    CZWTFCDocusignRequestDTO request = new CZWTFCDocusignRequestDTO();
    CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();

    if (!Test.isRunningTest()) {
      doLogin();
    }

    if (accountId == null) {
      throw new CZWTFCCustomService.CZDocumentException('Failed to fetch account details');
    }

    tffa__Submission__c sub = CZWTFCSubmissionRepository.findOne(params.get('Submission__c'));
    request.recipientView.authenticationMethod = 'email';

    if (params.get('ParticipantType') == 'PARTY') {
      tffa__Party__c party = CZWTFCPartyRepository.fetchPartyById(params.get('ParticipantId'));

      request.recipientView.email = String.isNotBlank(party.tffa__PrimaryEmail__c) ? party.tffa__PrimaryEmail__c : 'test@mail.com';
      request.recipientView.userName = party.Name;
      request.recipientView.clientUserId = party.Id;
    } else if (params.get('ParticipantType') == 'USER') {
      User currentUser = tffa.UserService.getCurrentUser();
      request.recipientView.email = String.isNotBlank(currentUser.Email) ? currentUser.Email : 'test@mail.com';
      request.recipientView.userName = currentUser.Name;
      request.recipientView.clientUserId = currentUser.Id;
    } else if (params.get('ParticipantType') == 'OTHER') {
      tffa__DisclosureParticipant__c dp = CZDocusignRepository.fetchDisclosureParticipantById(params.get('ParticipantId'));
      request.recipientView.email = String.isNotBlank(dp.tffa__Party__r.tffa__PrimaryEmail__c)
        ? dp.tffa__Party__r.tffa__PrimaryEmail__c
        : 'test@mail.com';
      request.recipientView.clientUserId = dp.Id;

      if (dp.tffa__RoleCode__c == 'NATURAL_PERSON') {
        request.recipientView.userName =
          dp.tffa__Party__r.CZCertifyingIndividualFN__c +
          ' ' +
          dp.tffa__Party__r.CZCertifyingIndividualLN__c;
      } else {
        request.recipientView.userName = dp.tffa__Party__r.CZSpouseName__c;
      }
    }

    PageReference pageRef = new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + Page.CZDocusignRedirectPage.getUrl());
    pageRef.getParameters().put('envelopeId', params.get('envId'));
    pageRef.getParameters().put('signerId', params.get('ParticipantId'));
    request.recipientView.returnUrl = pageRef.getUrl();

    //CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();

    CZWTFCIntegrationLogService.setCurrentLogItem(CZDocusignConstants.SIGNATURE, request.recipientView.userName, true);
    CZWTFCIntegrationLogService.setLogItemRequestAndResponse(Json.serialize(request, true), null);

    HttpResponse hresp2 = getRecipientView('callout:Docusign/v2/accounts/' + accountId + '/envelopes/' + params.get('envId'), request);
    if (HTTPCalloutConstants.HTTP_STATUS_CREATED != hresp2.getStatusCode()) {
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, hresp2.getBody());
      CZWTFCIntegrationLogService.setLogItemFailed('Failure');
      throw new CZWTFCCustomService.CZDocumentException(
        'Failure while getting recipient view with status code => ' +
        hresp2.getStatusCode() +
        ' response body => ' +
        hresp2.getBody()
      );
    } else {
      resp.recipientViewResp = (CZWTFCDocusignResponseDTO.RecipientViewResponseDTO) Json.deserialize(
        hresp2.getBody(),
        Type.forname('CZWTFCDocusignResponseDTO.RecipientViewResponseDTO')
      );
      resp.status = CZWTFCResultStatus.Success;
      resp.statusMsg = 'Docusign call is successful';
      tffa.Logger.debug('Sign Response ' + resp.recipientViewResp.url);
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, hresp2.getBody());
      CZWTFCIntegrationLogService.setLogItemOk('Success');
      return String.Valueof(resp.recipientViewResp.url);
    }
  }

  @TestVisible
  private static void doLogin() {
    if (String.isNotEmpty(accountId)) {
      return;
    }
    CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();
    HttpResponse hresp = callHttp('callout:Docusign/v2/login_information', HTTPCalloutConstants.HTTP_METHOD_GET, null);
    if (HTTPCalloutConstants.HTTP_STATUS_OK == hresp.getStatusCode()) {
      resp.lgnResp = (CZWTFCDocusignResponseDTO.LoginResponseDTO) Json.deserialize(
        hresp.getBody(),
        Type.forname('CZWTFCDocusignResponseDTO.LoginResponseDTO')
      );

      accountId = resp.lgnResp.loginAccounts[0].accountId;
      baseUrl = resp.lgnResp.loginAccounts[0].baseUrl;
      if (Test.isRunningTest()) {
        accountId = '1234';
        baseUrl = '12345';
      }
    }
    if (accountId == null || baseUrl == null) {
      throw new CZWTFCCustomService.CZDocumentException('Failed to fetch account details');
    }
  }

  @TestVisible
  private HttpResponse createEnvelope(String accountId, CZWTFCDocusignRequestDTO request) {
    request.envelope.accountId = String.isBlank(request.envelope.accountId) ? accountId : request.envelope.accountId;
    HttpResponse resp = callHttp(
      'callout:Docusign/v2/accounts/' +
      accountId +
      '/envelopes',
      HTTPCalloutConstants.HTTP_METHOD_POST,
      Json.serialize(request.envelope, true)
    );

    return resp;
  }

  @TestVisible
  private static HttpResponse getRecipientView(String url, CZWTFCDocusignRequestDTO request) {
    HttpResponse resp = callHttp(
      url + '/views/recipient',
      HTTPCalloutConstants.HTTP_METHOD_POST,
      Json.serialize(request.recipientView, true)
    );
    tffa.Logger.debug('docusing request for each recipient==> ' + Json.serialize(request.recipientView));
    return resp;
  }

  @TestVisible
  private static HttpResponse getSenderView(String url, CZWTFCDocusignRequestDTO request) {
    HttpResponse resp = callHttp(url + '/views/sender', HTTPCalloutConstants.HTTP_METHOD_POST, Json.serialize(request.recipientView, true));
    tffa.Logger.debug('docusing request for each recipient==> ' + Json.serialize(request.recipientView));
    return resp;
  }

  public CZWTFCSignersStatusDTO getSignersStatus(String envId) {
    if (!Test.isRunningTest()) {
      doLogin();
    }
    String url = 'callout:Docusign/v2/accounts/' + accountId + '/envelopes/' + envId + '/recipients';
    HttpResponse resp = callHttp(url, HTTPCalloutConstants.HTTP_METHOD_GET, null);
    CZWTFCSignersStatusDTO respDto = (CZWTFCSignersStatusDTO) Json.deserialize(resp.getBody(), Type.forname('CZWTFCSignersStatusDTO'));

    return respDto;
  }

  @TestVisible
  private static HttpResponse callHttp(String url, String method, String body) {
    if (String.isBlank(token)) {
      token = callToken();
    }
    tffa.Logger.debug('Requestbody =>' + body);
    HttpResponse resp;
    tffa.Interaction.begin(CZWTFCDocusignAdapter.class, 'callHttp');
    try {
      Http http = new Http();
      HttpRequest req = new HttpRequest();
      req.setTimeout(120000);
      req.setEndpoint(url);
      req.setHeader('Authorization', 'Bearer ' + token);
      req.setHeader('Content-Type', 'application/json');
      req.setMethod(method);
      if (String.isNotBlank(body)) {
        req.setHeader('Content-Length', String.valueOf(body.length()));
        req.setbody(body);
      }
      resp = http.send(req);
      tffa.logger.debug('resp==>' + resp);
      tffa.logger.debug('resp==>' + resp.getBody());
    } finally {
      tffa.Interaction.close();
    }
    return resp;
  }

  /**
   * Called to Generate Token
   */
  @TestVisible
  private static string callToken() {
    String jwtTokenEndpoint = 'callout:DocusignJWT' + '/token';
    tffa.Credential credential = tffa.CredentialService.get('DocusignJWT');
    Auth.JWT jwt = new Auth.JWT();
    jwt.setSub(credential.subjectClaim); //User Id
    jwt.setAud(credential.audienceClaim); //url
    jwt.setIss(credential.decryptedApiKey); //Decrypted Integration Key
    jwt.setValidityLength(3600);

    Map<String, Object> claims = new Map<String, Object>();
    claims.put('scope', 'signature');
    jwt.setAdditionalClaims(claims);
    Auth.JWS jws = new Auth.JWS(jwt, credential.certificateName);
    String token = jws.getCompactSerialization();
    String tokenEndpoint = jwtTokenEndpoint;
    Auth.JWTBearerTokenExchange bearer = new Auth.JWTBearerTokenExchange(tokenEndpoint, jws);
    String accessToken = bearer.getAccessToken();

    return accessToken;
  }
  /**
   * Call to fetch document in PDF format
   * NOT USED
   
  public Blob prefilledEnvelope(Map<String, String> params) {
    tffa.Logger.debug('In prefillderEnvelope');
    CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();
    try {
      HttpResponse hresp = doLogin();
      if (HTTPCalloutConstants.HTTP_STATUS_OK != hresp.getStatusCode()) {
        throw new CZWTFCCustomService.CZDocumentException(
          'Failure while doLogin with status code => ' +
          hresp.getStatusCode() +
          ' response body => ' +
          hresp.getBody()
        );
      } else {
        resp.lgnResp = (CZWTFCDocusignResponseDTO.LoginResponseDTO) Json.deserialize(
          hresp.getBody(),
          Type.forname('CZWTFCDocusignResponseDTO.LoginResponseDTO')
        );
        String accNbr = resp.lgnResp.loginAccounts[0].accountId;
        String url =
          'callout:Docusign/v2/accounts/' +
          accNbr +
          '/envelopes/' +
          params.get('envId') +
          '/documents/combined?show_changes=true';
        tffa.Logger.debug('url ' + url);
        HttpResponse resp_1 = callHttp(url, HTTPCalloutConstants.HTTP_METHOD_GET, null);
        if (resp_1.getStatusCode() == 200 && resp_1.getBodyAsBlob() != null) {
          return resp_1.getBodyAsBlob();
        }
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Excep in prefillderEnvelope ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return null;
  }
*/
  /**
   * Call to fetch document in PDF format
   */
  public Blob fetchDocumentPDF(Map<String, String> params) {
    tffa.Logger.debug('In prefillderEnvelope');
    CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();
    try {
      if (!Test.isRunningTest()) {
        doLogin();
      }

      String url =
        'callout:Docusign/v2/accounts/' +
        accountId +
        '/envelopes/' +
        params.get('envId') +
        '/documents/' +
        params.get('documentId');
      tffa.Logger.debug('url ' + url);
      HttpResponse resp_1 = callHttp(url, HTTPCalloutConstants.HTTP_METHOD_GET, null);
      if (resp_1.getStatusCode() == 200 && resp_1.getBodyAsBlob() != null) {
        return resp_1.getBodyAsBlob();
      }
    } catch (Exception ex) {
      tffa.Logger.debug('Excep in prefillderEnvelope ' + ex.getLineNumber() + ' ' + ex.getMessage());
    }
    return null;
  }

  public CZWTFCDocusingResult fetchDocusignUrl(Map<String, String> params) {
    tffa.Logger.debug('In fetchDocusignUrl');
    CZWTFCDocusingResult response = new CZWTFCDocusingResult();
    CZWTFCDocusignResponseDTO resp = new CZWTFCDocusignResponseDTO();
    try {
      if (!Test.isRunningTest()) {
        doLogin();
      }
      CZWTFCIntegrationLogService.setCurrentLogItem('Sender View', request.envelope.status, true);

      User u = CZDocusignRepository.fetchUserDetails(UserInfo.getUserId());

      request.recipientView.authenticationMethod = 'email';
      request.recipientView.email = u.email;
      request.recipientView.userName = u.Name;
      request.recipientView.clientUserId = u.Id;
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(Json.serialize(request.recipientView, true), null);
      String url = 'callout:Docusign/v2/accounts/' + accountId + '/envelopes/' + params.get('envId') + '/views/sender';
      tffa.Logger.debug('url ' + url);
      HttpResponse resp_1 = callHttp(url, HTTPCalloutConstants.HTTP_METHOD_POST, Json.serialize(request.recipientView, true));
      resp.recipientViewResp = (CZWTFCDocusignResponseDTO.RecipientViewResponseDTO) Json.deserialize(
        resp_1.getBody(),
        Type.forname('CZWTFCDocusignResponseDTO.RecipientViewResponseDTO')
      );
      response.url = resp.recipientViewResp.url;
      CZWTFCIntegrationLogService.setLogItemOk('Success');
      CZWTFCIntegrationLogService.setLogItemRequestAndResponse(null, resp_1.getBody());
    } catch (Exception ex) {
      tffa.Logger.error('Exception in fetchDocusignUrl' + ex.getMessage());
      response.msg = 'Failure';
      CZWTFCIntegrationLogService.setLogItemFailed('Failure');
    }
    return response;
  }
}