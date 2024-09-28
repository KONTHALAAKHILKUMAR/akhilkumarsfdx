@isTest
private class CRTDashboardCtrlTest {

    @isTest
    static void myUnitTest() {
        Account university = new Account(Name = 'Test Account', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('College_University').getRecordTypeId());
        insert university;

        Program__c program = new Program__c(Name = 'Web Designing & Development');
        insert program;

        Course__c course = new Course__c(Name = 'Test Course', Status__c = 'Completed',Program__c=program.Id);
        insert course;

        CourseOffering__c courseOffering = new CourseOffering__c(Course__c = course.Id, collegeOrUniversity__c = university.Id);
        insert courseOffering;

        Contact student = new Contact(FirstName = 'Test', LastName = 'Student', Email = 'test@student.com', AccountId = university.Id,APSCHE_Name__c='APSCHE 1');
        insert student;

        CourseConnection__c courseConnection = new CourseConnection__c(Contact__c = student.Id, CourseOffering__c = courseOffering.Id, Type__c = 'Student', Batch__c = 'Batch1',Year__c='II');
        insert courseConnection;

        CourseProgress__c courseProgress = new CourseProgress__c(
            Student__c = student.Id,
            Module_1_Status__c = 'Completed',
            Module_2_Status__c = 'Not Applicable',
            Module_3_Status__c = 'Completed',
            CourseConnection__c = courseConnection.Id
        );
        insert courseProgress;
        String selectedUniversity = university.Id;
        String selectedBatch = 'Batch1';
        String selectedCourse = 'Android Studio';
        String selectedProgram = 'Web Designing & Development';
        String selectedModule = 'Module 1';
        String selectedApsche = 'APSCHE 1';
        String selectedCourseStatus = 'Completed';
        String selectedUDLabel = 'Avila';
        String selectedMentor = 'John';
        Boolean selectedCRTValue = true;
        String selectedYear='II';


        Map<String, Object> universities= CRTDashboardCtrl.getUniversities();
        Map<String, Integer> YearWiseStudentCount = CRTDashboardCtrl.getYearWiseStudentCount(selectedUniversity,selectedYear);
        
        List<Chart_Colors__mdt> result3= CRTDashboardCtrl.getChartColors();

        Map<String, Object> programWiseData1 = CRTDashboardCtrl.getPrograms(selectedUniversity,selectedYear);

        List<String> CourseOptions1= CRTDashboardCtrl.getCourses(selectedUniversity, selectedYear,selectedProgram);

        List<CourseProgress__c> ModuleWiseData1= CRTDashboardCtrl.getModuleWiseData(selectedUniversity, selectedYear,selectedProgram,selectedCourse);
        
    }
}