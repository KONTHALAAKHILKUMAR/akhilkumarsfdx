@RestResource(urlMapping='/DocumentUploadBase64/*')
global class DocumentUploadBase64{
    
    @HttpPost
    global static void uploadDocument()
    {
        RestRequest req = RestContext.request;
        RestResponse res = Restcontext.response;
        Id workorderID = req.params.get('workorderID');
        string contenttype = req.params.get('contenttype');
        string name = req.params.get('name');
        
        System.debug('**workorderID**          '   + workorderID );
        String jsonString = ( String ) JSON.deserialize( req.requestBody.toString(), String.class );
       
        System.debug('**1 ' + jsonString );
        try
        {
            //Insert ContentVersion
            ContentVersion cVersion = new ContentVersion();
            cVersion.PathOnClient = name;//File name with extention
            cVersion.Title = name;//Name of the file
            cVersion.VersionData = EncodingUtil.base64Decode(jsonString);//File content
            Insert cVersion;
            System.debug('**cVersion ' +cVersion );
            //After saved the Content Verison, get the ContentDocumentId
            Id conDocument = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:cVersion.Id].ContentDocumentId;
            System.debug('**conDocument ' +conDocument );
            //Insert ContentDocumentLink
            ContentDocumentLink cDocLink = new ContentDocumentLink();
            cDocLink.ContentDocumentId = conDocument;//Add ContentDocumentId
            cDocLink.LinkedEntityId = workorderID;//Add attachment parentId
            Insert cDocLink;
            System.debug('**cDocLink ' +cDocLink );
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(generateJSON('Success',conDocument,''));
            
        }
        catch(Exception e)
        {
            RestContext.response.addHeader('Content-Type', 'application/json');
            RestContext.response.responseBody = Blob.valueOf(generateJSON('Error','',e.getMessage()));
            ErrorHandler.logError('DocumentUploadBase64','uploadDocument - '+workorderID, e.getMessage(),e.getStackTraceString());

        }
        
    }
    // To generate JSON response
    private static string generateJSON(String Status,String Content,String error){
        JSONGenerator jsGen = JSON.createGenerator(true);
        jsGen.writeStartObject();
        jsGen.writeStringField('Status',Status);
        jsGen.writeStringField('ContentID', Content);
        jsGen.writeStringField('Error', error);
        jsGen.writeEndObject();
        return jsGen.getAsString();
    }
    
}