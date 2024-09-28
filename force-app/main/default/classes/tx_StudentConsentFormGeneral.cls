public  class tx_StudentConsentFormGeneral{
    public Contact SelectedContact {get;set;}
    public Contact SelectedContact1 {get;set;}
    public boolean showTenantDetails {get;set;}
    public string studentEmail {get;set;}
    public boolean hideButtons {get;set;}
    public boolean showButtons {get;set;}
    
    public tx_StudentConsentFormGeneral(){
        showTenantDetails=false;
        SelectedContact=new Contact();
        
    }
    public PageReference cancel(){
        SelectedContact.recordtypeID=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        selectedContact.referredStudent__c=true;
        selectedContact.accountid=system.label.unknownAccountID;
        SelectedContact.lastName =SelectedContact.firstName + ' '+ SelectedContact.lastName;
        SelectedContact.firstName=null;
        insert selectedContact;
        
        Case c  = new Case();
        c.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Taxation').getRecordTypeId(); 
        c.contactID=SelectedContact.id;
        c.Accountid=SelectedContact.accountid;
        c.subject= Date.Today().Year() + ' Taxation for - ' + SelectedContact.lastName;
        c.origin='Student Consent';
        c.status='Student Consent Rejection';
        c.tx_Contact_Email__c=SelectedContact.email;
        Insert c;
        PageReference pageRef = new PageReference('/apex/Tx_StudentConsentAcknowledgement');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public PageReference save(){
        
        SelectedContact.recordtypeID=Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Student').getRecordTypeId();
        selectedContact.referredStudent__c=true;
        selectedContact.accountid=system.label.unknownAccountID;
        SelectedContact.lastName =SelectedContact.firstName + ' '+ SelectedContact.lastName;
        SelectedContact.firstName=null;
        insert selectedContact;
        
        Case c  = new Case();
        c.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Taxation').getRecordTypeId(); 
        c.contactID=SelectedContact.id;
        c.Accountid=SelectedContact.accountid;
        c.subject= Date.Today().Year() + ' Taxation for - ' + SelectedContact.lastName;
        c.origin='Student Consent';
        c.status='Student Consent Acceptance';
        c.tx_Contact_Email__c=SelectedContact.email;
        c.txVisaStatus__c=SelectedContact.Tx_VisaStatus__c;
        Insert c;
        
        PageReference pageRef = new PageReference('/apex/Tx_StudentConsentAcknowledgement');
        pageRef.setRedirect(true);
        return pageRef;      
    }
    
    
}