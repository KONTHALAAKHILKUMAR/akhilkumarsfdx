import { LightningElement, track } from 'lwc';
import sJT_goBackArrowIcon from '@salesforce/resourceUrl/sJT_goBackArrowIcon';
import sJT_DropDownIcon from '@salesforce/resourceUrl/sJT_DropDownIcon';
import sJT_CalenderIcon from '@salesforce/resourceUrl/sJT_CalenderIcon';
import { NavigationMixin } from 'lightning/navigation';

export default class SJTStudentSearch extends NavigationMixin(LightningElement) {
    // Resource URL Icons
    goBackArrowIcon = sJT_goBackArrowIcon;
    dropDownIcon = sJT_DropDownIcon;
    calenderIcon = sJT_CalenderIcon;

    // Search and Filter Properties
    searchKey = '';
    selectedProgram = 'All Programs';
    selectedYear = 'All Years';
    selectedSemester = 'All Semesters';

    // Pagination
    @track currentPage = 1;
    @track rowsPerPage = 6;
    @track totalPages = 0;
    @track pageList = [];

    // Static Data for Filtering and Pagination
    allStudents = [
        { id: 1, sNo: '01', name: 'Scarlett Johansson', semester: 'Sem 1', year: '2023-2024', grade: '98%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 2, sNo: '02', name: 'Aria Caldwell', semester: 'Sem 2', year: '2023-2024', grade: '88%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 3, sNo: '03', name: 'Lucas Trent', semester: 'Sem 3', year: '2023-2024', grade: '75%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 4, sNo: '04', name: 'Evelyn Harper', semester: 'Sem 4', year: '2023-2024', grade: '67%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 5, sNo: '05', name: 'Nolan Pierce', semester: 'Sem 5', year: '2022-2023', grade: '23%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 6, sNo: '06', name: 'Sophia Ellis', semester: 'Sem 6', year: '2023-2024', grade: '48%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 7, sNo: '07', name: 'Disujadevi', semester: 'Sem 7', year: '2019-2020', grade: '99%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 8, sNo: '08', name: 'Scarlett Johansson', semester: 'Sem 8', year: '2023-2024', grade: '98%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 9, sNo: '09', name: 'Aria Caldwell', semester: 'Sem 2', year: '2023-2024', grade: '88%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 10, sNo: '10', name: 'Lucas Trent', semester: 'Sem 3', year: '2023-2024', grade: '75%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 11, sNo: '11', name: 'Evelyn Harper', semester: 'Sem 4', year: '2021-2022', grade: '67%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 12, sNo: '12', name: 'Nolan Pierce', semester: 'Sem 5', year: '2022-2023', grade: '23%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 13, sNo: '13', name: 'Sophia Ellis', semester: 'Sem 6', year: '2023-2024', grade: '48%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 14, sNo: '14', name: 'Disujadevi', semester: 'Sem 7', year: '2019-2020', grade: '99%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 15, sNo: '01', name: 'Scarlett Johansson', semester: 'Sem 1', year: '2023-2024', grade: '98%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 16, sNo: '02', name: 'Aria Caldwell', semester: 'Sem 2', year: '2023-2024', grade: '88%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 17, sNo: '03', name: 'Lucas Trent', semester: 'Sem 3', year: '2023-2024', grade: '75%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 18, sNo: '04', name: 'Evelyn Harper', semester: 'Sem 4', year: '2023-2024', grade: '67%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 19, sNo: '05', name: 'Nolan Pierce', semester: 'Sem 5', year: '2022-2023', grade: '23%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 20, sNo: '06', name: 'Sophia Ellis', semester: 'Sem 6', year: '2023-2024', grade: '48%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 21, sNo: '07', name: 'Disujadevi', semester: 'Sem 7', year: '2019-2020', grade: '99%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 22, sNo: '08', name: 'Scarlett Johansson', semester: 'Sem 8', year: '2023-2024', grade: '98%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 23, sNo: '09', name: 'Aria Caldwell', semester: 'Sem 2', year: '2023-2024', grade: '88%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 24, sNo: '10', name: 'Lucas Trent', semester: 'Sem 3', year: '2023-2024', grade: '75%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 25, sNo: '11', name: 'Evelyn Harper', semester: 'Sem 4', year: '2021 - 2022', grade: '67%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 26, sNo: '12', name: 'Nolan Pierce', semester: 'Sem 5', year: '2022 - 2023', grade: '23%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 27, sNo: '13', name: 'Sophia Ellis', semester: 'Sem 6', year: '2023 - 2024', grade: '48%', skills: ['HTML', 'JAVA', 'SQL'] },
        { id: 28, sNo: '14', name: 'Disujadevi', semester: 'Sem 7', year: '2019 - 2020', grade: '99%', skills: ['HTML', 'JAVA', 'SQL'] },
    ];

    // Program, Year, and Semester Options
    programOptions = [
        { label: 'All Programs', value: 'All Programs' },
        { label: 'Java Full Stack with React', value: 'Java Full Stack with React' },
        { label: 'Testing with Selenium using Java', value: 'Testing with Selenium using Java' },
        { label: 'MERN', value: 'MERN' },
        { label: 'Data Science', value: 'Data Science' },
        { label: 'DevOps', value: 'DevOps' }
    ];

    yearOptions = [
        { label: '2019-2020', value: '2019-2020' },
        { label: '2020-2021', value: '2020-2021' },
        { label: '2021-2022', value: '2021-2022' },
        { label: '2022-2023', value: '2022-2023' },
        { label: '2023-2024', value: '2023-2024' },
        { label: 'All Years', value: 'All Years' }
    ];

    semesterOptions = [
        { label: 'Sem 1', value: 'Sem 1' },
        { label: 'Sem 2', value: 'Sem 2' },
        { label: 'Sem 3', value: 'Sem 3' },
        { label: 'Sem 4', value: 'Sem 4' },
        { label: 'Sem 5', value: 'Sem 5' },
        { label: 'Sem 6', value: 'Sem 6' },
        { label: 'Sem 7', value: 'Sem 7' },
        { label: 'Sem 8', value: 'Sem 8' },
        { label: 'All Semesters', value: 'All Semesters' }
    ];

    // Lifecycle Hook
    connectedCallback() {
        this.updatePageList();
    }

    // Update Pagination List
    updatePageList() {
        this.pageList = [];

        // Always add the first two pages
        if(this.totalPages >= 1) {
            this.pageList.push(1);
        }

        if(this.totalPages >= 2){
            this.pageList.push(2);
        }

        // Add ellipsis if total pages greater than 2
        if (this.totalPages > 2) {
            this.pageList.push('...');
        }

        // Always add the last page
        if (this.totalPages >= 3) {
            this.pageList.push(this.totalPages);
        }
    }

    // Filtered Students
    get filteredStudents() {
        let filtered = this.allStudents;

        // Apply filters
        if (this.searchKey) {
            filtered = filtered.filter(student => student.name.toLowerCase().includes(this.searchKey.toLowerCase()));
        }
        if (this.selectedProgram !== 'All Programs') {
            filtered = filtered.filter(student => student.program === this.selectedProgram);
        }
        if (this.selectedYear !== 'All Years') {
            filtered = filtered.filter(student => student.year === this.selectedYear);
        }
        if (this.selectedSemester !== 'All Semesters') {
            filtered = filtered.filter(student => student.semester === this.selectedSemester);
        }

        // Update total pages for pagination
        this.totalPages = Math.ceil(filtered.length / this.rowsPerPage);
        this.updatePageList();

        // Return paginated results
        const start = (this.currentPage - 1) * this.rowsPerPage;
        const end = start + this.rowsPerPage;
        return filtered.slice(start, end);
    }

    // Pagination Helpers
    get isFirstPage() {
        return this.currentPage === 1;
    }

    get isLastPage() {
        return this.currentPage === this.totalPages;
    }

    // Event Handlers
    handleSearch(event) {
        this.searchKey = event.target.value;
        this.currentPage = 1; // Reset to first page after search
        this.updatePageList();
    }

    handleProgramChange(event) {
        this.selectedProgram = event.detail.value;
        this.currentPage = 1; // Reset to first page after filter change
        this.updatePageList();
    }

    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        this.currentPage = 1; // Reset to first page after filter change
        this.updatePageList();
    }

    handleSemesterChange(event) {
        this.selectedSemester = event.detail.value;
        this.currentPage = 1; // Reset to first page after filter change
        this.updatePageList();
    }

    handleNextPage() {
        if (!this.isLastPage) {
            this.currentPage++;
            this.updatePageList();
        }
    }

    handlePreviousPage() {
        if (!this.isFirstPage) {
            this.currentPage--;
            this.updatePageList();
        }
    }

    handlePageClick(event) {
        const selectedPage = event.target.dataset.page;
        if (selectedPage !== '...') {
            this.currentPage = Number(selectedPage);
            this.updatePageList();
        }
    }

    getPageClass(page) {
        if (page === '...') {
            return 'pagination-ellipsis';
        }
        return page === this.currentPage ? 'pagination-item active' : 'pagination-item';
    }
}