@RestResource(urlMapping='/v1/findContact/')
global with sharing class getDataContact{
    
   /* @httpGet
    global static Account doGetMethod(){
    Account acc= new Account();
    Map<String,String> paramsMap = RestContext.request.params;
    String accid=paramsMap.get('id');
    acc = [select id,name,AnnualRevenue from Account where Id =:accid];
    return acc;
    } */
        @httpPost

    global static string getResourceBookingList() {
        responseWrapper responseJSON = new responseWrapper(); //responseWrapper object for API response
        RestRequest req = RestContext.request;
        
   system.debug('req'+Json.serializePretty(req));
       // responseJSON.message = 'Hello World';
       //return responseJSON; 
        //resourceBookingList = Database.query('SELECT Booking_ID__c, Booking_Name__c, Start_Date_Time__c, End_Date_Time__c, Resource__c FROM Resource_Booking__c');    
      /* RestResponse standardResp = RestContext.response;         
        Contact cont = new Contact();
        cont.FirstName = reqBodyObj.FirstName.trim();   
        cont.LastName  = reqBodyObj.LastName.trim();
        cont.Phone  = reqBodyObj.Phone.trim();
        insert cont;
         
        CustomeResponse.Success = true;
        CustomeResponse.Message = 'Contact Created id ='+cont.id;
        standardResp.statusCode = 200;
        standardResp.responseBody = RestHelper.formatResponse(CustomeResponse,ContentType);  */
             
        return 'xyz'; 
        
    }
    
    //wrapper class for the response to an API request
    global class responseWrapper {
        
        global String Status {get;set;} 
        global String Message {get;set;} 
        global String Data {get;set;}
        responseWrapper(){}

    }
    
    
  

}