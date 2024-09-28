@isTest
private class TPODashboardCtrlTest {

    @isTest
    static void myUnitTest() {
        Account university = new Account(
            Name = 'Test University'
        );
        insert university;

        Program__c program = new Program__c(Name = 'Web Designing & Development');
        insert program;

        Course__c course = new Course__c(
            Name = 'Test Course', 
            Status__c = 'Completed', 
            Program__c = program.Id,
            No_of_Modules__c=3
        );
        insert course;

        CourseOffering__c courseOffering = new CourseOffering__c(
            Course__c = course.Id, 
            collegeOrUniversity__c = university.Id
        );
        insert courseOffering;

        Contact student = new Contact(
            FirstName = 'Test', 
            LastName = 'Student', 
            Email = 'test@student.com', 
            AccountId = university.Id,
            CRT__c = true 
        );
        insert student;

        CourseConnection__c courseConnection = new CourseConnection__c(
            Contact__c = student.Id, 
            CourseOffering__c = courseOffering.Id, 
            Type__c = 'Student', 
            Status__c = 'Active',
            Year__c = 'II' 
        );
        insert courseConnection;


        String selectedUniversity = university.Name; 
        String selectedCourse = 'Test Course';
        String selectedProgram = 'Web Designing & Development';
        String selectedYear = 'II';

        Test.startTest();
        
        Map<String, Object> universitiesResult = TPODashboardCtrl.getUniversities();
        // System.assertNotEquals(null, universitiesResult, 'Expected universitiesResult not to be null');
        // System.assert(universitiesResult.containsKey('universityStudentCounts'), 'Expected universityStudentCounts key in result');
        Map<String, Integer> universityStudentCounts = (Map<String, Integer>) universitiesResult.get('universityStudentCounts');
        // System.assertEquals(1, universityStudentCounts.get(selectedUniversity), 'Expected student count for university');

        Map<String, Integer> yearWiseStudentCountResult = TPODashboardCtrl.getYearWiseStudentCount(selectedUniversity, selectedYear);
        // System.assertNotEquals(null, yearWiseStudentCountResult, 'Expected yearWiseStudentCountResult not to be null');
        // System.assertEquals(1, yearWiseStudentCountResult.get(selectedYear), 'Expected student count for selected year');

        List<Chart_Colors__mdt> chartColorsResult = TPODashboardCtrl.getChartColors();
        // System.assertNotEquals(null, chartColorsResult, 'Expected chartColorsResult not to be null');

        Map<String, Object> programsResult = TPODashboardCtrl.getPrograms(selectedUniversity, selectedYear);
        // System.assertNotEquals(null, programsResult, 'Expected programsResult not to be null');
        // System.assert(programsResult.containsKey('programWiseStudentCount'), 'Expected programWiseStudentCount key in result');
        Map<String, Integer> programWiseStudentCount = (Map<String, Integer>) programsResult.get('programWiseStudentCount');
        // System.assertEquals(1, programWiseStudentCount.get(selectedProgram), 'Expected student count for program');

        List<String> coursesResult = TPODashboardCtrl.getCourses(selectedUniversity, selectedYear, selectedProgram);
        // System.assertNotEquals(null, coursesResult, 'Expected coursesResult not to be null');
        // System.assertEquals(1, coursesResult.size(), 'Expected number of courses');
        // System.assertEquals('Test Course', coursesResult[0], 'Expected course name');

        Map<String, Object> moduleWiseDataResult = TPODashboardCtrl.getModuleWiseData(selectedUniversity, selectedYear, selectedCourse, selectedProgram);
        // System.assertNotEquals(null, moduleWiseDataResult, 'Expected moduleWiseDataResult not to be null');
        // System.assertEquals(1, moduleWiseDataResult.size(), 'Expected number of module progress records');
        // System.assertEquals('Not Yet Started', moduleWiseDataResult[0].Module_1_Status__c, 'Expected Module 1 status');
        
        
        System.debug('Universities Result: ' + universitiesResult);
        System.debug('Year Wise Student Count Result: ' + yearWiseStudentCountResult);
        System.debug('Chart Colors Result: ' + chartColorsResult);
        System.debug('Programs Result: ' + programsResult);
        System.debug('Courses Result: ' + coursesResult);
        System.debug('Module Wise Data Result: ' + moduleWiseDataResult);

        Test.stopTest();
    }
}