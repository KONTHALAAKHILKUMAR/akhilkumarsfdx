@isTest
public class ContactInfoWebserviceTest {
    @isTest 
    public static void testContactJsonReqResSuccessCase() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://cherishtechnologies--dev.sandbox.my.salesforce.com/services/apexrest/api/ContactJson/';
        request.httpMethod = 'Post';       
        string requestJson  = '{"contactEmail":"testContact@gmail.com","contactEtutorId":"12345"} ';
        request.requestBody = Blob.valueOf(requestJson);
        RestContext.request = request;
        // Call the method to test
         string contactInfo = ContactInfoWebservice.getContactInfo();
         //system.debug('contactInfo'+contactInfo);
    }
     @isTest 
    public static void testContactJsonReqResFailedCase() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://cherishtechnologies--dev.sandbox.my.salesforce.com/services/apexrest/api/ContactJson/';
        request.httpMethod = 'Post';       
        string requestJson  = '{"contactEmail":"testContact@gmail.com","contactEtutorId":"123456"} ';
        request.requestBody = Blob.valueOf(requestJson);
        RestContext.request = request;
        // Call the method to test
         string contactInfo = ContactInfoWebservice.getContactInfo();
         //system.debug('contactInfo'+contactInfo);
    }
    @istest
    public static Id createTestRecord() {
        // Create test record
        Contact conObj = new Contact(
            lastName='Test record',
            Email='testContact@gmail.com',
            eTutorUserID__c	='12345'
            );
        insert conObj;
        return conObj.Id;
    }          
    

}