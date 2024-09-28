@isTest
public class tx_StudentConsentFormTest {
    
    public static testmethod void testMethod1()
    {
        account Cumberlands = new account();
        Cumberlands.name = 'Cumberlands';
        insert Cumberlands; 
        contact student_cumb = new contact();
        student_cumb.lastname='student_cumb';
        student_cumb.recordtypeid= Schema.SObjectType.contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        student_cumb.AccountId=Cumberlands.id;
        insert student_cumb;
         Tx_StudentConsentForm  consent= new Tx_StudentConsentForm();
        consent.save();
        consent.cancel();
        
       
    }
    
     public static testmethod void testMethod2()
    {
        account Cumberlands = new account();
        Cumberlands.name = 'Cumberlands';
        insert Cumberlands; 
        contact student_cumb = new contact();
        student_cumb.lastname='student_cumb';
        student_cumb.recordtypeid= Schema.SObjectType.contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        student_cumb.AccountId=Cumberlands.id;
        insert student_cumb;
       
        Tx_StudentConsentFormGeneral  consent1= new Tx_StudentConsentFormGeneral();
        consent1.SelectedContact.lastname='student_cumb';  
        consent1.save();
       
       
    }
     public static testmethod void testMethod3()
    {
        account Cumberlands = new account();
        Cumberlands.name = 'Cumberlands';
        insert Cumberlands; 
        contact student_cumb = new contact();
        student_cumb.lastname='student_cumb';
        student_cumb.recordtypeid= Schema.SObjectType.contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        student_cumb.AccountId=Cumberlands.id;
        insert student_cumb;
       
        Tx_StudentConsentFormGeneral  consent1= new Tx_StudentConsentFormGeneral();
        consent1.SelectedContact.lastname='student_cumb';  
        
        consent1.cancel();
       
    }
}