/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class PlaidAccountResponseDTO {
    global String accessToken {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Account> accounts {
        get;
        set;
    }
    global String displayMessage {
        get;
        set;
    }
    global String errorCode {
        get;
        set;
    }
    global String errorMessage {
        get;
        set;
    }
    global String errorType {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.Item item {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.Liability liabilities {
        get;
        set;
    }
    global String linkSessionId {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.Numbers numbers {
        get;
        set;
    }
    global String requestId {
        get;
        set;
    }
    global String suggestedAction {
        get;
        set;
    }
    global PlaidAccountResponseDTO() {

    }
    global static tffa.PlaidAccountResponseDTO deserialize(String jsonString) {
        return null;
    }
global class Account {
    global String accountId {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.Balances balances {
        get;
        set;
    }
    global String mask {
        get;
        set;
    }
    global String name {
        get;
        set;
    }
    global String officialName {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Owner> owners {
        get;
        set;
    }
    global String subtype {
        get;
        set;
    }
    global String typeX {
        get;
        set;
    }
    global String verificationStatus {
        get;
        set;
    }
    global Account() {

    }
}
global class Ach {
    global String account {
        get;
        set;
    }
    global String accountId {
        get;
        set;
    }
    global String routing {
        get;
        set;
    }
    global String wireRouting {
        get;
        set;
    }
    global Ach() {

    }
}
global class Address {
    global String city {
        get;
        set;
    }
    global String country {
        get;
        set;
    }
    global String postalCode {
        get;
        set;
    }
    global String region {
        get;
        set;
    }
    global String street {
        get;
        set;
    }
    global Address() {

    }
}
global class AddressXref {
    global tffa.PlaidAccountResponseDTO.Address data {
        get;
        set;
    }
    global Boolean primary {
        get;
        set;
    }
    global AddressXref() {

    }
}
global class Apr {
    global Decimal aprPercentage {
        get;
        set;
    }
    global String aprType {
        get;
        set;
    }
    global Decimal balanceSubjectToApr {
        get;
        set;
    }
    global Decimal interestChargeAmount {
        get;
        set;
    }
    global Apr() {

    }
}
global class Bacs {
    global String account {
        get;
        set;
    }
    global String accountId {
        get;
        set;
    }
    global String sortCode {
        get;
        set;
    }
    global Bacs() {

    }
}
global class Balances {
    global Decimal available {
        get;
        set;
    }
    global Decimal current {
        get;
        set;
    }
    global String isoCurrencyCode {
        get;
        set;
    }
    global Decimal limitX {
        get;
        set;
    }
    global String unofficialCurrencyCode {
        get;
        set;
    }
    global Balances() {

    }
}
global class ContactInformation {
    global String data {
        get;
        set;
    }
    global Boolean primary {
        get;
        set;
    }
    global String typeX {
        get;
        set;
    }
    global ContactInformation() {

    }
}
global class Credit {
    global String accountId {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Apr> aprs {
        get;
        set;
    }
    global Boolean isOverdue {
        get;
        set;
    }
    global Decimal lastPaymentAmount {
        get;
        set;
    }
    global String lastPaymentDate {
        get;
        set;
    }
    global Decimal lastStatementBalance {
        get;
        set;
    }
    global String lastStatementIssueDate {
        get;
        set;
    }
    global Decimal minimumPaymentAmount {
        get;
        set;
    }
    global String nextPaymentDueDate {
        get;
        set;
    }
    global Credit() {

    }
}
global class Eft {
    global String account {
        get;
        set;
    }
    global String accountId {
        get;
        set;
    }
    global String branch {
        get;
        set;
    }
    global String institution {
        get;
        set;
    }
    global Eft() {

    }
}
global class Error {
    global List<String> causes {
        get;
        set;
    }
    global String displayMessage {
        get;
        set;
    }
    global String documentationUrl {
        get;
        set;
    }
    global String errorCode {
        get;
        set;
    }
    global String errorMessage {
        get;
        set;
    }
    global String errorType {
        get;
        set;
    }
    global String requestId {
        get;
        set;
    }
    global Integer status {
        get;
        set;
    }
    global String suggestedAction {
        get;
        set;
    }
    global Error() {

    }
}
global class InteresRate {
    global Decimal percentage {
        get;
        set;
    }
    global String typeX {
        get;
        set;
    }
    global InteresRate() {

    }
}
global class International {
    global String accountId {
        get;
        set;
    }
    global String bic {
        get;
        set;
    }
    global String iban {
        get;
        set;
    }
    global International() {

    }
}
global class Item {
    global List<String> availableProducts {
        get;
        set;
    }
    global List<String> billedProducts {
        get;
        set;
    }
    global String consetExpirationTime {
        get;
        set;
    }
    global Object error {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.Error errorObj {
        get;
        set;
    }
    global String institutionId {
        get;
        set;
    }
    global String itemId {
        get;
        set;
    }
    global String updateType {
        get;
        set;
    }
    global String webhook {
        get;
        set;
    }
    global Item() {

    }
}
global class Liability {
    global List<tffa.PlaidAccountResponseDTO.Credit> credit {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Mortgage> mortgage {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Student> student {
        get;
        set;
    }
    global Liability() {

    }
}
global class LoanStatus {
    global String endDate {
        get;
        set;
    }
    global String typeX {
        get;
        set;
    }
    global LoanStatus() {

    }
}
global class Mortgage {
    global String accountId {
        get;
        set;
    }
    global String accountNumber {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.InteresRate interestRate {
        get;
        set;
    }
    global Decimal lastPaymentAmount {
        get;
        set;
    }
    global String lastPaymentDate {
        get;
        set;
    }
    global Decimal lastStatementBalance {
        get;
        set;
    }
    global String lastStatementIssueDate {
        get;
        set;
    }
    global String loanTerm {
        get;
        set;
    }
    global String loanTypeDescription {
        get;
        set;
    }
    global String maturityDate {
        get;
        set;
    }
    global Decimal minimumPaymentAmount {
        get;
        set;
    }
    global Decimal nextMonthlyPayment {
        get;
        set;
    }
    global String nextPaymentDueDate {
        get;
        set;
    }
    global String originationDate {
        get;
        set;
    }
    global Decimal originationInterestAmount {
        get;
        set;
    }
    global Decimal originationPrincipalAmount {
        get;
        set;
    }
    global Decimal pastDueAmount {
        get;
        set;
    }
    global Decimal ytdInterestPaid {
        get;
        set;
    }
    global Decimal ytdPrincipalPaid {
        get;
        set;
    }
    global Mortgage() {

    }
}
global class Numbers {
    global List<tffa.PlaidAccountResponseDTO.Ach> ach {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Bacs> bacs {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.Eft> eft {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.International> international {
        get;
        set;
    }
    global Numbers() {

    }
}
global class Owner {
    global List<tffa.PlaidAccountResponseDTO.AddressXref> addresses {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.ContactInformation> emails {
        get;
        set;
    }
    global List<String> names {
        get;
        set;
    }
    global List<tffa.PlaidAccountResponseDTO.ContactInformation> phoneNumbers {
        get;
        set;
    }
    global Owner() {

    }
}
global class Student {
    global String accountId {
        get;
        set;
    }
    global String accountNumber {
        get;
        set;
    }
    global List<String> disbursementDates {
        get;
        set;
    }
    global String expectedPayoffDate {
        get;
        set;
    }
    global String guarantor {
        get;
        set;
    }
    global Decimal interestRatePercentage {
        get;
        set;
    }
    global Boolean isOverdue {
        get;
        set;
    }
    global Decimal lastPaymentAmount {
        get;
        set;
    }
    global String lastPaymentDate {
        get;
        set;
    }
    global Decimal lastStatementBalance {
        get;
        set;
    }
    global String lastStatementIssueDate {
        get;
        set;
    }
    global String loanName {
        get;
        set;
    }
    global tffa.PlaidAccountResponseDTO.LoanStatus loanStatus {
        get;
        set;
    }
    global Decimal minimumPaymentAmount {
        get;
        set;
    }
    global String nextPaymentDueDate {
        get;
        set;
    }
    global String originationDate {
        get;
        set;
    }
    global Decimal originationInterestAmount {
        get;
        set;
    }
    global Decimal originationPrincipalAmount {
        get;
        set;
    }
    global Decimal ytdInterestPaid {
        get;
        set;
    }
    global Decimal ytdPrincipalPaid {
        get;
        set;
    }
    global Student() {

    }
}
}
