public without sharing class StudentJourneyTrackerCtrl {
    public static final Id ACCOUNT_COLLEGE_UNIVERSITY = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName()
        .get('College_University')
        .getRecordTypeId();

    @AuraEnabled
    public static List<Account> getUniversities() {
        return [SELECT Id, Name FROM Account WHERE RecordTypeId = :ACCOUNT_COLLEGE_UNIVERSITY ORDER BY Name ASC];
    }

    @AuraEnabled(cacheable=true)
    public static List<CourseProgress__c> getStudentData(String selectedUniversity, String selectedStudent) {
      String activeStatus='Active';

        String query= 'SELECT Name,Student__r.Name,Course__r.Name,Course__r.Status__c,Course__r.No_of_Modules__c,Program__r.Name, '+
         'Student__r.Email, Student__r.Account.Name,Student__r.APSCHE__c,Student__r.APSCHE_Name__c, '+
         'Module_1_Status__c, Module_2_Status__c, Module_3_Status__c, Module_4_Status__c, Module_5_Status__c, '+
         'Module_6_Status__c, Module_7_Status__c, Module_8_Status__c, Module_9_Status__c, Module_10_Status__c, '+
         'Module_11_Status__c, Module_12_Status__c, Module_13_Status__c, Module_14_Status__c, Module_15_Status__c, '+
         'Module1_Completion_Date__c, Module2_Completion_Date__c, Module3_Completion_Date__c, Module4_Completion_Date__c, Module5_Completion_Date__c, Module6_Completion_Date__c, Module7_Completion_Date__c,Module8_Completion_Date__c, '+
         'Module9_Completion_Date__c, Module10_Completion_Date__c, Module11_Completion_Date__c, Module12_Completion_Date__c, Module13_Completion_Date__c, Module14_Completion_Date__c, Module15_Completion_Date__c, '+
         'Module_1_feedback__c, Module_2_feedback__c, Module_3_feedback__c, Module_4_feedback__c, Module_5_feedback__c, '+
         'Module_6_feedback__c, Module_7_feedback__c, Module_8_feedback__c, Module_9_feedback__c, Module_10_feedback__c, '+
         'Module_11_feedback__c, Module_12_feedback__c, Module_13_feedback__c, Module_14_feedback__c, Module_15_feedback__c, Course_Feedback__c, '+        
         'Module_1_Grade__c, Module_2_Grade__c, Module_3_Grade__c, Module_4_Grade__c, Module_5_Grade__c, '+
         'Module_6_Grade__c, Module_7_Grade__c, Module_8_Grade__c, Module_9_Grade__c, Module_10_Grade__c, '+
         'Module_11_Grade__c, Module_12_Grade__c, Module_13_Grade__c, Module_14_Grade__c, Module_15_Grade__c '+        
         
         'FROM CourseProgress__c  WHERE Student__r.AccountId =: selectedUniversity AND Student__c=: selectedStudent  ';
       
         return Database.query(query);
    }

}