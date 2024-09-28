import { LightningElement, api } from 'lwc';

export default class ModulePath extends LightningElement {
    @api course;
    modules = [
        { id: 1, name: 'Module 1', status: 'Completed', color: this.getModuleStatusColor('Completed') },
        { id: 2, name: 'Module 2', status: 'In Progress', color: this.getModuleStatusColor('In Progress') },
        { id: 3, name: 'Module 3', status: 'Not Started', color: this.getModuleStatusColor('Not Started') }
    ];

    handleClose() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    getModuleStatusColor(status) {
        switch (status) {
            case 'Completed': return '#4CAF50';
            case 'In Progress': return '#FFC107';
            case 'Not Started': return '#9C27B0';
            default: return '#333333';
        }
    }
}