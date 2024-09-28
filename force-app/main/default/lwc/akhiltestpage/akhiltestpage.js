// import { LightningElement, track } from 'lwc';

// export default class UniversityPage extends LightningElement {
//     @track stats = [
//         { label: 'Total Universities', value: 100 },
//         { label: 'Students', value: 200 },
//         { label: 'Mentors', value: 300 },
//         { label: 'Programs', value: 400 },
//         { label: 'Courses', value: 500 }
//     ];

//     @track universityList = [
//         { rollNumber: 1, name: 'KLC Technologies', programs: 10, students: 100, mentors: 123 },
//         { rollNumber: 2, name: 'Tech University', programs: 12, students: 150, mentors: 110 },
//         { rollNumber: 3, name: 'KLC Technologies', programs: 10, students: 100, mentors: 123 },
//         { rollNumber: 4, name: 'Tech University', programs: 12, students: 150, mentors: 110 },   { rollNumber: 1, name: 'KLC Technologies', programs: 10, students: 100, mentors: 123 },
//         { rollNumber: 5, name: 'Tech University', programs: 12, students: 150, mentors: 110 },
//         { rollNumber: 6, name: 'Innovate Academy', programs: 15, students: 200, mentors: 95 }
//         // Add more data as needed...
//     ];

//     @track filteredData = [...this.universityList];
//     @track paginatedData = [];
//     @track currentPage = 1;
//     rowsPerPage = 5;
//     searchQuery = '';

//     columns = [
//         { label: 'S.No', fieldName: 'rollNumber' },
//         { label: 'Name of University', fieldName: 'name' },
//         { label: 'No. of Programs Offered', fieldName: 'programs' },
//         { label: 'Students', fieldName: 'students' },
//         { label: 'Mentors', fieldName: 'mentors' }
//     ];

//     get isFirstPage() {
//         return this.currentPage === 1;
//     }

//     get isLastPage() {
//         return this.currentPage === this.totalPages;
//     }

//     get pageNumbers() {
//         let pages = [];
//         for (let i = 1; i <= this.totalPages; i++) {
//             pages.push(i);
//         }
//         return pages;
//     }

//     get totalPages() {
//         return Math.ceil(this.filteredData.length / this.rowsPerPage);
//     }

//     handleInputChange(event) {
//         this.searchQuery = event.target.value;
//     }

//     handleSearchClick() {
//         this.filteredData = this.searchQuery
//             ? this.universityList.filter(university => university.name.toLowerCase().includes(this.searchQuery.toLowerCase()))
//             : [...this.universityList];
//         this.currentPage = 1;
//         this.updatePaginatedData();
//     }

//     handlePageClick(event) {
//         this.currentPage = parseInt(event.target.label, 10);
//         this.updatePaginatedData();
//     }
    
//     handlePrevPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//             this.updatePaginatedData();
//         }
//     }
    
//     handleNextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//             this.updatePaginatedData();
//         }
//     }
    
//     updatePaginatedData() {
//         const startIndex = (this.currentPage - 1) * this.rowsPerPage;
//         this.paginatedData = this.filteredData.slice(startIndex, startIndex + this.rowsPerPage);
//     }

//     connectedCallback() {
//         this.updatePaginatedData();
//     }

//     getButtonVariant(page) {
//         return page === this.currentPage ? 'neutral' : 'base';
//     }
// }





// import { LightningElement, track } from 'lwc';

// export default class UniversityPage extends LightningElement {
//     @track dataWithRowNumbers = [
//         // Add real data here, this is sample
//         { rowNumber: 1, name: 'Harvard University', programs: 50, students: 2000, mentors: 100 },
//         { rowNumber: 2, name: 'Stanford University', programs: 45, students: 1800, mentors: 90 },
//         { rowNumber: 3, name: 'MIT', programs: 60, students: 2200, mentors: 110 },
//         { rowNumber: 4, name: 'Oxford University', programs: 55, students: 1900, mentors: 95 },
//         { rowNumber: 5, name: 'Cambridge University', programs: 40, students: 1700, mentors: 80 },
//         // Additional data...
//     ];

//     @track paginatedData = [];
//     @track currentPage = 1;    // Current page for pagination
//     @track rowsPerPage = 5;    // Rows per page for pagination

//     connectedCallback() {
//         this.paginateData();  // Ensure data is paginated when component loads
//     }

//     // Pagination Logic
//     paginateData() {
//         const start = (this.currentPage - 1) * this.rowsPerPage;
//         const end = this.currentPage * this.rowsPerPage;
//         this.paginatedData = this.dataWithRowNumbers.slice(start, end);
//     }

//     // Handle previous page button click
//     handlePreviousPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//             this.paginateData();
//         }
//     }

//     // Handle next page button click
//     handleNextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//             this.paginateData();
//         }
//     }

//     // Calculate total pages
//     get totalPages() {
//         return Math.ceil(this.dataWithRowNumbers.length / this.rowsPerPage);
//     }

//     // Disable/enable next and previous buttons based on the current page
//     get prevDisabledClass() {
//         return this.currentPage === 1 ? 'disabled' : '';
//     }

//     get nextDisabledClass() {
//         return this.currentPage === this.totalPages ? 'disabled' : '';
//     }

//     // Handle page number click
//     handlePageClick(event) {
//         const clickedPage = Number(event.target.dataset.page);
//         if (clickedPage !== this.currentPage) {
//             this.currentPage = clickedPage;
//             this.paginateData();
//         }
//     }
// }

// import { LightningElement, track } from 'lwc';

// export default class UniversityPage extends LightningElement {
//     @track dataWithRowNumbers = [
//         // Add your real data here, this is sample data
//         { rowNumber: 1, name: 'Harvard University', programs: 50, students: 2000, mentors: 100 },
//         { rowNumber: 2, name: 'Stanford University', programs: 45, students: 1800, mentors: 90 },
//         { rowNumber: 3, name: 'MIT', programs: 60, students: 2200, mentors: 110 },
//         { rowNumber: 4, name: 'Oxford University', programs: 55, students: 1900, mentors: 95 },
//         { rowNumber: 5, name: 'Cambridge University', programs: 40, students: 1700, mentors: 80 },
//         { rowNumber: 6, name: 'MIT', programs: 60, students: 2200, mentors: 110 },
//         { rowNumber: 7, name: 'Oxford University', programs: 55, students: 1900, mentors: 95 },
//         { rowNumber: 8, name: 'Cambridge University', programs: 40, students: 1700, mentors: 80 }
//         // Add more data...
//     ];

//     @track paginatedData = [];
//     @track currentPage = 1; // Current page for pagination
//     @track rowsPerPage = 5; // Rows per page for pagination

//     connectedCallback() {
//         this.paginateData(); // Ensure data is paginated when component loads
//     }

//     // Pagination Logic
//     paginateData() {
//         const start = (this.currentPage - 1) * this.rowsPerPage;
//         const end = this.currentPage * this.rowsPerPage;
//         this.paginatedData = this.dataWithRowNumbers.slice(start, end);
//     }

//     // Handle previous page button click
//     handlePreviousPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//             this.paginateData();
//         }
//     }

//     // Handle next page button click
//     handleNextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//             this.paginateData();
//         }
//     }

//     // Calculate total pages
//     get totalPages() {
//         return Math.ceil(this.dataWithRowNumbers.length / this.rowsPerPage);
//     }

//     // Disable/enable next and previous buttons based on the current page
//     get prevDisabledClass() {
//         return this.currentPage === 1 ? 'slds-button_disabled' : ''; // Correct class name for disabled
//     }

//     get nextDisabledClass() {
//         return this.currentPage === this.totalPages ? 'slds-button_disabled' : ''; // Correct class name for disabled
//     }

//     // Handle page number click
//     handlePageClick(event) {
//         const clickedPage = Number(event.target.dataset.page);
//         if (clickedPage !== this.currentPage) {
//             this.currentPage = clickedPage;
//             this.paginateData();
//         }
//     }
// }



// import { LightningElement, track } from 'lwc';

// export default class UniversityPage extends LightningElement {
//     @track dataWithRowNumbers = [
//         // Add your real data here, this is sample data
//         { rowNumber: 1, name: 'Harvard University', programs: 50, students: 2000, mentors: 100 },
//         { rowNumber: 2, name: 'Stanford University', programs: 45, students: 1800, mentors: 90 },
//         { rowNumber: 3, name: 'MIT', programs: 60, students: 2200, mentors: 110 },
//         { rowNumber: 4, name: 'Oxford University', programs: 55, students: 1900, mentors: 95 },
//         { rowNumber: 5, name: 'Cambridge University', programs: 40, students: 1700, mentors: 80 },
//         { rowNumber: 6, name: 'MIT', programs: 60, students: 2200, mentors: 110 },
//         { rowNumber: 7, name: 'Oxford University', programs: 55, students: 1900, mentors: 95 },
//         { rowNumber: 8, name: 'Cambridge University', programs: 40, students: 1700, mentors: 80 }
//         // Add more data...
//     ];

//     @track paginatedData = [];
//     @track currentPage = 1; // Current page for pagination
//     @track rowsPerPage = 5; // Rows per page for pagination

//     connectedCallback() {
//         this.paginateData(); // Ensure data is paginated when component loads
//     }

//     // Pagination Logic
//     paginateData() {
//         const start = (this.currentPage - 1) * this.rowsPerPage;
//         const end = this.currentPage * this.rowsPerPage;
//         this.paginatedData = this.dataWithRowNumbers.slice(start, end);
//     }

//     // Handle previous page button click
//     handlePreviousPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//             this.paginateData();
//         }
//     }

//     // Handle next page button click
//     handleNextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//             this.paginateData();
//         }
//     }

//     // Calculate total pages
//     get totalPages() {
//         return Math.ceil(this.dataWithRowNumbers.length / this.rowsPerPage);
//     }

//     // Disable/enable previous button based on the current page
//     get prevDisabledClass() {
//         return this.currentPage === 1 ? 'slds-button_disabled' : ''; // Correct class name for disabled
//     }

//     // Disable/enable next button based on the current page
//     get nextDisabledClass() {
//         return this.currentPage === this.totalPages ? 'slds-button_disabled' : ''; // Correct class name for disabled
//     }

//     // Handle page number click
//     handlePageClick(event) {
//         const clickedPage = Number(event.target.dataset.page);
//         if (clickedPage !== this.currentPage) {
//             this.currentPage = clickedPage;
//             this.paginateData();
//         }
//     }

//     // Getter for pages array for rendering pagination links
//     get pages() {
//         return Array.from({ length: this.totalPages }, (_, i) => i + 1);
//     }
// }


// import { LightningElement, track } from 'lwc';

// export default class UniversityPage extends LightningElement {
//     @track currentPage = 1;
//     @track rowsPerPage = 5;
//     @track searchQuery = '';

//     dataWithRowNumbers = [
//         { rowNumber: 1, name: "KLC Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 2, name: "Tech University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 3, name: "Innovate Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 4, name: "SRM Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 5, name: "AR University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 6, name: "KD Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 7, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 8, name: "SP University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 9, name: "SN Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 10, name: "SS Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 11, name: "SL Tech University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 12, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 13, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 14, name: "TT University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 15, name: "MN Academy", programs: 15, students: 200, mentors: 95 }
//         // Add more data here...
//     ];

//     get filteredData() {
//         const lowerCaseQuery = this.searchQuery.toLowerCase();
//         return this.dataWithRowNumbers
//             .filter(item => item.name.toLowerCase().includes(lowerCaseQuery));
//     }

//     get paginatedData() {
//         const start = (this.currentPage - 1) * this.rowsPerPage;
//         const end = this.currentPage * this.rowsPerPage;
//         return this.filteredData.slice(start, end);
//     }

//     get totalPages() {
//         return Math.ceil(this.filteredData.length / this.rowsPerPage);
//     }

//     get pages() {
//         const totalPages = this.totalPages;
//         return Array.from({ length: totalPages }, (_, i) => i + 1);
//     }

//     handleSearch(event) {
//         this.searchQuery = event.target.value;
//         this.currentPage = 1; // Reset to first page on search
//     }

//     handlePageClick(event) {
//         const page = Number(event.target.dataset.page);
//         if (page !== this.currentPage) {
//             this.currentPage = page;
//         }
//     }

//     handlePreviousPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//         }
//     }

//     handleNextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//         }
//     }

//     handleUniversityClick(event) {
//         const universityName = event.target.dataset.name;
//         // Logic for handling university click (e.g., navigation or showing details)
//         console.log(`University clicked: ${universityName}`);
//     }
// }
import { LightningElement, track } from 'lwc';

export default class UniversityPage extends LightningElement {
    @track currentPage = 1;
    @track rowsPerPage = 5;
    @track searchQuery = '';

    // Sample data
    dataWithRowNumbers = [
        { rowNumber: 1, name: "KLC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber: 2, name: "Tech University", programs: 12, students: 150, mentors: 110 },
        { rowNumber: 3, name: "Global University", programs: 15, students: 200, mentors: 90 },
        { rowNumber: 4, name: "Innovative Institute", programs: 20, students: 180, mentors: 80 },
        { rowNumber: 5, name: "AR University", programs: 12, students: 150, mentors: 110 },
        { rowNumber: 6, name: "KD Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber: 7, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber: 8, name: "SP University", programs: 12, students: 150, mentors: 110 },
        { rowNumber: 9, name: "SN Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber: 10, name: "SS Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber: 11, name: "SL Tech University", programs: 12, students: 150, mentors: 110 },
        { rowNumber: 12, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
        { rowNumber: 13, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber: 14, name: "TT University", programs: 12, students: 150, mentors: 110 },
        { rowNumber: 15, name: "MN Academy", programs: 15, students: 200, mentors: 95 }
        // Add more data here...
        // Add more data if needed
    ];

    get filteredData() {
        const lowerCaseQuery = this.searchQuery.toLowerCase();
        return this.dataWithRowNumbers.filter(item => 
            item.name.toLowerCase().includes(lowerCaseQuery)
        );
    }

    get paginatedData() {
        const start = (this.currentPage - 1) * this.rowsPerPage;
        const end = this.currentPage * this.rowsPerPage;
        return this.filteredData.slice(start, end);
    }

    get totalPages() {
        return Math.ceil(this.filteredData.length / this.rowsPerPage);
    }

    handleSearchChange(event) {
        this.searchQuery = event.target.value;
        this.currentPage = 1; // Reset to first page on search
    }

    handleSearch() {
        this.currentPage = 1; // Reset to first page on search
    }

    handleUniversityClick(event) {
        const universityName = event.target.dataset.name;
        console.log(`University clicked: ${universityName}`);
        // Handle the click event, e.g., navigate to details page
    }

    handlePageUpdate(event) {
        this.currentPage = event.detail;
    }
}

// import { LightningElement, track } from 'lwc';

// export default class SJTUniversitySearchPage extends LightningElement {
//     @track dataWithRowNumbers = [
//         { rowNumber: 1, name: "KLC Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 2, name: "Tech University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 3, name: "Innovate Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 4, name: "SRM Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 5, name: "AR University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 6, name: "KD Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 7, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 8, name: "SP University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 9, name: "SN Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 10, name: "SS Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 11, name: "SL Tech University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 12, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
//         { rowNumber: 13, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
//         { rowNumber: 14, name: "TT University", programs: 12, students: 150, mentors: 110 },
//         { rowNumber: 15, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
//     ];

//     @track paginatedData = [];
//     @track currentPage = 1;
//     @track rowsPerPage = 5;

//     connectedCallback() {
//         this.paginateData();
//     }

//     paginateData() {
//         const start = (this.currentPage - 1) * this.rowsPerPage;
//         const end = this.currentPage * this.rowsPerPage;
//         this.paginatedData = this.dataWithRowNumbers.slice(start, end);
//     }

//     handlePreviousPage() {
//         if (this.currentPage > 1) {
//             this.currentPage--;
//             this.paginateData();
//         }
//     }

//     handleNextPage() {
//         if (this.currentPage < this.totalPages) {
//             this.currentPage++;
//             this.paginateData();
//         }
//     }

//     get totalPages() {
//         return Math.ceil(this.dataWithRowNumbers.length / this.rowsPerPage);
//     }

//     get pages() {
//         const totalPages = this.totalPages;
//         return Array.from({ length: totalPages }, (_, i) => i + 1);
//     }

//     get prevDisabledClass() {
//         return this.currentPage === 1 ? 'slds-button_disabled' : '';
//     }

//     get nextDisabledClass() {
//         return this.currentPage === this.totalPages ? 'slds-button_disabled' : '';
//     }

//     handlePageClick(event) {
//         const clickedPage = Number(event.target.dataset.page);
//         if (clickedPage !== this.currentPage) {
//             this.currentPage = clickedPage;
//             this.paginateData();
//         }
//     }

//     handleUniversityClick(event) {
//         const universityName = event.target.dataset.name;
//         console.log(`University clicked: ${universityName}`);
//         // Add your navigation logic here
//     }
// }