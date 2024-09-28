import { LightningElement, api, wire, track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';
import getStudentData from '@salesforce/apex/StudentJourneyTrackerCtrl.getStudentData';

export default class StudentJourneyTree extends LightningElement {
    @track items = [];
    @track showModal = false;
    @track moduleItems = [];
    @track selectedModule = null;
    moduleData = {};
    selectedStudent;
    selectedUniversity;

    @wire(CurrentPageReference)
    getStateParameters(currentPageReference) {
        if (currentPageReference) {
            this.selectedStudent = currentPageReference.state.selectedStudent;
            console.log('this.selectedStudent',this.selectedStudent);
            this.selectedUniversity = currentPageReference.state.selectedUniversity;
            console.log('this.selectedUniversity ',this.selectedUniversity );
        }
    }

    @wire(getStudentData, { selectedUniversity: '$selectedUniversity', selectedStudent: '$selectedStudent' })
    wiredStudentData({ error, data }) {
        if (data) {
            this.processData(data);
            console.log('wiredStudentData',data);
        } else if (error) {
            console.error(error);
        }
    }

    processData(data) {
        let programs = {};
        let studentName = '';
    
        data.forEach(record => {
            studentName = record.Student__r.Name;
            let programName = record.Program__r.Name;
            if (!programs[programName]) {
                programs[programName] = {
                    studentName: studentName,
                    label: programName,
                    name: programName,
                    expanded: true,
                    items: []
                };
            }
            let courseName = record.Course__r.Name;
            let courseFeedback = record.Course_Feedback__c; 
            let modules = [];
            let moduleStatuses = [];
            for (let i = 1; i <= record.Course__r.No_of_Modules__c; i++) {
                let moduleName = `Module_${i}_Status__c`;
                let moduleStatus = record[moduleName];
                if (moduleStatus ) {
                    modules.push({
                        label: `Module ${i}`,
                        name: `${courseName}_module_${i}`,
                        status: moduleStatus,
                        statusClass: this.getStatusClass(moduleStatus),
                        completionDate: record[`Module${i}_Completion_Date__c`],
                        feedback: record[`Module_${i}_feedback__c`],                        
                        grade: record[`Module_${i}_Grade__c`]
                    });
                    moduleStatuses.push(moduleStatus);
                }
            }
            this.moduleData[courseName] = modules;
    
            let courseStatus = this.calculateCourseStatus(moduleStatuses);
            let statusClass = this.getCourseStatusClass(courseStatus);
    
            programs[programName].items.push({
                label: courseName,
                courseStatus: courseStatus,
                name: courseName,
                expanded: false,
                items: [],
                statusClass: statusClass,
                record: record,
                courseFeedback: courseFeedback 
            });
        });
    
        this.items = Object.values(programs);
    }

    calculateCourseStatus(moduleStatuses) {
        if (moduleStatuses.every(status => status === 'Completed')) {
            return 'Completed';
        } else if (moduleStatuses.every(status => status === 'Not Yet Started')) {
            return 'Not Yet Started';
        } else if (moduleStatuses.some(status => status === 'In Progress')) {
            return 'In Progress';
        } else {
            return 'In Progress';
        }
    }

    getCourseStatusClass(status) {
        if (status === 'Completed') {
            return 'course-completed';
        } else if (status === 'In Progress') {
            return 'course-inprogress';
        } else if (status === 'Not Yet Started') {
            return 'course-notstarted';
        }
        return '';
    }

   handleCourseSelect(event) {
        const selectedItem = event.currentTarget.dataset.name;
        const selectedCourse = this.findCourseDetails(selectedItem);
        if (selectedCourse) {
            this.moduleItems = this.moduleData[selectedCourse.name] || [];
            this.selectedModule = this.moduleItems[0];
            this.courseFeedback = selectedCourse.courseFeedback; 
            console.log('this.selectedModule', this.selectedModule);
            this.showModal = true;
        }
    }

    findCourseDetails(selectedItem) {
        for (let program of this.items) {
            for (let course of program.items) {
                if (course.name === selectedItem) {
                    return course;
                }
            }
        }
        return null;
    }

    getStatusClass(status) {
        if (status === 'Not Yet Started') {
            return 'slds-path__item slds-is-incomplete';
        } else if (status === 'In Progress') {
            return 'slds-path__item slds-is-current slds-is-active';
        } else if (status === 'Completed') {
            return 'slds-path__item slds-is-complete';
        }
        return 'slds-path__item slds-is-incomplete';
    }

    handleModuleSelect(event) {
        event.preventDefault();
        event.stopPropagation();

        const moduleName = event.currentTarget.dataset.name;
        this.selectedModule = this.moduleItems.find(module => module.name === moduleName);
        console.log('moduleName', moduleName);
    }

    closeModal() {
        this.showModal = false;
    }
}