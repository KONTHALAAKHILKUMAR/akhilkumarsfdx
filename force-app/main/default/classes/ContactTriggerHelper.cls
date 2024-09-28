public class ContactTriggerHelper {
    
    public void sendNeweTutorStudentWelcomeEmail(List<Contact> newList)
    {
        List<String> receiver = new List<String>(); 
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('eTutor').getRecordTypeId();

        For(Contact c: newList)
        {
            IF (c.Status__c.equalsignorecase('Active')&& c.eTutorUserID__c!=null && contactRecordTypeId==c.recordtypeid)
            {
                receiver.add(c.email);
                eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,'00X1g0000020aj8',c.id);
                
            }
        }
        
    }

}