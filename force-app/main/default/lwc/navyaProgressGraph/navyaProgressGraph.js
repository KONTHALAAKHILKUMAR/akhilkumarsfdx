import { LightningElement } from 'lwc';

export default class StudentProgress extends LightningElement {
    selectedSemester = 1;
    yearFilter = 'All';
    student = {
        name: 'Scarlett Johansson',
        program: 'Cloud Engineering',
        about: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
        email: 'Eleanorpena@gmail.com',
        phone: '9652348956',
        linkedin: 'https://www.linkedin.com'
    };
    semesters = [
        { id: 1, name: 'Sem - 1', year: '2023', percentage: 83 },
        { id: 2, name: 'Sem - 2', year: '2023', percentage: 92 },
        { id: 3, name: 'Sem - 3', year: '2024', percentage: 95 },
        { id: 4, name: 'Sem - 4', year: '2024', percentage: 80 },
        { id: 5, name: 'Sem - 5', year: '2026', percentage: 98 }
    ];

    renderedCallback() {
        this.renderChart();
    }

    renderChart() {
        const ctx = this.template.querySelector('.bar-chart').getContext('2d');
        const data = {
            labels: this.semesters.map(sem => sem.name),
            datasets: [
                {
                    label: 'Percentage',
                    data: this.semesters.map(sem => sem.percentage),
                    backgroundColor: ['#4caf50', '#2196f3', '#ff9800', '#f44336', '#9c27b0']
                }
            ]
        };

        new Chart(ctx, {
            type: 'bar',
            data: data,
            options: {
                responsive: true,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100,
                        title: {
                            display: true,
                            text: 'Percentage'
                        }
                    }
                }
            }
        });
    }

    handleSemesterClick(event) {
        this.selectedSemester = event.currentTarget.dataset.semester;
        this.renderChart();
    }

    handleYearChange(event) {
        this.yearFilter = event.target.value;
    }

    previousSemester() {
        if (this.selectedSemester > 1) {
            this.selectedSemester--;
            this.renderChart();
        }
    }

    nextSemester() {
        if (this.selectedSemester < this.semesters.length) {
            this.selectedSemester++;
            this.renderChart();
        }
    }
}