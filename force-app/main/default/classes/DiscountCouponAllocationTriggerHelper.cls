public class DiscountCouponAllocationTriggerHelper {
    
     public DiscountCouponAllocationTriggerHelper()
    {
        
    } 

    
     public void sendDiscountCouponsNotificationsToCustomer(List<Discount_Coupon_Allocation__c> newList,Map<ID,Discount_Coupon_Allocation__c> oldMap)
    {
        List<String> receiver = new List<String>();
         Set<ID> lstDisCouAll = new Set<ID>(); 
        
        For(Discount_Coupon_Allocation__c dc: newList )   
            
        { Discount_Coupon_Allocation__c old = new Discount_Coupon_Allocation__c();
           If(oldMap!=null)
           old = oldMap.get(dc.id);
             system.debug('**outsideloop ' + old);
            if((old!=null && dc.status__c.equals('Active') && old.Status__c!=dc.status__c) || (old==null && dc.status__c.equals('Active')))
            {
               system.debug('**Insideloop ' + old);
                lstDisCouAll.add(dc.id);
            }
            
        }
          For(Discount_Coupon_Allocation__c dc: [Select id,Name,Discount_Coupons__r.ExpiryDate__c,status__c,Discount_Coupons__r.Start_Date__c,Discount_Coupons__r.Category__c,Discount_Coupons__r.DiscountCode__c,Discount_Coupons__r.Description__c,Discount_Coupons__r.Discount_Type__c,Discount_Coupons__r.Discount_Amount__c,Discount_Coupons__r.Service__c, eTutorUserID__c,StudentEmail__c,StudentNameFormula__c,StudentPhone__c from Discount_Coupon_Allocation__c where id IN : lstDisCouAll] )
        {
           IF(dc.Discount_Coupons__r.Service__c.equalsignorecase('Assignment') ||dc.Discount_Coupons__r.Service__c.equalsignorecase('Plagiarism')  )
            {
                try
                {
                    Boolean sendToETutor=false;
                    Boolean sendSMS =false;
                    String SMSMessageTemplate;
                    receiver.add(dc.StudentEmail__c);
               
                        eTutorEmailNotificationsUtility emailNotification =  new eTutorEmailNotificationsUtility(receiver,label.eTutorInitialPayment,dc.id);
                       
                        SMSMessageTemplate ='DiscountCoupon';
                    
                        sendDiscountCouponToETutor(dc.eTutorUserID__c,dc.Discount_Coupons__r.DiscountCode__c,dc.Discount_Coupons__r.Service__c,dc.Status__c,dc.id,'DiscountCouponAllocation',dc.Discount_Coupons__r.description__c,String.valueof(dc.Discount_Coupons__r.Discount_Amount__c),dc.Discount_Coupons__r.Discount_Type__c,String.valueof(dc.Discount_Coupons__r.Start_Date__c),String.valueof(dc.Discount_Coupons__r.ExpiryDate__c),dc.Discount_Coupons__r.category__c);
                   
                    
                        eTutorSMSNotificationsUtility.sendSMS(label.eTutorSMSMagicFromNumber, dc.StudentPhone__c, SMSMessageTemplate,dc.name,dc.id,dc.StudentNameFormula__c,null,null,null);
                    
                } 
                catch( System.Exception e) {  
                    System.debug('ERROR: '+ e);  
                    ErrorHandler.logError('DiscountCouponTriggerHelper','sendDiscountCouponsNotificationsToCustomer'+dc.id, e.getMessage(),e.getStackTraceString());
                }
                
            }  
        }
    }
    
    
    public void sendDiscountCouponToETutor(String eTutorUserID,String discountCode,String discountService,String Status,String recordID, String objName,String description,String discountValue, String discountType,String startDate,String expiryDate,String category)
    {
        Map<String,Object> msg = new Map<String,Object>();
        JSONGenerator gen = JSON.createGenerator(true);
        gen.writeStartObject();
        gen.writeStringField('discount_Code', discountCode);
        gen.writeStringField('discount_description', description);
        gen.writeStringField('discount_value', discountValue);
        gen.writeStringField('discount_type', discountType);
        gen.writeStringField('service',discountService);
        gen.writeStringField('status', Status);
         if(eTutorUserID!=null)gen.writeStringField('eTutor_ID', eTutorUserID);
        gen.writeStringField('startDate', startDate);
        gen.writeStringField('expiryDate', expiryDate);
        gen.writeStringField('category', category);
        gen.writeEndObject();
        eTutorAPIUtility.executeeTutorCallFuture('POST', gen.getAsString(),objName,recordID,null);
        
    }
    
    
    
}