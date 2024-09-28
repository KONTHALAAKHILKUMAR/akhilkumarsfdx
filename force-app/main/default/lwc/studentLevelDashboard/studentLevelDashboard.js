import { LightningElement, track, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class StudentLevelDashboard extends NavigationMixin(LightningElement) {
    @track showSpinner = false;
    @track showModal = true;
    @track studentData = [];
    @track showCompletionDateColumn = true;
    @track showProjectColumn = false;
    @track visibleRecords = [];
    @track _selectedModule = '';
    @track _selectedChart = '';
    @track isRecordAvailable = false;
    @track allRecords = [];
    
    @api
    get selectedModule() {
        return this._selectedModule;
    }

    set selectedModule(value) {
        this._selectedModule = value;
        console.log('Selected Module:', value); 
        this.updateColumns();
    }

    @api
    get selectedChart() {
        return this._selectedChart;
    }

    set selectedChart(value) {
        this._selectedChart = value;
        this.updateColumns();
    }

    @api
    set studentDetails(value) {
        this.studentData = value;
        this.allRecords = [...value];
        this.isRecordAvailable = this.allRecords.length > 0;
        this.updateVisibleRecords();
        console.log('Student Details Received:', value);
    }

    updateVisibleRecords() {
        if (this.allRecords.length > 0) {
            const start = 0;
            const end = this.recordSize || 50; 
            this.visibleRecords = this.allRecords.slice(start, end).map(student => {
                console.log('Student:', student.StudentName, 'hasMultipleInProgressModules:', student.hasMultipleInProgressModules);
    
                const rowClass = student.hasMultipleInProgressModules ? 'highlightRow' : 'slds-hint-parent';
                console.log('Assigning rowClass:', rowClass, 'for student:', student.StudentName);
    
                return {
                    ...student,
                    rowClass
                };
            });
    
            console.log('Visible Records:', this.visibleRecords);
        }
    }
    
    
    get studentClasses() {
        return this.visibleRecords.map(student => {
            return {
                ...student,
                rowClass: student.hasMultipleInProgressModules ? 'highlightRow' : 'slds-hint-parent'
            };
        });
    }
    
    
    get studentDetails() {
        return this.studentData;
    }

    get dynamicModuleStatusHeading() {
        return `${this._selectedModule} Status`;
    }

    get dynamicModuleCompletionDateHeading() {
        return `${this._selectedModule} Completion Date`;
    }

    updateColumns() {
        if (!this._selectedModule || !this._selectedChart || !this.studentData) {
            return;
        }

        if (this._selectedChart === 'courseProgress') {
            this.showCompletionDateColumn = false;
        } else if (this._selectedChart === 'project') {
            this.showProjectColumn = true;
            this.showCompletionDateColumn = false;
        } else {
            this.showCompletionDateColumn = true;
            this.showProjectColumn = false;
        }
    }

    handleCloseModal(event) {
        this.showModal = false;
        this.dispatchEvent(new CustomEvent('closestudentchart'));
    }

    handleStudentClick(event) {
        const studentId = event.target.getAttribute('data-id');
        const student = this.studentData.find(stu => stu.contactId === studentId);
        const studentUniversity = student ? student.studentUniversity : null;

        console.log('Navigating with - studentUniversity:', studentUniversity, ' studentId:', studentId);

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Student_Journey_Tree__c'
            },
            state: {
                selectedStudent: studentId,
                selectedUniversity: studentUniversity
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }

    handleUpdate(event) {
        this.visibleRecords = event.detail.records;
    }

    
}