import { LightningElement, api, track, wire } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import MODULE_STATUS_FIELD from '@salesforce/schema/CourseProgress__c.Module_1_Status__c';
import updateCourseProgress from '@salesforce/apex/MentorCourseProgressTracker.updateCourseProgress';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class MentorCPTTrackerStatusUpdate extends LightningElement {
    @api recordId;
    @api totalModules;
    _moduleOptions = [];
    @track formattedModuleOptions = [];
    @track statusOptions = [];
    @track selectedModuleNumbers= [];
    @track status;
    @track completedDate;
    @track moduleGrade;
    @track moduleFeedback;
    @track showSpinner = false;

    @api
    get moduleOptions() {
        return this._moduleOptions;
    }

    set moduleOptions(value) {
        if (value && Array.isArray(value) && value.length > 0) {
            this._moduleOptions = value;
            this.formatModuleOptions();
        } else {
            console.error('moduleOptions set with undefined or empty value');
        }
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

    connectedCallback() {
        this.completedDate = this.formatDate(new Date());
    }

    formatDate(date) {
        let month = '' + (date.getMonth() + 1);
        let day = '' + date.getDate();
        const year = date.getFullYear();

        if (month.length < 2) 
            month = '0' + month;
        if (day.length < 2) 
            day = '0' + day;

        return [year, month, day].join('-');
    }

    formatModuleOptions() {
        if (this._moduleOptions && this._moduleOptions.length > 0) {
            this.formattedModuleOptions = this._moduleOptions.map(module => {
                return { label: module, value: module };
            });
        } else {
            console.error('formatModuleOptions: moduleOptions is not defined or empty');
        }
    }

    handleModuleChange(event) {
        this.selectedModuleNumbers = event.detail.value;
    }

    handleStatusChange(event) {
        this.status = event.detail.value;
        if (this.status === 'Completed') {
            this.completedDate = this.formatDate(new Date());
        } else {
            this.completedDate = null;
        }
    }
    handleModuleGradeChange(event){
       this.moduleGrade = event.detail.value;
    }
    handleModuleFeedbackChange(event){
        this.moduleFeedback = event.detail.value;
     }
 
    handleCloseModal() {
        this.dispatchEvent(new CustomEvent('closemodal'));
    }

    handleDateChange(event) {
        this.completedDate = event.target.value;
    }

    showNotification(title, message, varient) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: varient
        });
        this.dispatchEvent(evt);
    }

    handleUpdate() {
        this.showSpinner = true;
        const updatedRecord = {
            Id: this.recordId,
            selectedModuleNumbers: this.selectedModuleNumbers,
            status: this.status,
            completedDate: this.completedDate,
            moduleGrade: this.moduleGrade,
            moduleFeedback: this.moduleFeedback
        };


        updateCourseProgress({ updates: [updatedRecord] })
            .then(() => {
                this.showSpinner = false;
                this.handleCloseModal();
                this.dispatchEvent(new CustomEvent('statusupdate'));
                this.showNotification("Success", "Updated successfully!", "success");
            })
            .catch(error => {
                this.showSpinner = false;
                console.error('Error updating course progress:', error);
                this.showNotification("Error", "Error Updating Status.", "error");
            });
    }

    get isUpdateDisabled() {
        const today = new Date();
        const selectedDate = new Date(this.completedDate);
    
        if (this.formattedModuleOptions.length === 0 || selectedDate > today || !this.selectedModuleNumbers || !this.status) {
            return true;
        }
    
        if (this.status === 'Completed' && (!this.moduleGrade || !this.moduleFeedback)) {
            return true;
        }
    
        return false;
    }

    get isCompletionDateDisabled() {
        return this.status !== 'Completed';
    }
}