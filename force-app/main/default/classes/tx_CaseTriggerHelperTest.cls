@isTest
public class tx_CaseTriggerHelperTest {
    
    public static testmethod void testMethod1()
    {
        account Cumberlands = new account();
        Cumberlands.name = 'Cumberlands';
        insert Cumberlands; 
        contact student_cumb = new contact();
        student_cumb.lastname='student_cumb';
        student_cumb.email='test1@abc.com';
        student_cumb.recordtypeid= Schema.SObjectType.contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        student_cumb.AccountId=Cumberlands.id;
        insert student_cumb;
        
        Case c = new Case();
        c.subject='Test';
        c.contactid=student_cumb.id;
        c.tx_Contact_Email__c='test@abc.com';
        
        insert c;
        
    }
}