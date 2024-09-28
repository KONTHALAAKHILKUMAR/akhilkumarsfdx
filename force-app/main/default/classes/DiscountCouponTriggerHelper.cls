public class DiscountCouponTriggerHelper {
    public String assignmentRecordTypeID;
    
    public DiscountCouponTriggerHelper()
    {
        
    }
    
    
    
    
    public void sendDiscountCouponsNotificationsToCustomer(List<DiscountCoupons__c> newList,Map<ID,DiscountCoupons__c> oldMap)
    {
        List<String> receiver = new List<String>();
        
        For(DiscountCoupons__c dc: newList)
        {
            IF(dc.Service__c.equalsignorecase('Assignment') ||dc.Service__c.equalsignorecase('Plagiarism')  )
            {
                try
                { 
                    Boolean sendToETutor=false;
                    Boolean sendSMS =false;
                    String SMSMessageTemplate;
                    DiscountCoupons__c oldWo = new DiscountCoupons__c();
                    If(oldMap!=null)
                     oldWo = oldMap.get(dc.id);
                    receiver.add(dc.StudentEmail__c);
                    If( dc.category__c.equalsignorecase('Generic Coupon for First WO') || dc.category__c.equalsignorecase('Generic Coupon for specific time'))
                    {
                       
                    IF ((Trigger.isUpdate && oldWo!=null && dc.Status__c.equalsignorecase('Active') && !oldWo.Status__c.equalsignorecase('Active')) || (Trigger.isInsert && dc.Status__c.equalsignorecase('Active')))
                    {
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorInitialPayment,dc.id);
                        sendToETutor=true;
                        sendSMS =True;
                        SMSMessageTemplate ='DiscountCoupon';
                        DiscountCouponAllocationTriggerHelper helper1 = new DiscountCouponAllocationTriggerHelper ();
                        
                        // sendDiscountCouponToETutor(dc.eTutorUserID__c,dc.DiscountCode__c,dc.Service__c,dc.Status__c,dc.id,'DiscountCoupon',dc.description__c,String.valueof(dc.Discount_Amount__c),dc.Discount_Type__c,String.valueof(dc.ExpiryDate__c));
                        helper1.sendDiscountCouponToETutor(dc.eTutorUserID__c,dc.DiscountCode__c,dc.Service__c,dc.Status__c,dc.id,'DiscountCoupon',dc.description__c,String.valueof(dc.Discount_Amount__c),dc.Discount_Type__c,String.valueof(dc.Start_Date__c),String.valueof(dc.ExpiryDate__c),dc.category__c);
                        eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, dc.StudentPhone__c, SMSMessageTemplate,dc.name,dc.id,dc.StudentNameFormula__c,null,null,null);
                    }
                    }
                } 
                catch( System.Exception e) {  
                    System.debug('ERROR: '+ e);  
                    ErrorHandler.logError('DiscountCouponTriggerHelper','sendDiscountCouponsNotificationsToCustomer'+dc.id, e.getMessage(),e.getStackTraceString());
                }
                
            }  
            
        }
    }
    
    
    
    
    
    
    
    
    
}