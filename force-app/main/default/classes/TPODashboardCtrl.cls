public class TPODashboardCtrl {
    public static final Id COURSECONNECTION_CRT = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('CRT').getRecordTypeId();
    public static final Id COURSECONNECTION_INTERNSHIP = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('Internship').getRecordTypeId();
    public static final Id COURSEPROGRESS_CRT = Schema.SObjectType.CourseProgress__c.getRecordTypeInfosByDeveloperName().get('CRT').getRecordTypeId();
    public static final Boolean crtStatus =true;
    public static String ACTIVE_STATUS='Active';
    

    @AuraEnabled
    public static Map<String, Object> getUniversities() {
        User loggedInUser = [SELECT Profile.Name, Account.Name, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
    
        if (loggedInUser.Profile.Name != 'System Administrator' && loggedInUser.Profile.Name != 'Etutor System Administrator' ) {
            try {
                Contact userContact = [SELECT TPO__c FROM Contact WHERE Id = :loggedInUser.ContactId LIMIT 1];
                if (userContact == null || !userContact.TPO__c) {
                    return null;
                }
            } catch (Exception e) {
                System.debug('Error retrieving user contact: ' + e.getMessage());
                return null;
            }
        }
            
        List<CourseConnection__c> courseConnections;
        
        if (loggedInUser.Profile.Name == 'System Administrator' || loggedInUser.Profile.Name =='Etutor System Administrator') {
            courseConnections = [
                SELECT CourseOffering__r.collegeOrUniversity__r.Name, Contact__r.Id 
                FROM CourseConnection__c 
                WHERE Contact__r.CRT__c = true AND Status__c=: ACTIVE_STATUS 
                ORDER BY CourseOffering__r.collegeOrUniversity__r.Name ASC
            ];
        } else {
            courseConnections = [
                SELECT CourseOffering__r.collegeOrUniversity__r.Name, Contact__r.Id 
                FROM CourseConnection__c 
                WHERE Contact__r.CRT__c = true AND Contact__r.Account.Name = :loggedInUser.Account.Name AND Status__c=: ACTIVE_STATUS
                ORDER BY CourseOffering__r.collegeOrUniversity__r.Name ASC
            ];
        }
        
        Map<String, Set<Id>> universityStudentMap = new Map<String, Set<Id>>();
        
        for (CourseConnection__c connection : courseConnections) {
            if (connection.CourseOffering__r.collegeOrUniversity__r.Name != null) {
                String universityName = connection.CourseOffering__r.collegeOrUniversity__r.Name;
                Id studentId = connection.Contact__r.Id;
                
                if (!universityStudentMap.containsKey(universityName)) {
                    universityStudentMap.put(universityName, new Set<Id>());
                }
                
                if (studentId != null) {
                    universityStudentMap.get(universityName).add(studentId);
                }
            }
        }
        Map<String, Object> result = new Map<String, Object>();
        Map<String, Integer> universityStudentCountMap = new Map<String, Integer>();
        for (String universityName : universityStudentMap.keySet()) {
            universityStudentCountMap.put(universityName, universityStudentMap.get(universityName).size());
        }
        result.put('universityStudentCounts', universityStudentCountMap);
        
        return result;
    }
    
    @AuraEnabled
    public static Map<String, Integer> getYearWiseStudentCount(String selectedUniversity, String selectedYear) {
        String query = 'SELECT Year__c, Contact__r.Id FROM CourseConnection__c WHERE Contact__r.CRT__c =: crtStatus AND Status__c=: ACTIVE_STATUS ';
        
        if (selectedUniversity != '') {
            query += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity';
        }
        if (selectedYear != '') {
            query += ' AND Year__c = :selectedYear';
        }
        List<CourseConnection__c> courseConnections = Database.query(query);
        
        Map<String, Set<Id>> yearWiseStudentMap = new Map<String, Set<Id>>();
        
        for (CourseConnection__c connection : courseConnections) {
            if (connection.Year__c != null) {
                if (!yearWiseStudentMap.containsKey(connection.Year__c)) {
                    yearWiseStudentMap.put(connection.Year__c, new Set<Id>());
                }
                yearWiseStudentMap.get(connection.Year__c).add(connection.Contact__r.Id);
            }
        }
        Map<String, Integer> yearWiseStudentCountMap = new Map<String, Integer>();
        for (String year : yearWiseStudentMap.keySet()) {
            yearWiseStudentCountMap.put(year, yearWiseStudentMap.get(year).size());
        }
        
        return yearWiseStudentCountMap;
    }
    

    @AuraEnabled
    public static Map<String, Object> getPrograms(String selectedUniversity, String selectedYear) {
        String query = 'SELECT CourseOffering__r.Course__r.Program__r.Name, Contact__r.Id ' +
                    'FROM CourseConnection__c ' +
                    'WHERE Contact__r.CRT__c =: crtStatus AND RecordTypeId = :COURSECONNECTION_CRT AND Status__c=: ACTIVE_STATUS ';
        
        if (selectedUniversity != null && selectedUniversity != '') {
            query += 'AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity ';
        }
        if (selectedYear != null && selectedYear != '') {
            query += 'AND Year__c = :selectedYear ';
        }        

        query += ' ORDER BY CourseOffering__r.Course__r.Program__r.Name ASC';
        System.debug('@@query' + query);
        
        List<CourseConnection__c> courseConnections = Database.query(query);

        Map<String, Set<Id>> programToStudentIdsMap = new Map<String, Set<Id>>();
        for (CourseConnection__c courseConnection : courseConnections) {
            String programName = courseConnection.CourseOffering__r.Course__r.Program__r.Name;
            if (!programToStudentIdsMap.containsKey(programName)) {
                programToStudentIdsMap.put(programName, new Set<Id>());
            }
            programToStudentIdsMap.get(programName).add(courseConnection.Contact__r.Id);
        }
        System.debug('@@programToStudentIdsMap' + programToStudentIdsMap);

        Map<String, Integer> programWiseStudentCount = new Map<String, Integer>();
        for (String programName : programToStudentIdsMap.keySet()) {
            programWiseStudentCount.put(programName, programToStudentIdsMap.get(programName).size());
        }

        Map<String, Object> result = new Map<String, Object>();
        result.put('programWiseStudentCount', programWiseStudentCount);

        return result;
    }



    
    @AuraEnabled
    public static List<Chart_Colors__mdt> getChartColors() {
        return [SELECT DeveloperName, Color__c FROM Chart_Colors__mdt];
    }
     

    
    @AuraEnabled
    public static List<String> getCourses(String selectedUniversity, String selectedYear, String selectedProgram) {

        String query = 'SELECT CourseOffering__r.Course__r.Name FROM CourseConnection__c WHERE Contact__r.CRT__c =: crtStatus AND RecordTypeId = :COURSECONNECTION_CRT  AND Status__c=: ACTIVE_STATUS ';

        
        if (selectedUniversity != null && selectedUniversity != '') {
            query += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity ';
        }
        if (selectedYear != '' ) {
            query += ' AND Year__c= :selectedYear ';
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
    public static List<CourseProgress__c> getModuleWiseData(String selectedUniversity,String selectedYear, String selectedCourse,String selectedProgram) {
        
        String query = 'Select Id, Name,Module_1_Status__c, Module_2_Status__c, Module_3_Status__c, Module_4_Status__c ,Module_5_Status__c, Module_6_Status__c, Module_7_Status__c, Module_8_Status__c, ' +
        'Module_9_Status__c, Module_10_Status__c, Module_11_Status__c, Module_12_Status__c ,Module_13_Status__c, Module_14_Status__c, Module_15_Status__c,Project__c , ' +
        'Course__r.No_of_Modules__c, Student__r.Name, Student__r.Email,Student__r.AccountId,Course__r.Name,CourseConnection__r.CourseOffering__r.Start_Date__c,CourseConnection__r.CourseOffering__r.End_Date__c, '+
        'Module1_Completion_Date__c, Module2_Completion_Date__c, Module3_Completion_Date__c, Module4_Completion_Date__c, Module5_Completion_Date__c, Module6_Completion_Date__c, Module7_Completion_Date__c,Module8_Completion_Date__c, '+
        'Module9_Completion_Date__c, Module10_Completion_Date__c, Module11_Completion_Date__c, Module12_Completion_Date__c, Module13_Completion_Date__c, Module14_Completion_Date__c, Module15_Completion_Date__c, '+
        'CourseConnection__r.CourseOffering__r.Module1_Due_Date__c,CourseConnection__r.CourseOffering__r.Module2_Due_Date__c,CourseConnection__r.CourseOffering__r.Module3_Due_Date__c,CourseConnection__r.CourseOffering__r.Module4_Due_Date__c,CourseConnection__r.CourseOffering__r.Module5_Due_Date__c, '+
        'CourseConnection__r.CourseOffering__r.Module6_Due_Date__c,CourseConnection__r.CourseOffering__r.Module7_Due_Date__c,CourseConnection__r.CourseOffering__r.Module8_Due_Date__c,CourseConnection__r.CourseOffering__r.Module9_Due_Date__c,CourseConnection__r.CourseOffering__r.Module10_Due_Date__c, '+
        'CourseConnection__r.CourseOffering__r.Module11_Due_Date__c,CourseConnection__r.CourseOffering__r.Module12_Due_Date__c,CourseConnection__r.CourseOffering__r.Module13_Due_Date__c,CourseConnection__r.CourseOffering__r.Module14_Due_Date__c,CourseConnection__r.CourseOffering__r.Module15_Due_Date__c '+
        'FROM CourseProgress__c  WHERE Student__r.CRT__c =: crtStatus AND RecordTypeId = :COURSEPROGRESS_CRT AND Status__c=: ACTIVE_STATUS ';

        
        if (selectedUniversity != '' ) {
            query += ' AND CourseConnection__r.CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity';
        }
        if (selectedYear != '' ) {
            query += ' AND CourseConnection__r.Year__c= :selectedYear ';
        }
        if (selectedCourse != null && selectedCourse != '') {
            query += ' AND Course__r.Name = :selectedCourse';

        }    

        if (selectedProgram != null && selectedProgram != '') {
            query += ' AND Program__r.Name = :selectedProgram ';
        }
        query +=' ORDER BY Student__r.Name ASC ';
        System.debug('Database.query(query): '+Database.query(query));
        return Database.query(query);
    }
    
    
    
}