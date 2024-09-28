import { LightningElement, track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class UniversityPage extends NavigationMixin (LightningElement) {
    @track currentPage = 1;
    @track rowsPerPage = 5;
    @track searchQuery = '';

    // Sample data with row numbers
    dataWithRowNumbers = [
        { rowNumber: 1, name: "KLC Technologies", programs: 10, students: 100, mentors: 123 },
        { rowNumber: 2, name: "Tech University", programs: 12, students: 150, mentors: 110 },
        { rowNumber: 3, name: "Global University", programs: 15, students: 200, mentors: 90 },
        { rowNumber: 4, name: "Innovative Institute", programs: 20, students: 180, mentors: 80 },
        { rowNumber: 5, name: "Future Academy", programs: 25, students: 220, mentors: 60 },
        { rowNumber: 6, name: "KD Academy", programs: 15, students: 200, mentors: 95 },
                { rowNumber: 7, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
                { rowNumber: 8, name: "SP University", programs: 12, students: 150, mentors: 110 },
                { rowNumber: 9, name: "SN Academy", programs: 15, students: 200, mentors: 95 },
                { rowNumber: 10, name: "SS Technologies", programs: 10, students: 100, mentors: 123 },
                { rowNumber: 11, name: "SL Tech University", programs: 12, students: 150, mentors: 110 },
                { rowNumber: 12, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
                { rowNumber: 13, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
                { rowNumber: 14, name: "TT University", programs: 12, students: 150, mentors: 110 },
                { rowNumber: 15, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
                { rowNumber: 16, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
                { rowNumber: 17, name: "SP University", programs: 12, students: 150, mentors: 110 },
                { rowNumber: 18, name: "SN Academy", programs: 15, students: 200, mentors: 95 },
                { rowNumber: 19, name: "SS Technologies", programs: 10, students: 100, mentors: 123 },
                { rowNumber: 20, name: "SL Tech University", programs: 12, students: 150, mentors: 110 },
                { rowNumber: 21, name: "MN Academy", programs: 15, students: 200, mentors: 95 },
                { rowNumber: 22, name: "KC Technologies", programs: 10, students: 100, mentors: 123 },
                { rowNumber: 23, name: "TT University", programs: 12, students: 150, mentors: 110 },
                { rowNumber: 24, name: "MN Academy", programs: 15, students: 200, mentors: 95 }
        // Add more data for testing purposes
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

    isEllipsis(value) {
        return value === '...';
    }

    // get pages() {
    //     const totalPages = Math.ceil(this.filteredData.length / this.rowsPerPage);
    //     const currentPage = this.currentPage;
    //     const pages = [];
    
    //     if (totalPages <= 3) {
    //         // If 3 or fewer pages, show all page numbers
    //         return Array.from({ length: totalPages }, (_, i) => ({
    //             key: i + 1,
    //             number: i + 1,
    //             label: i + 1
    //         }));
    //     }
    
    //     // Always show the first two pages
    //     pages.push({ key: 1, number: 1, label: 1 });
    //     pages.push({ key: 2, number: 2, label: 2 });
    
    //     if (currentPage > 3 && currentPage < totalPages - 1) {
    //         // Show ellipsis before and after current page if in the middle
    //         pages.push({ key: 'ellipsis1', number: null, label: '...' });
    //         pages.push({ key: currentPage, number: currentPage, label: currentPage });
    //         pages.push({ key: 'ellipsis2', number: null, label: '...' });
    //     } else if (currentPage >= totalPages - 1) {
    //         // Show ellipsis only before last pages if the current page is near the end
    //         pages.push({ key: 'ellipsis', number: null, label: '...' });
    //     }
    
    //     // Always show the last page
    //     pages.push({ key: totalPages, number: totalPages, label: totalPages });
    
    //     return pages;
    // }
    

    // previousPage() {
    //     if (this.currentPage > 1) {
    //         this.currentPage -= 1;
    //     }
    // }

    // nextPage() {
    //     if (this.currentPage < this.pages.length) {
    //         this.currentPage += 1;
    //     }
    // }

    // gotoPage(event) {
    //     const selectedPage = parseInt(event.target.closest('li').dataset.page, 10);
    //     this.currentPage = selectedPage;
    // }
    
    ///////////////////////////////////////

    // get pages() {
    //     const totalPages = Math.ceil(this.filteredData.length / this.rowsPerPage);
    //     const currentPage = this.currentPage;
    //     const pages = [];
    
    //     // If there are 3 or fewer pages, show all pages
    //     if (totalPages <= 3) {
    //         return Array.from({ length: totalPages }, (_, i) => ({
    //             key: i + 1,
    //             number: i + 1,
    //             label: i + 1
    //         }));
    //     }
    
    //     // Always show the first two pages
    //     pages.push({ key: 1, number: 1, label: 1 });
    //     pages.push({ key: 2, number: 2, label: 2 });
    
    //     if (currentPage > 3 && currentPage < totalPages) {
    //         // Add ellipsis after the second page
    //         pages.push({ key: 'ellipsis1', number: null, label: '...' });
            
    //         // Add the current page
    //         pages.push({ key: currentPage, number: currentPage, label: currentPage });
    
    //         // Add ellipsis before the last page if current page is not right next to the last page
    //         if (currentPage < totalPages - 1) {
    //             pages.push({ key: 'ellipsis2', number: null, label: '...' });
    //         }
    //     } else if (currentPage >= totalPages - 1) {
    //         // Add ellipsis if the current page is close to the last page but not shown yet
    //         pages.push({ key: 'ellipsis', number: null, label: '...' });
    //     }
    
    //     // Always show the last page
    //     pages.push({ key: totalPages, number: totalPages, label: totalPages });
    
    //     return pages;
    // }
    
    // previousPage() {
    //     if (this.currentPage > 1) {
    //         this.currentPage -= 1;
    //     }
    // }
    
    // nextPage() {
    //     const totalPages = Math.ceil(this.filteredData.length / this.rowsPerPage);
    //     if (this.currentPage < totalPages) {
    //         this.currentPage += 1;
    //     }
    // }
    
    // gotoPage(event) {
    //     const selectedPage = parseInt(event.target.closest('li').dataset.page, 10);
    //     if (selectedPage) {
    //         this.currentPage = selectedPage;
    //     }
    // }
    
get pages() {
    const totalPages = Math.ceil(this.filteredData.length / this.rowsPerPage);
    const currentPage = this.currentPage;
    const pages = [];

    // If there are 3 or fewer pages, show all page numbers
    if (totalPages <= 3) {
        return Array.from({ length: totalPages }, (_, i) => ({
            key: i + 1,
            number: i + 1,
            label: i + 1,
            isCurrent: currentPage === i + 1  // Highlight the current page
        }));
    }

    // Always show the first two pages
    pages.push({ key: 1, number: 1, label: 1, isCurrent: currentPage === 1 });
    pages.push({ key: 2, number: 2, label: 2, isCurrent: currentPage === 2 });

    // Show ellipses and the current page if it’s beyond page 3
    if (currentPage > 3 && currentPage < totalPages) {
        pages.push({ key: 'ellipsis1', number: null, label: '...' });
        pages.push({ key: currentPage, number: currentPage, label: currentPage, isCurrent: true });
        pages.push({ key: 'ellipsis2', number: null, label: '...' });
    } else if (currentPage >= totalPages - 1) {
        pages.push({ key: 'ellipsis', number: null, label: '...' });
    }

    // Always show the last page
    pages.push({ key: totalPages, number: totalPages, label: totalPages, isCurrent: currentPage === totalPages });

    return pages;
}

previousPage() {
    if (this.currentPage > 1) {
        this.currentPage -= 1;
    }
}

nextPage() {
    const totalPages = Math.ceil(this.filteredData.length / this.rowsPerPage);
    if (this.currentPage < totalPages) {
        this.currentPage += 1;
    }
}

gotoPage(event) {
    const selectedPage = parseInt(event.target.closest('li').dataset.page, 10);
    if (selectedPage) {
        this.currentPage = selectedPage;
    }
}

    handleSearchChange(event) {
        this.searchQuery = event.target.value;
        this.currentPage = 1; // Reset to first page on search
    }

    handleSearch() {
        this.currentPage = 1; // Reset to first page on search
    }
    
    // handleUniversityClick(event) {
    //     const universityName = event.target.dataset.name;
    //     console.log(`University clicked: ${universityName}`);
    
    //     this[NavigationMixin.GenerateUrl]({
    //         type: 'standard__navItemPage',  // This will navigate to a custom LWC tab
    //         attributes: {
    //             apiName: 'UniversityPage__c'  // The API name of the custom LWC tab
    //         },
    //         state: {
    //             university: universityName  // Passing the university name as a parameter
    //         }
    //     }).then(url => {
    //         window.open(url, '_blank');  // Opens the custom LWC page in a new tab
    //     });
    // }
    

    handleUniversityClick(event) {
        const universityName = event.target.dataset.name;
        console.log(`University clicked: ${universityName}`);

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'StudentPage__c'
            }
            
        }).then(url => {
            window.open(url, '_blank');
        });
    }
        // Handle click action, e.g., navigate to details page
    }