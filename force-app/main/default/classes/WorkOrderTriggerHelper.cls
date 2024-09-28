public class WorkOrderTriggerHelper {
    public Map<String,String> mapSlackUrl = new Map<String,String>();
    public String workOrderRecordTypeID;
    public String plagrismRecordTypeID;
    
    
    public WorkOrderTriggerHelper()
    {
        List<SlackChannel__mdt> slackUrl = [select id, Slack_Url__c , DeveloperName from SlackChannel__mdt ];
        for(SlackChannel__mdt slack: slackUrl)
        {
            mapSlackUrl.put(slack.DeveloperName,slack.Slack_Url__c);
        }  
        
        workOrderRecordTypeID = Schema.SObjectType.WorkOrder__c.getRecordTypeInfosByName().get('Content Writing').getRecordTypeId();
        
        plagrismRecordTypeID = Schema.SObjectType.WorkOrder__c.getRecordTypeInfosByName().get('Plagiarism Check').getRecordTypeId();
        
        
    }
    
    public void updateDiscountCouponAllocationStatus(List<WorkOrder__c> newList,Map<ID,WorkOrder__c> oldMap)
    {
        map<String,ID> mapStudentDiscount =  new Map<String,ID>();  
        Set<ID> setStudentId = new Set<ID>();
        Set<ID> discountId = new Set<ID>();
        Set<ID> workOrderId = new Set<ID>();
        List<Discount_Coupon_Allocation__c> lstNewDisAll =  new List<Discount_Coupon_Allocation__c>();
        List<Discount_Coupon_Allocation__c> lstUpdateDisAll =  new List<Discount_Coupon_Allocation__c>();
        
         For(WorkOrder__c wo: newList)
        {
            WorkOrder__c oldWo =  oldMap.get(wo.id);
            IF (wo.DiscountCoupon__c!=NULL && oldWo.DiscountCoupon__c==NULL )
            {
                workOrderId.add(wo.id);
            }
        }
        
        For(WorkOrder__c wo: [Select ID,Student__c,DiscountCoupon__c,DiscountCoupon__r.category__c from WorkOrder__c where ID IN:workOrderId])
        {
            WorkOrder__c oldWo =  oldMap.get(wo.id);
            IF (wo.DiscountCoupon__c!=NULL && oldWo.DiscountCoupon__c==NULL )
            {
                Discount_Coupon_Allocation__c disAll =  new Discount_Coupon_Allocation__c();
                if(wo.DiscountCoupon__r.category__c.equalsignorecase('Generic Coupon for specific time') || wo.DiscountCoupon__r.category__c.equalsignorecase('Generic Coupon for First WO'))
                {
                    disAll.contact__c=wo.Student__c;
                    disAll.Discount_Coupons__c=wo.DiscountCoupon__c;
                    disAll.Status__c='Redeemed';
                    disAll.work_order__c=wo.id;
                    lstNewDisAll.add(disAll);
                }
                if(wo.DiscountCoupon__r.category__c.equalsignorecase('Specific to a student'))
                {
                    setStudentId.add(wo.Student__c);
                    discountId.add(wo.DiscountCoupon__c);
                    mapStudentDiscount.put(wo.Student__c +':'+wo.DiscountCoupon__c,wo.Id);
                }
            }
            
        }
        IF(lstNewDisAll.size()>0)
            insert lstNewDisAll;
        
        For(Discount_Coupon_Allocation__c dc:[Select id,contact__c,Discount_Coupons__c,Status__c,work_order__c from Discount_Coupon_Allocation__c where contact__c IN:setStudentId AND Discount_Coupons__c IN:discountId])
        {
            Discount_Coupon_Allocation__c disAll =  new Discount_Coupon_Allocation__c();
            disAll.Status__c='Redeemed';
            disAll.work_order__c=mapStudentDiscount.get(dc.contact__c +':'+dc.Discount_Coupons__c);
            disAll.ID=dc.id;
            lstUpdateDisAll.add(disAll);
        }
        
        IF(lstUpdateDisAll.size()>0)
            update lstUpdateDisAll;
    }
  
    public void validateData(List<WorkOrder__c> newList)
    {
        
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==workOrderRecordTypeID)
            {
                IF (wo.eTutorStatus__c.equalsignorecase('Payment Pending') && wo.Price__c==null )
                    
                {
                    wo.addError('Please enter the Price');
                }
                IF (wo.eTutorStatus__c.equalsignorecase('Completed') && wo.final_document__c==null )
                    
                {
                    wo.addError('Please update the final document URL');
                }
                
            }
            
            
        }
        
    }
    public void sendNewWorkOrderNotificationsToCustomer(List<WorkOrder__c> newList)
    {
        List<String> receiver = new List<String>(); 
        For(WorkOrder__c wo: newList)
        {
            
            IF(wo.recordtypeid==workOrderRecordTypeID)
            {
                IF (wo.eTutorStatus__c.equalsignorecase('Work order Received'))
                {
                    receiver.add(wo.StudentEmail__c);
                    eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorWorkOrderCreationAck,wo.id);
                    
                    eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, wo.StudentPhone__c, 'WorkorderReceived',wo.name,wo.id,wo.StudentNameFormula__c,wo.eTutorWorkOrderID__c,wo.MainHandlerNameFormula__c,null);
                    
                }
            }
        }
        
    }
    public void sendNewWorkOrderNotificationsToSlack(List<WorkOrder__c> newList)
    {
        Map<String,Object> msg = new Map<String,Object>();
        String channelName;
        Boolean sendToSlack=false;
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==workOrderRecordTypeID)
            {
                String message; 
                IF (wo.actualStatus__c.equalsignorecase('New Work order') )
                {
                    message =  'Hello, ' + '\n' ; 
                    message = message+ 'You have received a work order '+wo.name +' from Student '+wo.StudentNameFormula__c +'.' + '\n' ; 
                    message= message +'Please check the requirements and assign it to a respective Main Handler Name.'  + '\n';
                    msg.put('text', message );
                    
                    channelName='eTutorManager';
                    sendToSlack=true;
                    
                }
                if(sendToSlack)
                {
                    msg.put('mrkdwn', true);
                    String body = JSON.serialize(msg); 
                    eTutorSlackNotificationsUtility.executeSlackCallTrigger(mapSlackUrl.get(channelName), 'POST', body);
                } 
            }
            
        }
    }
    public void sendWorkOrderUpdateNotificationsToCustomer(List<WorkOrder__c> newList,Map<ID,WorkOrder__c> oldMap)
    {
        List<String> receiver = new List<String>();
        Boolean discountApplied=False;
        
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==workOrderRecordTypeID)
            {
                try
                {
                    Boolean sendToETutor=false;
                    Boolean sendSMS =false;
                    String SMSMessageTemplate;
                    WorkOrder__c oldWo =  oldMap.get(wo.id);
                    receiver.add(wo.StudentEmail__c);
                    
                    IF (wo.DiscountCoupon__c!=NULL && oldWo.DiscountCoupon__c==NULL && wo.FinalAmountAfterDiscount__c<wo.price__c)
                    {
                        sendToETutor=true;
                        discountApplied=true;
                    }
                    
                    
                    
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Payment Pending') && !oldWo.eTutorStatus__c.equalsignorecase('Payment Pending'))
                        
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorInitialPayment,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='PaymentPending';
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Work in Progress') && !oldWo.eTutorStatus__c.equalsignorecase('Work in Progress'))
                        
                    {
                        sendToETutor=true;
                    }
                    
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Additional information Required') && !oldWo.eTutorStatus__c.equalsignorecase('Additional information Required'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorAdditionalInformationRequired,wo.id);
                        sendToETutor=true; 
                        sendSMS =True;
                        SMSMessageTemplate ='AdditionalInformationRequired'; 
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Work completed. Payment pending') && !oldWo.eTutorStatus__c.equalsignorecase('Work completed. Payment pending'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorWorkCompletedPaymentPending,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='WorkCompletedPaymentPending';               
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Completed') && !oldWo.eTutorStatus__c.equalsignorecase('Completed'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorWorkCompleted,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='Completed';
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Declined') && !oldWo.eTutorStatus__c.equalsignorecase('Declined'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorDeclined,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='Declined';
                    }
                    
                    IF(sendToETutor)
                    {
                        sendWorkOrderUpdatesToETutor(String.valueof(wo.Price__c),String.valueof(wo.Initial_Amount_to_Pay__c),wo.eTutorWorkOrderID__c,wo.eTutorStatus__c,'WorkOrder',String.valueof(wo.ID),wo.MainHandlerNameFormula__c,wo.Final_Document__c,'Content Writing',String.valueof(discountApplied),String.valueof(wo.DiscountOnAssignmentPrice__c),String.valueof(wo.FinalAmountAfterDiscount__c));
                    }
                    
                    IF(sendSMS) 
                    {
                        eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, wo.StudentPhone__c, SMSMessageTemplate,wo.name,wo.id,wo.StudentNameFormula__c,wo.eTutorWorkOrderID__c,wo.MainHandlerNameFormula__c,null);
                    }
                } 
                catch( System.Exception e) {  
                    System.debug('ERROR: '+ e);  
                    ErrorHandler.logError('WorkOrderTriggerHelper','sendWorkOrderUpdateNotificationsToCustomer'+wo.id, e.getMessage(),e.getStackTraceString());
                }
                
            }  
        }
        
    }
    public void sendWorkOrderUpdateNotificationsToSlack(List<WorkOrder__c> newList,Map<ID,WorkOrder__c> oldMap)
    {
        Map<String,Object> msg = new Map<String,Object>();
        String channelName;
        Boolean sendToSlack=false;
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==workOrderRecordTypeID)
            {
                WorkOrder__c oldWo =  oldMap.get(wo.id);
                String message;
                IF (wo.actualStatus__c.equalsignorecase('Assigned to Main Handler') && !oldWo.actualStatus__c.equalsignorecase('Assigned to Main Handler'))
                {
                    message =  'Hello ' +wo.MainHandlerNameFormula__c +','+ '\n' ; 
                    message = message+ 'A new work order '+wo.name +' from Student '+wo.StudentNameFormula__c +' has been assigned to you. ' + '\n' ; 
                    message= message +'Please check the student requirements and complete it as per the deadlines.'  + '\n';
                    
                    msg.put('text', message);
                    channelName=wo.MainHandlerNameFormula__c;
                    sendToSlack=true;   
                }
                
                if(sendToSlack)
                {
                    msg.put('mrkdwn', true);
                    String body = JSON.serialize(msg); 
                    eTutorSlackNotificationsUtility.executeSlackCallTrigger(mapSlackUrl.get(channelName), 'POST', body);
                } 
            }
        }
        
    }
    
    public void sendWorkOrderUpdatesToETutor(String workOrderAmount,String workorderinitialamount,String workOrderId,String status,String objName,String recordID,String workOrderMainHandlerName, String outputFileURL, String recordTypeName, String discountApplied,String discountValue,String finalAmountAfterDiscount)
    {
        Map<String,Object> msg = new Map<String,Object>();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('workOrderId', workOrderId);
        gen.writeStringField('workOrderStatus', status);
        gen.writeStringField('workOrderMainHandlerName',workOrderMainHandlerName);
        if(outputFileURL!=null)gen.writeStringField('outputFileURL',outputFileURL );
        gen.writeStringField('discountApplied',discountApplied);
        if(workOrderAmount!=null)gen.writeStringField('workOrderAmount', workOrderAmount);
        gen.writeStringField('workOrderInitialAmount',workorderinitialamount);
        gen.writeStringField('discountvalue',discountValue);
        gen.writeStringField('finalAmountAfterDiscount',finalAmountAfterDiscount);
        
        
        gen.writeEndObject();
        eTutorAPIUtility.executeeTutorCallFuture('POST', gen.getAsString(),objName,recordID,recordTypeName);
        
    }
     
    public void sendNewPlagrismNotificationsToCustomer(List<WorkOrder__c> newList)
    {
        List<String> receiver = new List<String>(); 
        For(WorkOrder__c wo: newList)
        {
            
            IF(wo.recordtypeid==plagrismRecordTypeID)
            {
                IF (wo.eTutorStatus__c.equalsignorecase('Work order Received'))
                {
                    receiver.add(wo.StudentEmail__c);
                    eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorPlagiarismCreationAck,wo.id);
                    
                    eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, wo.StudentPhone__c, 'PlagiarismOrderReceived',wo.name,wo.id,wo.StudentNameFormula__c,wo.eTutorWorkOrderID__c,wo.MainHandlerNameFormula__c,null);
                    
                }
            }
        }
        
    }
    public void sendNewPlagrismNotificationsToSlack(List<WorkOrder__c> newList)
    {
        Map<String,Object> msg = new Map<String,Object>();
        String channelName;
        Boolean sendToSlack=false;
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==plagrismRecordTypeID)
            {
                String message; 
                IF (wo.actualStatus__c.equalsignorecase('New Work order') )
                {
                    message =  'Hello, ' + '\n' ; 
                    message = message+ 'You have received Plagiarism check work order '+wo.name +' from Student '+wo.StudentNameFormula__c +'.' + '\n' ; 
                    message= message +'Please check the requirements and assign it to a respective Main Handler Name.'  + '\n';
                    msg.put('text', message );
                    
                    channelName='eTutorManager';
                    sendToSlack=true;
                    
                }
                if(sendToSlack)
                {
                    msg.put('mrkdwn', true);
                    String body = JSON.serialize(msg); 
                    eTutorSlackNotificationsUtility.executeSlackCallTrigger(mapSlackUrl.get(channelName), 'POST', body);
                } 
            }
            
        }
    }
    public void sendplagrismUpdateNotificationsToCustomer(List<WorkOrder__c> newList,Map<ID,WorkOrder__c> oldMap)
    {
        List<String> receiver = new List<String>();
        Boolean discountApplied=False;
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==plagrismRecordTypeID)
            {
                try
                {
                    Boolean sendToETutor=false;
                    Boolean sendSMS =false;
                    String SMSMessageTemplate;
                    WorkOrder__c oldWo =  oldMap.get(wo.id);
                    receiver.add(wo.StudentEmail__c);
                    
                      IF (wo.DiscountCoupon__c!=NULL && oldWo.DiscountCoupon__c==NULL )
                    {
                        sendToETutor=true;
                        discountApplied=true;
                    }
                    
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Plagiarism Free Report Payment Pending') && !oldWo.eTutorStatus__c.equalsignorecase('Plagiarism Free Report Payment Pending'))
                        
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorInitialPayment,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='PaymentPending';
                    }
                    
                    IF ((wo.eTutorStatus__c.equalsignorecase('Work in Progress') && !oldWo.eTutorStatus__c.equalsignorecase('Work in Progress')) ||
                        ( wo.PlagiarismCheckAmount__c!=oldWo.PlagiarismCheckAmount__c) ||
                        ( wo.PlagiairsmFreeAmount__c!=oldWo.PlagiairsmFreeAmount__c ) ||         
                        ( wo.PromptMessage__c!=oldWo.PromptMessage__c )||
                        ( wo.PlagiarismCheckURLDocument__c!=oldWo.PlagiarismCheckURLDocument__c )||
                        ( wo.Final_Document__c!=oldWo.Final_Document__c )||
                        ( wo.Plagiarism_more_than_20__c==true && oldWo.Plagiarism_more_than_20__c!=true ))
                    {
                        sendToETutor=true; 
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Plagiarism Check Report Completed') && !oldWo.eTutorStatus__c.equalsignorecase('Plagiarism Check Report Completed'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorplagiarismcheckCompleted,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='PlagiarismCheckReportCompleted';
                    }
                    
                    IF (wo.Plagiarism_more_than_20__c==true  && wo.eTutorStatus__c.equalsignorecase('Plagiarism Check Report Completed') && !oldWo.eTutorStatus__c.equalsignorecase('Plagiarism Check Report Completed'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorplagiarismcheck20,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='PlagiarismCheckReportCompleted20';
                    }
                    
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Additional information Required') && !oldWo.eTutorStatus__c.equalsignorecase('Additional information Required'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorAdditionalInformationRequired,wo.id);
                        sendToETutor=true; 
                        sendSMS =True;
                        SMSMessageTemplate ='AdditionalInformationRequired';  
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Work completed. Payment pending') && !oldWo.eTutorStatus__c.equalsignorecase('Work completed. Payment pending'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorWorkCompletedPaymentPending,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='WorkCompletedPaymentPending';               
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Plagiarism Free Report Completed') && !oldWo.eTutorStatus__c.equalsignorecase('Plagiarism Free Report Completed'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorWorkCompleted,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='Completed';
                    }
                    
                    IF (wo.eTutorStatus__c.equalsignorecase('Declined') && !oldWo.eTutorStatus__c.equalsignorecase('Declined'))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorDeclined,wo.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='Declined';
                    }
                    
                    IF(sendToETutor)
                    {
                        sendplagrismUpdatesToETutor(String.valueof(wo.PlagiarismCheckAmount__c),String.valueof(wo.PlagiairsmFreeAmount__c),wo.PromptMessage__c,wo.eTutorWorkOrderID__c,wo.eTutorStatus__c,'WorkOrder',String.valueof(wo.ID),wo.MainHandlerNameFormula__c,wo.Final_Document__c,wo.PlagiarismCheckURLDocument__c,'Plagiarism Check',String.valueof(wo.Plagiarism_more_than_20__c),String.valueof(discountApplied),String.valueof(wo.Discount_on_Plagarism_Price__c),String.valueof(wo.Final_Plagarism_amount_after_discount__c) );
                     }
                    
                    IF(sendSMS) 
                    {
                        eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, wo.StudentPhone__c, SMSMessageTemplate,wo.name,wo.id,wo.StudentNameFormula__c,wo.eTutorWorkOrderID__c,wo.MainHandlerNameFormula__c,null);
                    }
                } 
                catch( System.Exception e) {  
                    System.debug('ERROR: '+ e);  
                    ErrorHandler.logError('WorkOrderTriggerHelper','sendWorkOrderUpdateNotificationsToCustomer'+wo.id, e.getMessage(),e.getStackTraceString());
                }
                
            }  
        }
        
    }
    public void sendplagrismUpdateNotificationsToSlack(List<WorkOrder__c> newList,Map<ID,WorkOrder__c> oldMap)
    {
        Map<String,Object> msg = new Map<String,Object>();
        String channelName;
        Boolean sendToSlack=false;
        For(WorkOrder__c wo: newList)
        {
            IF(wo.recordtypeid==plagrismRecordTypeID)
            {
                WorkOrder__c oldWo =  oldMap.get(wo.id);
                String message;
                IF (wo.actualStatus__c.equalsignorecase('Assigned to Main Handler') && !oldWo.actualStatus__c.equalsignorecase('Assigned to Main Handler'))
                {
                    message =  'Hello ' +wo.MainHandlerNameFormula__c +','+ '\n' ; 
                    message = message+ 'A new Plagiarism check work order '+wo.name +' from Student '+wo.StudentNameFormula__c +' has been assigned to you. ' + '\n' ; 
                    message= message +'Please check the Plagiarism using turnitin and upload the document.'  + '\n';
                    
                    msg.put('text', message);
                    channelName=wo.MainHandlerNameFormula__c;
                    sendToSlack=true;   
                }
                IF (wo.Plagiairsm_Free_Report_Requested__c==true && oldWo.Plagiairsm_Free_Report_Requested__c==false)
                {
                    message =  'Hello ' +wo.MainHandlerNameFormula__c +','+ '\n' ; 
                    message = message+ 'For Plagiarism check work order '+wo.name +' from Student '+wo.StudentNameFormula__c +', ' + '\n' ; 
                    message= message +'The student has requested for a plagiarism free document. Kindly check the document and complete it as per the requirements.'  + '\n';
                    
                    msg.put('text', message);
                    channelName=wo.MainHandlerNameFormula__c;
                    sendToSlack=true;   
                }
                
                if(sendToSlack)
                {
                    msg.put('mrkdwn', true);
                    String body = JSON.serialize(msg); 
                    eTutorSlackNotificationsUtility.executeSlackCallTrigger(mapSlackUrl.get(channelName), 'POST', body);
                } 
            }
        }
        
    }
    
    public void sendplagrismUpdatesToETutor(String plagiairsmCheckAmount,String plagiairsmFreeAmount,String promtMessage,String workOrderId,String status,String objName,String recordID,String workOrderMainHandlerName, String outputFileURL ,String PlagiarismCheckURLDocument , String recordTypeName, String PlagiarismMoreThan20, String discountApplied,String discountValue,String finalAmountAfterDiscount)
    {
        Map<String,Object> msg = new Map<String,Object>();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('workOrderId', workOrderId);
        gen.writeStringField('workOrderStatus', status);
        gen.writeStringField('workOrderMainHandlerName',workOrderMainHandlerName);
        if(promtMessage!=null) gen.writeStringField('promtMessage',promtMessage);
        gen.writeStringField('plagiairsmCheckAmount',plagiairsmCheckAmount);
        gen.writeStringField('plagiairsmFreeAmount',plagiairsmFreeAmount);
        if(outputFileURL!=null)gen.writeStringField('PlagiarismFreeDocument',outputFileURL );
        if(PlagiarismCheckURLDocument!=null)gen.writeStringField('PlagiarismCheckURLDocument',PlagiarismCheckURLDocument );
        if(PlagiarismMoreThan20.equalsignorecase('true') )gen.writeStringField('PlagiarismMoreThan20',PlagiarismMoreThan20 );
        
        gen.writeStringField('discountApplied',discountApplied);
        gen.writeStringField('discountvalue',discountValue);
        gen.writeStringField('finalAmountAfterDiscount',finalAmountAfterDiscount);
       
        gen.writeEndObject();
        eTutorAPIUtility.executeeTutorCallFuture('POST', gen.getAsString(),objName,recordID,recordTypeName);
        
    }
    
    
    
}