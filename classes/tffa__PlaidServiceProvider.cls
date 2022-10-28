/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global virtual class PlaidServiceProvider {
    global PlaidServiceProvider() {

    }
    global virtual Map<String,Object> cancelBankTransfer(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> createAssetReportAuditCopy(String assetReportToken, String auditorId) {
        return null;
    }
    global virtual Map<String,Object> createAssetReport(tffa.PlaidAssetRequestDTO dto) {
        return null;
    }
    global virtual tffa.PlaidBankTransferDTO.BankTransferCreateResponse createBankTransfer(tffa.PlaidBankTransferDTO.BankTransferCreateRequest dto) {
        return null;
    }
    global virtual Map<String,Object> createDepositSwitchRequest(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> createIncomeVerificationRequest(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> createPublicToken(String accessToken) {
        return null;
    }
    global virtual tffa.PlaidAccountResponseDTO fetchAccountBalances(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidAccountResponseDTO fetchAccountsForFunding(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidBankTransferDTO.BankTransferEventListResponse fetchAllBankTransferEvents(tffa.PlaidBankTransferDTO.BankTransferEventListRequest dto) {
        return null;
    }
    global virtual tffa.PlaidBankTransferDTO.BankTransferListResponse fetchAllBankTransfers(tffa.PlaidBankTransferDTO.BankTransferListRequest dto) {
        return null;
    }
    global virtual tffa.PlaidAccountResponseDTO fetchAssetsAndLiabilities(Map<String,Object> params) {
        return null;
    }
    global Map<String,Object> fetchAuthenticationToken(String publicToken) {
        return null;
    }
    global virtual tffa.PlaidDepositResponseSwitchDTO fetchDepositSwitch(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidAccountResponseDTO fetchIdentityData(Map<String,Object> params) {
        return null;
    }
    global virtual Blob fetchIncomeVerificationPaystubDocument(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidIncomeResponseDTO fetchIncomeVerificationPaystubs(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidIncomeResponseDTO fetchIncomeVerificationSummary(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidIncomeResponseDTO fetchIncomeVerificationTaxforms(Map<String,Object> params) {
        return null;
    }
    global virtual tffa.PlaidAccountResponseDTO fetchLiabilities(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> fetchLinkToken(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> fetchWebhookVerificationKey(String kid) {
        return null;
    }
    global virtual Map<String,Object> filterAccountsFromAssetReport(String assetReportToken, List<String> excludedAccountIds) {
        return null;
    }
    global virtual Blob getAssetReportAsPDF(String assetReportToken, Boolean includeInsights) {
        return null;
    }
    global static tffa.PlaidServiceProvider getInstance() {
        return null;
    }
    global virtual tffa.PlaidBankTransferDTO.BankTransferGetResponse readBankTransfer(Map<String,Object> params) {
        return null;
    }
    global virtual Map<String,Object> refreshAssetReport(tffa.PlaidAssetRequestDTO dto) {
        return null;
    }
    global virtual Map<String,Object> removeAssetReportAuditCopy(String auditCopyToken) {
        return null;
    }
    global virtual Map<String,Object> removeAssetReport(String assetReportToken) {
        return null;
    }
    global virtual Map<String,Object> removeItem(String accessToken) {
        return null;
    }
    global virtual void setCredential(String credentialName) {

    }
    global virtual tffa.PlaidBankTransferDTO.BankTransferEventListResponse syncBankTransferEvents(tffa.PlaidBankTransferDTO.BankTransferEventListRequest dto) {
        return null;
    }
}
