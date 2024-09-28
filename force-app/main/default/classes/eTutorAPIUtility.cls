public class eTutorAPIUtility {
    private final String url;
    private final String method;
    private final String body;
    
/*    public eTutorAPIUtility(String url, String method, String body) {
        this.url = url;
        this.method = method;
        this.body = body;
    }  
    public void executeeTutorCall() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
   */ 
    @Future(callout=true)
    public Static void executeeTutorCallFuture(String method, String body,String objName,String recordID , String recordTypeName)
    {
        eTutorDetails__c et = eTutorDetails__c.getInstance();
        String url;
        IF(objName.equalsignorecase('workorder') && recordTypeName.equalsignorecase('Content Writing') )
        {
            url=et.WorkOrderURL__c;
        }
         IF(objName.equalsignorecase('workorder')&& recordTypeName.equalsignorecase('Plagiarism Check'))
        {
            url=et.PlagiairsmURL__c;
        }
        
        IF(objName.equalsignorecase('WorkOrderPayment') && recordTypeName.equalsignorecase('Content Writing'))
        {
            url=et.WorkOrderPaymentURL__c;
        }
        IF(objName.equalsignorecase('WorkOrderPayment') && recordTypeName.equalsignorecase('Plagiarism Check'))
        {
            url=et.PlagiairsmPaymentURL__c;
        }
         IF(objName.equalsignorecase('DiscountCoupon') || objName.equalsignorecase('DiscountCouponAllocation'))
        {
            url=et.DiscountCouponURL__c;
        }
        system.debug('body**' + body);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setHeader('X-Etutorconnect-Api-Key', et.APIKEY__c);
        req.setHeader('Content-Type', 'application/json');
        req.setHeader('Accept', 'application/json');

        req.setBody(body);
        
        try {  
            Http http = new Http();
            HttpResponse httpResponse = http.send(req); 
            if (httpResponse.getStatusCode() == 200 ) {  
                System.debug('ERROR: '+ httpResponse.getBody());
               updateIntegrationStatus(objName,recordID,'Success', httpResponse.getBody());  
            } else {  
                System.debug('ERROR: '+ httpResponse.getBody());
               updateIntegrationStatus(objName,recordID,'Failed', httpResponse.getBody());  
               throw new CalloutException( httpResponse.getBody() );  
            }   
        } catch( System.Exception e) {  
            System.debug('ERROR: '+ e);  
            ErrorHandler.logError('eTutorAPIUtility',objName + 'id - '+recordID, e.getMessage(),e.getStackTraceString());
        }   
        
        
    }
    
    public static void updateIntegrationStatus(String objName,String recordID,String status, String responsebody)
    {
        
        IF(objName.equalsignorecase('workorder'))
        {
            workOrder__c wo = new workOrder__c();
            wo.eTutorSyncStatus__c = status;
            wo.eTutorSyncResponse__c = responsebody;
            wo.LastSyncDateTime__c = System.now();
            wo.id=recordID;
            update wo;
        }
        
        IF(objName.equalsignorecase('WorkOrderPayment'))
        {
            WorkOrderPayment__c wop = new WorkOrderPayment__c();
            wop.eTutorSyncStatus__c = status;
            wop.eTutorSyncResponse__c = responsebody;
            wop.LastSyncDateTime__c = System.now();
            wop.id=recordID;
            update wop;
        }
        
         IF(objName.equalsignorecase('DiscountCoupon'))
        {
            DiscountCoupons__c dc = new DiscountCoupons__c();
            dc.eTutorSyncStatus__c = status;
            dc.eTutorSyncResponse__c = responsebody;
            dc.LastSyncDateTime__c = System.now();
            dc.id=recordID;
            update dc;
        }
        
         IF(objName.equalsignorecase('DiscountCouponAllocation'))
        {
            Discount_Coupon_Allocation__c dc = new Discount_Coupon_Allocation__c();
            dc.eTutorSyncStatus__c = status;
            dc.eTutorSyncResponse__c = responsebody;
            dc.LastSyncDateTime__c = System.now();
            dc.id=recordID;
            update dc;
        }
        
    }
    
    
    
}