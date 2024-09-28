import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class SJTUniversitySearchPage extends NavigationMixin(LightningElement) {
    searchQuery = '';
    visibleRecords = [];
    allRecords = [
        { rowNumber:"1", name: "KLC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber:"2", name: "Tech University", programs: 12, students: 150, mentors: 110 },
        { rowNumber:"3",name: "Innovate Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber:"4",name: "SRM Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber:"5",name: "AR University", programs: 12, students: 150, mentors: 110 },
        { rowNumber:"6",name: "KD Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber:"7",name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber:"8",name: "SP University", programs: 12, students: 150, mentors: 110 },
        {rowNumber:"9", name: "SN Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber:"10",name: "SS Technologies", programs: 10, students: 100, mentors: 123 },
        {rowNumber:"11", name: "SL Tech University", programs: 12, students: 150, mentors: 110 },
        { rowNumber:"12",name: "MN Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber:"13",name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber:"14",name: "TT University", programs: 12, students: 150, mentors: 110 },
        {rowNumber:"15", name: "MN Academy", programs: 15, students: 200, mentors: 95 },
    ];

    connectedCallback() {

        this.visibleRecords = this.filteredRecords.slice(0, 5); 
    }

    get filteredRecords() {
        return this.allRecords.filter((item) =>
            item.name.toLowerCase().includes(this.searchQuery.toLowerCase())
        );
    }

    get dataWithRowNumbers() {
        return this.filteredRecords.map((item, index) => {
            return {
                ...item,
                rowNumber: index + 1 
            };
        });
    }

    handleSearch(event) {
        this.searchQuery = this.template.querySelector('.search-input').value;
        this.visibleRecords = this.filteredRecords.slice(0, 5);
    }

    handleUpdate(event) {
        this.visibleRecords = event.detail.records;
    }

    handleUniversityClick(event) {
        const universityName = event.target.dataset.name;

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'sJTStudentSearch__c'
            }
            
        }).then(url => {
            window.open(url, '_blank');
        });
    }
}