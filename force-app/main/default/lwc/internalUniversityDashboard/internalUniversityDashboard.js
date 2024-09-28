import { LightningElement, track, wire } from 'lwc';
import getMentors from '@salesforce/apex/DashBoardCtrl.getMentors';
import getUniversities from '@salesforce/apex/DashBoardCtrl.getUniversities';
import getUniversityWiseData from '@salesforce/apex/DashBoardCtrl.getUniversityWiseData';
import getChartColors from '@salesforce/apex/DashBoardCtrl.getChartColors';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chartJSLibrary';
import chartJsPluginDatalabels from '@salesforce/resourceUrl/ChartJsDataLabel';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import APSCHE_FIELD from '@salesforce/schema/Contact.APSCHE_Name__c';

export default class InternalUniversityDashboard extends LightningElement {
    @track selectedMentor;
    @track mentors=[];
    @track selectedUniversity;
    @track universities = [];
    @track showSpinner = true;
    @track showUniversityChart = false;
    @track showProgramWiseChart = false;
    @track showTotalCount =false;
    @track selectedUDLabel = '';
    chart;
    dataToChart;
    chartColors = [];
    @track apscheOptions=[];
    @track selectedApsche = false;
    @track showApscheFilter = false;
    @track totalStudents = 0;
    @track selectedCRTValue = false;

    @wire(getObjectInfo, { objectApiName: 'Contact' }) objectInfo;
    @wire(getPicklistValues, { recordTypeId: '$objectInfo.data.defaultRecordTypeId', fieldApiName: APSCHE_FIELD })
    wiredPicklistValues({ error, data }) {
        if (data) {
            this.apscheOptions = [{ label: 'All', value: '' }, ...data.values.map(item => {
                return { label: item.label, value: item.value };
            })];
        } else if (error) {
            console.error('Error fetching picklist values', error);
        }
        if (this.apscheOptions.length > 0) {
            this.selectedApsche = this.apscheOptions[0].value;
        }
    }

    connectedCallback() {
        this.fetchMentors();
        this.fetchChartColors();
        Promise.all([loadScript(this, CHARTJS)])
        .then(() => {
            console.log('Chartjs Loaded...');
            Promise.all([loadScript(this, chartJsPluginDatalabels)])
            .then(() => {
                console.log('Chartjs Data labels Loaded...');
            })
            .catch(error => {
                console.log('Unable to load Chartjs DataLabels');
            });
        })
        .catch(error => {
            console.log('Unable to load Chartjs');
        });
    }
    
    fetchChartColors() {
        getChartColors()
            .then(result => {
                this.chartColors = result.map(color => color.Color__c);
            })
            .catch(error => {
                console.error('Error fetching chart colors: ', error);
            });
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
        getUniversities({selectedCRTValue:this.selectedCRTValue,selectedMentor:this.selectedMentor})
            .then(result => {
                this.universities = [{ label: 'All', value: '' }, ...result.map(universityName => {
                    return { label: universityName, value: universityName };
                })];

                if(this.selectedCRTValue==false){
                    this.universities.push({ label: 'APSCHE', value: 'APSCHE' });
                }
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
    handleCRTChange(event) {
        this.selectedCRTValue = event.detail.checked;
        this.fetchMentors();
    }
    handleMentorChange(event) {
        this.selectedMentor = event.detail.value;
        this.fetchUniversities();
    }
    
    handleUniversityChange(event) {
        this.selectedUniversity = event.detail.value;
        if(this.selectedUniversity == 'APSCHE'){
            this.showApscheFilter = true;
        } else {
            this.showApscheFilter = false;
        }
    }

    handleAPSCHEChange(event){
        this.selectedApsche = event.detail.value;
    }

    handleSearch() {
        this.showSpinner = true;

        getUniversityWiseData({
            selectedCRTValue: this.selectedCRTValue,
            selectedMentor: this.selectedMentor,
            selectedUniversity: this.selectedUniversity,
            selectedApsche: this.selectedApsche
        })
        .then(result => {
            console.log('getUniveristies', result);
            this.showSpinner = false;
            this.showUniversityChart = true;
            this.showProgramWiseChart = false;
            this.dataToChart = result;
            this.showTotalCount=true;
            this.totalStudents = result.reduce((sum, item) => sum + item.uniqueStudents, 0); 
            this.initializeChart();
        })
        .catch(error => {
            console.error('Error fetching university-wise data: ', error);
            this.showSpinner = false;
        });
    }
    renderedCallback() {
        if (this.showUniversityChart && this.dataToChart) {
            this.initializeChart();
        }
    }

    initializeChart() {
        const ctx = this.template.querySelector('canvas.chart');
        if (!ctx) {
            return;
        }
        if (this.chart) {
            this.chart.destroy();
        }
        const labels = this.dataToChart.map(item => item.collegeOrUniversityName || item.APSCHEName || item.Year__c || 'Unknown');

        const counts = this.dataToChart.map(item => item.uniqueStudents);
        this.chart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: counts,
                    backgroundColor: this.chartColors.slice(0, labels.length),
                    borderColor: this.chartColors.slice(0, labels.length),
                    borderWidth: 1
                }]
            },
            options: {
                responsive: true,
                aspectRatio: 0,
                plugins: {
                    tooltip: {
                        callbacks: {
                            label: (context) => {
                                let label = context.label || '';
                                let value = context.raw || 0;
                                return `${label}: ${value}`;
                            }
                        }
                    },
                    datalabels: {
                        // color: '#FFFFFF',
                        // font: {
                        //     weight: 'bold',
                        //     size: 14
                        // },
                        // formatter: (value, ctx) => {
                        //     let label = ctx.chart.data.labels[ctx.dataIndex];
                        //     return `${label}\n${value}`;
                        // },
                        // anchor: 'center',
                        // align: 'center'
                        labels: {
                            title: {
                                color:'White',
                                font: {
                                       color: 'White',
                                        weight: 'bold',
                                        size: 14
                                },
                                formatter: (value, ctx) => {
                                        let label = ctx.chart.data.labels[ctx.dataIndex];
                                        return `${label}`;
                                    },
                                    anchor: 'center',
                                    align: 'right',
                                    position:'inside',
                                    rotation: -10
                            },

                            value: {
                              color: 'White',
                              font: {
                                    weight: 'bold',
                                    size: 14
                                }, 
                            }
                        }
                    }
                },
                onClick: (event, elements) => {
                    if (elements.length > 0) {
                        const chartElement = elements[0];
                        const index = chartElement._index;
                        const selectedLabel = this.chart.data.labels[index];
                        this.handleUniversityLabelClick(selectedLabel);
                        console.log('batchLabel',selectedLabel);
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
        this.chart.options.onClick = this.chart.options.onClick.bind(this);
    }
    

    handleUniversityLabelClick(selectedLabel) {
        this.selectedUDLabel = selectedLabel;
        this.showUniversityChart = false;
        this.showProgramWiseChart = true;
    }

    handleProgramChartClose(event){
        this.showUniversityChart = true;
        this.showProgramWiseChart = false;
        this.dataToChart = null;  
        this.chart = null;  
        this.handleSearch();
    }
}