import { LightningElement, track, wire } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getUniversities from '@salesforce/apex/StudentJourneyTrackerCtrl.getUniversities';
import getStudentData from '@salesforce/apex/StudentJourneyTrackerCtrl.getStudentData';

export default class StudentJourneyTracker extends NavigationMixin(LightningElement) {
    @track selectedUniversity;
    @track universities = [];
    @track showSpinner = false;
    @track selectedStudent;
    @track studentData;
    @track showStudentProgress = false;

    @track matchingInfo = {
        primaryField: {
            fieldPath: 'Name'
        },
        additionalFields: [{
            fieldPath: 'Email'
        }]
    }

    get filterCriteria() {
        return {
            criteria: [{
                fieldPath: 'AccountId',
                operator: 'eq',
                value: this.selectedUniversity
            }]
        };
    }

    displayInfo = {
        primaryField: 'Name',
        additionalFields: ['Email'],
    };

    connectedCallback() {
        this.fetchUniversities();
    }

    fetchUniversities() {
        this.showSpinner = true;
        getUniversities()
            .then(result => {
                this.universities = result.map(account => {
                    return { label: account.Name, value: account.Id };
                });
                if (this.universities.length > 0) {
                    this.selectedUniversity = this.universities[0].value;
                }
                this.showSpinner = false;
            })
            .catch(error => {
                console.error('Error fetching universities: ', error);
                this.showSpinner = false;
            });
    }

    handleUniversityChange(event) {
        this.selectedUniversity = event.detail.value;
        console.log('selectedUniversity ', this.selectedUniversity);
    }

    handleStudentSelect(event) {
        this.selectedStudent = event.detail.recordId;
        console.log('selectedStudent',this.selectedStudent);
    }

    handleSearch() {
        this.showSpinner = true;
        getStudentData({
            selectedUniversity: this.selectedUniversity,
            selectedStudent: this.selectedStudent
        })
        .then(result => {
            console.log('handleSearch', result);
            this.studentData = result[0]; 
            this.showSpinner = false;
        })
        .catch(error => {
            console.error('Error fetching student data: ', error);
            this.showSpinner = false;
        });
    }

    handleStudentProgress() {
        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Student_Journey_Tree__c'
            },
            state: {
                selectedStudent: this.selectedStudent,
                selectedUniversity: this.selectedUniversity
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }
}