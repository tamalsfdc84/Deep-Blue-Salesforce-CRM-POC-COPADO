import { LightningElement } from 'lwc';
import getArticle from "@salesforce/apex/WT_FAQArticleController.GetArticle";
import rateArticle from "@salesforce/apex/WT_FAQArticleController.RateArticle";
import FAQ_Assets from "@salesforce/resourceUrl/FAQAssets";

export default class WT_FAQArticle extends LightningElement {
    categoryName;
    articleName;
    articleQuestion;
    articleAnswer;
    isSandbox = true;
    backUrl = '/s/';
    isLoading = true;
    shouldShowSearchResult = false;
    shouldShowDropdownMenu = false;
    yesIcon;
    noIcon;
    hasDisclaimer = true;
    searchTerm;
    categoryName = 'Help Center';
    hasCategoryNameInQueryString = false;

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
        this.yesIcon = FAQ_Assets + '/FAQAssets/yes.svg';
        this.noIcon = FAQ_Assets + '/FAQAssets/no.svg';
        this.searchTerm = this.getUrlParamValue(window.location.href, 'searchTerm');
        let queryStringCategoryName = this.getUrlParamValue(window.location.href, 'categoryName');
        if(queryStringCategoryName != null && queryStringCategoryName != ''){
            this.categoryName = queryStringCategoryName;
            if(this.categoryName.includes('~')){
                this.categoryName = this.categoryName.replace('~', '&');
            }
            this.backUrl = document.referrer;
            this.hasCategoryNameInQueryString = true;
        }
        this.getCurrentArticle();
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    getCurrentArticle() {
        getArticle({ articleName: this.articleName, searchTerm: this.searchTerm })
            .then((data) => {
                if (data.IsSuccess) {
                    this.articleQuestion = data.ArticleQuestion;
                    this.articleAnswer = data.ArticleAnswer;
                    this.isSandbox = data.IsSandbox;
                    this.hasDisclaimer = data.HasDisclaimer;
                    this.articleDisclaimer = data.ArticleDisclaimer;
                    if (!this.hasCategoryNameInQueryString && !this.isSandbox) {
                        this.backUrl = '/';
                    }
                }
                if (this.articleQuestion) {
                    document.title = this.articleQuestion;
                }
                this.isLoading = false;
            })
            .catch((error) => {
                this.isLoading = false;
            });
    }

    handleBackClick() {
        window.history.back();
    }
    openDropdownNav(event) {
        let opendDropdownMenu = this.template.querySelector('.faq_dropdown__main');
        this.shouldShowDropdownMenu = true;
        if (this.shouldShowDropdownMenu) {
            opendDropdownMenu.classList.add('visible');
            opendDropdownMenu.classList.remove('hidden');
        }
    }
    closeDropdownNav(event) {
        let opendDropdownMenu = this.template.querySelector('.faq_dropdown__main');
        this.shouldShowDropdownMenu = false;
        if (this.shouldShowDropdownMenu == false) {
            opendDropdownMenu.classList.add('hidden');
            opendDropdownMenu.classList.remove('visible');
        }
    }
    rateArticleUp() {
        let helpfulRateBar = this.template.querySelector('.helpfulRate');
        let thankyouBar = this.template.querySelector('.helpfulThankyou');
        helpfulRateBar.classList.remove('visible');
        helpfulRateBar.classList.add('hidden');
        thankyouBar.classList.remove('hidden');
        thankyouBar.classList.add('visible');
        this.updateArticleRating(true);

    }
    rateArticleDown() {
        let helpfulRateBar = this.template.querySelector('.helpfulRate');
        let thankyouBar = this.template.querySelector('.helpfulThankyou');
        helpfulRateBar.classList.remove('visible');
        helpfulRateBar.classList.add('hidden');
        thankyouBar.classList.remove('hidden');
        thankyouBar.classList.add('visible');
        this.updateArticleRating(false);
    }

    updateArticleRating(isLiked){
        rateArticle({ articleName: this.articleName, isLike: isLiked })
            .then((data) => {
            })
            .catch((error) => {
                
            });
    }
}