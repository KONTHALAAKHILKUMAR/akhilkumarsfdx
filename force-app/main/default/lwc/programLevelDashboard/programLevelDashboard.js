import { LightningElement, api, track, wire } from 'lwc';
import getProgramWiseData from '@salesforce/apex/DashBoardCtrl.getProgramWiseData';
import getChartColors from '@salesforce/apex/DashBoardCtrl.getChartColors';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chartJSLibrary';
import chartJsPluginDatalabels from '@salesforce/resourceUrl/ChartJsDataLabel';

export default class ProgramLevelDashboard extends LightningElement {
    @api selectedMentor;
    @api selectedUniversity;
    @api selectedUDLabel;
    @api selectedApsche;
    @api selectedCRTValue;
    @track showSpinner = false;
    @track chartColors = [];
    chart;
    @track showProgramWiseChart = false;
    @track showModuleWiseChart = false;
    @track dataToChart;
    @track showCourseFilter = true;
    @track totalStudents=0;
    
    connectedCallback() {
        this.showSpinner = true;        
        this.fetchChartColors();
        Promise.all([loadScript(this, CHARTJS)])
        .then(() => {
            console.log('Chartjs Loaded...');
            Promise.all([loadScript(this, chartJsPluginDatalabels)])
            .then(() => {
                this.showProgramWiseChart = true;
                this.fetchData();
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
                if (this.showProgramWiseChart) {
                    this.fetchData();
                }
            })
            .catch(error => {
                console.error('Error fetching chart colors: ', error);
            });
    }


    fetchData() {
        if (!this.showProgramWiseChart || this.chartColors.length === 0) {
            return;
        }
        console.log('selectedCRTValue:', this.selectedCRTValue);
        console.log('selectedMentor:', this.selectedMentor);
        console.log('selectedApsche:', this.selectedApsche);
        console.log('selectedUniversity:', this.selectedUniversity);
        console.log('selectedUDLabel:', this.selectedUDLabel);
        getProgramWiseData({
            selectedCRTValue: this.selectedCRTValue,
            selectedMentor: this.selectedMentor,
            selectedUniversity: this.selectedUniversity,
            selectedUDLabel: this.selectedUDLabel,
            selectedApsche: this.selectedApsche
        })
        .then(result => {
            console.log(result);
            this.showSpinner = false;
            this.dataToChart = result.programWiseData;  
            this.totalStudents = result.totalUniqueStudents; 
            this.initializeChart();
            this.showTotalCount = true;
        })
        .catch(error => {
            this.showSpinner = false;
            console.error('Error fetching data', error);
        });
    }
    
    
    


    initializeChart() {
        const ctx = this.template.querySelector('canvas.chart');
        if (!ctx || !this.dataToChart || this.dataToChart.length === 0) {
            return;
        }
    
        if (this.chart) {
            this.chart.destroy();
        }
        const labels = this.dataToChart.map(item => item.Name);
        const counts = this.dataToChart.map(item => item.uniqueStudents);
    
        this.chart = new Chart(ctx, {
            type: 'pie',
            data: {
                labels: labels,
                datasets: [{
                    data: counts,
                    backgroundColor: this.chartColors.slice(0, labels.length)
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
                                        weight: 'bold',
                                        size: 12
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
                        const programLabel = this.chart.data.labels[index];
                        this.handleprogramClick(programLabel);
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
        this.chart.options.onClick = this.chart.options.onClick.bind(this);
    }
    
    renderedCallback() {
        if (this.showProgramWiseChart && this.dataToChart) {
            const ctx = this.template.querySelector('canvas.chart');
            if (ctx && !this.chart) {
                this.initializeChart();
            }
        }
    }

    handleprogramClick(programLabel) {
        this.selectedProgram = programLabel;
        console.log('selectedProgram: ', this.selectedProgram);
        this.showProgramWiseChart = false;
        this.showCourseFilter = false;
        this.showModuleWiseChart = true;
    }

    handleProgramChartClose(event) {
        this.dispatchEvent(new CustomEvent('closeprogramchart'));
    }

    handleModuleChartClose(event) {
        this.showProgramWiseChart = true;
        this.showCourseFilter = true;
        this.showModuleWiseChart = false;
        this.dataToChart = null;  
        this.chart = null;  
        this.fetchData();  
    }
}