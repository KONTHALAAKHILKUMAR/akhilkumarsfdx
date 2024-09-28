@isTest
public class UtilityClassTest {
    
    public static testmethod void testMethod1()
    {
        account eTutor_Students = new account();
        eTutor_Students.name = 'eTutor_Students';
        insert eTutor_Students;
        account SirianProject = new account();
        SirianProject.name = 'SirianProject';
        insert SirianProject; 
        
        contact mainHandler = new contact();
        mainHandler.lastname='Kalyani_eTutor';
        mainHandler.email='Kalyani_eTutor@abc.com';
        mainHandler.recordtypeid= Schema.SObjectType.contact.getRecordTypeInfosByName().get('Internal').getRecordTypeId();
        mainHandler.AccountId=SirianProject.id;
        insert mainHandler;
        contact student = new contact();
        student.lastname='student';
        student.email='student@abc.com';
        student.recordtypeid= Schema.SObjectType.contact.getRecordTypeInfosByName().get('eTutor').getRecordTypeId();
        student.AccountId=eTutor_Students.id;
        insert student;
        
        
        Task t = new Task();
        t.OwnerId = UserInfo.getUserId();
        t.Subject='Donni';
        t.Status='Not Started';
        t.Priority='Normal';
        insert t;  
        
        ErrorHandler.logerror('test' ,'test' ,'test' ,'test');
        
        Test.setMock(HttpCalloutMock.class, new HttpCalloutMockClass());   
        test.startTest();
        WorkOrder__c wo = new WorkOrder__c();
        
        wo.Subject__c = 'test';
        wo.Price__c=200;
        wo.Final_Document__c='abc.com';
        wo.eTutorStatus__c='Work Order Received';
        wo.ActualStatus__c ='New Work order';
        wo.MainHandler__c=mainHandler.id;
        wo.TeamMember__c=mainHandler.id;
        wo.eTutorWorkOrderID__c='123';
        insert wo;
        
        
        
        RestRequest req = new RestRequest(); 
        req.addParameter('workorderID',wo.id);
        req.addParameter('name','test');
        String fileData = 'This ';
        String fileDateBase64 = EncodingUtil.base64Encode(Blob.valueOf(fileData));
        
        req.requestBody=Blob.valueof(JSON.serialize(fileDateBase64));
      
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/DocumentUploadBase64/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response= res;
        DocumentUploadBase64.uploadDocument();
      
        
        
         test.stopTest();   
        
        
        
        
    }
}