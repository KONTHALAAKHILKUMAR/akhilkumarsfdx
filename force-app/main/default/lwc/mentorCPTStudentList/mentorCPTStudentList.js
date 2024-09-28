import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import MODULE_STATUS_FIELD from '@salesforce/schema/CourseProgress__c.Module_1_Status__c';
import getIncompleteModuleStatuses from '@salesforce/apex/MentorCourseProgressTracker.getIncompleteModuleStatuses';

export default class MentorCPTStudentList extends LightningElement {
    @track statusOptions = [];
    @track projectOptions = [];
    _resourceList = [];
    @track isModalOpen = false;
    @api recordId;
    totalModules;
    @api selectedCRTValue;
    @track showSpinner = false;
    @track moduleOptions = [];

    setProjectOptions() {
        if (this.selectedCRTValue === true) {
            this.projectOptions = [
                { label: 'Assigned', value: 'Assigned' },                
                { label: 'In progress', value: 'In progress' },
                { label: 'Completed', value: 'Completed' }
            ];
        } else {
            this.projectOptions = [
                { label: 'Not Applicable', value: 'Not Applicable' },
                { label: 'Applicable', value: 'Applicable' },
                { label: 'Assigned', value: 'Assigned' },                
                { label: 'In progress', value: 'In progress' },
                { label: 'Completed', value: 'Completed' }
            ];
        }
    }
    @api 
    set resourceList(value) {
        this._resourceList = value.map(record => {
            const moduleOptions = this.getModuleOptions(record.totalModules);
            const moduleNumber = record.moduleNumber || moduleOptions[0].value;
            return {
                ...record,
                moduleOptions,
                moduleNumber
               
            };
        });
        this.setProjectOptions();
    }
    get resourceList() {
        return this._resourceList;
        this.setProjectOptions();
    }

    @wire(getObjectInfo, { objectApiName: 'CourseProgress__c' }) objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: MODULE_STATUS_FIELD })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.statusOptions = data.values.map(item => {
                return { label: item.label, value: item.value };
            });
        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
    }


    getModuleOptions(totalModules) {
        let options = [];
        for (let i = 1; i <= totalModules; i++) {
            options.push({ label: `Module ${i}`, value: `Module${i}` });
        }
        return options;
    }

   
    handleProjectChange(event) {
        const recordId = event.currentTarget.dataset.id;
        const selectedProject = event.detail.value;
        const updatedResourceList = this._resourceList.map(record => {
            if (record.serialNumber === parseInt(recordId, 10)) {
                record.project = selectedProject;
            }
            return record;
        });
        this._resourceList = [...updatedResourceList];
        this.dispatchUpdateEvent();
    }

    handleCommentsChange(event) {
        const recordId = event.currentTarget.dataset.id;
        const comments = event.target.value;
        const updatedResourceList = this._resourceList.map(record => {
            if (record.serialNumber === parseInt(recordId, 10)) {
                record.comments = comments;
            }
            return record;
        });
        this._resourceList = [...updatedResourceList];
        this.dispatchUpdateEvent();
    }
    handlecourseFeedbackChange(event) {
        const recordId = event.currentTarget.dataset.id;
        const courseFeedback = event.target.value;
        const updatedResourceList = this._resourceList.map(record => {
            if (record.serialNumber === parseInt(recordId, 10)) {
                record.courseFeedback = courseFeedback;
            }
            return record;
        });
        this._resourceList = [...updatedResourceList];
        this.dispatchUpdateEvent();
    }

    dispatchUpdateEvent() {
        const updateEvent = new CustomEvent('saverecords', {
            detail: { records: this._resourceList }
        });
        this.dispatchEvent(updateEvent);
    }

    handleEditClick(event) {
        const recordId = event.currentTarget.dataset.id;
        this.recordId = recordId;
        this.totalModules = event.currentTarget.dataset.totalModules;
        this.showSpinner = true;
        
        getIncompleteModuleStatuses({ recordId: recordId, totalModules: this.totalModules })
            .then(result => {
                this.showSpinner = false;
                if (result) {
                    this.moduleOptions = result;
                    this.isModalOpen = true;
                    
                }
            })
            .catch(error => {
                this.showSpinner = false;
                console.error('Error fetching course progress', error);
            });
    }
    
    

    handleCloseModal() {
        this.isModalOpen = false;
        this.selectedRecord = null;
    }

    handleStatusUpdate(event) {
        this.dispatchEvent(new CustomEvent('statusupdate'));
        this.isModalOpen = false;
    }
    
}