import { LightningElement, track } from 'lwc';

export default class UniversityList extends LightningElement {
    @track collegeData = [
        { id: 1, serial: '01', name: 'KJC Tech College', programs: '15', students: '100', mentors: '15' },
        { id: 2, serial: '02', name: 'KJC Tech College', programs: '9', students: '500', mentors: '9' },
        { id: 3, serial: '03', name: 'KJC Tech College', programs: '10', students: '800', mentors: '10' },
        { id: 4, serial: '04', name: 'KJC Tech College', programs: '12', students: '50', mentors: '12' },
        { id: 5, serial: '05', name: 'KJC Tech College', programs: '11', students: '500', mentors: '11' },
        { id: 6, serial: '06', name: 'KJC Tech College', programs: '6', students: '400', mentors: '6' },
        { id: 7, serial: '07', name: 'KJC Tech College', programs: '12', students: '50', mentors: '12' },
        { id: 8, serial: '08', name: 'SJC Tech College', programs: '12', students: '50', mentors: '12' },
        // Add more static rows as needed
    ];

    @track currentPage = 1;
    @track itemsPerPage = 6;  // Set items per page to 6
    @track searchTerm = '';

    

    get totalPages() {
        return Math.ceil(this.filteredCollegeData.length / this.itemsPerPage);
    }

    get disablePrevious() {
        return this.currentPage <= 1;
    }

    get disableNext() {
        return this.currentPage >= this.totalPages;
    }

    get visibleCollegeData() {
        const start = (this.currentPage - 1) * this.itemsPerPage;
        const end = start + this.itemsPerPage;
        return this.filteredCollegeData.slice(start, end);
    }

    get filteredCollegeData() {
        return this.collegeData.filter(college => 
            college.name.toLowerCase().includes(this.searchTerm.toLowerCase())
        );
    }

    handleSearch(event) {
        this.searchTerm = event.target.value;
        this.currentPage = 1; // Reset to first page on search
    }

    handleNext() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
        }
    }

    handlePrevious() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }
    
}