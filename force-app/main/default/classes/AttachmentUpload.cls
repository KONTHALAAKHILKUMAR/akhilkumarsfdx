public  class AttachmentUpload {
    
    public Attachment attachment {
        get {
            if (attachment == null)
                attachment = new Attachment();
            return attachment;
        }
        set;
    }
    
    public PageReference upload() {
       case c= new case();
        c.origin='email';
        insert c;
      //	  attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = c.id;//'5001g000009lvTz'; // the record the file is attached to
        //attachment.IsPrivate = true;
        
        try {
            insert attachment;
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'+e.getMessage()));
            return null;
        } finally {
            attachment = new Attachment(); 
        }
        
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
        return null;
    }
    
}