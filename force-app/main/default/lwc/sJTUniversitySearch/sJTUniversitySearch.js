// import { LightningElement } from 'lwc';

// export default class SJTUniversitySearch extends LightningElement {}

import { LightningElement, track } from 'lwc';

export default class SJTUniversitySearch extends LightningElement {
    @track searchKey = '';
    @track currentPage = 1;
    @track pageSize = 6;
    @track disablePrevious = true;
    @track disableNext = false;
    totalPages = 10; // Example total pages, adjust this as needed

    @track universities = [
        { id: 1, universityName: 'KLC Tech College', programsOffered: 15, students: 100, mentors: 15 },
        { id: 2, universityName: 'KLC Tech College', programsOffered: 9, students: 500, mentors: 9 },
        { id: 3, universityName: 'KLC Tech College', programsOffered: 10, students: 800, mentors: 10 },
        { id: 4, universityName: 'KLC Tech College', programsOffered: 12, students: 50, mentors: 12 },
        { id: 5, universityName: 'KLC Tech College', programsOffered: 11, students: 500, mentors: 11 },
        { id: 6, universityName: 'KLC Tech College', programsOffered: 6, students: 400, mentors: 6 },
        // Add more dummy data if necessary
    ];

    @track paginatedUniversities = [];
    @track pagesToShow = [];

    connectedCallback() {
        this.calculateTotalPages();
        this.updatePaginatedUniversities();
    }

    calculateTotalPages() {
        this.totalPages = Math.ceil(this.universities.length / this.pageSize);
        this.pagesToShow = this.calculatePagesToShow();
    }

    calculatePagesToShow() {
        const pages = [];

        // Always show the first page
        pages.push({
            pageNumber: 1,
            className: this.currentPage === 1 ? 'active' : '',
            isEllipsis: false
        });

        // Display ellipses if the current page is far from the start
        if (this.currentPage > 3) {
            pages.push({
                pageNumber: '...',
                className: '',
                isEllipsis: true
            });
        }

        // Display up to 3 pages around the current page
        for (let i = Math.max(2, this.currentPage - 1); i <= Math.min(this.currentPage + 1, this.totalPages - 1); i++) {
            pages.push({
                pageNumber: i,
                className: this.currentPage === i ? 'active' : '',
                isEllipsis: false
            });
        }

        // Display ellipses if the current page is far from the end
        if (this.currentPage < this.totalPages - 2) {
            pages.push({
                pageNumber: '...',
                className: '',
                isEllipsis: true
            });
        }

        // Always show the last page
        pages.push({
            pageNumber: this.totalPages,
            className: this.currentPage === this.totalPages ? 'active' : '',
            isEllipsis: false
        });

        return pages;
    }

    updatePaginatedUniversities() {
        const start = (this.currentPage - 1) * this.pageSize;
        const end = start + this.pageSize;
        this.paginatedUniversities = this.universities.slice(start, end);
        this.updatePaginationState();
    }

    updatePaginationState() {
        this.disablePrevious = this.currentPage === 1;
        this.disableNext = this.currentPage === this.totalPages;
        this.pagesToShow = this.calculatePagesToShow();
    }

    handlePreviousPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
            this.updatePaginatedUniversities();
        }
    }

    handleNextPage() {
        if (this.currentPage < this.totalPages) {
            this.currentPage++;
            this.updatePaginatedUniversities();
        }
    }

    goToFirstPage() {
        this.currentPage = 1;
        this.updatePaginatedUniversities();
    }

    goToLastPage() {
        this.currentPage = this.totalPages;
        this.updatePaginatedUniversities();
    }

    handlePageClick(event) {
        const page = Number(event.target.dataset.page);
        if (!isNaN(page)) {
            this.currentPage = page;
            this.updatePaginatedUniversities();
        }
    }

    handleSearchKeyChange(event) {
        this.searchKey = event.target.value;
    }

    handleSearch() {
        if (this.searchKey) {
            const filteredUniversities = this.universities.filter(university =>
                university.universityName.toLowerCase().includes(this.searchKey.toLowerCase())
            );
            this.universities = filteredUniversities;
        } else {
            // Reset to original data if search is cleared
            this.universities = [
                { id: 1, universityName: 'KLC Tech College', programsOffered: 15, students: 100, mentors: 15 },
                { id: 2, universityName: 'KLC Tech College', programsOffered: 9, students: 500, mentors: 9 },
                { id: 3, universityName: 'KLC Tech College', programsOffered: 10, students: 800, mentors: 10 },
                { id: 4, universityName: 'KLC Tech College', programsOffered: 12, students: 50, mentors: 12 },
                { id: 5, universityName: 'KLC Tech College', programsOffered: 11, students: 500, mentors: 11 },
                { id: 6, universityName: 'KLC Tech College', programsOffered: 6, students: 400, mentors: 6 },
                // Add more dummy data if necessary
            ];
        }
        this.currentPage = 1;
        this.calculateTotalPages();
        this.updatePaginatedUniversities();
    }
}