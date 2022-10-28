//Copyright (c) 2019 Terafina Inc
/**
 * Controller class to manage disclosures<br>
 * @group Controller
 */
public with sharing virtual class CZDocusignRedirectController extends tffa.AbstractController implements tffa.IController {
  /**
   * Parent custom controller
   */
  private static tffa.IController controller;

  public String disclosureId;
  public String disclosureStatus;
  public String event { get; set; }
  public String envelopeId { get; set; }
  public String signerId { get; set; }
  public Boolean completed { get; set; }
  public String signerUrl { get; set; }
  public Boolean signerInitialized { get; set; }
  /**
   * Default constructor
   */
  public CZDocusignRedirectController() {
  }

  /**
   * DisclosureController as an extension to a CustomController
   */
  public CZDocusignRedirectController(tffa.IController p) {
    controller = p;
  }

  /**
   * Initializes the disclosure page with the page parameter as envelopeId. And checks for the envelope status of the docusign
   * based on the envelope id received as the page parameter. Marks the status as completed if the envelope is completely
   * signed by all the signers and navigates back to the docusign iframe opened in the UI. If not complete, fetches the eSign
   * URL for the next signer and navigates in the same iframe window.
   *
   * @see DisclosureService.fetchStatus
   * @return page reference
   */
  public virtual PageReference init() {
    tffa.Interaction.begin(tffa.Context.get(), CZDocusignRedirectController.class, 'init');
    try {
      signerInitialized = false;
      envelopeId = tffa.ApexPageUtils.getPageParameter('envelopeId');
      signerId = tffa.ApexPageUtils.getPageParameter('signerId');
      event = tffa.ApexPageUtils.getPageParameter('event');
      Map<String, Object> queryParams = new Map<String, Object>();
      queryParams.put('EnvelopeId__c', envelopeId);
      /*      List<Disclosure__c> disclosures = tDisclosureRepository.findAll(new QueryContext(queryParams));
      if (!disclosures.isEmpty()) {
        completed = true;
      }*/
      completed = false;
      return null;
    } catch (Exception ex) {
      tffa.Logger.error(ex);
      return tffa.ApexPageUtils.getGenericErrorPage(ex);
    } finally {
      tffa.Interaction.close();
    }
  }
}