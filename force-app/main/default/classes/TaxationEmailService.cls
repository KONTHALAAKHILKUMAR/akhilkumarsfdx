global class TaxationEmailService implements Messaging.InboundEmailHandler {

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email,
    Messaging.InboundEnvelope envelope) {

        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();

		String subToCompare = 'Create Contact';

		if(email.subject.equalsIgnoreCase(subToCompare))
		{
			Contact c = new Contact();
			c.LastName = email.plainTextBody;
			insert c;

                // Save attachments, if any
        	for (Messaging.Inboundemail.TextAttachment tAttachment : email.textAttachments) {
          	Attachment attachment = new Attachment();

          	attachment.Name = tAttachment.fileName;
          	attachment.Body = Blob.valueOf(tAttachment.body);
          	attachment.ParentId = c.Id;
          	insert attachment;
        	}

        	 
		}

	result.success = true;
        return result;
    }

   
}