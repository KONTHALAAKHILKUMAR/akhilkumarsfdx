public without sharing class MentorCourseProgressTracker {

    public static final Id ACCOUNT_COLLEGE_UNIVERSITY = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('College_University').getRecordTypeId();
    public static final Id COURSECONNECTION_CRT = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('CRT').getRecordTypeId();
    public static final Id COURSECONNECTION_INTERNSHIP = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('Internship').getRecordTypeId();
    public static final Id COURSEPROGRESS_CRT = Schema.SObjectType.CourseProgress__c.getRecordTypeInfosByDeveloperName().get('CRT').getRecordTypeId();
    public static final Id COURSEPROGRESS_INTERNSHIP = Schema.SObjectType.CourseProgress__c.getRecordTypeInfosByDeveloperName().get('Internship').getRecordTypeId();
    public static String ACTIVE_STATUS='Active';
   
    @AuraEnabled
    public static List<String> getMentors(Boolean selectedCRTValue) {
        List<String> mentorNames = new List<String>();
        
        List<CourseConnection__c> courseConnections = [
            SELECT CourseOffering__r.Mentor__r.Name 
            FROM CourseConnection__c 
            WHERE Contact__r.CRT__c = :selectedCRTValue AND Status__c=: ACTIVE_STATUS
            ORDER BY CourseOffering__r.Mentor__r.Name ASC
        ];
        
        Set<String> mentorNamesSet = new Set<String>();
        
        for (CourseConnection__c connection : courseConnections) {
            if (connection.CourseOffering__r.Mentor__r.Name != null) {
                mentorNamesSet.add(connection.CourseOffering__r.Mentor__r.Name);
            }
        }
        
        mentorNames = new List<String>(mentorNamesSet);
        
        return mentorNames;
    }

    
    @AuraEnabled
    public static List<String> getUniversities(Boolean selectedCRTValue, String selectedMentor) {
        List<CourseConnection__c> courseConnections = [
            SELECT CourseOffering__r.collegeOrUniversity__r.Name 
            FROM CourseConnection__c 
            WHERE Contact__r.CRT__c = :selectedCRTValue AND CourseOffering__r.Mentor__r.Name = :selectedMentor AND Status__c=: ACTIVE_STATUS
            ORDER BY CourseOffering__r.collegeOrUniversity__r.Name ASC
        ];
        
        Set<String> universityNamesSet = new Set<String>();
        
        for (CourseConnection__c connection : courseConnections) {
            if (connection.CourseOffering__r.collegeOrUniversity__r.Name != null) {
                universityNamesSet.add(connection.CourseOffering__r.collegeOrUniversity__r.Name);
            }
        }
        return new List<String>(universityNamesSet);
    }
    

    @AuraEnabled
    public static List<String> getPrograms(Boolean selectedCRTValue, String selectedMentor, String selectedUniversity, String selectedApsche, String selectedYear) {
        String query = 'SELECT CourseOffering__r.Course__r.Program__r.Name ' +
                    'FROM CourseConnection__c ' +
                    'WHERE CourseOffering__r.Mentor__r.Name = :selectedMentor AND Status__c =: ACTIVE_STATUS ';
        
        if (selectedCRTValue) {
            query += 'AND Contact__r.CRT__c = true AND RecordTypeId = :COURSECONNECTION_CRT ';
            
            if (selectedYear != null && selectedYear != '') {
                query += 'AND Year__c = :selectedYear ';
            }
        } else {
            query += 'AND Contact__r.CRT__c = false AND RecordTypeId = :COURSECONNECTION_INTERNSHIP ';
        }
        
        if (selectedUniversity != null && selectedUniversity != '') {
            if (selectedUniversity == 'APSCHE' && selectedApsche != null && selectedApsche != '') {
                query += 'AND Contact__r.APSCHE_Name__c = :selectedApsche ';
            } else if (selectedUniversity != 'APSCHE') {
                query += 'AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity ';
            }
        }
        
        query += ' ORDER BY CourseOffering__r.Course__r.Program__r.Name ASC';
        System.debug('@@query' + query);
        
        List<CourseConnection__c> courseConnections = Database.query(query);

        Set<String> programNames = new Set<String>();
        for (CourseConnection__c courseConnection : courseConnections) {
            programNames.add(courseConnection.CourseOffering__r.Course__r.Program__r.Name);
        }
        System.debug('@@programNames' + programNames);

        return new List<String>(programNames);
    }


    @AuraEnabled
    public static List<String> getCourses(Boolean selectedCRTValue, String selectedMentor, String selectedUniversity, String selectedApsche, String selectedYear, String selectedProgram) {
        String query = 'SELECT CourseOffering__r.Course__r.Name FROM CourseConnection__c WHERE CourseOffering__r.Mentor__r.Name = :selectedMentor AND Status__c =: ACTIVE_STATUS ';

        if (selectedCRTValue != null) {
            if (selectedCRTValue) {
                query += ' AND Contact__r.CRT__c = true AND RecordTypeId = :COURSECONNECTION_CRT ';
                if (selectedYear != null && selectedYear != '') {
                    query += ' AND Year__c = :selectedYear ';
                }
            } else {
                query += ' AND Contact__r.CRT__c = false AND RecordTypeId = :COURSECONNECTION_INTERNSHIP ';
            }
        }
        
        if (selectedUniversity != null && selectedUniversity != '') {
            if (selectedUniversity == 'APSCHE' && selectedApsche != null && selectedApsche != '') {
                query += ' AND Contact__r.APSCHE_Name__c = :selectedApsche ';
            } else if (selectedUniversity != 'APSCHE') {
                query += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity ';
            }
        }
        
        if (selectedProgram != null && selectedProgram != '') {
            query += ' AND CourseOffering__r.Course__r.Program__r.Name = :selectedProgram ';
        }
        
        query += ' ORDER BY CourseOffering__r.Course__r.Name ASC';

        System.debug('@@query' + query);
        List<CourseConnection__c> courseConnections = Database.query(query);

        Set<String> courseNames = new Set<String>();
        for (CourseConnection__c courseConnection : courseConnections) {
            courseNames.add(courseConnection.CourseOffering__r.Course__r.Name);
        }
        System.debug('courseNames: ' + courseNames);

        return new List<String>(courseNames);
    }


    @AuraEnabled
    public static List<Wrapper> getData(Boolean selectedCRTValue,String selectedUniversity, String selectedMentor, String selectedAPSCHE, String selectedYear, String selectedProgram, String selectedCourse) {
        List<Wrapper> wrapList = new List<Wrapper>();
        
        Map<Id, String> courseToBatchMap = new Map<Id, String>();
        List<CourseOffering__c> courseOfferingList = [
            SELECT Course__c, Batch__c 
            FROM CourseOffering__c 
            WHERE Course__c IN (SELECT Course__c FROM CourseProgress__c)
        ];
        for (CourseOffering__c co : courseOfferingList) {
            courseToBatchMap.put(co.Course__c, co.Batch__c);
        }
    
        String query = 'SELECT Id, Program__r.Name, Course__r.Name,Course_Feedback__c, Course__r.No_of_Modules__c, Student__r.Name, Student__r.Account.Name, Student__r.APSCHE_Name__c, Project__c,Comments__c, ' +
                       ' Module_1_Status__c, Module_2_Status__c, Module_3_Status__c, Module_4_Status__c, Module_5_Status__c, Module_6_Status__c, Module_7_Status__c, Module_8_Status__c, ' +
                       ' Module_9_Status__c, Module_10_Status__c, Module_11_Status__c, Module_12_Status__c, Module_13_Status__c, Module_14_Status__c, Module_15_Status__c, ' +
                       ' Module1_Completion_Date__c, Module2_Completion_Date__c,Module3_Completion_Date__c,Module4_Completion_Date__c, '+
                       ' Module5_Completion_Date__c,Module6_Completion_Date__c,Module7_Completion_Date__c,Module8_Completion_Date__c, '+
                       ' Module9_Completion_Date__c,Module10_Completion_Date__c,Module11_Completion_Date__c,Module12_Completion_Date__c,Module13_Completion_Date__c,Module14_Completion_Date__c,Module15_Completion_Date__c '+
                       ' FROM CourseProgress__c WHERE Status__c =: ACTIVE_STATUS ';
    
        if (selectedMentor != null && selectedMentor != '') {
            query += ' AND CourseConnection__r.CourseOffering__r.Mentor__r.Name = : selectedMentor ';
        }

        if (selectedCRTValue != null) {
            if (selectedCRTValue) {
                query += ' AND Student__r.CRT__c = true AND RecordTypeId = :COURSEPROGRESS_CRT ';
                if (selectedYear != null && selectedYear != '') {
                    query += ' AND CourseConnection__r.Year__c = :selectedYear ';
                }
            } else {
                query += ' AND Student__r.CRT__c = false AND RecordTypeId = :COURSEPROGRESS_INTERNSHIP ';
            }
        }
        
        if (selectedUniversity != null && selectedUniversity != '') {
            if (selectedUniversity == 'APSCHE' && selectedApsche != null && selectedApsche != '') {
                query += ' AND Student__r.APSCHE_Name__c = :selectedApsche ';
            } else if (selectedUniversity != 'APSCHE') {
                query += ' AND CourseConnection__r.CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity ';
            }
        }

        if (selectedProgram != null && selectedProgram != '') {
            query += ' AND Program__r.Name= :selectedProgram';
        }
    
        if (selectedCourse != null && selectedCourse != '') {
            query += ' AND Course__r.Name = :selectedCourse ';
        }
        query += ' ORDER BY Course__r.Name ASC ';
        System.debug('Query: ' + query);
    
        List<CourseProgress__c> courseProgressList = Database.query(query);
        System.debug('Course Progress List: ' + JSON.serialize(courseProgressList));
        Integer serialNumber = 1;
    
        for (CourseProgress__c cp : courseProgressList) {
            Wrapper wrap = new Wrapper();
            wrap.Id = cp.Id;
            wrap.serialNumber = serialNumber++;
            wrap.studentName = cp.Student__r.Name;
            wrap.collegeName = cp.Student__r.Account.Name;
            wrap.apsche = cp.Student__r.APSCHE_Name__c;
            wrap.courseName = cp.Course__r.Name;
            wrap.project = cp.Project__c;
            wrap.comments = cp.Comments__c;
            wrap.courseFeedback = cp.Course_Feedback__c;
            wrap.totalModules = cp.Course__r.No_of_Modules__c;
            wrap.batchNumber = courseToBatchMap.get(cp.Course__c);
        
            Integer modulesCompletedCount = 0;
            Integer modulesInProgressCount = 0;
        
            for (Integer i = 1; i <= 15; i++) {
                String moduleStatus = (String) cp.get('Module_' + i + '_Status__c');
                if (moduleStatus == 'Completed') {
                    modulesCompletedCount++;
                } else if (moduleStatus == 'In Progress') {
                    modulesInProgressCount++;
                }
            }
        
            wrap.modulesCompleted = String.valueOf(modulesCompletedCount);
            wrap.modulesInProgress = String.valueOf(modulesInProgressCount);
            wrap.status = '';
            wrapList.add(wrap);
        }
        
        return wrapList;
    }
    
    @AuraEnabled
    public static void updateCourseProgress(List<Wrapper> updates) {
        System.debug('Entering updateCourseProgress method');
        if (updates == null || updates.isEmpty()) {
            System.debug('Updates list is empty or null');
        }

        List<CourseProgress__c> updateList = new List<CourseProgress__c>();
        for (Wrapper wrap : updates) {
            if (wrap.Id == null) {
                System.debug('One of the CourseProgress__c records is null');
            }

            CourseProgress__c cp = [SELECT Id, Course_Feedback__c, Project__c, Comments__c,
                                Module_1_Status__c, Module_2_Status__c, Module_3_Status__c, Module_4_Status__c, 
                                Module_5_Status__c, Module_6_Status__c, Module_7_Status__c, Module_8_Status__c,
                                Module_9_Status__c, Module_10_Status__c, Module_11_Status__c, Module_12_Status__c, 
                                Module_13_Status__c, Module_14_Status__c, Module_15_Status__c
                                FROM CourseProgress__c WHERE Id = :wrap.Id LIMIT 1];

            System.debug('Found CourseProgress__c record: ' + cp);

            if (wrap.selectedModuleNumbers != null) {
                for (String selectedModuleNumber : wrap.selectedModuleNumbers) {
                    System.debug('Processing selected module number: ' + selectedModuleNumber);

                    if (selectedModuleNumber.split(' ').size() > 1) {
                        String moduleNumber = selectedModuleNumber.split(' ')[1];
                        String statusField = 'Module_' + moduleNumber + '_Status__c';
                        String completionDateField = 'Module' + moduleNumber + '_Completion_Date__c';
                        String feedbackField = 'Module_' + moduleNumber + '_feedback__c';
                        String gradeField = 'Module_' + moduleNumber + '_Grade__c';

                        System.debug('Updating fields for module number: ' + moduleNumber);
                        cp.put(statusField, wrap.status);
                        cp.put(completionDateField, wrap.completedDate);
                        cp.put(feedbackField, wrap.moduleFeedback);
                        cp.put(gradeField, wrap.moduleGrade);
                    } else {
                        System.debug('Invalid selectedModuleNumber format: ' + selectedModuleNumber);
                    }
                }
            } else {
                System.debug('wrap.selectedModuleNumbers is null');
            }

            if (wrap.project != null) {
                cp.Project__c = wrap.project;
            }
            if (wrap.comments != null) {
                cp.Comments__c = wrap.comments;
            }
            if (wrap.courseFeedback != null) {
                cp.Course_Feedback__c = wrap.courseFeedback;
            }
            updateList.add(cp);
        }

        try {
            update updateList;
            System.debug('Successfully updated course progress records: ' + updateList);
        } catch (DmlException e) {
            System.debug('DML Exception: ' + e.getMessage());
        }
    }



    @AuraEnabled
    public static List<String> getIncompleteModuleStatuses(Id recordId, Integer totalModules) {
        List<String> incompleteStatuses = new List<String>();
        List<CourseProgress__c> results = [SELECT Id, Module_1_Status__c, Module_2_Status__c, Module_3_Status__c, Module_4_Status__c,
            Module_5_Status__c, Module_6_Status__c, Module_7_Status__c, Module_8_Status__c,Module_9_Status__c , Student__r.APSCHE_Name__c, 
            Module_10_Status__c,Module_11_Status__c,Module_12_Status__c,Module_13_Status__c,Module_14_Status__c,Module_15_Status__c
                                        FROM CourseProgress__c WHERE Id = :recordId LIMIT 1];
        
        if (results.isEmpty()) {
            return incompleteStatuses;
        }
        
        CourseProgress__c progress = results[0];
        
        for (Integer i = 1; i <= totalModules; i++) {
            String moduleStatusField = 'Module_' + i + '_Status__c';
            if ((String) progress.get(moduleStatusField) != 'Completed') {
                incompleteStatuses.add('Module ' + i);
            }
        }
        
        return incompleteStatuses;
    }


    public class Wrapper {
        @AuraEnabled public Id Id { get; set; }
        @AuraEnabled public Integer serialNumber { get; set; }
        @AuraEnabled public String studentName { get; set; }
        @AuraEnabled public String collegeName { get; set; }
        @AuraEnabled public String apsche { get; set; }
        @AuraEnabled public String batchNumber { get; set; }
        @AuraEnabled public String courseName { get; set; }
        @AuraEnabled public Decimal totalModules { get; set; }
        @AuraEnabled public String modulesCompleted { get; set; }
        @AuraEnabled public String modulesInProgress { get; set; }
        @AuraEnabled public List<String> selectedModuleNumbers { get; set; }
        @AuraEnabled public String status { get; set; }
        @AuraEnabled public String project { get; set; }
        @AuraEnabled public String comments { get; set; }
        @AuraEnabled public Date completedDate { get; set; }
        @AuraEnabled public String courseFeedback { get; set; }
        @AuraEnabled public String moduleFeedback { get; set; }
        @AuraEnabled public String moduleGrade { get; set; }
        public Wrapper() {
        }
    }
}