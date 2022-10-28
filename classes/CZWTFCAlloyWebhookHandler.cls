/**
 * Handles webhook alerts from Alloy system.
 * @group Provider
 */
global inherited sharing class CZWTFCAlloyWebhookHandler extends tffa.WebhookHandler {
  private tffa.AlloyService service = new tffa.AlloyService('Alloy_Person');

  global CZWTFCAlloyWebhookHandler() {
  }

  /**
   * Handles webhook alert coming as a Alloy webhook REST request.
   * @return `Response`
   */
  global override tffa.Response handle() {
    tffa.Interaction.begin(CZWTFCAlloyWebhookHandler.class, 'handle');
    try {
      tffa.Logger.debug(
        'Received webhook alert={0} for clientId={1}',
        new List<Object>{ tffa.ApexRESTUtils.getRequestAsString(), tffa.ApexRESTUtils.getHeader(tffa.AlloyService.X_ALLOY_CLIENT_ID) }
      );
      tffa.AlloyDTO.WebhookAlert alert = service.parseAndValidateWebhookAlert(
        tffa.ApexRESTUtils.getRequestAsString(),
        tffa.ApexRESTUtils.getHeaders()
      );
      switch on alert.type {
        when 'create:reviews:is_entity' {
          if (!checkAndForward(alert)) {
            tffa.AlloyDTO.EntityReview review = (tffa.AlloyDTO.EntityReview) alert.get('data', tffa.AlloyDTO.EntityReview.class);
            //review = canCallout() ? new tffa.AlloyService('Alloy_Person').readEntityReview(review.entity_token, review.review_token) : review;
            tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
              tffa__Type__c = tffa.DueDiligenceType.IDV.name(),
              tffa__Party__c = review.external_entity_id
            );
            new tffa.AlloyServiceHelper().populateReviewDetails(dd, review);
            tffa.DueDiligenceService.updateStatus(
              new List<tffa__DueDiligence__c>{ dd },
              new Map<String, Object>{ 'webhook' => true, 'review' => review, 'alert' => alert }
            );
          }
        }
        when 'update:evaluations:async_update' {
          if (!checkAndForward(alert)) {
            tffa.AlloyDTO.EvaluationResponse evaluation = (tffa.AlloyDTO.EvaluationResponse) alert.get(
              'data',
              tffa.AlloyDTO.EvaluationResponse.class
            );
            /* evaluation = canCallout()
              ? new tffa.AlloyService('Alloy_Business').readEvaluation(evaluation.entity_token, evaluation.evaluation_token)
              : evaluation;*/
            tffa__DueDiligence__c dd = new tffa__DueDiligence__c(
              tffa__Type__c = tffa.DueDiligenceType.IDV.name(),
              tffa__Party__c = evaluation.external_entity_id
            );
            new tffa.AlloyServiceHelper().populateEvaluationDetails(dd, evaluation, false);
            tffa.DueDiligenceService.refreshStatus(
              dd,
              new Map<String, Object>{ 'webhook' => true, 'evaluation' => evaluation, 'alert' => alert }
            );
          }
        }
      }
      return tffa.Response.ok().build();
    } catch (Exception ex) {
      tffa.Logger.error('Failed to handle alert=' + tffa.ApexRESTUtils.getRequestAsString(), ex);
      return tffa.Response.ok().build();
    } finally {
      tffa.Interaction.close();
    }
  }

  /**
   * Additional logic to foward the webhook alert to the right SF environment.
   * @param alert Webhook alert
   * @return true if request was forwarded
   */
  private Boolean checkAndForward(tffa.AlloyDTO.WebhookAlert alert) {
    // prevent System.CalloutException: Callout loop not allowed
    if (tffa__SiteUrl__c.getOrgDefaults().tffa__Url__c?.contains('dev-tffa') == true && canCallout()) {
      // we could do this by calling read entity review API also, we needed the meta on entity hence using read entity API
      String targetUrl;
      switch on alert.type {
        when 'create:reviews:is_entity' {
          tffa.AlloyService service = new tffa.AlloyService('Alloy_Person');
          tffa.AlloyDTO.EntityReview review = (tffa.AlloyDTO.EntityReview) alert.get('data', tffa.AlloyDTO.EntityReview.class);
          tffa.AlloyDTO.Entity entity = service.readEntity(review.entity_token);
          String webhookUrl = (String) entity.meta?.webhook_url;
          if (!String.isBlank(webhookUrl) && webhookUrl != tffa.WebhookRESTService.getWebhookUrl('alloy')) {
            alert.put('data', service.readEntityReview(review.entity_token, review.review_token));
            targetUrl = webhookUrl;
          }
        }
        when 'update:evaluations:async_update' {
          tffa.AlloyService service = new tffa.AlloyService('Alloy_Business');
          tffa.AlloyDTO.EvaluationResponse evaluation = (tffa.AlloyDTO.EvaluationResponse) alert.get(
            'data',
            tffa.AlloyDTO.EvaluationResponse.class
          );
          tffa.AlloyDTO.Entity entity = service.readEntity(evaluation.entity_token);
          String webhookUrl = (String) entity.meta?.webhook_url;
          if (!String.isBlank(webhookUrl) && webhookUrl != tffa.WebhookRESTService.getWebhookUrl('alloy')) {
            alert.put('data', service.readEvaluation(evaluation.entity_token, evaluation.evaluation_token));
            targetUrl = webhookUrl;
          }
        }
      }
      if (targetUrl != null) {
        Map<String, String> headers = new Map<String, String>();
        headers.put(tffa.AlloyService.X_ALLOY_CLIENT_ID, tffa.ApexRESTUtils.getHeader(tffa.AlloyService.X_ALLOY_CLIENT_ID));
        headers.put(tffa.ApplicationConstants.CONTENT_TYPE, tffa.ApexRESTUtils.getHeader(tffa.ApplicationConstants.CONTENT_TYPE));
        new tffa.HttpClient(targetUrl, alert.serialize(), headers).post();
        return true;
      }
    }
    return false;
  }

  private Boolean canCallout() {
    return tffa.ApexRESTUtils.getHeader('SFDC_STACK_DEPTH') != '1';
  }
}