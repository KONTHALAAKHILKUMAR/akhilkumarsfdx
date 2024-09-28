import { LightningElement } from 'lwc';
import sJT_goBackArrowIcon from '@salesforce/resourceUrl/sJT_goBackArrowIcon'; // Import Go Back icon
import sJT_DropDownIcon from '@salesforce/resourceUrl/sJT_DropDownIcon'; // Import Drop Down icon
import sJT_CalenderIcon from '@salesforce/resourceUrl/sJT_CalenderIcon'; // Import Calendar icon
import { NavigationMixin } from 'lightning/navigation';

export default class SJTStudentSearch extends NavigationMixin(LightningElement) {
 
    goBackArrowIcon = sJT_goBackArrowIcon;
    dropDownIcon = sJT_DropDownIcon;
    calenderIcon = sJT_CalenderIcon;

    searchInput = ''; 
    searchKey = ''; 
    selectedProgram = 'All Programs'; 
    visibleRecords = []; 
    allRecords = []; 
    selectedYear='All Years';
    selectedSemister='All Sems';
     
    yearOptions=[
    {label:'2019-2020', value:'2019-2020'},
        {label:'2020-2021', value:'2020-2021'},
        {label:'2021-2022', value:'2021-2022'},
        {label:'2022-2023', value:'2022-2023'},
        {label:'2023-2024', value:'2023-2024'},
        {label:'All Years', value:'All Years'}
    ]
    semisterOptions=[
        {label:'Sem-I',value:'Sem-I'},
        {label:'Sem-II',value:'Sem-II'},
        {label:'Sem-III',value:'Sem-III'},
        {label:'Sem-IV',value:'Sem-IV'},
        {label:'Sem-V',value:'Sem-V'},
        {label:'Sem-VI',value:'Sem-VI'},
        {label:'Sem-VII',value:'Sem-VII'},
        {label:'Sem-VIII',value:'Sem-VIII'},
        {label:'All Sems', value:'All Sems'}
    ]
    
    allStudents = [
        { id: 1, sNo: '01', name: 'Scarlett Johansson', semester: 'Sem-I', year: '2023-2024', grade: '98%', program: 'Java Full Stack with React', skills: ['HTML', 'JAVA', 'SQL'], program:'DevOps' },
        { id: 2, sNo: '02', name: 'Aria Caldwell', semester: 'Sem-I', year: '2023-2024', grade: '88%', program: 'Testing with Selenium using Java', skills: ['HTML', 'JAVA', 'SQL'], program:'DevOps' },
        { id: 3, sNo: '03', name: 'Lucas Trent', semester: 'Sem-I', year: '2023-2024', grade: '75%', program: 'Data Science', skills: ['Python', 'R', 'SQL'] , program:'Java Full Stack with React'},
        { id: 4, sNo: '04', name: 'Evelyn Harper', semester: 'Sem-II', year: '2023-2024', grade: '67%', program: 'MERN', skills: ['MongoDB', 'React', 'Node.js'], program:'DevOps' },
        { id: 5, sNo: '05', name: 'Nolan Pierce', semester: 'Sem-II', year: '2022-2023', grade: '23%', program: 'DevOps', skills: ['AWS', 'Docker', 'Kubernetes'] , program:'Java Full Stack with React'},
        { id: 6, sNo: '06', name: 'Sophia Ellis', semester: 'Sem-II', year: '2023-2024', grade: '48%', program: 'Java Full Stack with React', skills: ['JavaScript', 'HTML', 'CSS'], program:'Testing with Selenium using Java' },
        { id: 7, sNo: '07', name: 'Disujadevi', semester: 'Sem-III', year: '2019-2020', grade: '99%', program: 'Testing with Selenium using Java', skills: ['Selenium', 'JUnit', 'TestNG'] , program:'Testing with Selenium using Java'},
        { id: 8, sNo: '08', name: 'Michael Clarke', semester: 'Sem-III', year: '2023-2024', grade: '98%', program: 'MERN', skills: ['Express', 'React', 'Node.js'], program:'MERN' },
        { id: 9, sNo: '09', name: 'Isabella Brown', semester: 'Sem-III', year: '2023-2024', grade: '88%', program: 'Data Science', skills: ['Python', 'SQL', 'Tableau'], program:'MERN' },
        { id: 10, sNo: '10', name: 'James Wilson', semester: 'Sem-IV', year: '2023-2024', grade: '75%', program: 'DevOps', skills: ['AWS', 'Jenkins', 'Kubernetes'] , program:'Java Full Stack with React'},
        { id: 11, sNo: '11', name: 'Olivia Martin', semester: 'Sem-IV', year: '2023-2024', grade: '67%', program: 'MERN', skills: ['React', 'MongoDB', 'Node.js'] , program:'DevOps'},
        { id: 12, sNo: '12', name: 'Liam Jones', semester: 'Sem-IV', year: '2022-2023', grade: '23%', program: 'Java Full Stack with React', skills: ['React', 'CSS', 'Java'], program:'DevOps' },
        { id: 13, sNo: '13', name: 'Sophia White', semester: 'Sem-V', year: '2023-2024', grade: '48%', program: 'Testing with Selenium using Java', skills: ['JUnit', 'Selenium', 'Java'], program:'Data Science' },
        { id: 14, sNo: '14', name: 'Emma Harris', semester: 'Sem-V', year: '2019-2020', grade: '99%', program: 'Data Science', skills: ['R', 'Python', 'SQL'], program:'Data Science' }
    ];

    programOptions = [
        { label: 'All Programs', value: 'All Programs' },
        { label: 'Java Full Stack with React', value: 'Java Full Stack with React' },
        { label: 'Testing with Selenium using Java', value: 'Testing with Selenium using Java' },
        { label: 'MERN', value: 'MERN' },
        { label: 'Data Science', value: 'Data Science' },
        { label: 'DevOps', value: 'DevOps' }
    ];

    connectedCallback() {
        this.allRecords = this.allStudents; 
        this.visibleRecords = this.filteredRecords.slice(0, 7); 
    }

    get filteredRecords() {
        let filtered = this.allRecords;

        if (this.searchKey) {
            filtered = filtered.filter(student =>
                student.name.toLowerCase().includes(this.searchKey.toLowerCase())
            );
        }
          
        if (this.selectedProgram !== 'All Programs') {
            filtered = filtered.filter(student => student.program === this.selectedProgram);
        }
        if (this.selectedYear !== 'All Years') {
            filtered = filtered.filter(student => student.year === this.selectedYear);
        }
        if (this.selectedSemister !== 'All Sems') {
            filtered = filtered.filter(student => student.semester === this.selectedSemister);
        }
        
        return filtered;
    }

    handleSearchInputChange(event) {
        this.searchInput = event.target.value; 
    }

    handleSearch() {
        this.searchKey = this.searchInput; 
        this.visibleRecords = this.filteredRecords.slice(0, 7); 
    }

    handleProgramChange(event) {
        this.selectedProgram = event.detail.value; 
        
    }
    handleYearChange(event) {
        this.selectedYear = event.detail.value; 
        
    }
    handleSemisterChange(event) {
        this.selectedSemister = event.detail.value; 
        
    }

    handleUpdate(event) {
        this.visibleRecords = event.detail.records; 
    }

    handleStudentClick(event) {
        const studentName = event.target.dataset.name; 

        this[NavigationMixin.GenerateUrl]({
            type: 'comm__namedPage',
            attributes: {
                name: 'Test_Page__c'
            }
        }).then(url => {
            window.open(url, '_blank');
        });
    }
}