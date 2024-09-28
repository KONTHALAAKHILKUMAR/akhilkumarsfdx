public  class eTutorWhatsappMessageService{
    public WhatsAppMessage__c whatsAppMessage {get;set;}
    
 
    
    public eTutorWhatsappMessageService(){
       
       
        whatsAppMessage=new WhatsAppMessage__c();
      
        
    }
    public PageReference save(){
        
        
        Insert whatsAppMessage;
      
      //  PageReference pageRef = new PageReference('/apex/thankyoupage');
      //  pageRef.setRedirect(true);
        return null;      
    }
    public void showMessage()
    {
        List<WhatsAppMsgTemplates__c> temp = [select id, Message__c from WhatsAppMsgTemplates__c where id=:whatsAppMessage.WhatsAppMsgTemplate__c ];
        if(temp.size()>0)
        whatsAppMessage.WhatsAppMessage__c = temp[0].Message__c;
    }
   
}