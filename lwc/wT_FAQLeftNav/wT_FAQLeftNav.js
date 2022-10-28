import { LightningElement, api } from 'lwc';
import getFaqCategories from "@salesforce/apex/WT_FAQHomeController.GetFaqCategories";

export default class WT_FAQLeftNav extends LightningElement {
    @api categoryId;
    listCategory = [];
    isSandbox = true;
    connectedCallback() {
        let articleName = window.location.href.substring(window.location.href.lastIndexOf('/') + 1);
        if(articleName.includes('?')){
            let articleNameSplit = articleName.split('?');
            if(articleNameSplit && articleNameSplit.length > 1){
                this.articleName = articleNameSplit[0];
            }
        }
        else{
            this.articleName = articleName;
        }
        this.getListCategory();
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    getListCategory(){
        getFaqCategories({categoryId: this.categoryId, articleName: this.articleName})
        .then((data) => {   
            if(data.IsSuccess){
                this.listCategory = data.ListCategory;
                this.isSandbox = data.IsSandbox;
            }
        })
        .catch((error) => {
        });
    }
}