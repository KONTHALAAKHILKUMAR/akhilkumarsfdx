public without sharing class DashBoardCtrl {
    public static final Id COURSECONNECTION_CRT = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('CRT').getRecordTypeId();
    public static final Id COURSECONNECTION_INTERNSHIP = Schema.SObjectType.CourseConnection__c.getRecordTypeInfosByDeveloperName().get('Internship').getRecordTypeId();
    public static String ACTIVE_STATUS='Active';

    @AuraEnabled
    public static List<String> getMentors(Boolean selectedCRTValue) {
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
        
        return new List<String>(mentorNamesSet);
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
    public static List<AggregateResult> getUniversityWiseData(Boolean selectedCRTValue, String selectedMentor, String selectedUniversity, String selectedApsche) {
        String studentType = 'Student';
        String query = 'SELECT ';
        
        if (selectedCRTValue == false) {
            if (selectedUniversity == 'APSCHE') {
                query += 'Contact__r.APSCHE_Name__c APSCHEName';
            } else {
                query += 'CourseOffering__r.collegeOrUniversity__r.Name collegeOrUniversityName';
            }            
        } else {
            query += 'Year__c';
        }
    
        query += ', COUNT_DISTINCT(Contact__c) uniqueStudents ' +
                 'FROM CourseConnection__c WHERE  Type__c = :studentType  AND CourseOffering__r.Mentor__r.Name = :selectedMentor AND Status__c=: ACTIVE_STATUS ';
        
        if (selectedCRTValue != null) {
            if (selectedCRTValue) {
                query += ' AND Contact__r.CRT__c = true AND RecordTypeId = :COURSECONNECTION_CRT ';
            } else {
                query += ' AND Contact__r.CRT__c = false AND RecordTypeId = :COURSECONNECTION_INTERNSHIP ';
            }
        }
        
        if (selectedUniversity != null && selectedUniversity != '') {
            if (selectedUniversity == 'APSCHE' && selectedApsche != null && selectedApsche != '') {
                query += ' AND Contact__r.APSCHE_Name__c = :selectedApsche ';
            } else if (selectedUniversity == 'APSCHE' &&  selectedApsche == '') {
                query += ' AND Contact__r.APSCHE_Name__c != null ';
            } else if (selectedUniversity != 'APSCHE') {
                query += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUniversity ';
            }
        }
    
        if (selectedCRTValue == true) {
            query += ' GROUP BY Year__c';
        } 
        if (selectedCRTValue == false) {
            if (selectedUniversity == 'APSCHE') {
                query += ' GROUP BY Contact__r.APSCHE_Name__c';
            } else {
                query += ' GROUP BY CourseOffering__r.collegeOrUniversity__c, CourseOffering__r.collegeOrUniversity__r.Name';
            }
        }
        System.debug('@@query'+query);
        return Database.query(query);
        
    }
    


    
    @AuraEnabled
    public static List<Chart_Colors__mdt> getChartColors() {
        return [SELECT DeveloperName, Color__c FROM Chart_Colors__mdt];
    }
     
    @AuraEnabled
    public static Map<String, Object> getProgramWiseData(Boolean selectedCRTValue, String selectedMentor, String selectedUniversity, String selectedUDLabel, String selectedApsche) {
        String studentType = 'Student';
        String query = 'SELECT CourseOffering__r.Course__r.Program__r.Name, COUNT_DISTINCT(Contact__c) uniqueStudents FROM CourseConnection__c WHERE Type__c = :studentType AND Status__c=: ACTIVE_STATUS ';
        
        if (!String.isEmpty(selectedMentor)) {
            query += ' AND CourseOffering__r.Mentor__r.Name = :selectedMentor';
        }
        
        if (selectedCRTValue == false) {
            if ((selectedUniversity != '' && selectedUniversity != 'APSCHE') || (selectedUniversity == '')) {
                query += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUDLabel';
            } else if (selectedUniversity == 'APSCHE') {
                if (selectedApsche != '') {
                    query += ' AND Contact__r.APSCHE_Name__c = :selectedUDLabel';
                } else {
                    query += ' AND Contact__r.APSCHE_Name__c != null';
                }
            }
        } else {
            if (selectedUniversity != '' && selectedUDLabel != '') {
                query += ' AND Year__c = :selectedUDLabel';
            } 
        }
        
        query += ' GROUP BY CourseOffering__r.Course__r.Program__r.Name';
        List<AggregateResult> programWiseData = Database.query(query);
        
        String totalUniqueStudentsQuery = 'SELECT COUNT_DISTINCT(Contact__c) uniqueStudents FROM CourseConnection__c WHERE Type__c = :studentType';
        if (!String.isEmpty(selectedMentor)) {
            totalUniqueStudentsQuery += ' AND CourseOffering__r.Mentor__r.Name = :selectedMentor';
        }
        if (selectedCRTValue == false) {
            if ((selectedUniversity != '' && selectedUniversity != 'APSCHE') || (selectedUniversity == '')) {
                totalUniqueStudentsQuery += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUDLabel';
            } else if (selectedUniversity == 'APSCHE') {
                if (selectedApsche != '') {
                    totalUniqueStudentsQuery += ' AND Contact__r.APSCHE_Name__c = :selectedUDLabel';
                } else {
                    totalUniqueStudentsQuery += ' AND Contact__r.APSCHE_Name__c != null';
                }
            }
        } else {
            if (selectedUniversity != '' && selectedUDLabel != '') {
                totalUniqueStudentsQuery += ' AND Year__c = :selectedUDLabel';
            } 
        }

        AggregateResult totalUniqueStudentsResult = Database.query(totalUniqueStudentsQuery);
        Integer totalUniqueStudents = (Integer)totalUniqueStudentsResult.get('uniqueStudents');
        Map<String, Object> resultMap = new Map<String, Object>();
        resultMap.put('programWiseData', programWiseData);
        resultMap.put('totalUniqueStudents', totalUniqueStudents);
        
        return resultMap;
    }

    
    

    
    @AuraEnabled
    public static List<Map<String, String>> getCourseOptions( Boolean selectedCRTValue,
        String selectedMentor,String selectedUDLabel,
        String selectedUniversity, 
        String selectedProgram, String selectedApsche) {

        String query = 'SELECT CourseOffering__r.Course__r.Name, Id FROM CourseConnection__c WHERE  Status__c=: ACTIVE_STATUS ';
        
        if (selectedMentor != null && selectedMentor != '') {
            query += ' AND CourseOffering__r.Mentor__r.Name = :selectedMentor ';
        }
        if (selectedCRTValue == false) {
            if ((selectedUniversity != '' && selectedUniversity != 'APSCHE') || (selectedUniversity == '')) {
                query += ' AND CourseOffering__r.collegeOrUniversity__r.Name = :selectedUDLabel';
            } else if (selectedUniversity == 'APSCHE') {
                if (selectedApsche != '') {
                    query += ' AND Contact__r.APSCHE_Name__c = :selectedUDLabel';
                } else {
                    query += ' AND Contact__r.APSCHE_Name__c != null';
                }
            }
        } else {
            if (selectedUniversity != '' && selectedUDLabel != '') {
                query += ' AND Year__c = :selectedUDLabel';
            } 
        }
        if (selectedProgram != null && selectedProgram != '') {
            query += ' AND CourseOffering__r.Course__r.Program__r.Name = :selectedProgram '; 
        }
    
        System.debug('getCourseOptions query: ' + query);
        List<CourseConnection__c> courseConnections = Database.query(query);
        
        Set<String> uniqueCourseNames = new Set<String>();
        List<Map<String, String>> courseList = new List<Map<String, String>>();
        
        for (CourseConnection__c courseConnection : courseConnections) {
            String courseName = courseConnection.CourseOffering__r.Course__r.Name;
            if (!uniqueCourseNames.contains(courseName)) {
                uniqueCourseNames.add(courseName);
                Map<String, String> courseMap = new Map<String, String>();
                courseMap.put('label', courseName);
                courseMap.put('value', courseConnection.CourseOffering__r.Course__c);
                courseList.add(courseMap);
            }
        }
        
        return courseList;
    }

    @AuraEnabled
    public static List<CourseProgress__c> getModuleWiseData(  Boolean selectedCRTValue,      
        String selectedMentor,String selectedUDLabel,
        String selectedUniversity, String selectedCourse,
         String selectedProgram, String selectedApsche) {
        
        String query = 'Select Id, Name,Module_1_Status__c, Module_2_Status__c, Module_3_Status__c, Module_4_Status__c ,Module_5_Status__c, Module_6_Status__c, Module_7_Status__c, Module_8_Status__c, ' +
        'Module_9_Status__c, Module_10_Status__c, Module_11_Status__c, Module_12_Status__c ,Module_13_Status__c, Module_14_Status__c, Module_15_Status__c,Project__c , ' +
        'Course__r.No_of_Modules__c, Student__r.Name, Student__r.Email,Student__r.AccountId,Course__r.Name,CourseConnection__r.CourseOffering__r.Start_Date__c,CourseConnection__r.CourseOffering__r.End_Date__c, '+
        'Module1_Completion_Date__c, Module2_Completion_Date__c, Module3_Completion_Date__c, Module4_Completion_Date__c, Module5_Completion_Date__c, Module6_Completion_Date__c, Module7_Completion_Date__c,Module8_Completion_Date__c, '+
        'Module9_Completion_Date__c, Module10_Completion_Date__c, Module11_Completion_Date__c, Module12_Completion_Date__c, Module13_Completion_Date__c, Module14_Completion_Date__c, Module15_Completion_Date__c, '+
        'CourseConnection__r.CourseOffering__r.Module1_Due_Date__c,CourseConnection__r.CourseOffering__r.Module2_Due_Date__c,CourseConnection__r.CourseOffering__r.Module3_Due_Date__c,CourseConnection__r.CourseOffering__r.Module4_Due_Date__c,CourseConnection__r.CourseOffering__r.Module5_Due_Date__c, '+
        'CourseConnection__r.CourseOffering__r.Module6_Due_Date__c,CourseConnection__r.CourseOffering__r.Module7_Due_Date__c,CourseConnection__r.CourseOffering__r.Module8_Due_Date__c,CourseConnection__r.CourseOffering__r.Module9_Due_Date__c,CourseConnection__r.CourseOffering__r.Module10_Due_Date__c, '+
        'CourseConnection__r.CourseOffering__r.Module11_Due_Date__c,CourseConnection__r.CourseOffering__r.Module12_Due_Date__c,CourseConnection__r.CourseOffering__r.Module13_Due_Date__c,CourseConnection__r.CourseOffering__r.Module14_Due_Date__c,CourseConnection__r.CourseOffering__r.Module15_Due_Date__c '+
        'FROM CourseProgress__c  WHERE Status__c=: ACTIVE_STATUS ';

        if (selectedMentor != null && selectedMentor != '') {
            query += 'AND CourseConnection__r.CourseOffering__r.Mentor__r.Name = :selectedMentor ';
        }
        if (selectedCRTValue == false) {
            if ((selectedUniversity != '' && selectedUniversity != 'APSCHE') || (selectedUniversity == '')) {
                query += ' AND CourseConnection__r.CourseOffering__r.collegeOrUniversity__r.Name = :selectedUDLabel';
            } else if (selectedUniversity == 'APSCHE') {
                if (selectedApsche != '') {
                    query += ' AND Student__r.APSCHE_Name__c = :selectedUDLabel';
                } else {
                    query += ' AND Student__r.APSCHE_Name__c != null';
                }
            }
        } else {
            if (selectedUniversity != '' && selectedUDLabel != '') {
                query += ' AND CourseConnection__r.Year__c = :selectedUDLabel';
            } 
        }

        if (selectedCourse != null && selectedCourse != '') {
            query += ' AND Course__c = :selectedCourse';

        }    

        if (selectedProgram != null && selectedProgram != '') {
            query += ' AND Program__r.Name = :selectedProgram ';
        }
        query +=' ORDER BY Student__r.Name ASC ';
        
        System.debug('Database.query(query): '+Database.query(query));
        return Database.query(query);
    }

}