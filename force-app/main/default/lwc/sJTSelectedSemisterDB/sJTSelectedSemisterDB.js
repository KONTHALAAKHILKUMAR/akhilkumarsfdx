import { LightningElement, track } from 'lwc';
import leftArrow from '@salesforce/resourceUrl/LeftArrow';
import rightArrow from '@salesforce/resourceUrl/RightArrow';

export default class SJTSelectedSemisterDB extends LightningElement {
  @track circumference;
  @track innerCircumference;
  @track currentPage = 0;
  @track totalPages = 0;
  leftArrow = leftArrow;
  rightArrow = rightArrow;
  @track modules = [];
  totalGrade = 73;
  skills = {
    html: 70,
    java: 68,
    sql: 82
  };

  connectedCallback() {
    const numberOfModules = 14;
    this.modules = Array.from({ length: numberOfModules }, (_, i) => ({
      moduleId: i + 1,
      assignments: [
        { progress: 88, score: 88 },
        { progress: 68, score: 68 }
      ]
    }));

    this.totalPages = Math.ceil(this.modules.length / 4);
  }

  renderedCallback() {
    console.log("renderedCallback called");
    this.drawProgressRings();
    this.updateModuleProgress();
  }


  drawProgressRings() {
    console.log("drawProgressRings called");

    const skillPercentages = Object.values(this.skills);
    console.log("Skill percentages:", skillPercentages);

    const colors = ['#e96a62', '#6665dd', '#00a2b3']; 
    const lightColor = '#e0e0e0'; 
    const progressRing = this.template.querySelector('.progress-rings');

    if (!progressRing) {
      console.log("Progress ring not found!");
      return;
    }

    console.log("Progress ring found, proceeding to draw rings.");

    const radius = 70; 
    const strokeWidth = 10;  

    while (progressRing.firstChild) {
      progressRing.removeChild(progressRing.firstChild);
    }

    skillPercentages.forEach((percentage, index) => {
      console.log(`Drawing circle for percentage: ${percentage}`);

      const skillRadius = radius - (index * (strokeWidth + 10));  
      const circumference = 2 * Math.PI * skillRadius;
      const offset = circumference - (percentage / 100) * circumference;

      const backgroundCircle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      backgroundCircle.setAttribute('r', skillRadius);
      backgroundCircle.setAttribute('cx', '50%');
      backgroundCircle.setAttribute('cy', '50%');
      backgroundCircle.setAttribute('stroke-width', strokeWidth);
      backgroundCircle.setAttribute('stroke', lightColor);
      backgroundCircle.setAttribute('fill', 'transparent');
      backgroundCircle.setAttribute('stroke-dasharray', `${circumference} ${circumference}`);
      backgroundCircle.setAttribute('stroke-dashoffset', 0);

      progressRing.appendChild(backgroundCircle);

      const circle = document.createElementNS('http://www.w3.org/2000/svg', 'circle');
      circle.setAttribute('r', skillRadius);
      circle.setAttribute('cx', '50%');
      circle.setAttribute('cy', '50%');
      circle.setAttribute('stroke-width', strokeWidth);
      circle.setAttribute('stroke', colors[index]);
      circle.setAttribute('fill', 'transparent');
      circle.setAttribute('stroke-dasharray', `${circumference} ${circumference}`);
      circle.setAttribute('stroke-dashoffset', offset);

      progressRing.appendChild(circle);
    });

    let progressText = this.template.querySelector('.progress-text');
    if (!progressText) {
        console.log("Progress text element not found, creating it");

        progressText = document.createElementNS('http://www.w3.org/2000/svg', 'text');
        progressText.setAttribute('class', 'progress-text');
        progressText.setAttribute('x', '50%');
        progressText.setAttribute('y', '50%');
        progressText.setAttribute('text-anchor', 'middle');
        progressText.setAttribute('dy', '.3em');
        progressText.setAttribute('font-size', '15');
        progressText.setAttribute('fill', '#000');
        
        progressRing.appendChild(progressText);
    }

    const avgSkillPercentage = Math.round(
      (this.skills.html + this.skills.java + this.skills.sql) / 3
    );

    console.log(`Calculated average: ${avgSkillPercentage}%`);

    progressText.textContent = `${avgSkillPercentage}%`;
    console.log(`Setting text to: ${avgSkillPercentage}%`);
}





  updateModuleProgress() {
    const outerCircle = this.template.querySelector(".progress");
    const innerCircle = this.template.querySelector(".progress-inner");

    if (!outerCircle || !innerCircle) {
      return;
    }

    var rOuter = outerCircle.getAttribute("r");
    var rInner = innerCircle.getAttribute("r");

    this.circumference = 2 * Math.PI * rOuter;
    this.innerCircumference = 2 * Math.PI * rInner;

    outerCircle.style.strokeDasharray = this.circumference;
    innerCircle.style.strokeDasharray = this.innerCircumference;
  }

  handlePrev() {
    if (this.currentPage > 0) {
      this.currentPage--;
    }
  }

  handleNext() {
    if (this.currentPage < this.totalPages - 1) {
      this.currentPage++;
    }
  }

  get paginatedModules() {
    const start = this.currentPage * 4;
    const end = start + 4;

    let currentModules = this.modules.slice(start, end);
    if (currentModules.length < 4) {
      const remainingModules = this.modules.slice(0, 4 - currentModules.length);
      currentModules = [...currentModules, ...remainingModules];
    }

    return currentModules;
  }

  handleChange(event) {
    var percent = parseInt(event.target.value);
    var innerPercent = Math.min(100, percent + 20);

    const outerCircle = this.template.querySelector(".progress");
    const innerCircle = this.template.querySelector(".progress-inner");

    outerCircle.style.strokeDashoffset =
      this.circumference - (percent / 100) * this.circumference;
    innerCircle.style.strokeDashoffset =
      this.innerCircumference - (innerPercent / 100) * this.innerCircumference;

    this.template.querySelector(".progress-text").textContent = `${percent}%`;
  }
}