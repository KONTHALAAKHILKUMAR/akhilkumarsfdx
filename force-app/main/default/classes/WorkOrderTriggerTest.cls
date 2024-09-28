@isTest
public class WorkOrderTriggerTest {
    
    public static testmethod void testMethod1()
    {
        account eTutor_Students = new account();
        eTutor_Students.name = 'eTutor_Students';
        insert eTutor_Students;
        account SirianProject = new account();
        SirianProject.name = 'eTutor Staff';
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
        
        eTutorDetails__c customSetting= new eTutorDetails__c();
        customSetting.WorkOrderURL__c='abc.com';
        customSetting.WorkOrderPaymentURL__c='abc.com';
        customSetting.APIKEY__c='test';
        insert customSetting;
        
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
        wo.recordtypeid= Schema.SObjectType.WorkOrder__c.getRecordTypeInfosByName().get('Content Writing').getRecordTypeId();
        insert wo;
        
        wo.eTutorStatus__c='Work Order Received';
        wo.ActualStatus__c='Assigned to Main Handler';
        update wo;
        
        wo.eTutorStatus__c='Payment Pending';
        wo.ActualStatus__c='Pending with customer for Initial payment';
        update wo;
        
        WorkOrderPayment__c wop = new WorkOrderPayment__c();
        wop.Amount__c=100;
        wop.Status__c='Confirmed';
        wop.WorkOrder__c=wo.id;
        wop.eTutorPaymentID__c='123';
        insert wop;
        
        WorkOrderPayment__c wop1 = new WorkOrderPayment__c();
        wop1.Amount__c=100;
        wop1.Status__c='Pending Confirmation';
        wop1.WorkOrder__c=wo.id;
         wop1.eTutorPaymentID__c='1234';
        insert wop1;
        wop1.Status__c='Confirmed';
        update wop1;
        
        
        
        wo.eTutorStatus__c='Work in Progress';
        wo.ActualStatus__c='Pending with Team member';
        update wo;
        wo.eTutorStatus__c='Work in Progress';
        wo.ActualStatus__c='Team member open Queries';
        update wo;
        wo.eTutorStatus__c='Work in Progress';
        wo.ActualStatus__c='Main handler work review';
        update wo;
        
        wo.eTutorStatus__c='Additional information Required';
        wo.ActualStatus__c='Pending with Customer for Queires';
        update wo;
        
        wo.eTutorStatus__c='Work completed. Payment pending';
        wo.ActualStatus__c='Main Handler review completed';
        update wo;
        wo.eTutorStatus__c='Completed';
        wo.ActualStatus__c='Work delivered';
        update wo;
        
        test.stopTest();   
    }
     public static testmethod void testMethod2()
    {
        account eTutor_Students = new account();
        eTutor_Students.name = 'eTutor_Students';
        insert eTutor_Students;
        account SirianProject = new account();
        SirianProject.name = 'eTutor Staff';
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
        
        eTutorDetails__c customSetting= new eTutorDetails__c();
        customSetting.WorkOrderURL__c='abc.com';
        customSetting.WorkOrderPaymentURL__c='abc.com';
        customSetting.APIKEY__c='test';
        customSetting.PlagiairsmPaymentURL__c='abc.com';
         customSetting.PlagiairsmURL__c='abc.com';
        insert customSetting;
        
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
        wo.recordtypeid= Schema.SObjectType.WorkOrder__c.getRecordTypeInfosByName().get('Plagiarism Check').getRecordTypeId();
        insert wo;
        
        wo.eTutorStatus__c='Work Order Received';
        //wo.ActualStatus__c='Assigned to Main Handler';
        update wo;
        
        wo.eTutorStatus__c='Work completed. Payment Pending';
        //wo.ActualStatus__c='Pending with customer for Initial payment';
        update wo;
        
        WorkOrderPayment__c wop = new WorkOrderPayment__c();
        wop.Amount__c=100;
        wop.Status__c='Confirmed';
        wop.WorkOrder__c=wo.id;
        wop.eTutorPaymentID__c='123';
        insert wop;
        
        WorkOrderPayment__c wop1 = new WorkOrderPayment__c();
        wop1.Amount__c=100;
        wop1.Status__c='Pending Confirmation';
        wop1.WorkOrder__c=wo.id;
         wop1.eTutorPaymentID__c='1234';
        insert wop1;
        wop1.Status__c='Confirmed';
        update wop1;
        
        
        
        wo.eTutorStatus__c='Work in Progress';
        //wo.ActualStatus__c='Pending with Team member';
        update wo;
                
        wo.eTutorStatus__c='Additional information Required';
        
        update wo;
        
        
        wo.eTutorStatus__c='Plagiarism Free Report Completed';
       
        update wo;
        
        test.stopTest();   
    }
}