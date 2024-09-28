@isTest
private class MentorCourseProgressTrackerTest {

    @isTest
    static void myUnitTest() {
        Account university = new Account(Name = 'Avila', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('College_University').getRecordTypeId());
        insert university;

        Program__c program = new Program__c(Name = 'Test Program', Status__c = 'Active', University__c = university.Id);
        insert program;
        
        Course__c course = new Course__c(Name = 'Test Course', Status__c = 'Completed', Program__c = program.Id, No_of_Modules__c = 4);
        insert course;
        
        Contact mentor = new Contact(FirstName = 'Test', LastName = 'Mentor', AccountId = university.Id, Tutor__c = true, APSCHE__c = true);
        insert mentor;
        
        CourseOffering__c courseOffering = new CourseOffering__c(Course__c = course.Id, Mentor__c = mentor.Id, Batch__c = 'Batch1');
        insert courseOffering;

        CourseConnection__c courseConnection = new CourseConnection__c(CourseOffering__c=courseOffering.Id, Status__c='Active');
        insert courseConnection;

        Contact student = new Contact(FirstName = 'Test', LastName = 'Student', AccountId = university.Id, APSCHE__c = true);
        insert student;
        
        CourseProgress__c courseProgress = new CourseProgress__c(Student__c = student.Id, 
        Course__c = course.Id, Program__c = program.Id,
        CourseConnection__c=courseConnection.Id,Module_1_Status__c='Completed',
        Module_2_Status__c='Completed',Module_3_Status__c='Completed',Status__c='Active'
        
        
        );
        insert courseProgress;

        String selectedUniversity = university.Id;
        String selectedAPSCHE = ' ';        
        String selectedProgram = program.id;
        Integer totalModules = 4;
        String selectedMentor = mentor.id;
        String selectedCourse = course.Id ;
        Boolean selectedCRTValue = true;
        String selectedYear='II';

        MentorCourseProgressTracker.getMentors(selectedCRTValue);
        MentorCourseProgressTracker.getUniversities(selectedCRTValue,selectedMentor);
        MentorCourseProgressTracker.getPrograms(selectedCRTValue,selectedMentor,selectedUniversity,selectedAPSCHE,selectedYear);
        MentorCourseProgressTracker.getCourses(selectedCRTValue,selectedMentor,selectedUniversity,'',selectedProgram,selectedYear);
        MentorCourseProgressTracker.getCourses(selectedCRTValue,selectedMentor,'APSCHE',selectedAPSCHE,selectedProgram,selectedYear);
        MentorCourseProgressTracker.getData(selectedCRTValue,selectedMentor,'APSCHE', selectedAPSCHE, selectedProgram, selectedCourse,selectedYear);
        MentorCourseProgressTracker.getData(selectedCRTValue,selectedMentor,'APSCHE', '', selectedProgram, selectedCourse,selectedYear);
        MentorCourseProgressTracker.getData(selectedCRTValue,selectedMentor,selectedUniversity, '', selectedProgram, selectedCourse,selectedYear);
        MentorCourseProgressTracker.getIncompleteModuleStatuses(courseProgress.Id, totalModules);

        List<MentorCourseProgressTracker.Wrapper> wrappers = new List<MentorCourseProgressTracker.Wrapper>();

        MentorCourseProgressTracker.Wrapper wrap = new MentorCourseProgressTracker.Wrapper();
        wrap.Id = courseProgress.Id;
        wrap.serialNumber = 1;
        wrap.studentName = 'Test Student';
        wrap.collegeName = university.Name;
        wrap.apsche = 'APSCHE 1';
        wrap.batchNumber = 'Batch1';
        wrap.courseName = 'Test';
        wrap.totalModules = 4;
        wrap.modulesCompleted = '2';
        wrap.modulesInProgress = '2';
        wrap.selectedModuleNumbers = new List<String>{'Module 1', 'Module 2','Module 3','Module 4', 'Module 5','Module 6','Module 7', 'Module 8','Module 9','Module 10', 'Module 11','Module 12','Module 13', 'Module 14','Module 15'};
        wrap.status = 'Completed';
        wrap.project = 'Completed';
        wrap.comments = 'Test comments';
        wrap.moduleGrade = 'A';
        wrap.moduleFeedback = 'Good';
        wrap.courseFeedback = 'Good!';
        wrap.completedDate = Date.newInstance(2022, 1, 1);

        wrappers.add(wrap);

        Test.startTest();
        MentorCourseProgressTracker.updateCourseProgress(wrappers);
        Test.stopTest();

        CourseProgress__c updatedCourseProgress = [SELECT Id, Module_1_Status__c, Module_2_Status__c, Project__c, Comments__c, Module1_Completion_Date__c, Module2_Completion_Date__c FROM CourseProgress__c WHERE Id = :courseProgress.Id];
        
    }
}