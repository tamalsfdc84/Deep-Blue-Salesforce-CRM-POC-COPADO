import { LightningElement, api, track } from "lwc";
import { NavigationMixin } from "lightning/navigation";
import getAccounts from "@salesforce/apex/WT_ContactCenterSearchController.GetAccounts";
import getMulesoftData from "@salesforce/apex/WT_ContactCenterSearchController.GetMulesoftData";
import getAdditionalDetails from "@salesforce/apex/WT_ContactCenterSearchController.GetAdditionalDetails";
import setApprovalOnCustomer from "@salesforce/apex/WT_ContactCenterSearchController.SetApprovalOnCustomer";
import sendVerificationCode from "@salesforce/apex/WT_ContactCenterSearchController.SendVerificationCode";
import verifyCode from "@salesforce/apex/WT_ContactCenterSearchController.VerifyCode";
import getPenleyQuestion from "@salesforce/apex/WT_ContactCenterSearchController.GetPenleyQuestion";
import getPenleyDecision from "@salesforce/apex/WT_ContactCenterSearchController.GetPenleyDecision";
import getD3ChangeFlag from "@salesforce/apex/WT_ContactCenterSearchController.GetD3ChangeFlag";
import smsScriptLine1 from '@salesforce/label/c.WT_Contact_Center_SMS_Script_Line_1';
import smsScriptLine2 from '@salesforce/label/c.WT_Contact_Center_SMS_Script_Line_2';
import smsScriptLine3 from '@salesforce/label/c.WT_Contact_Center_SMS_Script_Line_3';
import smsScriptLine4 from '@salesforce/label/c.WT_Contact_Center_SMS_Script_Line_4';
import emailScriptLine1 from '@salesforce/label/c.WT_Contact_Center_Email_Script_Line_1';
import emailScriptLine2 from '@salesforce/label/c.WT_Contact_Center_Email_Script_Line_2';
import emailScriptLine3 from '@salesforce/label/c.WT_Contact_Center_Email_Script_Line_3';
import emailScriptLine4 from '@salesforce/label/c.WT_Contact_Center_Email_Script_Line_4';
import penleyScriptLine1 from '@salesforce/label/c.WT_Contact_Center_Penley_Script_Line_1';

export default class WT_ContactCenterSearch extends NavigationMixin(LightningElement) {
  label = {
    smsScriptLine1,
    smsScriptLine2,
    smsScriptLine3,
    smsScriptLine4,
    emailScriptLine1,
    emailScriptLine2,
    emailScriptLine3,
    emailScriptLine4,
    penleyScriptLine1
  }
  @track phoneNumber = "";
  @track firstName = "";
  @track lastName = "";
  @track ssn = "";
  @track accountNumber = "";
  @track listSearchResult = [];
  @track isLoadingSearchResult = true;
  @track isLoadingAdditionalSearchResult = false;
  @track hasResidence = false;
  @track hasListFinancialAccount = false;
  @track listFinancialAccount = [];
  @track searchHasNoResult = false;
  modalTitle = '';
  currentResidence;
  listRecentTransaction = [];
  hasListRecentTransaction = false;
  hasSelectedAccount = false;
  showShowModal = false;
  shouldShowLegalText = true;
  modalButtonText = 'Next';
  customerFirstName = '';
  hasCustomerApproval = false;
  selectedAccountId = '';
  listPhoneNumber = null;
  selectedPhone = null;
  hasSelectedPhone = false;
  isGoingThroughSmsVerification = false;
  isGoingThroughEmailVerification = false;
  listEmail = null;
  selectedEmail = null;
  hasSelectedEmail;
  shouldShowVerificationCode = false;
  verificationCode = '';
  shouldDisableSendCodeButton = false;
  hasClickedSendVerificationCode = false;
  customerReadVerificationCode = null;
  isCustomerVerified = false;
  shouldShowCustomerVerificationStatus = false;
  isVerifyingCode = false;
  isSendingCode = false;
  listVerificationQuestion = [];
  showShowIdentityVerificationModal = false;
  identityVerificationModalTitle = '';
  totalQuestionCount = 0;
  currentQuestionIndex;
  currentQuestionObject;
  hasMoreQuestionsToAsk;
  shouldShowPreviousButtonOnIdentityVerification = false;
  shouldShowCustomerIdentityVerificationStatus = false;
  isCustomerIdentityVerified = false;
  isVerifyingCustomerIdentity = false;
  isAccountLockedOut = false;
  isVerifyAccountLockedOut = false;
  shouldShowIdentityVerificationLegalText = true;
  shouldEnableNextQuestionButton = false;
  shouldEnableShowVerifyIdentityButton = false;
  currentIdaQuizId = '';
  currentIdaTransactionId = '';
  identityVerificationMessage = '';
  isIdentityVerifyAccountLockedOut = false;
  identityQuestionErrorMessage = '';
  isIdentityQuestionErroredOut = false;
  isLoadingIdaQuestions = false;
  hasAnsweredLegalText = false;
  shouldShowD3Changes = false;
  financialAccountColumns = [
    { label: "Charter", fieldName: "Charter" },
    { label: "Branch", fieldName: "Branch" },
    { label: "Account Number", fieldName: "AccountNumber" },
    { label: "Account Type", fieldName: "AccountType" },
    { label: "Relationship Type", fieldName: "RelationshipType" },
    { label: "Status", fieldName: "Status" },
    { label: "FIS Automatic Status" , fieldName: "FISAutomaticStatus"}, 
    { label: "FIS Manual Status" , fieldName: "FISManualStatus"} 
  ];
  recentTransactionColumns = [
    { label: "Date", fieldName: "DateTransaction" },
    { label: "Account Number", fieldName: "AccountNumber" },
    { label: "Account Type", fieldName: "AccountType" },
    { label: "Status", fieldName: "Status" },    
    { label: "Type", fieldName: "TransactionType" },
    { label: "Amount", fieldName: "Amount" }
  ];
  smsYesNoOptions = [
    { label: 'Yes', value: 'yes' },
    { label: 'No', value: 'no' },
  ];
  smsYesNoValue = '';

  connectedCallback() {
    const queryStringParameter = this.getUrlParamValue(
      window.location.href,
      "c__pno"
    );

    if (queryStringParameter) {
      this.phoneNumber = queryStringParameter;
    }
    this.getD3ChangeConfig();
    this.performSearch();
  }

  getD3ChangeConfig(){
    getD3ChangeFlag()
    .then((data) => {
      if(data){
        this.shouldShowD3Changes = data.ShouldShowD3Changes;
      }
    })
    .catch((error) => {
      
    });
  }

  closeModalClicked(event){
    this.showShowModal = false;
    this.shouldShowLegalText = true;
    this.hasCustomerApproval = false;
    this.selectedPhone = null;
    this.hasSelectedPhone = false;
    this.isGoingThroughSmsVerification = false;
    this.isGoingThroughEmailVerification = false;
    this.isGoingThroughPenleyVerification = false;
    this.selectedEmail = null;
    this.hasSelectedEmail = false;
    this.shouldShowVerificationCode = false;
    this.verificationCode = '';
    this.hasClickedSendVerificationCode = false;
    this.customerReadVerificationCode = null;
    this.shouldShowCustomerVerificationStatus = false;
    this.shouldDisableSendCodeButton = false;
    this.isVerifyingCode = false;
    this.isSendingCode = false;
    this.showShowIdentityVerificationModal = false;
    this.totalQuestionCount = 0;
    this.currentQuestionIndex = null;
    this.currentQuestionObject = null;
    this.hasMoreQuestionsToAsk = false;
    this.shouldShowPreviousButtonOnIdentityVerification = false;
    this.shouldShowCustomerIdentityVerificationStatus = false;
    this.isCustomerIdentityVerified = false;
    this.isVerifyingCustomerIdentity = false;
    this.shouldShowVerifyIdentityButton = false;
    this.isAccountLockedOut = false;
    this.verificationLockedMessage = '';
    this.isVerifyAccountLockedOut = false;
    this.shouldShowIdentityVerificationLegalText = true;    
    this.isLoadingIdaQuestions = false;
    this.shouldEnableNextQuestionButton = false;
    this.shouldEnableShowVerifyIdentityButton = false;
    this.currentIdaQuizId = '';
    this.currentIdaTransactionId = '';
    this.identityVerificationMessage = '';
    this.isIdentityVerifyAccountLockedOut = false;
    this.identityQuestionErrorMessage = '';
    this.isIdentityQuestionErroredOut = false;
    this.hasAnsweredLegalText = false;
  }

  get phoneNumberOptions() {
    return this.listPhoneNumber;
  }

  get emailOptions() {
    return this.listEmail;
  }

  handleIdentityVerificationAnswerChange(event){
    const selectedOption = event.detail.value;
    if(this.currentQuestionObject){
      this.currentQuestionObject.AnswerId = selectedOption;
    }
    this.shouldEnableNextQuestionButton = true;
    if(!this.hasMoreQuestionsToAsk){
      this.shouldEnableShowVerifyIdentityButton = true;
    }
  }

  moveToNextScreenForNextQuestionClicked(event){
    if(this.shouldShowIdentityVerificationLegalText == true){
      this.shouldShowIdentityVerificationLegalText = false;
      this.shouldEnableNextQuestionButton = false;
    }else{      
      if(this.currentQuestionIndex >= 0){
        let currentTempIndex = this.currentQuestionIndex + 1;
        if(this.currentQuestionObject && this.currentQuestionObject.AnswerId){
          this.listVerificationQuestion[this.currentQuestionIndex].AnswerId = this.currentQuestionObject.AnswerId;
        }
        if(this.listVerificationQuestion.length >= currentTempIndex + 1){          
          this.hasMoreQuestionsToAsk = true;
          this.currentQuestionObject = this.listVerificationQuestion[currentTempIndex];
          if(!this.currentQuestionObject.AnswerId){
            this.shouldEnableNextQuestionButton = false;
          }
          this.currentQuestionIndex = this.currentQuestionIndex + 1;
          this.shouldShowPreviousButtonOnIdentityVerification = true;

          //On the last question
          //Display Verify Identity Button
          if(this.listVerificationQuestion.length == currentTempIndex + 1){
            this.shouldShowVerifyIdentityButton = true;
            this.hasMoreQuestionsToAsk = false;
          }
        }
      }
    }
  }

  handleVerifyCustomerIdentityClick(event){
    this.isVerifyingCustomerIdentity = true;
    getPenleyDecision({ accountId: this.selectedAccountId, quizId: this.currentIdaQuizId, transactionId: this.currentIdaTransactionId, listQuestionString: JSON.stringify(this.listVerificationQuestion) })
    .then((data) => {
      if(data){
        this.shouldShowCustomerIdentityVerificationStatus = true;
        if(data.IsSuccess){
          if(data.IsVerified){
            this.isCustomerIdentityVerified = true;
          }else{
            this.isCustomerIdentityVerified = false;
          }
        }else{
          this.isCustomerIdentityVerified = false;
        }
        if(data.IsAccountLockedOut){
          this.isIdentityVerifyAccountLockedOut = true;
        }else{
          this.isIdentityVerifyAccountLockedOut = false;
        }
        this.identityVerificationMessage = data.Message;
        this.isVerifyingCustomerIdentity = false;
      }
    })
    .catch((error) => {
      this.isVerifyingCustomerIdentity = false;
    });
  }

  moveToPreviousScreenForPreviousQuestionClicked(event){
    if(this.currentQuestionIndex > 0){
      let currentTempIndex = this.currentQuestionIndex - 1;
      this.hasMoreQuestionsToAsk = true;
      this.currentQuestionObject = this.listVerificationQuestion[currentTempIndex];
      this.currentQuestionIndex = this.currentQuestionIndex - 1;
      this.shouldEnableNextQuestionButton = true;
    }
    if(this.currentQuestionIndex == 0){
      this.shouldShowPreviousButtonOnIdentityVerification = false;
    }
  }

  handlePenleyClick(event){
    this.isLoadingIdaQuestions = true;
    this.isGoingThroughPenleyVerification = true;
    this.identityVerificationModalTitle = 'Identity Verification';
    this.modalButtonText = 'Next';
    this.showShowIdentityVerificationModal = true;
    this.shouldShowIdentityVerificationLegalText = true;

    getPenleyQuestion({ accountId: this.selectedAccountId })
    .then((data) => {
      this.isLoadingIdaQuestions = false;
      if(data.IsSuccess){
        this.listVerificationQuestion = data.ListQuestion;
        this.totalQuestionCount = data.QuestionCount;      
        this.currentIdaQuizId = data.QuizId;
        this.currentIdaTransactionId = data.TransactionId;
        this.currentQuestionIndex = 0;
        if(this.listVerificationQuestion.length > 0){
          this.hasMoreQuestionsToAsk = true;
          this.currentQuestionObject = this.listVerificationQuestion[0];
        }
        this.shouldEnableNextQuestionButton = true;
      }else{
        this.identityQuestionErrorMessage = data.Message;
        this.isIdentityQuestionErroredOut = true;
      }
    })
    .catch((error) => {
      this.isLoadingIdaQuestions = false;
    });
  }

  handleVerificationCodeChange(event){
    this.customerReadVerificationCode = event.detail.value;
  }

  handleVerifyCodeClick(event){    
    this.isVerifyingCode = true;
    let currentVerificationMethod = '';
    let emailOrPhone = '';
    if(this.hasSelectedEmail){
      currentVerificationMethod = 'email';
      emailOrPhone = this.selectedEmail;
    } else if(this.hasSelectedPhone){
      currentVerificationMethod = 'sms';
      emailOrPhone = this.selectedPhone;
    }

    verifyCode({
      accountId: this.selectedAccountId,
      verificationMethod: currentVerificationMethod,
      verificationEmailOrPhone: emailOrPhone,
      code: this.customerReadVerificationCode
    })
    .then((data) => {
      this.shouldShowCustomerVerificationStatus = true;
      this.isVerifyingCode = false;
      if(data.IsSuccess){
        this.isCustomerVerified = true;
      }else{
        this.isVerifyAccountLockedOut = data.IsAccountLockedOut;
        this.verificationLockedMessage = data.Message;
        this.isCustomerVerified = false;
      }
    })
    .catch((error) => {
      this.shouldShowCustomerVerificationStatus = true;
      this.isCustomerVerified = false;
      this.isVerifyingCode = false;
    });
  }

  handleEmailChange(event){
    this.selectedEmail = event.detail.value;
    this.hasSelectedEmail = true;
  }

  handlePhoneNumberChange(event){
    this.selectedPhone = event.detail.value;
    this.hasSelectedPhone = true;
  }

  moveToNextScreenFromLegalClicked(event){
    this.shouldShowLegalText = false;
  }

  handleApprovalCheckBoxChange(event){
    this.hasAnsweredLegalText = true;
    let changedValue = event.detail.value;
    if(changedValue == 'yes'){
      this.hasCustomerApproval = true;
    }else{
      this.hasCustomerApproval = false;
    }
    
    if(this.hasCustomerApproval){
      setApprovalOnCustomer({
        accountId: this.selectedAccountId
      })
        .then((data) => {
          if(!data.IsSuccess){
            //TODO: How do we handle error in saving to Account?
            //Do we still let the verification go through?
          }
        })
        .catch((error) => {
        });
    }
  }

  handleSendVerificationCodeClick(event){    
    this.isSendingCode = true;
    this.shouldDisableSendCodeButton = true;
    let currentVerificationMethod = '';
    let emailOrPhone = '';
    if(this.hasSelectedEmail){
      currentVerificationMethod = 'email';
      emailOrPhone = this.selectedEmail;
    } else if(this.hasSelectedPhone){
      currentVerificationMethod = 'sms';
      emailOrPhone = this.selectedPhone;
    }
    sendVerificationCode({
      accountId: this.selectedAccountId,
      verificationMethod: currentVerificationMethod,
      verificationEmailOrPhone: emailOrPhone
    })
    .then((data) => {
      this.isSendingCode = false;
      if(data.IsSuccess){
        this.hasClickedSendVerificationCode = true;
        this.shouldShowVerificationCode = true;
        this.verificationCode = data.Code;
      }else{
        this.isAccountLockedOut = data.IsAccountLockedOut;
        this.verificationLockedMessage = data.Message;
        this.hasClickedSendVerificationCode = false;
      }
    })
    .catch((error) => {
      //TODO: Show toast
      this.hasClickedSendVerificationCode = false;
      this.isSendingCode = false;
    });
  }

  handleEmailVerificationClick(event){
    this.isGoingThroughEmailVerification = true;
    this.shouldShowLegalText = true;
    this.modalTitle = 'Email Verification';
    this.modalButtonText = 'Next';
    this.showShowModal = true;
  }

  handleSmsVerificationClick(event){    
    this.isGoingThroughSmsVerification = true;
    this.shouldShowLegalText = true;
    this.modalTitle = 'SMS Verification';
    this.modalButtonText = 'Next';
    this.showShowModal = true;
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
    this.isCustomerVerified = false;
    this.selectedAccountId = '';
    this.hasSelectedAccount = false;
    this.isLoadingSearchResult = true;
    this.listFinancialAccount = [];
    this.listRecentTransaction = [];
    this.currentResidence = null;
    this.hasResidence = false;
    this.hasListFinancialAccount = false;
    this.hasListRecentTransaction = false;
    this.performSearch();
  }

  performSearch() {
    this.isCustomerVerified = false;
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
    }

    document.title = tabName;
  }

  handleSearchResultClick(event) {
    this.hasSelectedAccount = true;
    this.listEmail = [];
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
    this.hasResidence = false;
    this.hasListFinancialAccount = false;
    this.hasListRecentTransaction = false;
    getAdditionalDetails({
      accountId: clickedAccountId
    })
      .then((data) => {
        if(data.CustomerEmailValue != null && data.CustomerEmailValue != ''){
          this.listEmail = [{label: data.CustomerEmailLabel, value: data.CustomerEmailValue}];
        }
        this.listPhoneNumber = data.ListPhoneNumber;
        this.selectedAccountId = data.AccountId;
        this.customerFirstName = data.CustomerFirstName;
        this.isLoadingAdditionalSearchResult = false;
        this.listFinancialAccount = data.ListFinancialAccount;
        this.currentResidence = data.CurrentResidence;
        this.listRecentTransaction = data.ListRecentTransaction;
        if (this.listFinancialAccount && this.listFinancialAccount.length > 0) {
          this.hasListFinancialAccount = true;
        } else {
          this.hasListFinancialAccount = false;
        }
        if (this.listRecentTransaction && this.listRecentTransaction.length > 0) {
          this.hasListRecentTransaction = true;
        } else {
          this.hasListRecentTransaction = false;
        }
        if (this.CurrentResidence && this.CurrentResidence.RecordKey != null) {
          this.hasResidence = true;
        } else {
          this.hasResidence = false;
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