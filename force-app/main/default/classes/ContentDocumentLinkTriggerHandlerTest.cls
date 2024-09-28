@IsTest
public class ContentDocumentLinkTriggerHandlerTest {
    @istest(SeeAllData=false)
    static void sendCustomNotificationTest(){
        Test.startTest();
        
        UserRole thisUserRole = [Select Id From UserRole Where DeveloperName  = 'CEO' Limit 1];
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        thisUser.UserRoleId = thisUserRole.Id;
        update thisUser;
        System.runAs (thisUser) {
            Account portalAccount = new Account(name = 'portalAccount');//create a portal account first
            insert portalAccount;
            Contact con = new Contact();
            con.lastName = 'test contact';
            con.email = 'customersupport@etutorconnect.com';
            con.AccountId=portalAccount.id;
            insert con;
            UserRole portalRole = [Select Id From UserRole Where DeveloperName  = 'SirianProjectCustomerUser' Limit 1];
            
            User u = new User(
                ProfileId =  [Select id from Profile where name = 'eTutor Community Plus User'].id,
                LastName = 'last',
                UserRoleId = portalRole.Id,
                Email = 'puser000@a.com',
                Username = 'puser000@a.co' + System.currentTimeMillis(),
                CompanyName = 'TEST',
                Title = 'title',
                Alias = 'alias',
                TimeZoneSidKey = 'America/Los_Angeles',
                EmailEncodingKey = 'UTF-8',
                LanguageLocaleKey = 'en_US',
                LocaleSidKey = 'en_US',
                contactid = con.Id  
                //IsPortalEnabled = true
                
            );
            insert u; 
            
            
            workOrder__c wob = new workOrder__c();
            wob.MainHandler__c = con.Id;
            insert wob;
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
            
            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;    
            List<ContentDocument> documents = [
                SELECT Id, Title, LatestPublishedVersionId 
                FROM ContentDocument
            ];
            
            //create ContentDocumentLink  record 
            ContentDocumentLink cdl = New ContentDocumentLink();
            cdl.LinkedEntityId = wob.id;
            cdl.ContentDocumentId = documents[0].Id;
            cdl.shareType = 'V';
            insert cdl;
            
            Test.stopTest();
            
        } 
    }
    
}