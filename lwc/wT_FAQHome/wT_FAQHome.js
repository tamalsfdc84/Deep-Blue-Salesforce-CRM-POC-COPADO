import { LightningElement, api, wire } from 'lwc';
import getFaqCategories from "@salesforce/apex/WT_FAQHomeController.GetFaqCategories";
import FAQ_Assets from "@salesforce/resourceUrl/FAQAssets";

export default class WT_FAQHome extends LightningElement {
    listCategory = [];
    isLoading = true;
    isSandbox = false;

    connectedCallback() {
        this.getListCategory();
        document.title = 'Wintrust Help Center';
    }

    getListCategory(){
        getFaqCategories({categoryName: '', articleName: ''})
        .then((data) => {   
            if(data.IsSuccess){
                let localListCategory = [];       
                this.isSandbox = data.IsSandbox;  
                data.ListCategory.forEach((categoryItem) => {
                    let categoryItemCopy = categoryItem;
                    if (categoryItemCopy.CategoryIcon) {
                        categoryItemCopy.CategoryIconFullPath = FAQ_Assets + '/FAQAssets/' + categoryItemCopy.CategoryIcon;
                    }
                    localListCategory.push(categoryItemCopy);
                });
                this.listCategory = localListCategory;
            }
            this.isLoading = false;
        })
        .catch((error) => {
            this.isLoading = false;
        });
    }
}