@isTest
private class DashBoardCtrlTest {

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

        CourseConnection__c courseConnection = new CourseConnection__c(Contact__c = student.Id, CourseOffering__c = courseOffering.Id, Type__c = 'Student', Batch__c = 'Batch1');
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

        List<String> mentors= DashBoardCtrl.getMentors(selectedCRTValue);

        List<String> universities= DashBoardCtrl.getUniversities(selectedCRTValue,selectedMentor);
        List<AggregateResult> universityWiseData = DashBoardCtrl.getUniversityWiseData(selectedCRTValue,selectedMentor,selectedUniversity,selectedApsche);
        List<AggregateResult> universityWiseData2 = DashBoardCtrl.getUniversityWiseData(false,selectedMentor,'APSCHE',selectedApsche);
        List<AggregateResult> universityWiseData3 = DashBoardCtrl.getUniversityWiseData(false,selectedMentor,'APSCHE','');
        List<AggregateResult> universityWiseData4 = DashBoardCtrl.getUniversityWiseData(false,selectedMentor,selectedUniversity,'');
        
        List<Chart_Colors__mdt> result3= DashBoardCtrl.getChartColors();

        Map<String, Object> programWiseData1 = DashBoardCtrl.getProgramWiseData(selectedCRTValue,selectedUniversity,selectedMentor,selectedApsche,selectedUDLabel);
        Map<String, Object> programWiseData2 = DashBoardCtrl.getProgramWiseData(false,selectedUniversity,selectedMentor,'','');
        Map<String, Object> programWiseData3 = DashBoardCtrl.getProgramWiseData(false,'APSCHE',selectedMentor,selectedApsche,selectedUDLabel);
        Map<String, Object> programWiseData4 = DashBoardCtrl.getProgramWiseData(false,'APSCHE',selectedMentor,'',selectedUDLabel);

        List<Map<String, String>> CourseOptions1= DashBoardCtrl.getCourseOptions(selectedCRTValue,selectedMentor, selectedUDLabel, selectedUniversity, selectedProgram,selectedApsche);
        List<Map<String, String>> CourseOptions2= DashBoardCtrl.getCourseOptions(false,selectedMentor, selectedUDLabel, selectedUniversity, selectedProgram,'');
        List<Map<String, String>> CourseOptions3= DashBoardCtrl.getCourseOptions(false,selectedMentor, selectedUDLabel, 'APSCHE', selectedProgram,selectedApsche);
        List<Map<String, String>> CourseOptions4= DashBoardCtrl.getCourseOptions(false,selectedMentor, selectedUDLabel, 'APSCHE', selectedProgram,'');

        List<CourseProgress__c> ModuleWiseData1= DashBoardCtrl.getModuleWiseData(selectedCRTValue,selectedMentor,selectedUniversity,selectedBatch,selectedCourse,selectedProgram,selectedUDLabel);
        List<CourseProgress__c> ModuleWiseData2= DashBoardCtrl.getModuleWiseData(false,selectedMentor,selectedUniversity,selectedBatch,selectedCourse,selectedProgram,selectedUDLabel);
        List<CourseProgress__c> ModuleWiseData3= DashBoardCtrl.getModuleWiseData(false,selectedMentor,'APSCHE',selectedApsche,selectedCourse,selectedProgram,selectedUDLabel);
        List<CourseProgress__c> ModuleWiseData4= DashBoardCtrl.getModuleWiseData(false,selectedMentor,'APSCHE','',selectedCourse,selectedProgram,selectedUDLabel);
        
    }
}