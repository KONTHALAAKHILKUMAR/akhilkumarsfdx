import { LightningElement, track } from 'lwc';
import leftArrow from '@salesforce/resourceUrl/LeftArrow';
import rightArrow from '@salesforce/resourceUrl/RightArrow';
import sJT_goBackArrowIcon from '@salesforce/resourceUrl/sJT_goBackArrowIcon';

export default class StudentJourneyTracker extends LightningElement {
    leftArrow = leftArrow;
    rightArrow = rightArrow;
    goBackArrowIcon = sJT_goBackArrowIcon;

    @track yearOptions = [
        { label: 'I', value: 'I' },
        { label: 'II', value: 'II' },
        { label: 'III', value: 'III' },
        { label: 'IV', value: 'IV' },
        { label: 'All Years', value: 'All Years' }
    ];

    @track yearValue = 'All Years';
    @track startIndex = 0;
    @track visibleButtons = 5;
    @track disableArrows = false;
    @track isSemisterBtnClicked = false;
    @track selectedSemesterId = null; 

    semesters = [
        { id: 1, name: 'Sem - 1 (2023)', year: 'I', percentage: 83, barStyle: 'height: 83%; background-color: #A4B561;' },
        { id: 2, name: 'Sem - 2 (2023)', year: 'I', percentage: 100, barStyle: 'height: 100%; background-color: #00A2B3;' },
        { id: 3, name: 'Sem - 3 (2024)', year: 'II', percentage: 75, barStyle: 'height: 75%; background-color: #F28C28;' },
        { id: 4, name: 'Sem - 4 (2024)', year: 'II', percentage: 88, barStyle: 'height: 88%; background-color: #F1788D;' },
        { id: 5, name: 'Sem - 5 (2024)', year: 'III', percentage: 85, barStyle: 'height: 85%; background-color: #9567E8;' },
        { id: 6, name: 'Sem - 6 (2024)', year: 'III', percentage: 80, barStyle: 'height: 80%; background-color: #5bc0de;' },
        { id: 7, name: 'Sem - 7 (2024)', year: 'IV', percentage: 90, barStyle: 'height: 90%; background-color: #f0ad4e;' },
        { id: 8, name: 'Sem - 8 (2024)', year: 'IV', percentage: 95, barStyle: 'height: 95%; background-color: #d9534f;' }
    ];

    get filteredSemesters() {
        if (this.yearValue === 'All Years') {
            return this.semesters;
        }
        return this.semesters.filter(sem => sem.year === this.yearValue);
    }

    get visibleSemesters() {
        const semestersToDisplay = this.yearValue !== 'All Years' ? this.filteredSemesters : this.filteredSemesters.slice(this.startIndex, this.startIndex + this.visibleButtons);

        return semestersToDisplay.map((sem) => {
            const barColor = sem.barStyle.match(/background-color:\s*(#[a-fA-F0-9]{6}|#[a-fA-F0-9]{3}|rgba?\(\d+,\s*\d+,\s*\d+(,\s*\d+(\.\d+)?)?\));/)[0].split(':')[1].trim();
            
            const buttonStyle = `background-color: ${barColor}; color: white; border: none; padding: 5px 10px;margin: 5px; border-radius: 5px;`;

           return {
                ...sem,
                htmlButtonStyle: `${buttonStyle} transition: background-color 0.3s ease;`,
                javaButtonStyle: `${buttonStyle} transition: background-color 0.3s ease;`,
                sqlButtonStyle: `${buttonStyle} transition: background-color 0.3s ease;`,
                hoverButtonStyle: `:hover { background-color: white; color: black; transition: background-color 0.3s ease; }`
            };

        });
    }

    get visibleSemesterButtons() {
        return this.semesters.slice(this.startIndex, this.startIndex + this.visibleButtons).map((sem) => {
            const isDisabled = this.yearValue !== 'All Years' && sem.year !== this.yearValue;
            const isSelected = this.selectedSemesterId === sem.id; 

            let buttonStyle = `width: 161px; height: 79px;font-weight: bold; border: 1px solid #dacece; border-radius: 6px; margin-right: 5px; box-shadow: none;`;

            if (isDisabled) {
                buttonStyle += `background: #d3d3d3; color: #999; cursor: not-allowed;`;
            } else if (isSelected) {
                buttonStyle += `background: #3E7AC3; color: white;`;  
            } else {
                buttonStyle += `background: #FFF; color: #000;`;     
            }

            return {
                ...sem,
                buttonStyle: buttonStyle,
                isDisabled
            };
        });
    }

    handleSemesterClick(event) {
        const semesterId = parseInt(event.target.dataset.id, 10); 
        this.selectedSemesterId = semesterId;  
        this.isSemisterBtnClicked = true;      
        console.log(`Semester ${semesterId} clicked`);
    }

    handleYearChange(event) {
        this.yearValue = event.target.value;

        if (this.yearValue === 'III' || this.yearValue === 'IV') {
            this.startIndex = 3; 
            this.visibleButtons = 5; 
            this.disableArrows = true; 
        } else {
            this.startIndex = 0; 
            this.visibleButtons = 5; 
            this.disableArrows = this.yearValue !== 'All Years'; 
        }
    }

    handlePrev() {
        if (this.startIndex > 0) {
            this.startIndex -= this.visibleButtons;
            if (this.startIndex < 0) this.startIndex = 0;
        }
    }

    handleNext() {
        if (this.yearValue === 'All Years' && this.startIndex === 0) {
            this.startIndex = 3; 
        } else {
            const totalSemesters = this.filteredSemesters.length;
            if (this.startIndex + this.visibleButtons < totalSemesters) {
                this.startIndex += this.visibleButtons;
            }
        }
    }

    get prevArrowClass() {
        return this.isPrevDisabled ? 'disabled-arrow' : '';
    }

    get nextArrowClass() {
        return this.isNextDisabled ? 'disabled-arrow' : '';
    }

    get isPrevDisabled() {
        return this.startIndex === 0;
    }

    get isNextDisabled() {
        const totalSemesters = this.filteredSemesters.length;
        return this.startIndex + this.visibleButtons >= totalSemesters;
    }

    handleGoBack() {
        if (this.isSemisterBtnClicked) {
            this.isSemisterBtnClicked = false; 
            this.selectedSemesterId = null;   
        }
    }
}