/*
  Author: Dhanik Lal Sahni
  Description : Class Handler to generate file public link
*/
public class ContentTriggerHandler {
    
  public Static void  UpdatePublicLink(List<ContentVersion> contentVersions,Map<ID,ContentVersion> oldMap)
    {
        Set<ID> conDocId = new Set<ID>();
        Map<ID,String> mapDocUrl = new Map<ID,String>();
         	for(ContentVersion objContentVersion : contentVersions){
                ContentVersion old = oldMap.get(objContentVersion.ID);
                IF(objContentVersion.GeneratePublicLink__c==true && old.GeneratePublicLink__c!=objContentVersion.GeneratePublicLink__c)
                 conDocId.add(objContentVersion.ContentDocumentId);
            }
        
        For(ContentDistribution cd:[Select ID,contentdownloadurl,ContentDocumentId from ContentDistribution where ContentDocumentId IN: conDocId])
        {
            mapDocUrl.put(cd.ContentDocumentId,cd.contentdownloadurl);
        }
        for(ContentVersion objContentVersion : contentVersions){
            if(mapDocUrl!=null && mapDocUrl.get(objContentVersion.ContentDocumentId)!=null)
            objContentVersion.PublicLink__c=mapDocUrl.get(objContentVersion.ContentDocumentId);
        }
        
        
     }
    
    
    public static void createPublicLinkForFile(List<ContentVersion> contentVersions){
        ContentDistribution[] distributionsToInsert = new List<ContentDistribution>();
       	for(ContentVersion objContentVersion : contentVersions){
            //if image uploaded then only create public link
           // if(objContentVersion.FileType.toLowerCase()=='jpg'){
                system.debug('objContentVersion.FileExtension.toLowerCase():' + objContentVersion.FileType);
                
                distributionsToInsert.add(createContentDistribution(objContentVersion.Id));
           // }
        }
        if(!distributionsToInsert.isEmpty())
        {
        	insert distributionsToInsert;
        }
    }
    
    public static ContentDistribution createContentDistribution(Id contentVersionId){
        ContentDistribution newDist = new ContentDistribution();
        newDist.ContentVersionId = contentVersionId;
        newDist.Name = 'External Link';
        newDist.PreferencesNotifyOnVisit = false;
        newDist.PreferencesAllowViewInBrowser = true;
        newDist.PreferencesAllowOriginalDownload=true;
        system.debug('createContentDistribution creted');
        return newDist;
    }
}