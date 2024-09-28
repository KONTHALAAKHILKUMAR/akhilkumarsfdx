import { LightningElement, track, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import APSCHE_FIELD from '@salesforce/schema/Contact.APSCHE_Name__c';
import getUniversities from '@salesforce/apex/MentorCourseProgressTracker.getUniversities';
import getMentors from '@salesforce/apex/MentorCourseProgressTracker.getMentors';
import getPrograms from '@salesforce/apex/MentorCourseProgressTracker.getPrograms';
import getCourses from '@salesforce/apex/MentorCourseProgressTracker.getCourses';
import getData from '@salesforce/apex/MentorCourseProgressTracker.getData';
import updateCourseProgress from '@salesforce/apex/MentorCourseProgressTracker.updateCourseProgress';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MentorCourseProgressTracker extends LightningElement {
    @track selectedUniversity;
    @track universities = [];
    @track apscheOptions = [{ label: 'All', value: '' }];
    @track selectedAPSCHE='';
    @track selectedMentor = '';
    @track selectedProgram = '';
    @track programs = [{ label: 'All', value: '' }];
    @track selectedCourse = '';
    @track courses = [{ label: 'All', value: '' }];
    @track showSpinner = true;
    @track visibleRecords = [];
    @track isRecordAvailable = false;
    @track recordsToUpdate = [];
    @track allRecords = [];
    @track showApscheFilter = false;
    @track isCRTSelected = false;
    @track selectedCRTValue = false;

    @track years=[
        { label: 'All', value: '' },
        { label: 'II', value: 'II' },
        { label: 'III', value: 'III' },
        { label: 'IV', value: 'IV' }

    ];
    @track selectedYear= this.years[0].value;
   
    connectedCallback(){
        this.fetchMentors();
    }

    @wire(getObjectInfo, { objectApiName: 'Contact' }) objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: APSCHE_FIELD })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.apscheOptions = [{ label: 'All', value: '' }, ...data.values.map(item => {
                return { label: item.label, value: item.value };
            })];
            if (this.apscheOptions.length > 0) {
                this.selectedAPSCHE = this.apscheOptions[0].value;
                this.fetchPrograms();
            }
        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }
   

    fetchMentors() {
        this.showSpinner = true;
        getMentors({ selectedCRTValue: this.selectedCRTValue })
            .then((result) => {
                console.log('getMentors', result);
                this.mentors = result.map(mentorName => {
                    return { label: mentorName, value: mentorName };
                });
                if (this.mentors.length > 0) {
                    this.selectedMentor = this.mentors[0].value;
                    this.fetchUniversities();
                }
                this.showSpinner = false;
            })
            .catch((error) => {
                console.error('Error fetching mentors: ', error);
                this.showSpinner = false;
            });
    }
    

    fetchUniversities() {
        this.showSpinner = true;
        getUniversities({selectedCRTValue: this.selectedCRTValue , selectedMentor: this.selectedMentor })
            .then((result) => {
                this.universities = [{ label: 'All', value: '' }, ...result.map(universityName => {
                    return { label: universityName, value: universityName };
                })];
                if(this.selectedCRTValue==false){
                    this.universities.push({ label: 'APSCHE', value: 'APSCHE' });
                }
                if (this.universities.length > 0) {
                    this.selectedUniversity = this.universities[0].value;
                    this.fetchPrograms(); 
                }
                this.showSpinner = false;
            })
            .catch((error) => {
                console.error('Error fetching universities: ', error);
                this.showSpinner = false;
            });
    }
    
    fetchPrograms() {
        this.showSpinner = true;
        const universityId = this.selectedUniversity || null;
        console.log( this.selectedCRTValue,this.selectedMentor,universityId,this.selectedAPSCHE,this.selectedYear);
        getPrograms({ selectedCRTValue: this.selectedCRTValue ,selectedMentor: this.selectedMentor, 
            selectedUniversity: universityId, 
            selectedAPSCHE: this.selectedAPSCHE,
            selectedYear: this.selectedYear
         })
            .then((result) => {
                console.log('getPrograms',result);
                this.programs = [{ label: 'All', value: '' }, ...result.map(program => {
                    return { label: program, value: program };
                })];
                if(this.programs.length > 0) {
                    this.fetchCourses(); 
                }
                this.showSpinner = false;
            })
            .catch((error) => {
                console.error('Error fetching programs: ', error);
                this.showSpinner = false;
            });
    }
    
    
    

    fetchCourses() {
        const universityId = this.selectedUniversity || null; 
        getCourses({
            selectedCRTValue: this.selectedCRTValue ,
            selectedMentor: this.selectedMentor,
            selectedUniversity: universityId,
            selectedAPSCHE: this.selectedAPSCHE,
            selectedYear: this.selectedYear,
            selectedProgram: this.selectedProgram 
        })
        .then((result) => {
            console.log('getCourses',result);

            this.courses = [{ label: 'All', value: '' }, ...result.map(course => {
                return { label: course, value: course };
            })];
            this.showSpinner = false;
        })
        .catch((error) => {
            console.error('Error fetching courses: ', error);
            this.showSpinner = false;
        });
    }
    handleCRTChange(event) {
        this.selectedCRTValue = event.target.checked;
        if(this.selectedCRTValue==true){
            this.isCRTSelected=true;
            this.showApscheFilter=false;
        }else{
            this.isCRTSelected=false;
            this.showApscheFilter=false;
        }
        this.fetchMentors();
    }
    handleMentorChange(event) {
        this.selectedMentor = event.detail.value;
        this.fetchUniversities();
    }

    handleUniversityChange(event) {
        this.selectedUniversity = event.detail.value;
    
        if (this.selectedUniversity === 'APSCHE') {
            this.showApscheFilter = true;
            this.isCRTSelected = false; 
        } 
    
        this.fetchPrograms();
        this.fetchCourses();
    }
    

    handleAPSCHEChange(event) {
        this.selectedAPSCHE = event.detail.value;
        this.fetchPrograms();
    }
    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        console.log('this.selectedYear',this.selectedYear);
        this.fetchPrograms();
    }


    handleProgramChange(event) {
        this.selectedProgram = event.detail.value;
        this.fetchCourses();
    }

    handleCourseChange(event) {
        this.selectedCourse = event.detail.value;
    }

    handleStatusUpdate() {
        this.handleSearch();
    }

    handleSearch() {
        this.showSpinner = true;

        getData({
            selectedCRTValue: this.selectedCRTValue,
            selectedUniversity: this.selectedUniversity,
            selectedAPSCHE: this.selectedAPSCHE ? this.selectedAPSCHE : '',
            selectedYear: this.selectedYear ? this.selectedYear : '',
            selectedMentor: this.selectedMentor,
            selectedProgram: this.selectedProgram,
            selectedCourse: this.selectedCourse
        })
        .then((result) => {
            console.log('getData',result);
            if (result && result.length > 0) {
                this.allRecords = result;
                this.isRecordAvailable = true;
            } else {
                this.allRecords = [];
                this.isRecordAvailable = false;
            }
            this.showSpinner = false;
        })
        .catch((error) => {
            console.error('Error fetching data: ', error);
            this.showSpinner = false;
        });
    }

    getModuleOptions(totalModules) {
        let options = [];
        for (let i = 1; i <= totalModules; i++) {
            options.push({ label: `Module ${i}`, value: `Module${i}` });
        }
        return options;
    }

    handleSave() {
        this.showSpinner = true;
        updateCourseProgress({ updates: this.recordsToUpdate })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Saved successfully!',
                        variant: 'success',
                    })
                );
                this.showSpinner = false;
                this.handleSearch();
            })
            .catch(error => {
                console.error('Error updating records', error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error',
                        message: 'Error updating course progress',
                        variant: 'error',
                    })
                );
                this.showSpinner = false;
            });
    }

    handleUpdateRecords(event) {
        this.recordsToUpdate = event.detail.records;
    }

    handleUpdate(event) {
        this.visibleRecords = event.detail.records;
    }
}