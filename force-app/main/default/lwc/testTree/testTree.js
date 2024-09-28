import { LightningElement } from 'lwc';
import CHARTJS from '@salesforce/resourceUrl/chartJSLibrary';
import { loadScript } from 'lightning/platformResourceLoader';
import chartJsPluginDatalabels from '@salesforce/resourceUrl/ChartJsDataLabel';
import profilePic from '@salesforce/resourceUrl/profilePic';
import leftArrow from '@salesforce/resourceUrl/LeftArrow';
import rightArrow from '@salesforce/resourceUrl/RightArrow';

export default class TestTree extends LightningElement {
    leftArrow = leftArrow;
    rightArrow = rightArrow;
    chart;
    profileImageUrl = profilePic; 
    currentStartIndex = 0;
    semestersPerPage = 5;

    yearOptions = [
        { label: 'I', value: 'I' },
        { label: 'II', value: 'II' },
        { label: 'III', value: 'III' },
        { label: 'IV', value: 'IV' },
        { label: 'All Years', value: 'All Years' }
    ];

    yearValue = 'All Years';

    semesters = [
        { label: 'Sem - 1 (2023)' },
        { label: 'Sem - 2 (2023)' },
        { label: 'Sem - 3 (2024)' },
        { label: 'Sem - 4 (2024)' },
        { label: 'Sem - 5 (2025)' },
        { label: 'Sem - 6 (2025)' },
        { label: 'Sem - 7 (2026)' },
        { label: 'Sem - 8 (2026)' }
    ];

    get visibleSemesters() {
        return this.semesters.slice(this.currentStartIndex, this.currentStartIndex + this.semestersPerPage);
    }

    handleNext() {
        if (this.currentStartIndex + this.semestersPerPage < this.semesters.length) {
            this.currentStartIndex += this.semestersPerPage;
        }
    }

    handlePrevious() {
        if (this.currentStartIndex > 0) {
            this.currentStartIndex -= this.semestersPerPage;
        }
    }

    handleYearChange(event) {
        this.yearValue = event.detail.value;        
    }

    connectedCallback() {
        if (this.chart) {
            return;
        }
        Promise.all([loadScript(this, CHARTJS)])
        .then(() => {
            console.log('Chartjs Loaded...');
            Promise.all([loadScript(this, chartJsPluginDatalabels)])
            .then(() => {
                this.initializeChart();
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

    initializeChart() {
        const ctx = this.template.querySelector('canvas').getContext('2d');
        this.chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ['Html Java sql', 'Html Java sql', 'Html Java sql', 'Html Java sql', 'Html Java sql'],
                datasets: [{
                    label: 'Percentage',
                    data: [60, 80, 40, 70, 90],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.6)',
                        'rgba(54, 162, 235, 0.6)',
                        'rgba(255, 206, 86, 0.6)',
                        'rgba(75, 192, 192, 0.6)',
                        'rgba(153, 102, 255, 0.6)'
                    ],
                    borderColor: [
                        'rgba(255, 99, 132, 1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)'
                    ],
                    borderWidth: 2,
                    borderSkipped: 'bottom'
                }]
            },
            options: {
                scales: {
                    y: {
                        beginAtZero: true,
                        ticks: {
                            stepSize: 20
                        },
                        grid: {
                            display: false
                        }
                    },
                    x: {
                        ticks: {
                            display: false,
                            autoSkip: false
                        },
                        grid: {
                            display: false
                        }
                    }
                },
                plugins: {
                    legend: {
                        display: false
                    },
                    datalabels: {
                        anchor: 'end',
                        align: 'end',
                        formatter: value => `${value}%`,
                        color: '#fff',
                        font: {
                            weight: 'bold',
                            size: 14,
                            family: 'Arial'
                        }
                    }
                }
            },
            plugins: [ChartDataLabels]
        });
    }
}