import { LightningElement } from 'lwc';

export default class Akhiltestcase extends LightningElement {
    searchValue = '';
    currentPage = 1;
    rowsPerPage = 6;

    rows = [
        { id: '01', name: 'KJC Tech College', programs: 15, students: 100, mentor: 15 },
        { id: '02', name: 'KJC Tech College', programs: 9, students: 500, mentor: 9 },
        { id: '03', name: 'KJC Tech College', programs: 10, students: 800, mentor: 10 },
        // Add more rows here...
    ];

    columns = [
        { label: 'S. No', fieldName: 'id', type: 'text' },
        { label: 'Name of University', fieldName: 'name', type: 'text' },
        { label: 'No. Programs offered', fieldName: 'programs', type: 'number' },
        { label: 'Students', fieldName: 'students', type: 'number' },
        { label: 'Mentor', fieldName: 'mentor', type: 'number' }
    ];

    get filteredRows() {
        const filtered = this.rows.filter(row =>
            row.name.toLowerCase().includes(this.searchValue.toLowerCase())
        );
        const start = (this.currentPage - 1) * this.rowsPerPage;
        const end = start + this.rowsPerPage;
        return filtered.slice(start, end);
    }

    handleSearchChange(event) {
        this.searchValue = event.target.value;
        this.currentPage = 1; // Reset to the first page on search
    }

    handleSearch() {
        // Search functionality logic
    }

    prevPage() {
        if (this.currentPage > 1) {
            this.currentPage--;
        }
    }

    nextPage() {
        if ((this.currentPage - 1) * this.rowsPerPage < this.rows.length) {
            this.currentPage++;
        }
    }
}