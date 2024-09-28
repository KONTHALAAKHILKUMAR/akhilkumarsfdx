@isTest
private class StudentJourneyTrackerCtrlTest {
    @isTest
    static void myUnitTest() {
          String selectedUniversity ='Avila';
          String selectedStudent ='testStudent';
          List<Account>acc= StudentJourneyTrackerCtrl.getUniversities();
          List<CourseProgress__c> cps= StudentJourneyTrackerCtrl.getStudentData(selectedUniversity,selectedStudent);
    }
}