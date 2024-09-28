@isTest
private class UpdateModuleStatusOnCourseProgressTest {

    @isTest
    static void myUnitTest() {
        
        System.debug('Starting test execution');

        Account university = new Account(
            Name = 'Test Account',
            RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('College_University').getRecordTypeId()
        );
        insert university;
        System.debug('Inserted university: ' + university.Id);

        Program__c program = new Program__c(Name = 'Web Designing & Development');
        insert program;
        System.debug('Inserted program: ' + program.Id);

        Course__c course = new Course__c(
            Name = 'Test Course',
            Status__c = 'Completed',
            Program__c = program.Id,
            No_of_Modules__c = 5 
        );
        insert course;
        System.debug('Inserted course: ' + course.Id);

        CourseOffering__c courseOffering = new CourseOffering__c(
            Course__c = course.Id,
            collegeOrUniversity__c = university.Id,
            Project__c='Available'
        );
        insert courseOffering;
        System.debug('Inserted courseOffering: ' + courseOffering.Id);

        Contact student = new Contact(
            FirstName = 'Test',
            LastName = 'Student',
            Email = 'test@student.com',
            AccountId = university.Id
        );
        insert student;
        System.debug('Inserted student: ' + student.Id);

        CourseConnection__c courseConnection1 = new CourseConnection__c(
            Contact__c = student.Id,
            CourseOffering__c = courseOffering.Id,
            Type__c = 'Student',
            Batch__c = 'Batch1',
            RecordTypeId = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('CRT').getRecordTypeId()
        );
        insert courseConnection1;
        System.debug('Inserted courseConnection1: ' + courseConnection1.Id);

        CourseConnection__c courseConnection2 = new CourseConnection__c(
            Contact__c = student.Id,
            CourseOffering__c = courseOffering.Id,
            Type__c = 'Student',
            Batch__c = 'Batch1',
            RecordTypeId = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('Internship').getRecordTypeId()
        );
        insert courseConnection2;
        System.debug('Inserted courseConnection2: ' + courseConnection2.Id);

        CourseProgress__c cp = new CourseProgress__c(
            courseConnection__c = courseConnection1.Id
        );
        insert cp;
        System.debug('Inserted CourseProgress: ' + cp.Id);

        System.debug('Test execution completed');
    }
}