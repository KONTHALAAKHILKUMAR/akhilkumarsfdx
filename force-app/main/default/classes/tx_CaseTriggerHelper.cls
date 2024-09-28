public class tx_CaseTriggerHelper {
    
    public void updateContactDetails(List<Case> lstCase)
    {
        Map<ID,String> mapContactEmail = new map<ID,String>();
        List<Contact> lstContact = new List<Contact>();
        For(Case c: lstCase)
        {
            IF(c.origin!=null && c.origin.equalsignorecase('Student Consent') && c.contactid!=null)
            {
                Contact con = new Contact();
                con.id=c.contactid;
                con.email=c.tx_Contact_Email__c;
                con.Tx_VisaStatus__c=c.txVisaStatus__c;
                con.TaxationJourneyStatus__c=c.status;
                con.mobilePhone=c.txContactMobilePhone__c;
                lstContact.add(con);
            }
        }
        
        if(lstContact.size()>0) update lstContact;
        
    }

}