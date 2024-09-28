import { LightningElement } from 'lwc';
import profilePic from '@salesforce/resourceUrl/profilePic';
import sJT_GmailIcon from '@salesforce/resourceUrl/sJT_GmailIcon';
import sJT_ContactIcon from '@salesforce/resourceUrl/sJT_ContactIcon';
import sJT_LinkDnIcon from '@salesforce/resourceUrl/sJT_LinkDnIcon';
import sJT_goBackArrowIcon from '@salesforce/resourceUrl/sJT_goBackArrowIcon';

export default class SJTStudentProfile extends LightningElement {
    profileImageUrl = profilePic; 
    gmailImageUrl = sJT_GmailIcon; 
    contactImageUrl = sJT_ContactIcon; 
    linkDnImageUrl = sJT_LinkDnIcon; 
    goBackArrowIcon = sJT_goBackArrowIcon;

    studentName = 'Eleanor Pena';
    programOpted = 'Java Full Stack';
    programDescription = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.';
    about = 'About';
    aboutDescription = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.';
    contact = 'Contact';
    email = 'Eleanorpena@gmail.com';
    phone = '9652348956';
    linkedinProfile = 'LinkedIn Profile';
    linkedinProfileUrl = 'https://www.linkedin.com/login';
}