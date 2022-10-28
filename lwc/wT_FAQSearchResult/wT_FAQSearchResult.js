import { LightningElement } from 'lwc';
import getSearchAutoSuggest from "@salesforce/apex/WT_FAQSearchController.GetSearchAutoSuggest";

export default class SearchResultComp extends LightningElement {
    listSearchResult = [];
    visibleListSearchResult = [];
    totalPages;
    currentPage = 1;
    totalRecords;
    searchTerm = '';
    isLoading = true;

    connectedCallback(){
        this.searchTerm = this.getUrlParamValue(window.location.href, 'searchTerm');
        this.getSearchResults();
    }

    getUrlParamValue(url, key) {
        return new URL(url).searchParams.get(key);
    }

    getSearchResults(event){
        getSearchAutoSuggest({ searchTerm: this.searchTerm, isAutoSuggestSearch: false })
        .then((data) => {   
            if(data.IsSuccess){
                this.listSearchResult = data.ListAutoSuggest;
                this.isSandbox = data.IsSandbox;
            }
            this.isLoading = false;
        })
        .catch((error) => {
            this.isLoading = false;
        });
    }

    updateSearchHandler(event) {
        this.visibleListSearchResult = [...event.detail.records];
        this.totalPages = event.detail.total;
        this.currentPage = event.detail.current;
        this.totalRecords = event.detail.totalRecords;
    }
}