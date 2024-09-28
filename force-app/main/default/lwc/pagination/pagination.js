import { LightningElement, api, track } from 'lwc';

export default class Pagination extends LightningElement {
    @track currentPage = 1;
    @track totalRecords;
    @api recordSize = 5;
    @track totalPage = 0;
    @track visibleRecords = [];
    
    get records(){
        return this.visibleRecords;
    }

    @api
    set records(data){
        if(data){
            this.totalRecords = data;
            this.recordSize = Number(this.recordSize);
            this.totalPage = Math.ceil(data.length/this.recordSize);
            this.updateRecords();
        }
    }

    get disablePrevious(){
        return this.currentPage <= 1;
    }

    get disableNext(){
        return this.currentPage >= this.totalPage;
    }

    previousHandler(){
        if(this.currentPage > 1){
            this.currentPage = this.currentPage - 1;
            this.updateRecords();
        }
    }

    nextHandler(){
        if(this.currentPage < this.totalPage){
            this.currentPage = this.currentPage + 1;
            this.updateRecords();
        }
    }

    updateRecords() {
        const start = (this.currentPage-1)*this.recordSize;
        const end = this.recordSize*this.currentPage;
        this.visibleRecords = this.totalRecords.slice(start, end);
        this.dispatchEvent(new CustomEvent("update",{
            detail:{
                records:this.visibleRecords
            }
        }));
    }
}