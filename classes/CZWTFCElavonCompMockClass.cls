global with sharing class CZWTFCElavonCompMockClass implements HttpCalloutMock {
  global CZWTFCElavonCompMockClass() {
  }

  global HttpResponse respond(HttpRequest req) {
    String validResponse = '<?xml version=\"1.0\" encoding=\"UTF-8\"?><txn><ssl_last_name>UserLastName</ssl_last_name><ssl_company/><ssl_phone/><ssl_card_number>40**********0002</ssl_card_number><ssl_oar_data>010010974310250849490000047554200000000000300383129808109743</ssl_oar_data><ssl_result>0</ssl_result><ssl_txn_id>251021ED3-FF481CB1-71D5-4CC7-88C0-75B60BD2B7B1</ssl_txn_id><ssl_avs_response/><ssl_approval_code>300383</ssl_approval_code><ssl_email/><ssl_amount>100.00</ssl_amount><ssl_avs_zip/><ssl_txn_time>10/25/2021 04:50:26 AM</ssl_txn_time><ssl_description/><ssl_exp_date>0222</ssl_exp_date><ssl_card_short_description>VISA</ssl_card_short_description><ssl_address2/><ssl_customer_code/><ssl_country/><ssl_card_type>CREDITCARD</ssl_card_type><ssl_transaction_type>COMPLETE</ssl_transaction_type><ssl_salestax/><ssl_avs_address/><ssl_account_balance>0.00</ssl_account_balance><ssl_ps2000_data>A7512983179012603450A</ssl_ps2000_data><ssl_state/><ssl_ship_to_zip/><ssl_city/><ssl_result_message>APPROVAL</ssl_result_message><ssl_first_name>Userone</ssl_first_name><ssl_invoice_number/><ssl_ship_to_address1/><ssl_cvv2_response/><ssl_partner_app_id>01</ssl_partner_app_id></txn>';
    HttpResponse res = new HttpResponse();

    res.setBody(validResponse);
    res.setStatusCode(200);

    return res;
  }
}