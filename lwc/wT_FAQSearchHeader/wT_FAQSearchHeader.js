import { LightningElement } from 'lwc';
import getSearchAutoSuggest from "@salesforce/apex/WT_FAQSearchController.GetSearchAutoSuggest";
import getTrendingTopics from "@salesforce/apex/WT_FAQSearchController.GetTrendingTopics";
 
export default class customSearch extends LightningElement {
    searchTerm = '';
    listAutoSuggestResult = [];
    isSandbox = false;
    hasRendered = false;
    isSearchInputFocused = false;
    listTrendingTopic = [];
    hasTrendingTopics = false;

    connectedCallback() {
        this.searchTerm = this.getUrlParamValue(window.location.href, 'searchTerm');
        this.generateTrendingTopics();
    }

    renderedCallback(){
        if(this.searchTerm && !this.hasRendered){            
            let searchInput = this.template.querySelector('.faq__search__searchBar--input');
            if(searchInput){
                this.hasRendered = true;
                searchInput.value = this.searchTerm;
            }
        }
    }

    generateTrendingTopics(){
        getTrendingTopics()
        .then((data) => {   
            if(data){
                this.listTrendingTopic = data;
                if(data.length > 0){
                    this.hasTrendingTopics = true;
                }
            }
        })
        .catch((error) => {
        });
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    handleSearchFocusIn(event){
        this.isSearchInputFocused = true;
    }

    handleSearchFocusOut(event){
        this.isSearchInputFocused = false;

        setTimeout(function () {
            let autoSuggestWrapper = this.template.querySelector('.faq__search__searchBar__inputBox--recommended');
            if(autoSuggestWrapper){
                autoSuggestWrapper.classList.remove('shadow');
            }
            this.listAutoSuggestResult = [];
        }.bind(this), 200);
    }

    handleSearchKeyPress(event){
        if(event.key === 'Enter' || event.keyCode === 13){
            setTimeout(function () {
                if(this.searchTerm != null && this.searchTerm != ''){
                    let redirectUrl = '/s/search-result' + '?searchTerm=' + this.searchTerm;
                    window.location.href = redirectUrl;
                }else{
                    this.addInputError();
                }
            }.bind(this), 50);
        }
    }

    searchClicked(event){
        if(this.searchTerm != null && this.searchTerm != ''){
            let redirectUrl = '/s/search-result' + '?searchTerm=' + this.searchTerm;
            window.location.href = redirectUrl;
        }else{            
            this.addInputError();
        }
    }

    removeInputError(){
        let inputElement = this.template.querySelector('.faq__search__searchBar--input');
        let autoSuggestElement = this.template.querySelector('.faq__search__searchBar__inputBox--recommended');

        if(inputElement && inputElement.classList){
            inputElement.classList.remove('input-error');
        }
        if(autoSuggestElement && autoSuggestElement.classList){
            autoSuggestElement.classList.remove('auto-suggest-error');
        }
    }

    addInputError(){
        let inputElement = this.template.querySelector('.faq__search__searchBar--input');
        let autoSuggestElement = this.template.querySelector('.faq__search__searchBar__inputBox--recommended');

        if(inputElement && inputElement.classList){
            inputElement.classList.add('input-error');
        }
        if(autoSuggestElement && autoSuggestElement.classList){
            autoSuggestElement.classList.add('auto-suggest-error');
        }
    }

    handleAutoSuggestClick(event){
        if(event.currentTarget.dataset.id != null && event.currentTarget.dataset.id != 'null'){
            let baseUrl = event.currentTarget.dataset.id;
            let articleName = this.searchTerm;
            this.listAutoSuggestResult.forEach(element => {
                if(element.RedirectUrl == baseUrl){
                    articleName = element.ArticleTitle;
                }
            });

            let redirectUrl = baseUrl + '?searchTerm=' + articleName;
            window.location.href = redirectUrl;
        }
    }

    handleSearchOnChange(event){
        this.searchTerm = event.target.value;
        if(this.searchTerm != null && this.searchTerm != ''){
            this.removeInputError();
        }
    }

    handleSearchKeyup(event){
        let currentSearchTerm = event.target.value;
        if(currentSearchTerm && currentSearchTerm.length > 0){
            this.removeInputError();
        }
        if(currentSearchTerm && currentSearchTerm.length >= 3){
            this.getSearchResult(currentSearchTerm, true);
        }else{
            let autoSuggestWrapper = this.template.querySelector('.faq__search__searchBar__inputBox--recommended');
            if(autoSuggestWrapper){
                autoSuggestWrapper.classList.remove('shadow');
            }
            this.listAutoSuggestResult = [];
        }
    }

    getSearchResult(currentSearchTerm, isAutoSuggestSearch){
        getSearchAutoSuggest({ searchTerm: currentSearchTerm, isAutoSuggestSearch: isAutoSuggestSearch })
        .then((data) => {   
            if(this.isSearchInputFocused){
                if(data.IsSuccess){
                    this.listAutoSuggestResult = data.ListAutoSuggest;
                    this.isSandbox = data.IsSandbox;
                    let autoSuggestWrapper = this.template.querySelector('.faq__search__searchBar__inputBox--recommended');
                    if(autoSuggestWrapper && this.listAutoSuggestResult && this.listAutoSuggestResult.length > 0){
                        setTimeout(function () {
                            autoSuggestWrapper.classList.add('shadow');
                        }.bind(this), 50);                        
                    }
                }
            }
        })
        .catch((error) => {
        });
    }
}