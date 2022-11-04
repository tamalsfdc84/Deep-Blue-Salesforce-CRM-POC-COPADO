import { LightningElement, api } from 'lwc';
import getListArticleInArticleCategory from "@salesforce/apex/WT_FAQArticleCategoryController.GetListArticleInArticleCategory";

export default class WT_FAQCategoryArticleList extends LightningElement {
    @api categoryId;
    categoryName = '';
    title = '';
    subTitle = '';
    listArticle = [];
    isLoading = true;
    isSandbox = true;
    backUrl = '/s/';
    shouldShowSearchResult = false;
    listExistingArticleId = [];
    hasMoreResults = false;

    connectedCallback() {
        this.getListArticle();
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    getListArticle() {
        getListArticleInArticleCategory({ articleCategoryId: this.categoryId, listExistingArticleId: this.listExistingArticleId, isFirstRequest: true })
            .then((data) => {
                if (data.IsSuccess) {
                    this.title = data.Title;
                    this.subTitle = data.SubTitle;
                    this.listArticle = data.ListArticle;
                    this.isSandbox = data.IsSandbox;
                    this.listExistingArticleId = data.ListExistingArticleId;
                    this.hasMoreResults = data.HasMoreResults;
                    if (!this.isSandbox) {
                        this.backUrl = '/';
                    }
                }
                this.isLoading = false;
                if (this.title) {
                    document.title = this.title;
                }
            })
            .catch((error) => {
                this.isLoading = false;
            });
    }

    handleLoadMoreClick(){
        getListArticleInArticleCategory({ articleCategoryId: this.categoryId, listExistingArticleId: this.listExistingArticleId, isFirstRequest: false })
            .then((data) => {
                if (data.IsSuccess) {
                    let listTempArticle = this.listArticle;
                    listTempArticle.push.apply(listTempArticle, data.ListArticle);
                    this.listArticle = [];
                    this.listArticle = listTempArticle;
                    this.listExistingArticleId = data.ListExistingArticleId;
                    this.hasMoreResults = data.HasMoreResults;
                }
                this.isLoading = false;
            })
            .catch((error) => {
                this.isLoading = false;
            });
    }

    openDropdownNav(event) {
        console.log('nav open')
        let opendDropdownMenu = this.template.querySelector('.faq_dropdown__main');
        this.shouldShowDropdownMenu = true;
        if (this.shouldShowDropdownMenu) {
            opendDropdownMenu.classList.add('visible');
            opendDropdownMenu.classList.remove('hidden');
        }
    }
    closeDropdownNav(event) {
        console.log('nav close')
        let opendDropdownMenu = this.template.querySelector('.faq_dropdown__main');
        this.shouldShowDropdownMenu = false;
        if (this.shouldShowDropdownMenu == false) {
            opendDropdownMenu.classList.add('hidden');
            opendDropdownMenu.classList.remove('visible');
        }
    }
}