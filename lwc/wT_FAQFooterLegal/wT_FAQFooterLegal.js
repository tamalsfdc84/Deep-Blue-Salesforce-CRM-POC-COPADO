import { LightningElement } from 'lwc';
import FAQ_Assets from "@salesforce/resourceUrl/FAQAssets";

export default class WT_FAQ_FooterLegal extends LightningElement {
    equalHousingIcon;
    fdicIcon;

    connectedCallback(){
        this.equalHousingIcon = FAQ_Assets + '/FAQAssets/equal-housing-lender.png';
        this.fdicIcon = FAQ_Assets + '/FAQAssets/fdic.png';
    }
}