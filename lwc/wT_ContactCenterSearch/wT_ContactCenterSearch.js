import { LightningElement, api, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getAccounts from "@salesforce/apex/WT_ContactCenterSearchController.GetAccounts";
import getMulesoftData from "@salesforce/apex/WT_ContactCenterSearchController.GetMulesoftData";
import getAdditionalDetails from "@salesforce/apex/WT_ContactCenterSearchController.GetAdditionalDetails";

export default class WT_ContactCenterSearch extends NavigationMixin(
  LightningElement
) {
  @track phoneNumber = "";
  @track firstName = "";
  @track lastName = "";
  @track ssn = "";
  @track accountNumber = "";
  @track listSearchResult = [];
  @track isLoadingSearchResult = true;
  @track isLoadingAdditionalSearchResult = false;
  @track hasListResidence = false;
  @track hasListFinancialAccount = false;
  @track listFinancialAccount = [];
  @track listResidence = [];
  @track searchHasNoResult = false;
  financialAccountColumns = [
    { label: "Charter", fieldName: "Charter" },
    { label: "Branch", fieldName: "Branch" },
    { label: "Account Number", fieldName: "AccountNumber" },
    { label: "Account Type", fieldName: "AccountType" },
    { label: "Relationship Type", fieldName: "RelationshipType" },
    { label: "Status", fieldName: "Status" }
  ];
  residenceColumns = [
    { label: "Street", fieldName: "Street" },
    { label: "City", fieldName: "City" },
    { label: "State", fieldName: "State" },
    { label: "Zip", fieldName: "Zip" },
    { label: "Country", fieldName: "Country" }
  ];

  connectedCallback() {
    const queryStringParameter = this.getUrlParamValue(
      window.location.href,
      "c__pno"
    );

    if (queryStringParameter) {
      this.phoneNumber = queryStringParameter;
    }
    this.performSearch();
  }

  getUrlParamValue(url, key) {
    return new URL(url).searchParams.get(key);
  }

  inputValueOnChange(event) {
    let value = null;
    let elementName = event.target.name;
    if (elementName) {
      value = event.target.value;
      if (elementName == "firstName") {
        this.firstName = value;
      } else if (elementName == "lastName") {
        this.lastName = value;
      } else if (elementName == "phoneNumber") {
        this.phoneNumber = value;
      } else if (elementName == "ssn") {
        this.ssn = value;
      } else if (elementName == "accountNumber") {
        this.accountNumber = value;
      }
    }
  }

  handleSearchButtonClick(event) {
    this.isLoadingSearchResult = true;
    this.listFinancialAccount = [];
    this.listResidence = [];
    this.hasListResidence = false;
    this.hasListFinancialAccount = false;
    this.performSearch();
  }

  performSearch() {
    this.getTabName();
    getAccounts({
      phoneNumber: this.phoneNumber,
      firstName: this.firstName,
      lastName: this.lastName,
      ssn: this.ssn,
      accountNumber: this.accountNumber
    })
      .then((data) => {
        this.listSearchResult = data;
        if (!this.listSearchResult || this.listSearchResult.length < 1) {
          this.searchHasNoResult = true;
        } else {
          this.searchHasNoResult = false;
        }
        this.isLoadingSearchResult = false;
        this.getMulesoftDataForAllResults();
      })
      .catch((error) => {
        this.isLoadingSearchResult = false;
      });
  }

  getTabName() {
    let tabName = "CTI Contact Center";
    let formattedPhone = "";
    if (this.phoneNumber) {
      var phoneNumberStripped = ("" + this.phoneNumber).replace(/\D/g, "");
      var matchedPattern = phoneNumberStripped.match(/^(\d{3})(\d{3})(\d{4})$/);

      if (matchedPattern) {
        formattedPhone =
          "(" +
          matchedPattern[1] +
          ") " +
          matchedPattern[2] +
          "-" +
          matchedPattern[3];
      }
    }

    if (formattedPhone || this.firstName || this.lastName) {
      tabName = "";
      if (formattedPhone != "") {
        tabName = formattedPhone;
      }
      if (this.firstName) {
        if (tabName != "") {
          tabName += " | ";
        }
        tabName += this.firstName;
      }
      if (this.lastName) {
        if (tabName != "") {
          tabName += " | ";
        }
        tabName += this.lastName;
      }
      console.log("tabName: " + tabName);
    }

    document.title = tabName;
  }

  handleSearchResultClick(event) {
    const clickedAccountId = event.currentTarget.dataset.item;
    let existingSelectedItem = this.template.querySelector(".search-selected");
    if (existingSelectedItem) {
      existingSelectedItem.classList.remove("search-selected");
    }
    let currentElement = this.template.querySelector(
      "[data-item='" + clickedAccountId + "' ]"
    );
    currentElement.classList.add("search-selected");
    this.isLoadingAdditionalSearchResult = true;
    this.hasListResidence = false;
    this.hasListFinancialAccount = false;
    getAdditionalDetails({
      accountId: clickedAccountId
    })
      .then((data) => {
        this.isLoadingAdditionalSearchResult = false;
        this.listFinancialAccount = data.ListFinancialAccount;
        this.listResidence = data.ListResidence;
        if (this.listFinancialAccount && this.listFinancialAccount.length > 0) {
          this.hasListFinancialAccount = true;
        } else {
          this.hasListFinancialAccount = false;
        }
        if (this.listResidence && this.listResidence.length > 0) {
          this.hasListResidence = true;
        } else {
          this.hasListResidence = false;
        }
      })
      .catch((error) => {
        this.isLoadingAdditionalSearchResult = false;
      });
  }

  getMulesoftDataForAllResults() {
    this.listSearchResult.forEach((searchResult) => {
      getMulesoftData({
        accountId: searchResult.AccountId,
        phoneNumber: this.phoneNumber
      })
        .then((data) => {
          searchResult.HasReturnedMulesoftResult = true;
          if (data) {
            searchResult.ListPassword = data.ListPasswordModel;
            searchResult.DriversLicense = data.DriversLicense;

            if (data.ListPasswordModel.length > 0) {
              searchResult.HasOneOrMorePasswordResult = true;
            }
          }
        })
        .catch((error) => {
          searchResult.HasReturnedMulesoftResult = true;
        });
    });
  }

  accountNameClicked(event) {
    this[NavigationMixin.GenerateUrl]({
      type: "standard__recordPage",
      attributes: {
        recordId: event.currentTarget.dataset.item,
        actionName: "view"
      }
    }).then((url) => {
      window.open(url);
    });
  }
}