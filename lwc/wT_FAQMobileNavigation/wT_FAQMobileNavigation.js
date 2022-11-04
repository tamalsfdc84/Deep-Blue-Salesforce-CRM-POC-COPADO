import { LightningElement, api } from 'lwc';
import getFaqCategories from "@salesforce/apex/WT_FAQHomeController.GetFaqCategories";

export default class WT_FAQMobileNavigation extends LightningElement {
    @api categoryId;
    @api isArticlePage;
    listCategory = [];
    isSandbox = true;
    isNavOpen = false;
    activeCategoryName = '';
    articleName;
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
                this.activeCategoryName = data.ActiveCategoryName;
            }
        })
        .catch((error) => {
        });
    }

    toggleDropdownNav(event){
        let opendDropdownMenu = this.template.querySelector('.faq_dropdown__main');

        if(!this.isNavOpen){
            opendDropdownMenu.classList.add('visible');
            opendDropdownMenu.classList.remove('hidden');
            this.isNavOpen = true;
        }else{
            opendDropdownMenu.classList.add('hidden');
            opendDropdownMenu.classList.remove('visible');
            this.isNavOpen = false;
        }
    }
}