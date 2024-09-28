public class WorkOrderPaymentTriggerHelper {
    public Map<String,String> mapSlackUrl = new Map<String,String>();
    
    public WorkOrderPaymentTriggerHelper()
    {
        List<SlackChannel__mdt> slackUrl = [select id, Slack_Url__c , DeveloperName from SlackChannel__mdt ];//where DeveloperName='sk_google_sheet_data' ];
        for(SlackChannel__mdt slack: slackUrl)
        {
            mapSlackUrl.put(slack.DeveloperName,slack.Slack_Url__c);
        }   
    }
    
    public void sendNewPaymentNotificationsToCustomer(List<WorkOrderPayment__c> newList)
    {
        List<String> receiver = new List<String>(); 
        
        For(WorkOrderPayment__c wo: newList)
        {
            try
            {
                IF (wo.Status__c.equalsignorecase('Confirmed'))
                {
                    receiver.add(wo.StudentEmail__c);
                    eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorInitialPaymentReceivedAck,wo.id);
                    eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, wo.StudentPhone__c,'PaymentReceived',wo.name,wo.WorkOrder__c,wo.StudentName__c,wo.eTutorWorkOrderIDFormula__c,null,wo.Amount__c);
                    
                }
            } catch( System.Exception e) {  
                System.debug('ERROR: '+ e);  
                ErrorHandler.logError('WorkOrderPaymentTriggerHelper','sendNewPaymentNotificationsToCustomer'+wo.id, e.getMessage(),e.getStackTraceString());
            }
        }
        
        
    }
    public void sendNewPaymentNotificationsToSlack(List<WorkOrderPayment__c> newList)
    {
        Map<String,Object> msg = new Map<String,Object>();
        String channelName;
        Boolean sendToSlack=false;
        
        For(WorkOrderPayment__c wo: newList)
        {
            String message;
            message =  'Hello ' +wo.MainHandlerName__c +','+ '\n' ; 
            message = message+ 'Payment has been received for the work order '+wo.WorkOrderName__c +' from Student '+wo.StudentName__c +'.' + '\n' ; 
            message= message +'Please validate the transaction and perform next steps'  + '\n';
            msg.put('text', message);
            msg.put('mrkdwn', true);
            String body = JSON.serialize(msg); 
            eTutorSlackNotificationsUtility.executeSlackCallTrigger(mapSlackUrl.get(wo.MainHandlerName__c), 'POST', body);
        }
    }
    public void sendPaymentUpdateNotificationsToCustomer(List<WorkOrderPayment__c> newList,Map<ID,WorkOrderPayment__c> oldMap)
    {
        List<String> receiver = new List<String>();
        For(WorkOrderPayment__c wo: newList)
        {
            try{
                
                Boolean sendToETutor=false;
                WorkOrderPayment__c oldWo =  oldMap.get(wo.id);
                receiver.add(wo.StudentEmail__c);
                IF (wo.Amount__c!=null && wo.Status__c.equalsignorecase('Confirmed') && oldWo.Status__c.equalsignorecase('Pending Confirmation'))
                    
                {
                    eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorInitialPaymentReceivedAck,wo.id);
                    sendToETutor=true;
                    eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, wo.StudentPhone__c,'PaymentReceived',wo.name,wo.WorkOrder__c,wo.StudentName__c,wo.eTutorWorkOrderIDFormula__c,null,wo.Amount__c);
                    
                }
                IF(sendToETutor)
                {
                    String amount = String.valueof(wo.Amount__c); 
                    Map<String,Object> msg = new Map<String,Object>();
                    JSONGenerator gen = JSON.createGenerator(true);
                    gen.writeStartObject();
                    gen.writeStringField('ETutorPaymentID__c', wo.eTutorPaymentID__c);
                    gen.writeStringField('Amount__c',amount);
                    gen.writeStringField('Status__c', wo.Status__c);
                    gen.writeEndObject();
                    eTutorAPIUtility.executeeTutorCallFuture('POST', gen.getAsString(),'WorkOrderPayment',String.valueof(wo.ID),wo.WorkOrder_RecordType__c); 
                }
                
            } catch( System.Exception e) {  
                System.debug('ERROR: '+ e);  
                ErrorHandler.logError('WorkOrderPaymentTriggerHelper','sendPaymentUpdateNotificationsToCustomer - ' + wo.ID, e.getMessage(),e.getStackTraceString());
            } 
        }
        
        
    }
    
}