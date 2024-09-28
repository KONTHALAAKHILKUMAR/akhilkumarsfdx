public class eTutorSMSNotificationsUtility {
    @Future(callout=true)
    public Static void sendSMS(String fromNumber, String toNumber, String msgName,String workOrderName,ID recordID, String studentName, String orderNumber, String mainHandler,Decimal amount) {
        String SMSMessage;
        String objectName;

        if(msgName.equalsignorecase('WorkorderReceived')) 
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Thanks for placing an order with us.'+ '\n' ;
            SMSMessage=SMSMessage+'We are reviewing your order# '+ orderNumber +', you will receive an email soon with the next steps.';
            objectName='WorkOrder';
        }
        if(msgName.equalsignorecase('PaymentPending'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Work order# '+  orderNumber +' has been assigned to prof ' + mainHandler +'.' +'\n' ;
            SMSMessage=SMSMessage+'Please login and do the payment to start working on your order. ';	
            objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('AdditionalInformationRequired'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'We have couple of questions regarding the requirements which you provided for the  order# '+  orderNumber  + '.'+'\n' ;
            SMSMessage=SMSMessage+'Please come on live chat to discuss the requirement or you can reach us directly via +1 5144370899';
            objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('WorkCompletedPaymentPending'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'We have completed your work order# '+  orderNumber + '.'+'\n' ;
            SMSMessage=SMSMessage+'Kindly make the pending payment so that we can deliver the work.';	
            objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('Completed'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'We have attached the final copy of work to your work order# '+  orderNumber  + '.'+'\n' ;
            SMSMessage=SMSMessage+'Please login to your account and download it.  Just remember, we’re always an email away if you need help.';		
            objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('Declined'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Thank you for your recent order with order id:'+ orderNumber + '.'+'\n' ;
            SMSMessage=SMSMessage+' With great regret, we are informing you that we do not have the capacity to accept your order.We are very sorry that we are unable to help with your task.';	
           objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('PaymentReceived'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Payment has been received regarding the work order# '+  orderNumber  + '.'+'\n' ;
            SMSMessage=SMSMessage+'You can check the status updates in your dashboard and we will send you the updates via email as well.';	
            objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('PlagiarismOrderReceived')) 
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Thanks for placing an order with us.'+ '\n' ;
            SMSMessage=SMSMessage+'We are reviewing your order# '+ orderNumber +', We will check the plagiarism for the document you have shared using Turnitin.';					
            objectName='WorkOrder';
        }
        
        if(msgName.equalsignorecase('PlagiarismCheckReportCompleted'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'We have attached the the plagiarism report of the document to your work order# '+  orderNumber  + '.'+'\n' ;
            SMSMessage=SMSMessage+'Please login to your account and download it.  Just remember, we’re always an email away if you need help.';					
            objectName='WorkOrder';
        }
         if(msgName.equalsignorecase('PlagiarismCheckReportCompleted20'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Regarding your work order# '+  orderNumber  + '.'+'\n' ;
            SMSMessage=SMSMessage+'We have noticed that there is plagiarism in the document you have shared. We can help you in making the document plagiarism free at an affordabale pricing. Kindly let us know if you want to remove plagiarism and make the document better.';					
            objectName='WorkOrder';
        }
        
         if(msgName.equalsignorecase('DiscountCoupon'))
        {
            SMSMessage = 'Hello '+studentName+ ',' + '\n' ;
            SMSMessage=SMSMessage+'Regarding your work order# '+  orderNumber  + '.'+'\n' ;
            SMSMessage=SMSMessage+'We have noticed that there is plagiarism in the document you have shared. We can help you in making the document plagiarism free at an affordabale pricing. Kindly let us know if you want to remove plagiarism and make the document better.';					
            objectName='DiscountCoupon';
        }
        
        
        List<smagicinteract__smsMagic__c>  smsObjectList = new List<smagicinteract__smsMagic__c> ();
        String senderId = fromNumber;  
        String templateText = SMSMessage;  
        smagicinteract__smsMagic__c smsObject = new smagicinteract__smsMagic__c();
        smsObject.smagicinteract__SenderId__c = senderId;
        smsObject.smagicinteract__PhoneNumber__c = toNumber;
        smsObject.smagicinteract__Name__c = workOrderName; // records name
        smsObject.smagicinteract__ObjectType__c = objectName;
        IF(objectName.equals('WorkOrder')) smsObject.workorder__c=recordID;
        IF(objectName.equals('DiscountCoupon')) smsObject.DiscountCoupons__c=recordID;
           
            
        smsObject.smagicinteract__disableSMSOnTrigger__c = 0; // this field either be 0 or 1, if you specify the value as 1 then sms will not get send but entry of sms will get create under SMS History object
        smsObject.smagicinteract__external_field__c = smagicinteract.ApexAPI.generateUniqueKey();
        smsObject.smagicinteract__SMSText__c = templateText;
        smsObjectList.add(smsObject);
        Database.insert(smsObjectList, false);
        
    }
}