/*
This file is generated and isn't the actual source code for this
managed global class.
This read-only file shows the class's global constructors,
methods, variables, and properties.
To enable code to compile, all methods return null.
*/
global class CodatDTO {
    global CodatDTO() {

    }
global class AddCompanyModel extends tffa.CodatDTO.BaseDTO {
    global String name;
    global String platformType;
    global AddCompanyModel() {

    }
}
global class AddRuleModel extends tffa.CodatDTO.BaseDTO {
    global String companyId;
    global tffa.CodatDTO.Notifiers notifiers;
    global String type;
    global AddRuleModel() {

    }
}
global class Address extends tffa.CodatDTO.BaseDTO {
    global String city;
    global String country;
    global String line1;
    global String line2;
    global String postalCode;
    global String region;
    global String type;
    global Address() {

    }
}
global class Alert extends tffa.CodatDTO.BaseDTO {
    global String companyId;
    global String data;
    global String id;
    global Datetime raisedOnUtc;
    global Datetime resolvedOnUtc;
    global String ruleId;
    global Alert() {

    }
}
global class BalanceSheet extends tffa.CodatDTO.BaseDTO {
    global tffa.CodatDTO.ReportLine assets;
    global Datetime dateX;
    global tffa.CodatDTO.ReportLine equity;
    global tffa.CodatDTO.ReportLine liabilities;
    global Decimal netAssets;
    global BalanceSheet() {

    }
}
global class BalanceSheetResponse extends tffa.CodatDTO.BaseDTO {
    global String currencyX;
    global Datetime earliestAvailableMonth;
    global Datetime mostRecentAvailableMonth;
    global List<tffa.CodatDTO.BalanceSheet> reports;
    global BalanceSheetResponse() {

    }
}
global abstract class BaseDTO extends tffa.AbstractDTO {
    global BaseDTO() {

    }
}
global class CashFlowStatement extends tffa.CodatDTO.BaseDTO {
    global tffa.CodatDTO.ReportLine cashPayments;
    global tffa.CodatDTO.ReportLine cashReceipts;
    global Datetime fromDate;
    global Datetime toDate;
    global CashFlowStatement() {

    }
}
global class CashFlowStatementResponse extends tffa.CodatDTO.BaseDTO {
    global String currencyX;
    global Datetime earliestAvailableMonth;
    global Datetime mostRecentAvailableMonth;
    global String reportBasis;
    global String reportInput;
    global List<tffa.CodatDTO.CashFlowStatement> reports;
    global CashFlowStatementResponse() {

    }
}
global class ClientSyncSettings extends tffa.CodatDTO.BaseDTO {
    global String clientId;
    global Boolean overridesDefaults;
    global List<tffa.CodatDTO.SyncSetting> settings;
    global ClientSyncSettings() {

    }
}
global class Company extends tffa.CodatDTO.BaseDTO {
    global Datetime created;
    global List<tffa.CodatDTO.DataConnection> dataConnections;
    global String id;
    global Datetime lastSync;
    global String name;
    global String platform;
    global String redirect;
    global String status {
        get;
        set;
    }
    global Company() {

    }
}
global class CompanyDataset extends tffa.CodatDTO.BaseDTO {
    global String accountingPlatformRef;
    global List<tffa.CodatDTO.Address> addresses;
    global String baseCurrency;
    global String companyLegalName;
    global String companyName;
    global Datetime createdDate;
    global Datetime financialYearStartDate;
    global List<tffa.CodatDTO.Phone> phoneNumbers;
    global String registrationNumber;
    global Map<String,String> sourceUrls;
    global String taxNumber;
    global List<tffa.CodatDTO.WebLink> webLinks;
    global CompanyDataset() {

    }
    global List<tffa.CodatDTO.Address> getAddresses(String type) {
        return null;
    }
    global List<tffa.CodatDTO.Phone> getPhoneNumbers(String type) {
        return null;
    }
    global List<tffa.CodatDTO.WebLink> getWebLinks(String type) {
        return null;
    }
}
global class CompanyPagedResponse extends tffa.CodatDTO.BaseDTO {
    global Map<String,tffa.CodatDTO.HalLink> links;
    global Integer pageNumber;
    global Integer pageSize;
    global List<tffa.CodatDTO.Company> results;
    global Integer totalResults;
    global CompanyPagedResponse() {

    }
}
global class DataConnection extends tffa.CodatDTO.BaseDTO {
    global Datetime created;
    global String id;
    global String integrationId;
    global Datetime lastSync;
    global String linkUrl;
    global String platformName;
    global String sourceId;
    global String status;
    global DataConnection() {

    }
}
global class DataSet extends tffa.CodatDTO.BaseDTO {
    global String blobUrl;
    global String companyId;
    global Datetime completed;
    global String connectionId;
    global String dataType;
    global String errorMessage;
    global String id;
    global Boolean isCompleted;
    global Boolean isErrored;
    global Integer progress;
    global Datetime requested;
    global String status;
    global String validationinformationUrl;
    global DataSet() {

    }
}
global class DataStatus extends tffa.CodatDTO.BaseDTO {
    global String currentStatus;
    global String dataType;
    global Datetime lastSuccessfulSync;
    global String latestSuccessfulSyncId;
    global String latestSyncId;
    global DataStatus() {

    }
}
global class HalLink extends tffa.CodatDTO.BaseDTO {
    global String href;
    global HalLink() {

    }
}
global class Notifiers extends tffa.CodatDTO.BaseDTO {
    global List<String> emails;
    global String webhook;
    global Notifiers() {

    }
}
global class Phone extends tffa.CodatDTO.BaseDTO {
    global String numberX;
    global String type;
    global Phone() {

    }
}
global class PlatformSource extends tffa.CodatDTO.BaseDTO {
    global Boolean enabled;
    global String integrationId;
    global String key;
    global String logoUrl;
    global String name;
    global String sourceId;
    global String sourceType;
    global PlatformSource() {

    }
}
global class ProfitAndLossReport extends tffa.CodatDTO.BaseDTO {
    global tffa.CodatDTO.ReportLine costOfSales;
    global tffa.CodatDTO.ReportLine expenses;
    global Datetime fromDate;
    global Decimal grossProfit;
    global tffa.CodatDTO.ReportLine income;
    global Decimal netOperatingProfit;
    global Decimal netOtherIncome;
    global Decimal netProfit;
    global tffa.CodatDTO.ReportLine otherExpenses;
    global tffa.CodatDTO.ReportLine otherIncome;
    global Datetime toDate;
    global ProfitAndLossReport() {

    }
}
global class ProfitAndLossResponse extends tffa.CodatDTO.BaseDTO {
    global String currencyX;
    global Datetime earliestAvailableMonth;
    global Datetime mostRecentAvailableMonth;
    global String reportBasis;
    global List<tffa.CodatDTO.ProfitAndLossReport> reports;
    global ProfitAndLossResponse() {

    }
}
global class ReportLine extends tffa.CodatDTO.BaseDTO {
    global String accountId;
    global List<tffa.CodatDTO.ReportLine> items;
    global String name;
    global Decimal value;
    global ReportLine() {

    }
}
global class Rule extends tffa.CodatDTO.BaseDTO {
    global String companyId;
    global String id;
    global tffa.CodatDTO.Notifiers notifiers;
    global String type;
    global Rule() {

    }
}
global class SyncSetting extends tffa.CodatDTO.BaseDTO {
    global String dataType;
    global Boolean fetchOnFirstLink;
    global Integer monthsToSync;
    global Datetime syncFromUtc;
    global Integer syncFromWindow;
    global Integer syncOrder;
    global Integer syncSchedule;
    global SyncSetting() {

    }
}
global class WebLink extends tffa.CodatDTO.BaseDTO {
    global String type;
    global String url;
    global WebLink() {

    }
}
global class WebhookAlert extends tffa.CodatDTO.BaseDTO {
    global String alertId;
    global String companyId;
    global tffa.CodatDTO.WebhookAlertData data;
    global String message;
    global String ruleId;
    global String ruleType;
    global WebhookAlert() {

    }
}
global class WebhookAlertData extends tffa.CodatDTO.BaseDTO {
    global String companyName;
    global String dataConnectionId;
    global String datasetId;
    global String datasetStatus;
    global String dataType;
    global String newStatus;
    global String oldStatus;
    global String platformKey;
    global WebhookAlertData() {

    }
}
}
