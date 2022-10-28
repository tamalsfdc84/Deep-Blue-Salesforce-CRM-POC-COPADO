import { LightningElement } from 'lwc';

export default class WT_SharePointURL extends LightningElement {
    renderedCallback() {
    this.handleClick();    
    }
    handleClick(){
        window.open("https://wintrust.sharepoint.com/resources/wuniv/Customer_Contact_Center/SitePages/Home.aspx");
    }
}