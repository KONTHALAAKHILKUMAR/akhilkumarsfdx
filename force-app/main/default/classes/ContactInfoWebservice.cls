@RestResource(urlMapping='/api/ContactJson/*')

global with sharing class ContactInfoWebservice {
  public static final string suceessStatus = 'Success';
    public static final string errorStatus = 'Error';
    public static final string MessageSuccess = 'Contact Id Found';
    public static final string MessageError = 'Contact Id Not Found'; 
    
    @HttpPost
    global static string getContactInfo() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        Blob body = req.requestBody;
        String requestString = body.toString();
        ResponseWrapper resWrapper = new ResponseWrapper();
        String  jsonBodyResonse;
        try{
            RequestWrapper jsonBody = (RequestWrapper)JSON.deserialize(requestString, RequestWrapper.class);
            system.debug('jsonBody'+jsonBody); 
            string contactEmail = jsonBody.ContactEmail; 
            string contactEtutorId = jsonBody.contactEtutorId;    
            
            if(!string.isblank(contactEmail) && !string.isblank(contactEtutorId)) {
                List<Contact> conList = [SELECT ID FROM Contact Where Email =:contactEmail AND eTutorUserID__c =:contactEtutorId LIMIT 1 ];
                
                if(!conList.isEmpty()) {
                    resWrapper.Status = suceessStatus;
                    resWrapper.Message = MessageSuccess; 
                    resWrapper.Data = conList[0].Id;
                    
                }else{
                    resWrapper.Status = errorStatus; 
                    resWrapper.Message = MessageError; 
                    resWrapper.Data = ''; 
                }
               jsonBodyResonse = JSON.serialize(resWrapper);

                
            }

            
        }Catch(Exception e){
            system.debug('e'+e);
        }
       return jsonBodyResonse;
        
    }
    
    public class RequestWrapper{ 
        public String ContactEmail; 
        public string contactEtutorId;  
    }
    public class ResponseWrapper{
        public string Status;
        public string Message;
        public string Data;
    }
}