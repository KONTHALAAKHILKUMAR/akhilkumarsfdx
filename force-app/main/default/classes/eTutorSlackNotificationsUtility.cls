public class eTutorSlackNotificationsUtility {
private final String url;
    private final String method;
    private final String body;
    
 /*   public eTutorSlackNotificationsUtility(String url, String method, String body) {
        this.url = url;
        this.method = method;
        this.body = body;
    }  
    public void executeSlackCall() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
  */  
@Future(callout=true)
    public Static void executeSlackCallTrigger(String url, String method, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod(method);
        req.setBody(body);
        Http http = new Http();
        HttpResponse res = http.send(req);
        System.debug('Body**'+body);
    }
}