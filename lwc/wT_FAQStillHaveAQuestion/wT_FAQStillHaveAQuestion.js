import { LightningElement } from 'lwc';
import FAQ_Assets from "@salesforce/resourceUrl/FAQAssets";
import getCustomerSupportInformation from "@salesforce/apex/WT_FAQCustomerSupportController.GetCustomerSupportInformation";

export default class WT_FAQ_StillHaveAQuestion extends LightningElement {
    askAQuestionIcon;
    customerSupportIcon;
    findUsIcon;
    listBankInformation = [];

    connectedCallback() {
        this.askAQuestionIcon = FAQ_Assets + '/FAQAssets/ask-a-question-email.svg';
        this.customerSupportIcon = FAQ_Assets + '/FAQAssets/customer-support-phone.svg';
        this.findUsIcon = FAQ_Assets + '/FAQAssets/find-us.svg';

        this.getInformation();
    }

    getInformation(){
        getCustomerSupportInformation({categoryName: this.categoryName})
        .then((data) => {   
            this.listBankInformation = data;
        })
        .catch((error) => {
        });
    }

    openLetsTalk(event) {
        let faq_letsTalkModal = this.template.querySelector('.faq__letsTalk');
        let faq_blackout = this.template.querySelector('.faq__blackout');
        faq_letsTalkModal.classList.remove('hidden');
        faq_blackout.classList.remove('hide');
        faq_letsTalkModal.classList.add('visible');
        faq_blackout.classList.add('show');
        document.body.style.overflow = 'hidden';
    }
    closeLetsTalk(event) {
        let faq_letsTalkModal = this.template.querySelector('.faq__letsTalk');
        let faq_blackout = this.template.querySelector('.faq__blackout');
        faq_letsTalkModal.classList.remove('visible');
        faq_blackout.classList.remove('show');
        faq_letsTalkModal.classList.add('hidden');
        faq_blackout.classList.add('hide');
        document.body.style.overflow = 'auto';
    }
}