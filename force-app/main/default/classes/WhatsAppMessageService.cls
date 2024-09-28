public class WhatsAppMessageService {
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
    public Static void executeeTutorCallFuture()
    {
        Map<String,Object> msg = new Map<String,Object>();
        msg.put('group_admin', '+919666173999');
        msg.put('group_name', 'Accounting - Sirian Group');
        msg.put('message', 'Anil testing API call from Salesforce..pleaseignore this');
        
  
        String body = JSON.serialize(msg); 
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://api.whatsmate.net/v3/whatsapp/group/text/message/20');
        req.setMethod('POST');
        req.setHeader('X-WM-CLIENT-ID', 'support@etutorconnect.com');
        req.setHeader('X-WM-CLIENT-SECRET', 'bfd7210711194a6b9b764cb22e08d714');
         req.setHeader('Content-type', 'application/json');
        req.setBody(body);
        
        try {  
            Http http = new Http();
            HttpResponse httpResponse = http.send(req); 
             System.debug('output '+ httpResponse.getBody());
            if (httpResponse.getStatusCode() == 200 ) {  
                System.debug('ERROR: '+ httpResponse.getBody());
                
            } else {  
                System.debug('ERROR: '+ httpResponse.getBody());
                
                
            }   
        } catch( System.Exception e) {  
            System.debug('ERROR: '+ e);  
            
        }   
        
        
    }
    
    
    
    
    
}