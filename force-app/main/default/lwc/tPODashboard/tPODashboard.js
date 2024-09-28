import { LightningElement ,track,api} from 'lwc';
import getUniversities from '@salesforce/apex/TPODashboardCtrl.getUniversities';
import getYearWiseStudentCount from '@salesforce/apex/TPODashboardCtrl.getYearWiseStudentCount';
import getPrograms from '@salesforce/apex/TPODashboardCtrl.getPrograms';
import getModuleWiseData from '@salesforce/apex/TPODashboardCtrl.getModuleWiseData';
import getCourses from '@salesforce/apex/TPODashboardCtrl.getCourses';
import getChartColors from '@salesforce/apex/TPODashboardCtrl.getChartColors';
import { loadScript } from 'lightning/platformResourceLoader';
import CHARTJS from '@salesforce/resourceUrl/chartJSLibrary';
import chartJsPluginDatalabels from '@salesforce/resourceUrl/ChartJsDataLabel';

export default class TPODashboard extends LightningElement {
    @track selectedMentor;
    @track selectedUDLabel;
    @track universities=[];
    @track selectedUniversity;
    @track selectedProgram='';
    @track programs=[];
    @track selectedModule;
    @track selectedChart;
    @track mentors=[];
    chart;
    dataToChart;
    chartColors = [];
    @track totalStudents = 0;
    @track years=[
        { label: 'II', value: 'II' },
        { label: 'III', value: 'III' },
        { label: 'IV', value: 'IV' }

    ];
    @track selectedYear= this.years[0].value;
    @track chartData = {
        aheadOfSchedule: {},
        asPerTheSchedule: {},
        laggingBehind: {},
        courseProgress: {}
    };
    chart = {
        aheadOfSchedule: null,
        asPerTheSchedule: null,
        laggingBehind: null,
        courseProgress: null
    };
    @track showSpinner = true;
    @track showModuleWiseChart = false;
    @track showStudentLevelChart = false;
    @track chartColors = [];
    @track moduleData = {};
    @track selectedCourse='';
    @track courseOptions = [];
    @track showTotalCount =false;
    @track totalStudents=0;
    @track selectedYrStudentCount=0;
    @track selectedPrStudentCount=0;

    connectedCallback() {
        this.fetchUniversities();
        Promise.all([loadScript(this, CHARTJS)])
        .then(() => {
            console.log('Chartjs Loaded...');
            Promise.all([loadScript(this, chartJsPluginDatalabels)])
            .then(() => {
                this.fetchChartColorsAndData();
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
    

    fetchUniversities() {
        this.showSpinner = true;
        getUniversities({})
            .then(result => {
                const universityStudentCounts = result.universityStudentCounts;
                this.universities = Object.keys(universityStudentCounts).map(universityName => {
                    return { label: universityName, value: universityName, studentCount: universityStudentCounts[universityName] };
                });
    
                if (this.universities.length > 0) {
                    this.selectedUniversity = this.universities[0].value;
                    this.updateSelectedUniversityCount();
                    this.fetchPrograms();
                    this.fetchCourses();
                } else {
                    this.totalStudents = 0;
                }
    
                
                this.showSpinner = false;
            })
            .catch(error => {
                console.error('Error fetching universities: ', error);
                this.showSpinner = false;
            });
    }
    
    updateSelectedUniversityCount() {
        const selectedUniversityData = this.universities.find(univ => univ.value === this.selectedUniversity);
        if (selectedUniversityData) {
            this.totalStudents = selectedUniversityData.studentCount;
        } else {
            this.totalStudents = 0;
        }
    }
    
    handleUniversityChange(event) {
        this.selectedUniversity = event.detail.value;
        if(this.selectedUniversity!=''){
            this.updateSelectedUniversityCount();
            this.fetchPrograms();
        }
    }

    handleYearChange(event) {
        this.selectedYear = event.detail.value;
        if (this.selectedUniversity) {
            if (this.selectedYear) {
                getYearWiseStudentCount({
                    selectedUniversity: this.selectedUniversity,
                    selectedYear: this.selectedYear
                })
                .then(result => {
                    this.selectedYrStudentCount = result[this.selectedYear] || 0;
                })
                .catch(error => {
                    console.error('Error fetching YearWiseStudentCount: ', error);
                });
            }
            this.fetchPrograms();
            this.fetchCourses();
        }
    }
    
    
    handleCourseChange(event) {
        this.selectedCourse = event.detail.value;
    }


    fetchPrograms() {

        this.showSpinner = true;
        getPrograms({
            selectedUniversity: this.selectedUniversity
        })
        .then((result) => {
            this.programWiseStudentCount = result.programWiseStudentCount; 
            this.programs = [...Object.keys(this.programWiseStudentCount).map(program => {
                return { label: program, value: program };
            })];

            if (this.programs.length > 0) {
                this.selectedProgram = this.programs[0].value;
                this.updateSelectedProgramStudentCount();
            }
            this.fetchCourses();
            this.showSpinner = false;
        })
        .catch((error) => {
            console.error('Error fetching programs: ', error);
            this.showSpinner = false;
        });
    }

    handleProgramChange(event) {
        this.selectedProgram = event.detail.value;
        this.updateSelectedProgramStudentCount();
        this.fetchCourses();
    }

    updateSelectedProgramStudentCount() {
        if (this.selectedProgram !== '') {
            this.selectedPrStudentCount = this.programWiseStudentCount[this.selectedProgram] || 0;
        } else {
            this.selectedPrStudentCount = 0;
        }
    }
    

    fetchCourses() {
        this.showSpinner = true;
        getCourses({
            selectedUniversity: this.selectedUniversity, 
            selectedYear: this.selectedYear,
            selectedProgram:this.selectedProgram
        })
        .then(data => {
            this.courseOptions = [                
                ...data.map(course => ({
                    label: course,
                    value: course
                }))
            ];
    
            if (this.courseOptions.length > 0) {
                this.selectedCourse = this.courseOptions[0].value;
            } else {
                this.showModuleWiseChart = false;
            }
            this.showSpinner = false;
        })
        .catch(error => {
            console.error('Error fetching course options', error);
            this.showSpinner = false;
            this.showModuleWiseChart = false;
        });
    }

    handleSearch() {
        this.showSpinner = true;
        getYearWiseStudentCount({
            selectedUniversity: this.selectedUniversity,
            selectedYear: this.selectedYear
        })
        .then(result => {
            this.selectedYrStudentCount = result[this.selectedYear] || 0;
            return getPrograms({ selectedUniversity: this.selectedUniversity });
        })
        .then(result => {
            this.programWiseStudentCount = result.programWiseStudentCount;
            this.updateSelectedProgramStudentCount();
            return getModuleWiseData({
                selectedUniversity: this.selectedUniversity,
                selectedYear: this.selectedYear,
                selectedCourse: this.selectedCourse,
                selectedProgram: this.selectedProgram,
            });
        })
        .then(data => {
            this.showTotalCount = true;
            this.processData(data);
            this.showSpinner = false;
            this.showModuleWiseChart = data.length > 0;
        })
        .catch(error => {
            console.error('Error fetching data', error);
            this.showSpinner = false;
            this.showModuleWiseChart = false;
        });
    }
    

    renderedCallback() {
        if (this.showUniversityChart && this.dataToChart) {
            this.initializeChart();
        }
    }

    fetchChartColorsAndData() {
        getChartColors()
            .then(result => {
                this.chartColors = result.map(color => color.Color__c);
                if (this.chartColors.length > 0) {
                }
            })
            .catch(error => {
                console.error('Error fetching chart colors: ', error);
                this.showSpinner = false;
            });
    }
    

    
    

    processData(data) {
        let highestNoOfModules = 0;
        this.data = data;
        this.filteredStudentDataMap = {
            aheadOfSchedule: {},
            asPerTheSchedule: {},
            laggingBehind: {},
            courseNotStarted: [],
            courseCompleted: [],
            projectAssigned: [],
            projectInProgress: [],
            projectCompleted: [],
            moduleProgress: {}
        };
    
        data.forEach(item => {
            if (item.Course__r.No_of_Modules__c > highestNoOfModules) {
                highestNoOfModules = item.Course__r.No_of_Modules__c;
            }
        });
    
        this.highestNoOfModules = highestNoOfModules;
    
        let modules = [];
        let completionCounts = {
            aheadOfSchedule: {},
            asPerTheSchedule: {},
            laggingBehind: {},
            moduleProgress: {}
        };
    
        let courseStatusCounts = {
            notStarted: 0,
            completed: 0
        };
    
        let projectStatusCounts = {
            assigned: 0,
            inProgress: 0,
            completed: 0
        };
    
        for (let i = 1; i <= highestNoOfModules; i++) {
            const moduleField = `Module_${i}_Status__c`;
            modules.push(moduleField);
            completionCounts.aheadOfSchedule[moduleField] = 0;
            completionCounts.asPerTheSchedule[moduleField] = 0;
            completionCounts.laggingBehind[moduleField] = 0;
            completionCounts.moduleProgress[moduleField] = 0;
    
            this.filteredStudentDataMap.aheadOfSchedule[moduleField] = [];
            this.filteredStudentDataMap.asPerTheSchedule[moduleField] = [];
            this.filteredStudentDataMap.laggingBehind[moduleField] = [];
            this.filteredStudentDataMap.moduleProgress[moduleField] = [];
        }
    
        data.forEach(item => {
            const startDate = new Date(item.CourseConnection__r.CourseOffering__r.Start_Date__c);

            startDate.setMinutes(startDate.getMinutes() + 330);  

            startDate.setHours(0, 0, 0, 0);  
            const today = new Date();
            today.setMinutes(today.getMinutes() + 330); 
            today.setHours(0, 0, 0, 0);  

            let latestModuleStatus = null;
            let latestModuleIndex = 0;
            let allModulesCompleted = true;
            let allModulesNotStarted = true;
            let inProgressModules = [];

            let prevModuleDueDate = startDate;

            for (let i = 1; i <= highestNoOfModules; i++) {
                const moduleField = `Module_${i}_Status__c`;
                const completionDateField = `Module${i}_Completion_Date__c`;
                const moduleCompletionDate = item[completionDateField] ? new Date(item[completionDateField]) : null;

                const moduleDueDateField = `Module${i}_Due_Date__c`;
                const moduleDueDate = new Date(item.CourseConnection__r.CourseOffering__r[moduleDueDateField]);
                moduleDueDate.setMinutes(moduleDueDate.getMinutes() + 330); 
                moduleDueDate.setHours(23, 59, 59, 999);  

                const scheduledStartDate = new Date(prevModuleDueDate.getTime() + 1 * 24 * 60 * 60 * 1000);
                const scheduledCompletionDate = moduleDueDate;
                console.log(`Module ${i} - Start and End Dates:`);
                console.log(`Scheduled Start Date: ${scheduledStartDate.toISOString()}`);
                console.log(`Scheduled Completion Date: ${scheduledCompletionDate.toISOString()}`);
                const currentDate = today.setHours(0, 0, 0, 0);  


                
    
                if (item[moduleField] === 'Completed') {
                    allModulesNotStarted = false;
                    if (moduleCompletionDate && moduleCompletionDate < moduleDueDate) {
                        latestModuleStatus = 'Ahead of Schedule';
                    } else {
                        latestModuleStatus = 'As per the Schedule';
                    }
                    latestModuleIndex = i;
    
                    const nextModuleField = `Module_${i + 1}_Status__c`;
                    if (item[nextModuleField] === 'Not Yet Started') {
                        completionCounts.moduleProgress[nextModuleField]++;
                        this.filteredStudentDataMap.moduleProgress[nextModuleField].push(item); 
                    }
                } else if (item[moduleField] === 'In Progress') {
                    allModulesCompleted = false;
                    allModulesNotStarted = false;
                    inProgressModules.push(i);
    
                    if (currentDate < scheduledStartDate) {
                        latestModuleStatus = 'Ahead of Schedule';
                    } else if ((currentDate >= scheduledStartDate) &&(currentDate <= scheduledCompletionDate)) {
                        latestModuleStatus = 'As per the Schedule';
                    } else {
                        latestModuleStatus = 'Lagging Behind';
                    }
                    latestModuleIndex = i;
                } else {
                    allModulesCompleted = false;
                    if (currentDate > scheduledCompletionDate) {
                        latestModuleStatus = 'Lagging Behind';
                    }
                }
    
                item.currentStatus = latestModuleStatus;
                item.currentModule = moduleField;
    
                prevModuleDueDate = moduleDueDate;
            }
    
            if (allModulesCompleted) {
                courseStatusCounts.completed++;
                this.filteredStudentDataMap.courseCompleted.push(item);
            } else if (allModulesNotStarted) {
                courseStatusCounts.notStarted++;
                this.filteredStudentDataMap.courseNotStarted.push(item);
            } else {
                if (inProgressModules.length > 1) {
                    let prevModuleDueDate = startDate; 
                
                    inProgressModules.forEach(moduleIndex => {
                        const moduleField = `Module_${moduleIndex}_Status__c`;
                        const completionDateField = `Module${moduleIndex}_Completion_Date__c`;
                        const completionDate = item[completionDateField] ? new Date(item[completionDateField]) : null;
                
                        const moduleDueDateField = `Module${moduleIndex}_Due_Date__c`;
                        const moduleDueDate = new Date(item.CourseConnection__r.CourseOffering__r[moduleDueDateField]);
                        moduleDueDate.setHours(23, 59, 59, 999);
                
                        const scheduledStartDate = new Date(prevModuleDueDate);
                        scheduledStartDate.setDate(scheduledStartDate.getDate() + 1); 
                        scheduledStartDate.setHours(0, 0, 0, 0); 

                        const scheduledCompletionDate = moduleDueDate;
                
                        const today = new Date();
                        today.setHours(0, 0, 0, 0);
                
                        console.log('scheduledStartDate', scheduledStartDate, 'scheduledCompletionDate', scheduledCompletionDate);
                
                        if (today < scheduledStartDate) {
                            completionCounts.aheadOfSchedule[moduleField]++;
                            this.filteredStudentDataMap.aheadOfSchedule[moduleField].push(item);
                        } else if (today >= scheduledStartDate && today <= scheduledCompletionDate) {
                            completionCounts.asPerTheSchedule[moduleField]++;
                            this.filteredStudentDataMap.asPerTheSchedule[moduleField].push(item);
                        } else {
                            completionCounts.laggingBehind[moduleField]++;
                            this.filteredStudentDataMap.laggingBehind[moduleField].push(item);
                        }
                
                        prevModuleDueDate = moduleDueDate;
                    });
                }else {
                    const latestModuleField = `Module_${latestModuleIndex}_Status__c`;
                    if (latestModuleStatus === 'Ahead of Schedule') {
                        completionCounts.aheadOfSchedule[latestModuleField]++;
                        this.filteredStudentDataMap.aheadOfSchedule[latestModuleField].push(item);
                    } else if (latestModuleStatus === 'As per the Schedule') {
                        completionCounts.asPerTheSchedule[latestModuleField]++;
                        this.filteredStudentDataMap.asPerTheSchedule[latestModuleField].push(item);
                    } else if (latestModuleStatus === 'Lagging Behind') {
                        completionCounts.laggingBehind[latestModuleField]++;
                        this.filteredStudentDataMap.laggingBehind[latestModuleField].push(item);
                    }
                }
                
            }
    
            switch (item.Project__c) {
                case 'Assigned':
                    projectStatusCounts.assigned++;
                    this.filteredStudentDataMap.projectAssigned.push(item);
                    break;
                case 'In Progress':
                    projectStatusCounts.inProgress++;
                    this.filteredStudentDataMap.projectInProgress.push(item);
                    break;
                case 'Completed':
                    projectStatusCounts.completed++;
                    this.filteredStudentDataMap.projectCompleted.push(item);
                    break;
                default:
                    break;
            }
            item.hasMultipleInProgressModules = inProgressModules.length > 1;
        });
    
        let createChartData = (status) => ({
            labels: modules.map(module => module.replace('_Status__c', '').replace(/_/g, ' ')),
            datasets: [
                {
                    label: `${status.replace(/([A-Z])/g, ' $1').trim()} (Count)`,
                    backgroundColor: this.chartColors.slice(0, modules.length),
                    borderColor: this.chartColors.slice(0, modules.length).map(color => color.replace('0.2', '1')),
                    borderWidth: 1,
                    data: modules.map(module => {
                        const hasStartedOrCompleted = this.data.some(item => item[module] !== 'Not Yet Started');
                        return hasStartedOrCompleted ? completionCounts[status][module] : 0;
                    })
                }
            ]
        });
    
        this.chartData.aheadOfSchedule = createChartData('aheadOfSchedule');
        this.chartData.asPerTheSchedule = createChartData('asPerTheSchedule');
        this.chartData.laggingBehind = createChartData('laggingBehind');
    
        this.chartData.moduleProgress = {
            labels: modules.map(module => module.replace('_Status__c', '').replace(/_/g, ' ')),
            datasets: [
                {
                    label: 'Module Progress (Current Completed, Next Not Started)',
                    backgroundColor: this.chartColors.slice(0, modules.length),
                    borderColor: this.chartColors.slice(0, modules.length).map(color => color.replace('0.2', '1')),
                    borderWidth: 1,
                    data: modules.map(module => completionCounts.moduleProgress[module])
                }
            ]
        };
    
        this.chartData.courseProgress = {
            labels: ['Course Not Started', 'Course Completed'],
            datasets: [
                {
                    label: 'Course Progress',
                    backgroundColor: [this.chartColors[0], this.chartColors[1]],
                    borderColor: [this.chartColors[0].replace('0.2', '1'), this.chartColors[1].replace('0.2', '1')],
                    borderWidth: 1,
                    data: [courseStatusCounts.notStarted, courseStatusCounts.completed]
                }
            ]
        };
    
        this.chartData.project = {
            labels: ['Assigned', 'In Progress', 'Completed'],
            datasets: [
                {
                    label: 'Project Status',
                    backgroundColor: [this.chartColors[2], this.chartColors[3], this.chartColors[4], this.chartColors[5]],
                    borderColor: [this.chartColors[2].replace('0.2', '1'), this.chartColors[3].replace('0.2', '1'), this.chartColors[4].replace('0.2', '1'), this.chartColors[5].replace('0.2', '1')],
                    borderWidth: 1,
                    data: [projectStatusCounts.assigned, projectStatusCounts.inProgress, projectStatusCounts.completed]
                }
            ]
        };
    
        this.showModuleWiseChart = true;
        this.showSpinner = false;
    }
    
    
    

    initializeChart(status, chartClass) {
        const ctx = this.template.querySelector(`canvas.chart.${chartClass}`);
        if (!ctx) {
            return;
        }
    
        if (this.chart[status]) {
            this.chart[status].destroy();
        }
    
        let maxDataValue = Math.max(...this.chartData[status].datasets[0].data);
        let suggestedMax = maxDataValue + 10;
    
        this.chart[status] = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: this.chartData[status].labels,
                datasets: [{
                    label: `${status.replace(/([A-Z])/g, ' $1').trim()} (Count)`,
                    backgroundColor: this.chartColors.slice(0, this.chartData[status].labels.length),
                    borderColor: this.chartColors.slice(0, this.chartData[status].labels.length).map(color => color.replace('0.2', '1')),
                    borderWidth: 1,
                    data: this.chartData[status].datasets[0].data
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    datalabels: {
                        formatter: (value) => {
                            return value !== 0 ? value : null;
                        },
                        labels: {                            
                            value: {
                                anchor:'end',
                                align: 'top',
                                rotation:-10 ,
                                color: 'Black',
                                font: {
                                    
                                    //weight: 'bold',
                                    size: 14
                                }, 
                            }
                        }
                    }
                },

                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero: false,
                            maxTicksLimit: 20,
                            suggestedMin: 0,
                            suggestedMax: suggestedMax,
                            stepSize: 1,
                        },
                    }]
                },
                hover: {
                    mode: 'nearest',
                    intersect: false
                },
                tooltips: {
                    mode: 'nearest',
                    intersect: false
                },
                onClick: (event, elements) => {
                    if (elements.length > 0) {
                        const chartElement = elements[0];
                        const index = chartElement._index;
                        const chartName = status;
                        const moduleLabel = this.chart[status].data.labels[index];
                        this.handleModuleClick(moduleLabel, chartName);

                    }
                }
            },
            plugins: [ChartDataLabels]
        });
        this.chart[status].options.onClick = this.chart[status].options.onClick.bind(this);
    }
    
    
    
    renderedCallback() {
        if (this.data && this.data.length > 0) {
            if (this.chartData.aheadOfSchedule.datasets) {
                this.initializeChart('aheadOfSchedule', 'ahead-of-schedule');
            }
            if (this.chartData.asPerTheSchedule.datasets) {
                this.initializeChart('asPerTheSchedule', 'as-per-the-schedule');
            }
            if (this.chartData.laggingBehind.datasets) {
                this.initializeChart('laggingBehind', 'lagging-behind');
            }
            if (this.chartData.courseProgress.datasets) {
                this.initializeChart('courseProgress', 'course-progress');
            }
            if (this.chartData.project.datasets) {
                this.initializeChart('project', 'project');
            }
    
            if (this.chartData.moduleProgress.datasets) {
                this.initializeChart('moduleProgress', 'module-progress');
            }
        }
    }
    
    
    
    


   
    handleModuleClick(moduleLabel, chartName) {
        this.selectedModule = moduleLabel;
        this.selectedChart = chartName;
    
        let progressKey = '';
    
        if (chartName === 'aheadOfSchedule') {
            progressKey = 'aheadOfSchedule';
        } else if (chartName === 'asPerTheSchedule') {
            progressKey = 'asPerTheSchedule';
        } else if (chartName === 'laggingBehind') {
            progressKey = 'laggingBehind';
        } else if (chartName === 'courseProgress' && moduleLabel === 'Course Completed') {
            progressKey = 'courseCompleted';
        } else if (chartName === 'courseProgress' && moduleLabel === 'Course Not Started') {
            progressKey = 'courseNotStarted';
        } else if (chartName === 'project' && moduleLabel === 'Assigned') {
            progressKey = 'projectAssigned';
        } else if (chartName === 'project' && moduleLabel === 'In Progress') {
            progressKey = 'projectInProgress';
        } else if (chartName === 'project' && moduleLabel === 'Completed') {
            progressKey = 'projectCompleted';
        } 
        else if (chartName === 'moduleProgress') {
            progressKey = 'moduleProgress'; 
        }
    
        this.filterStudentData(progressKey);
    }
    
    
    
    
    
    filterStudentData(progressKey) {
        let filteredData = [];
    
        if (progressKey.includes('course') || progressKey.includes('project')) {
            filteredData = this.filteredStudentDataMap[progressKey] || [];
        } else if (progressKey === 'moduleProgress') {
            const moduleField = this.selectedModule.replace(' ', '_') + '_Status__c';
            filteredData = this.filteredStudentDataMap.moduleProgress[moduleField] || [];
        } else {
            const moduleField = this.selectedModule.replace(' ', '_') + '_Status__c';
            filteredData = this.filteredStudentDataMap[progressKey][moduleField] || [];
        }
    
        const studentData = filteredData.map((item, index) => {
            const moduleNumber = parseInt(this.selectedModule.replace('Module ', ''));
            const moduleCompletionDateField = `Module${moduleNumber}_Completion_Date__c`;
            const statusField = `Module_${moduleNumber}_Status__c`;
            const completionDate = item[moduleCompletionDateField];
            const scheduledCompletionDate = new Date(item.CourseConnection__r.CourseOffering__r.Start_Date__c);
            const totalModules = item.Course__r.No_of_Modules__c;
            const totalDays = (new Date(item.CourseConnection__r.CourseOffering__r.End_Date__c) - new Date(item.CourseConnection__r.CourseOffering__r.Start_Date__c)) / (1000 * 60 * 60 * 24);
            const daysPerModule = totalDays / totalModules;
            scheduledCompletionDate.setDate(scheduledCompletionDate.getDate() + (moduleNumber * daysPerModule));
    
            return {
                serialNumber: index + 1,
                contactId: item.Student__c,
                StudentName: item.Student__r.Name,
                studentUniversity: item.Student__r.AccountId,
                StudentEmail: item.Student__r.Email,
                Course: item.Course__r.Name,
                StartDate: item.CourseConnection__r.CourseOffering__r.Start_Date__c,
                EndDate: item.CourseConnection__r.CourseOffering__r.End_Date__c,
                ModuleStatus: item[statusField],
                ModuleCompletionDates: [{
                    key: `module${moduleNumber}`,
                    date: completionDate ? new Date(completionDate).toISOString().split('T')[0] : ''
                }],
                ModuleProgress: [{ key: `progress${moduleNumber}`, progress: item.progress }],
                project: item.Project__c,
                selectedModule: this.selectedModule,
                selectedChart: this.selectedChart,
                hasMultipleInProgressModules: item.hasMultipleInProgressModules
            };
        });
    
        this.filteredStudentData = studentData;
        this.showStudentLevelChart = filteredData.length > 0;
    }
    
    
    
    
    filterByModuleStatus(data, status) {
        return data.filter(item => {
            const noOfModules = item.Course__r.No_of_Modules__c;
            for (let i = 1; i <= noOfModules; i++) {
                const moduleStatusField = `Module_${i}_Status__c`;
                if (item[moduleStatusField] !== status) {
                    return false;
                }
            }
            return true;
        });
    }
    handleStudentListClose(event) {
        this.showStudentLevelChart=false;
        this.handleSearch();
    }

}