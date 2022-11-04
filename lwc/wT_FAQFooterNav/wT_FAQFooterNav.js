import { LightningElement } from 'lwc';
import FAQ_Assets from "@salesforce/resourceUrl/FAQAssets";

export default class WT_FAQ_FooterNav extends LightningElement {
    navIsOpen = false;
    showMobileAbout = false;
    showMobileGetInTouch = false;
    showMobileEvents = false;
    showMobileResources = false;
    facebookIcon;
    linkedinIcon;
    twitterIcon;

    connectedCallback(){
        this.facebookIcon = FAQ_Assets + '/FAQAssets/facebook.svg';
        this.linkedinIcon = FAQ_Assets + '/FAQAssets/linkedin.svg';
        this.twitterIcon = FAQ_Assets + '/FAQAssets/twitter.svg';
    }

    openAboutNav(event) {
        let faq_about = this.template.querySelector('.faq_about');
        console.log(faq_about, 'check me', event, this.showMobileAbout);
        if (this.showMobileAbout) {
            this.showMobileAbout = false;
            faq_about.children[0].classList.remove('opened');
            faq_about.children[0].classList.add('closed');

        } else {
            this.showMobileAbout = true;
            faq_about.children[0].classList.remove('closed');
            faq_about.children[0].classList.add('opened');
        }

    }
    openTouchNav(event) {
        let faq_touch = this.template.querySelector('.faq_touch');
        console.log(faq_touch, 'check me', event, this.showMobileAbout);
        if (this.showMobileGetInTouch) {
            this.showMobileGetInTouch = false;
            faq_touch.children[0].classList.remove('opened');
            faq_touch.children[0].classList.add('closed');

        } else {
            this.showMobileGetInTouch = true;
            faq_touch.children[0].classList.remove('closed');
            faq_touch.children[0].classList.add('opened');
        }

    }
    openResourcesNav(event) {
        let faq_resources = this.template.querySelector('.faq_resources');
        console.log(faq_resources, 'check me', event, this.showMobileAbout);
        if (this.showMobileResources) {
            this.showMobileResources = false;
            faq_resources.children[0].classList.remove('opened');
            faq_resources.children[0].classList.add('closed');

        } else {
            this.showMobileResources = true;
            faq_resources.children[0].classList.remove('closed');
            faq_resources.children[0].classList.add('opened');
        }

    }
    openEventsNav(event) {
        let faq_events = this.template.querySelector('.faq_events');
        console.log(faq_events, 'check me', event, this.showMobileAbout);
        if (this.showMobileEvents) {
            this.showMobileEvents = false;
            faq_events.children[0].classList.remove('opened');
            faq_events.children[0].classList.add('closed');

        } else {
            this.showMobileEvents = true;
            faq_events.children[0].classList.remove('closed');
            faq_events.children[0].classList.add('opened');
        }

    }
}