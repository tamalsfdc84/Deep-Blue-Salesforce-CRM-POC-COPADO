import { LightningElement, api } from 'lwc';

export default class WTFAQSearchPagination extends LightningElement {
    currentPage = 1;
    totalRecords;
    recordSize = 5;
    pageList = [];
    totalPage = 0;
    previousButton = '<';
    get records() {
        return this.visibleRecords;
    }
    @api
    set records(data) {
        if (data) {
            this.totalRecords = JSON.parse(JSON.stringify(data));
            this.recordSize = Number(this.recordSize);
            //total number of pages displayed basing on records
            this.totalPage = Math.ceil(data.length / this.recordSize);
            for (let i = 1; i <= this.totalPage; i++)
            //handle pages basing on records
            {
                let recordCount = {};
                recordCount.no = i;
                if (i < 10) {
                    recordCount.less = true;
                } else {
                    recordCount.less = false;
                }
                this.pageList.push(recordCount);
            }
            this.updateRecords();
        }
    };

    get disablePreviousButton() {
        return this.currentPage <= 1;
    };
    get disableNextButton() {
        return this.currentPage >= this.totalPage;
    };
    previousClickButtonHandler() {
        if (this.currentPage > 1) {
            this.currentPage = this.currentPage - 1;
            this.updateRecords();
            this.handleButtonDisable();
        }
    };
    nextClickButtonHandler() {
        if (this.currentPage < this.totalPage) {
            this.currentPage = parseInt(this.currentPage) + 1;
            this.updateRecords();
            this.handleButtonDisable();
        }
    };
    updateRecords() {
        this.updateButtonVariant();
        const start = (this.currentPage - 1) * this.recordSize;
        const end = this.recordSize * this.currentPage;
        this.visibleRecords = this.totalRecords.slice(start, end);
        this.dispatchEvent(new CustomEvent('update', {
            detail: {
                records: this.visibleRecords,
                total: this.totalPage,
                current: this.currentPage,
                totalRecords: this.totalRecords.length
            }
        }))
    };
    handlePageClick(event) {
        this.currentPage = event.target.dataset.id;
        this.updateRecords();
    }

    updateButtonVariant() {
        for (let i = 0; i < this.pageList.length; i++) {
            if (this.pageList[i].no == this.currentPage) {
                this.pageList[i].variant = 'activePage';

            } else {
                this.pageList[i].variant = 'page';
            }
        }
    }

    handleButtonDisable() {
        let faqPaginationPrevious = this.template.querySelector('.pagination--previous');
        let faqPaginationNext = this.template.querySelector('.pagination--next');
        if (this.currentPage <= 1) {
            faqPaginationPrevious.classList.add('deactivated');
        } else if (this.currentPage > 1 && this.currentPage < this.totalPage) {
            // remove deactivated from previous and next button if there
            faqPaginationPrevious.classList.remove('deactivated');
            faqPaginationNext.classList.remove('deactivated');
        } else if (this.currentPage >= this.totalPage) {
            faqPaginationNext.classList.add('deactivated');
        }
    }
}