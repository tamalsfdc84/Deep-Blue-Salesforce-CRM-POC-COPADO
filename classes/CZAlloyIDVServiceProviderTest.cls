/**
 * Tests AlloyIDVServiceProviderTest
 */
@isTest
public class CZAlloyIDVServiceProviderTest {
  @isTest
  public static void testCaseOne() {
    tffa__Product__c prod2 = new tffa__Product__c();
    prod2.tffa__Category__c = 'CHECKING';
    prod2.tffa__Code__c = '1234';
    prod2.Name = 'Test';
    insert prod2;

    tffa__Submission__c submissionObj = new tffa__Submission__c();
    submissionObj.tffa__Status__c = 'IN_PROGRESS';
    submissionObj.tffa__KYCDecisionOutcome__c = 'APPROVED';
    submissionObj.tffa__State__c = 'PersonalInfo';
    submissionObj.tffa__HasExistingParty__c = true;
    submissionObj.tffa__SubmittedChannel__c = 'DIGITAL';
    insert submissionObj;

    tffa.SObjectAssembler asm = new tffa.SObjectAssembler(submissionObj);

    List<tffa__Application__c> applicationobjs = new List<tffa__Application__c>();
    tffa__Product__c product1 = CZWTFCTestDataRepository.createCheckingProduct();
    tffa__Application__c application = CZWTFCTestDataRepository.createCheckingApplication();
    application.tffa__Product__c = product1.id;
    application.tffa__Submission__c = submissionObj.id;
    application.tffa__ProductCode__c = '20234';

    insert application;

    applicationobjs.add(application);

    asm.addChildObject('Applications__r', application);

    tffa__Party__c partyObj = CZWTFCTestDataRepository.createIndividualParty();

    partyObj.tffa__ExternalId__c = '123456';
    insert partyObj;

    tffa__Address__c address = new tffa__Address__c();
    address.tffa__Line1__c = '803 Ecostar';
    address.tffa__Line2__c = ' ';
    address.tffa__State__c = 'CT1';
    address.tffa__City__c = 'Darien';
    address.tffa__Country__c = 'US';
    address.tffa__ZipCode__c = '06820-4621';
    insert address;

    List<tffa__PartyAddressXref__c> partyAddressXrefs = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref0 = new tffa__PartyAddressXref__c();
    partyAddressXref0.tffa__Type__c = 'HOME';
    partyAddressXref0.tffa__Preferred__c = true;
    partyAddressXref0.tffa__Address__r = address;
    partyAddressXrefs.add(partyAddressXref0);

    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty1 = new tffa.SObjectAssembler(jointParty);
    asmParty1.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs);
    jointParty = (tffa__Party__c) asmParty1.assemble();

    tffa__Address__c address1 = new tffa__Address__c();
    address1.tffa__Line1__c = '803 Ecostar';
    address1.tffa__Line2__c = ' ';
    address1.tffa__State__c = 'CT1';
    address1.tffa__City__c = 'Darien';
    address1.tffa__Country__c = 'US';
    address1.tffa__ZipCode__c = '06820-41';
    insert address1;

    List<tffa__PartyAddressXref__c> partyAddressXrefs1 = new List<tffa__PartyAddressXref__c>();
    tffa__PartyAddressXref__c partyAddressXref01 = new tffa__PartyAddressXref__c();
    partyAddressXref01.tffa__Type__c = 'HOME';
    partyAddressXref01.tffa__Preferred__c = true;
    partyAddressXref01.tffa__Address__r = address1;
    partyAddressXrefs1.add(partyAddressXref01);

    tffa__Party__c jointParty1 = new tffa__Party__c();
    jointParty1.tffa__BrandCode__c = '118';
    jointParty1.tffa__IsExistingCustomer__c = false;
    jointParty1.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty1.tffa__Citizenship__c = 'Citizen';
    jointParty1.tffa__DoNotCall__c = false;
    jointParty1.tffa__DoNotEmail__c = false;
    jointParty1.tffa__DoNotText__c = false;
    jointParty1.tffa__FirstName__c = 'John';
    jointParty1.tffa__LastName__c = 'May';
    jointParty1.tffa__QualiFileStatus__c = 'PASSED';
    jointParty1.tffa__IDVStatus__c = 'PASSED';
    jointParty1.tffa__IDAStatus__c = 'PASSED';
    jointParty1.tffa__CDDStatus__c = 'PASSED';
    jointParty1.tffa__OFACStatus__c = 'PASSED';
    //jointParty1.tffa__Type__c = 'ORGANIZATION';

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa.SObjectAssembler asmParty12 = new tffa.SObjectAssembler(jointParty1);
    asmParty12.addChildObjects('tffa__AddressXrefs__r', partyAddressXrefs1);
    jointParty1 = (tffa__Party__c) asmParty12.assemble();

    tffa.SObjectAssembler asmParty = new tffa.SObjectAssembler(partyObj);
    asmParty.addChildObjects('tffa__AddressXrefs__r', CZWTFCTestDataRepository.createPartyAddressXrefs());
    asmParty.addChildObject('tffa__Identifications__r', CZWTFCTestDataRepository.createIdentification());
    partyObj = (tffa__Party__c) asmParty.assemble();

    tffa__SubmissionPartyXref__c xref12 = new tffa__SubmissionPartyXref__c();
    xref12.tffa__Submission__c = submissionObj.id;
    xref12.tffa__Party__r = jointParty1;
    xref12.Name = 'TEst';
    xref12.tffa__IsPresent__c = true;
    xref12.tffa__Primary__c = true;
    xref12.tffa__Type__c = 'INDIVIDUAL';

    tffa__SubmissionPartyXref__c xref1 = new tffa__SubmissionPartyXref__c();
    xref1.tffa__Submission__c = submissionObj.id;
    xref1.tffa__Party__r = partyObj;
    xref1.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    xref1.tffa__Primary__c = true;
    xref1.tffa__Type__c = 'INDIVIDUAL';

    tffa__SubmissionPartyXref__c partyXRef = new tffa__SubmissionPartyXref__c();
    partyXRef.tffa__Submission__c = submissionObj.id;
    partyXRef.tffa__Party__r = jointParty;
    partyXRef.tffa__IsPresent__c = true;
    xref1.Name = 'TEst';
    partyXRef.tffa__Type__c = 'INDIVIDUAL';
    partyXref.tffa__Primary__c = false;

    tffa__ProductMatrix__c prodMat1 = new tffa__ProductMatrix__c();
    prodMat1.tffa__BrandCodeSet__c = '1234';
    prodMat1.StateCodeSet__c = ';CT;';
    prodMat1.tffa__Product__c = product1.Id;
    insert prodMat1;

    tffa__Product__c prod8003 = new tffa__Product__c();
    prod8003.tffa__Category__c = 'CHECKING';
    prod8003.tffa__Code__c = '8004';
    prod8003.Name = 'Test';
    insert prod8003;

    tffa__ProductMatrix__c prodMat12 = new tffa__ProductMatrix__c();
    prodMat12.tffa__BrandCodeSet__c = '1234';
    prodMat12.StateCodeSet__c = ';CT1;';
    prodMat12.zipCodeSet__c = '06820-4621';
    prodMat12.tffa__Product__c = prod8003.Id;
    insert prodMat12;

    asm.addChildObjects('tffa__PartyXrefs__r', new List<tffa__SubmissionPartyXref__c>{ partyXRef, xref1, xref12 });
    submissionObj = (tffa__Submission__c) asm.assemble();

    Test.startTest();

    FISCCIntegrationLogService.setSubmissionObj((String) submissionObj.Id);
    FISCCIntegrationLogService.setIntegrationLog((String) submissionObj.Id);
    FISCCIntegrationLogService.setCurrentLog(submissionObj.Name + '-' + FISCCIntegrationConstants.CUSTOMER_API_INQUIRES);
    CZWTFCIntegrationLogService.setCurrentLogItem(FISCCIntegrationConstants.OLB_CHECK, submissionObj.name, true);

    Map<String, Object> params = new Map<String, Object>();
    params.put('Submission__r', submissionObj);
    params.put('Submission__c', submissionObj.Id);
    params.put('Type__c', 'IDV');
    params.put('DeviceToken__c', '1');
    CZAlloyIDVServiceProvider provider = new CZAlloyIDVServiceProvider();
    upsert jointParty1;
    upsert jointParty;

    try {
      new CZIDVServiceProvider().verify(new List<tffa__Party__c>{ jointParty }, params);
    } catch (Exception ex) {
    }

    provider.verifyUsingAlloy(new List<tffa__Party__c>{ jointParty1 }, params);
    provider.verifyUsingAlloy(new List<tffa__Party__c>{ jointParty }, params);
    List<tffa__DueDiligence__c> allDiligences = new List<tffa__DueDiligence__c>();
    List<tffa.DocumentMetadataDTO> allReports = new List<tffa.DocumentMetadataDTO>();
    try {
      provider.verifyOrganization(jointParty, allDiligences, allReports, params);
    } catch (Exception ex) {
    }

    String responseJson =
      '{"status_code":201,"timestamp":5456564,"evaluation_token":"dedewee3ew","entity_token":"P-wewewrwe' +
      '5wOjzeB","application_token":"NAqEbyVvyZvXzIlgiqlvHayhX4jTBRwD","application_version_id":2,"summary":{"result":"success"' +
      ',"score":0.91,"tags":["Checking Account","SSN Not Verified","KYC Name Match","KYC DOB Match","KYC Address Match","Denied' +
      ' KYC","Phone Match","QualiFile Accept","KBA Quiz Passed"],"outcome_reasons":[],"outcome":"Approved","services":{"QualiFi' +
      'le":"executed","Ekata":"cached","ID Analytics ID Score":"executed","Lexis Nexis Instant ID":"executed","Socure 30":"exec' +
      'uted","Iovation":"executed","IDAnalytics CertainID":"executed"}},"meta":{},"matching":{"pho' +
      'ne":{"score":1,"matched":["Ekata","Lexis Nexis Instant ID","Socure 30"],"unmatched":[]},"address":{"score":1,"matched":[' +
      '"Ekata","Lexis Nexis Instant ID","Socure 30"],"unmatched":[]},"email":{"score":0.99,"matched":["Ekata","Socure 30"],"unm' +
      'atched":[]},"name":{"score":0.99,"matched":["Lexis Nexis Instant ID","Socure 30"],"unmatched":[]},"ssn":{"score":0.49,"m' +
      'atched":["Socure 30"],"unmatched":["Lexis Nexis Instant ID"]},"dob":{"score":0.99,"matched":["Lexis Nexis Instant ID","S' +
      'ocure 30"],"unmatched":[]},"average_score":0.91},"diligence":{"watchlists":{"lists":["BES","CFTC","DTC","EUDT","FBI","FC' +
      'EN","FAR","IMW","OFAC","OCC","OSFI","PEP","SDT","UNNT","BIS","WBIF"],"matches":[{"type":"United States,OFAC","source":"S' +
      'ocure","confidence":100,"reasons":["nameExact","dobExact"],"details":{"name":{"Full":"Individual"},"address":{"Country":' +
      '"United States of America"},"birth_date":"1996-04-07","links":["https://alloy.co/"]}}]},"fraud":{"average_score":0.22,"f' +
      'lags":[],"sources":{"ID Analytics ID Score":{"normalized_score":0.5,"raw_score":500,"attribute":"IDScore"},"Iovation":{"' +
      'normalized_score":0.5,"raw_score":0,"attribute":"SureScore"},"Ekata":{"normalized_score":0,"raw_score":0,"attribute":"Fr' +
      'aud Score"},"Socure 30":{"normalized_score":0,"raw_score":0,"attribute":"Generic Fraud Score"},"QualiFile":{"normalized_' +
      'score":0.12,"raw_score":800,"attribute":"Qualifile Score"}},"score":0.22},"financial":{"credit":[{"source":"QualiFile","' +
      'models":{"QualiFile":{"name":"ChexSys QualiFile","score":800,"codes":["AA","AB","AC","AD","AE"],"model_codes":[{"code":"' +
      'AA","description":"Retail item activity"},{"code":"AB","description":"DDA history"},{"code":"AC","description":"Time sin' +
      'ce DDA activity"},{"code":"AD","description":"DDA closure(s)"},{"code":"AE","description":"Time since DDA closure(s)"}],' +
      '"bureau":"QualiFile"}}}]},"identity_questions":[{"source":"IDAnalytics CertainID","score":100}]},"related_data":{"social' +
      '":[{"type":"Facebook","url":"https://www.facebook.com/dog","id":"dog"},{"type":"Google Plus","url":"https://plus.google.' +
      'com/dog","id":"dog"}]},"raw_responses":{"Lexis Nexis Instant ID":[{"response":{"Header":{"Status":0,"TransactionId":"0"}' +
      ',"Result":{"ComprehensiveVerification":{"ComprehensiveVerificationIndex":50,"PotentialFollowupActions":{"FollowupAction"' +
      ':[{"RiskCode":"B","Description":"Verify name with Social (via SSN card, DL if applicable, paycheck stub, or other Govern' +
      'ment Issued ID)"},{"RiskCode":"C","Description":"Verify name with Address (via DL, utility bill, Directory Assistance, p' +
      'aycheck stub, or other Government Issued ID)"}]},"RiskIndicators":{"RiskIndicator":[{"RiskCode":"PA","Sequence":1,"Descr' +
      'iption":"Potential address discrepancy - the Input address may be previous address"},{"RiskCode":"SD","Sequence":2,"Desc' +
      'ription":"The input address state is different than LN best address on file"},{"RiskCode":"10","Sequence":3,"Description' +
      '":"The input phone number is a mobile number"}]}}}}}],"QualiFile":[{"callChexSystemsServiceV001Return":{"txtReport":"htm' +
      'l report txt"}}],"Iovation":[{"result":"A","reason":"Other Subscriber Financial Evidence","trackingnumber":"807429173349' +
      '4565465","device.alias":"43454656","device.firstseen":"2016-03-22T22:16:30.769Z","device.new":"1"}]},"formatted' +
      '_responses":{"ID Analytics ID Score":{"data":{"idScore":500,"consumerStatement":"","reason_codes":["909","925","934"]},"' +
      'matching":{}},"Iovation":{"data":{"days_since_device_first_seen_by_alloy":0,"num_times_device_seen_by_alloy":0,"3rd_part' +
      'y_os":false}},"Ekata":{"data":{},"matching":{"phone":{"score":1,"matched":true},"address":{"score":1,"matched":true},"em' +
      'ail":{"score":1,"matched":true}}},"Lexis Nexis Instant ID":{"matching":{"name":{"score":1,"matched":true},"address":{"sc' +
      'ore":1,"matched":true},"ssn":{"score":0,"matched":false},"dob":{"score":1,"matched":true},"phone":{"score":1,"matched":t' +
      'rue},"passport":{"score":0,"matched":false}},"diligence":{"watchlists":{"lists":["BES","CFTC","DTC","EUDT","FBI","FCEN",' +
      '"FAR","IMW","OFAC","OCC","OSFI","PEP","SDT","UNNT","BIS","WBIF"],"matches":[]},"fraud":{},"financial":{}},"data":{"watch' +
      'lists":{"pep":0,"ofac":0},"identity_theft_risk":1,"risk_codes":["PA","SD","10"],"followup_codes":[],"address":{"po_box":' +
      'false,"commercial_mail":false},"ssn":{"issuance_start_date":"1977-01-1","issuance_end_date":"1979-12-1","issuance_state"' +
      ':"VIRGINIA"},"reverse_phone":{"name_first":"THOMAS","name_last":"NICHOLAS","address_city":"RICHMOND","address_state":"VA' +
      '","address_postal_code_last5":"23220"},"reverse_name_address":{"phone_number":8043563199},"verification":{"dob_day":true' +
      ',"dob_month":true,"dob_year":true,"name_first_last":true,"name_first_address":true,"name_last_address":true,"name_first_' +
      'phone":true,"name_last_phone":true,"name_first_ssn":false,"name_last_ssn":false,"address_phone":true,"address_ssn":false' +
      ',"name_first_last_address":true,"name_first_last_phone":true,"name_first_last_ssn":false,"name_first_address_phone":true' +
      ',"name_last_address_phone":true,"name_first_last_address_phone":true,"name_first_address_ssn":false,"name_last_address_s' +
      'sn":false,"name_first_last_address_ssn":false}}},"IDAnalytics CertainID":{"data":{"status":"210","results":{"result":"PA' +
      'SSED","numberWrong":0,"timedOut":false}},"matching":{}},"Socure 30":{"data":{"reasonCodes":[],"watchLists":{"internation' +
      'alPEP":0,"internationalOFAC":0,"domesticPEP":0,"domesticOFAC":0,"ofac":0,"adverseMedia":0},"fraudScores":{"generic":0,"s' +
      'igma":0,"sigmaSynthetic":0},"kycValidation":{"firstName":true,"surName":true,"streetAddress":true,"city":true,"state":tr' +
      'ue,"zip":true,"dob":true,"mobileNumber":true,"ssn":true}},"matching":{"email":{"score":0.99,"matched":true},"name":{"sco' +
      're":0.99,"matched":true},"address":{"score":0.99,"matched":true},"dob":{"score":0.99,"matched":true},"phone":{"score":0.' +
      '99,"matched":true},"ssn":{"score":0.99,"matched":true}}},"QualiFile":{"data":{"frozen":false,"qualifile":{"score":800,"r' +
      'easoncodes":["AA","AB","AC","AD","AE"],"accountAcceptanceTxt":"ACCEPT","accountActionTxt":"A0100002,TRI-BUREAU ID THEFT,' +
      'ALERT NOT FOUND"},"closures":{"closureNotFoundCd":"Y","consumerDisputeQty":0,"paidClosureQty":0,"totalClosures":0,"unpai' +
      'dClosureQty":0,"soldClosuresQty":0,"partiallyPaidClosuresQty":0,"amounts":{"all":0,"paid":0,"unpaid":0}},"customerInquir' +
      'ies":{"numberInquiryCustomersTotalQty":0,"previousInquiryTotalQty":0}},"matching":{}}}}';

    tffa.AlloyDTO.EvaluationResponse response = (tffa.AlloyDTO.EvaluationResponse) new tffa.AlloyDTO.EvaluationResponse()
      .deserialize(responseJson);
    try {
      provider.parseIDVResponse(response, jointParty1, allDiligences, allReports);
    } catch (Exception ex) {
    }

    try {
      response.matching = null;
      provider.parseIDVResponse(response, jointParty1, allDiligences, allReports);
    } catch (Exception ex) {
    }

    try {
      provider.parseOFACResponse(response, jointParty1, allDiligences);
    } catch (Exception ex) {
    }

    try {
      provider.parseFraudResponse(response, jointParty1, allDiligences);
    } catch (Exception ex) {
    }

    try {
      provider.parseDebitBureauResponse(response, jointParty1, allDiligences);
    } catch (Exception ex) {
    }

    try {
      provider.parseIDAResponse(response, jointParty1, allDiligences);
    } catch (Exception ex) {
    }

    try {
      provider.parseDebitBureauReport(response, jointParty1, allDiligences, allReports);
    } catch (Exception ex) {
    }

    try {
      provider.parseDeviceResponse(response, jointParty1, allDiligences);
    } catch (Exception ex) {
    }

    try {
      provider.addWebhook(new tffa.AlloyService(), jointParty1);
    } catch (Exception ex) {
    }

    Test.stopTest();
  }

  @isTest
  public static void testCaseForRefreshStatus() {
    tffa__Party__c jointParty = new tffa__Party__c();
    jointParty.tffa__BrandCode__c = '118';
    jointParty.tffa__IsExistingCustomer__c = false;
    jointParty.tffa__BirthDate__c = Date.valueOf('1981-02-02');
    jointParty.tffa__Citizenship__c = 'Citizen';
    jointParty.tffa__DoNotCall__c = false;
    jointParty.tffa__DoNotEmail__c = false;
    jointParty.tffa__DoNotText__c = false;
    jointParty.tffa__NationalIdentifierValue__c = '123412341';
    jointParty.tffa__PrimaryEmail__c = 'a@a.c';

    jointParty.tffa__FirstName__c = 'John';
    jointParty.tffa__LastName__c = 'May';
    jointParty.tffa__QualiFileStatus__c = 'PASSED';
    jointParty.tffa__IDVStatus__c = 'PASSED';
    jointParty.tffa__IDAStatus__c = 'PASSED';
    jointParty.tffa__CDDStatus__c = 'PASSED';
    jointParty.tffa__OFACStatus__c = 'PASSED';
    jointParty.tffa__Type__c = 'INDIVIDUAL';
    insert jointParty;

    //jointParty.tffa__AddressXrefs__r = partyAddressXrefs;

    tffa__DueDiligence__c dueDiligence = new tffa__DueDiligence__c();
    List<tffa__DueDiligenceItem__c> ddItems = new List<tffa__DueDiligenceItem__c>();
    dueDiligence.Name = 'FIS OOW';
    dueDiligence.tffa__Type__c = 'IDA';
    dueDiligence.tffa__Status__c = 'CHALLENGED';
    dueDiligence.tffa__Provider__c = 'FIS IDA';
    dueDiligence.tffa__ExternalQuestionnaireId__c = '12323';
    dueDiligence.tffa__ConversationId__c = '1233';
    dueDiligence.tffa__party__c = jointParty.Id;

    tffa.SObjectAssembler asm12 = new tffa.SObjectAssembler(dueDiligence);

    tffa__DueDiligenceItem__c item = new tffa__DueDiligenceItem__c(
      Name = 'Test',
      tffa__Label__c = 'test',
      tffa__Code__c = '12345',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 1,
      tffa__Value__c = '12345'
    );
    List<Object> choices = new List<Object>();
    choices.add(new Map<String, String>{ 'name' => 'idaQuestion.answer1Text', 'value' => 'test' });
    choices.add(new Map<String, String>{ 'name' => 'idaQuestion.answer2Text', 'value' => 'tets' });

    item.tffa__Choices__c = JSON.serialize(choices);
    ddItems.add(item);
    tffa__DueDiligenceItem__c item1 = new tffa__DueDiligenceItem__c(
      Name = 'Tes2t',
      tffa__Label__c = 'test2',
      tffa__Code__c = '123425',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 2,
      tffa__Value__c = '123425'
    );
    List<Object> choices1 = new List<Object>();
    choices1.add(new Map<String, String>{ 'name' => 'idaQuestion.answer1Text', 'value' => 'test' });
    choices1.add(new Map<String, String>{ 'name' => 'idaQuestion.answer2Text', 'value' => 'tets' });

    item1.tffa__Choices__c = JSON.serialize(choices1);
    ddItems.add(item1);

    tffa__DueDiligenceItem__c item3 = new tffa__DueDiligenceItem__c(
      Name = 'Test1',
      tffa__Label__c = 'test1',
      tffa__Code__c = '123451',
      tffa__ValueType__c = 'RADIO_GROUP',
      tffa__Required__c = true,
      tffa__SortOrder__c = 3,
      tffa__Value__c = '123145'
    );
    List<Object> choices2 = new List<Object>();
    choices2.add(new Map<String, String>{ 'name' => 'idaQuestion.answer1Text', 'value' => 'test' });
    choices2.add(new Map<String, String>{ 'name' => 'idaQuestion.answer2Text', 'value' => 'tets' });

    item3.tffa__Choices__c = JSON.serialize(choices2);
    ddItems.add(item3);

    asm12.addChildObjects('Items__r', ddItems);
    dueDiligence = (tffa__DueDiligence__c) asm12.assemble();
    //insert dueDiligence;

    tffa.SObjectAssembler asmPar = new tffa.SObjectAssembler(jointParty);
    asmPar.addChildObjects('DueDiligences__r', new List<tffa__DueDiligence__c>{ dueDiligence });
    jointParty = (tffa__Party__c) asmPar.assemble();

    upsert dueDiligence;
    update jointParty;
    CZIDVServiceProvider idvProv = new CZIDVServiceProvider();
    tffa.AlloyDTO.EntityReview review = new tffa.AlloyDTO.EntityReview();

    Map<String, Object> facts = new Map<String, Object>();
    facts.put('webhook', true);
    facts.put('review', review);
    Test.startTest();
    try {
      idvProv.refreshStatus(new List<tffa__DueDiligence__c>{ dueDiligence }, facts);
    } catch (Exception ex) {
    }

    try {
      idvProv.updateStatus(new List<tffa__DueDiligence__c>{ dueDiligence }, facts);
    } catch (Exception ex) {
    }

    try {
      idvProv.pushStatusUpdate(dueDiligence, jointParty);
    } catch (Exception ex) {
    }
    Test.stopTest();
  }
}