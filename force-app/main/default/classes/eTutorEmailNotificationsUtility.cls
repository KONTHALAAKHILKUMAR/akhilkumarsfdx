public class eTutorEmailNotificationsUtility {
    private List<Messaging.SingleEmailMessage> allmsg;
    public eTutorEmailNotificationsUtility(List<String> receivers, String templateId, ID  relatedToID) {
       ID orgEmailID=label.eTutorOrgWideEmailAddress;
        allmsg = new List<Messaging.SingleEmailMessage>();
        List<String> toAddresses = new List<String>();
        for(String receiver : receivers) {
             toAddresses.add(receiver);
        }
        
        Messaging.SingleEmailMessage msg = createRenderedEmailMessage(templateId, relatedToID, null, true, orgEmailID);
        msg.setToAddresses(toAddresses);
        
        allmsg.add(msg);
        sendEmail();
    }
    
    
    public void sendEmail() {
        Messaging.SendEmailResult[] result = Messaging.sendEmail(allmsg, false);
        List<Messaging.SendEmailResult> rl= new List<Messaging.SendEmailResult>(result);
        Integer noOfSuccessEmail = 0;
        for(Messaging.SendEmailResult r:rl) {
          List<Messaging.SendEmailError> a =new List<Messaging.SendEmailError>(r.getErrors());
          if(r.isSuccess()) {
            noOfSuccessEmail++;
          }
          for(Messaging.SendEmailError e:a) {
            system.debug('error : '+e.getMessage());
          }
        }
    }
    
    private static Messaging.SingleEmailMessage createRenderedEmailMessage(Id templateId, Id whatId, Id whoId, Boolean saveAsActivity, Id orgWideDefaultEmailId){
        Messaging.SingleEmailMessage renderedEmail = Messaging.renderStoredEmailTemplate(templateId, whoId, whatId);
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        if(orgWideDefaultEmailId != null) mail.setOrgWideEmailAddressId(orgWideDefaultEmailId);
        mail.setSubject(renderedEmail.getSubject());
        if(renderedEmail.getHtmlBody() != null) mail.setHtmlBody(renderedEmail.getHtmlBody());
        if(renderedEmail.getPlainTextBody() != null) mail.setPlainTextBody(renderedEmail.getPlainTextBody());
        if(String.valueof(whatID).startswith('003'))
        mail.setTargetObjectId(whatId);
        else
        mail.setWhatId(whatId);
        //
        mail.setSaveAsActivity(saveAsActivity);
        return mail;
    }


}