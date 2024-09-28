public  class tx_StudentConsentForm{
    public Contact SelectedContact {get;set;}
    public Contact SelectedContact1 {get;set;}
    public boolean showTenantDetails {get;set;}
    public string studentEmail {get;set;}
    public boolean hideButtons {get;set;}
    public boolean showButtons {get;set;}
   
    public tx_StudentConsentForm(){
        showTenantDetails=false;
        SelectedContact=new Contact();
        SelectedContact1=new Contact();
        Id contactID = apexpages.currentpage().getparameters().get('studentID');
        List<Contact> c=[Select ID,accountid,Name,lastName,firstname,mobilePhone,email,Tx_visaStatus__c from Contact where ID=:contactID];
        List<Case> cas=[select id, status,IsClosed from Case where contactid=:contactID AND IsClosed=False];
        system.debug('**Contact'+c);
        IF(cas.size()>0) showButtons=false;
        else  showButtons=true;
       
        if(c.size()>0)
        {
            SelectedContact.email=c[0].email;
             SelectedContact.mobilePhone=c[0].mobilePhone;
            SelectedContact.Tx_visaStatus__c=c[0].Tx_visaStatus__c;
            SelectedContact1= c[0];
        }
        
    }
    public PageReference cancel(){
        if(showButtons)
        { 
        Case c  = new Case();
        c.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Taxation').getRecordTypeId(); 
        c.contactID=SelectedContact1.id;
        c.Accountid=SelectedContact1.accountid;
        c.subject= Date.Today().Year() + ' Taxation for - '+ SelectedContact1.name;
        c.origin='Student Consent';
        c.status='Student Consent Rejection';
        c.tx_Contact_Email__c=SelectedContact.email;
        c.txContactMobilePhone__c= SelectedContact.mobilePhone;

        
        Insert c;
        }
        
        PageReference pageRef = new PageReference('/apex/Tx_StudentConsentAcknowledgement');
        pageRef.setRedirect(true);
        return pageRef; 
    }
    
    public PageReference save(){
        
       if(showButtons)
        {   
        Case c  = new Case();
        c.recordtypeid=Schema.SObjectType.Case.getRecordTypeInfosByName().get('Taxation').getRecordTypeId(); 
        c.contactID=SelectedContact1.id;
        c.Accountid=SelectedContact1.accountid;
        c.subject= Date.Today().Year() + ' Taxation for - '+ SelectedContact1.name;
        c.origin='Student Consent';
        c.status='Student Consent Acceptance';
        c.tx_Contact_Email__c=SelectedContact.email;
        c.txVisaStatus__c=SelectedContact.Tx_VisaStatus__c;
        c.txContactMobilePhone__c= SelectedContact.mobilePhone;
        Insert c;
        }
        PageReference pageRef = new PageReference('/apex/Tx_StudentConsentAcknowledgement');
        pageRef.setRedirect(true);
        return pageRef;      
    }
    
    
}