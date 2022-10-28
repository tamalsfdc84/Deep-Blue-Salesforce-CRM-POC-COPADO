import { LightningElement } from 'lwc';
import FORM_FACTOR from '@salesforce/client/formFactor';
// import logo image 
import FAQ_Assets from "@salesforce/resourceUrl/FAQAssets";
export default class WT_FAQHeader extends LightningElement {
    selectedItemValue;
    openMenu;
    equalHousingIcon;
    fdicIcon;
    wintrustLogo;
    connectedCallback() {
        this.equalHousingIcon = FAQ_Assets + '/FAQAssets/equal-housing-lender.png';
        this.fdicIcon = FAQ_Assets + '/FAQAssets/fdic.png';
        this.wintrustLogo = FAQ_Assets + '/FAQAssets/wintrust-logo-big.png'
    }
    openDropdownNav(event) {
        let opendDropdownMenu = this.template.querySelector('.faq__dropdownNav__main');
        this.shouldShowDropdownMenu = true;
        if (this.shouldShowDropdownMenu) {
            opendDropdownMenu.classList.add('visible');
            opendDropdownMenu.classList.remove('hidden');
        }
    }
    closeDropdownNav(event) {
        let opendDropdownMenu = this.template.querySelector('.faq__dropdownNav__main');
        this.shouldShowDropdownMenu = false;
        if (this.shouldShowDropdownMenu == false) {
            opendDropdownMenu.classList.add('hidden');
            opendDropdownMenu.classList.remove('visible');
        }
    }

    handleLogoClick(event){
        window.location.href = '/s/';
    }
}