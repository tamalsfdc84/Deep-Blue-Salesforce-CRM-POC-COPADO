/**
 * @description This is the Mock class for MX Read accounts Call
 */
@isTest
global class CZWTFCMXReadAccountProviderMockClass implements HttpCalloutMock {
  private String endPoint = '';
  public CZWTFCMXReadAccountProviderMockClass(String endPoint) {
    this.endPoint = endPoint;
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '{"account":{"account_number_set_by_name":"FEED","account_subtype_set_by_name":null,"account_type_set_by_name":"FEED","apr_set_by_name":null,"apy_set_by_name":null,"available_balance_set_by_name":"FEED","available_credit_set_by_name":null,"balance_set_by_name":"FEED","cash_balance_set_by_name":null,"cash_surrender_value_set_by_name":null,"currency_code_set_by_name":"FEED","credit_limit_set_by_name":null,"day_payment_is_due_set_by_name":null,"death_benefit_set_by_name":null,"feed_account_type_name":"CHECKING","feed_account_subtype_name":null,"holdings_value_set_by_name":null,"interest_rate_set_by_name":null,"last_payment_set_by_name":null,"last_payment_at_set_by_name":null,"loan_amount_set_by_name":null,"matures_on_set_by_name":null,"minimum_balance_set_by_name":null,"minimum_payment_set_by_name":null,"name_set_by_name":"FEED","nickname_set_by_name":null,"original_balance_set_by_name":null,"payment_due_at_set_by_name":null,"payoff_balance_set_by_name":null,"started_on_set_by_name":null,"statement_balance_set_by_name":null,"total_account_value_set_by_name":null,"account_number":"7395421551","account_number_set_by":1,"account_subtype":null,"account_subtype_name":null,"account_subtype_set_by":null,"account_type":1,"account_type_name":"CHECKING","account_type_set_by":1,"apr":null,"apr_set_by":null,"apy":null,"apy_set_by":null,"available_balance":1000,"available_balance_set_by":1,"available_credit":null,"available_credit_set_by":null,"balance":1000,"balance_set_by":1,"calculated_apr":null,"cash_balance":null,"cash_balance_set_by":null,"cash_surrender_value":null,"cash_surrender_value_set_by":null,"created_at":"2020-06-04T09:19:48+00:00","credit_limit":null,"credit_limit_set_by":null,"currency_code":"USD","currency_code_set_by":1,"day_payment_is_due":null,"day_payment_is_due_set_by":null,"death_benefit":null,"death_benefit_set_by":null,"external_guid":"account-3fd9365b-82b6-4329-93ec-44758d6614e7","feed_account_number":"7395421551","feed_account_subtype":null,"feed_account_type":1,"feed_apr":null,"feed_apy":null,"feed_available_balance":1000,"feed_balance":1000,"feed_cash_balance":null,"feed_cash_surrender_value":null,"feed_credit_limit":null,"feed_currency_code":"USD","feed_death_benefit":null,"feed_day_payment_is_due":null,"feed_holdings_value":null,"feed_interest_rate":null,"feed_last_payment":null,"feed_last_payment_at":null,"feed_loan_amount":null,"feed_matures_on":null,"feed_minimum_balance":null,"feed_minimum_payment":null,"feed_name":"Gringotts Checking","feed_nickname":null,"feed_original_balance":null,"feed_payment_due_at":null,"feed_payoff_balance":null,"feed_routing_number":null,"feed_started_on":null,"feed_statement_balance":null,"feed_total_account_value":null,"guid":"ACT-cb9769e4-0a1d-4419-a237-36d7bb3951fc","holdings_value":null,"holdings_value_set_by":null,"institution_guid":"INS-1572a04c-912b-59bf-5841-332c7dfafaef","interest_rate":null,"interest_rate_set_by":null,"is_closed":false,"is_hidden":false,"is_manual":false,"last_payment":null,"last_payment_at":null,"last_payment_at_set_by":null,"last_payment_set_by":null,"loan_amount":null,"loan_amount_set_by":null,"matures_on":null,"matures_on_set_by":null,"member_guid":"MBR-c1bfc41b-46a7-48e4-a2a3-c974cd17715b","member_is_managed_by_user":true,"metadata":"some hard coded metadata","minimum_balance":null,"minimum_balance_set_by":null,"minimum_payment":null,"minimum_payment_set_by":null,"name":"Gringotts Checking","name_set_by":1,"nickname":null,"nickname_set_by":null,"original_balance":null,"original_balance_set_by":null,"payment_due_at":null,"payment_due_at_set_by":null,"payoff_balance":null,"payoff_balance_set_by":null,"property_type":null,"property_type_name":null,"routing_number":null,"revision":1,"started_on":null,"started_on_set_by":null,"statement_balance":null,"statement_balance_set_by":null,"total_account_value":null,"total_account_value_set_by":null,"updated_at":"2020-06-04T09:19:48+00:00","user_guid":"USR-9d8213ba-0cc9-4d60-8b9f-183e5a39d1c2"}}';

    String errResponse = '{"error":{"code":null,"message":"That id is already in use, please use a unique id."}}';

    HttpResponse res = new HttpResponse();
    if (endPoint.equals('FaultCode')) {
      res.setBody(errResponse);
      res.setStatusCode(500);
    } else if (endPoint.equals('testSuccess')) {
      res.setBody(validResponse);
      res.setStatusCode(200);
    }
    return res;
  }
}