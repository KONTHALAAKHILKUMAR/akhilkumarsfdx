public class ContentDocumentLinkTriggerHandler {
    public static final string customNotificationDeveloperName = 'Sending_Notification_when_new_notes_creates';
    public static final string workOrderObjectRef = 'a01';
    public static final string contactSupportEmailId = 'customersupport@etutorconnect.com';
    public static void onAfterInsert(string methodName, List<ContentDocumentLink> contentDocumentLinkList){
        if(methodName == 'sendCustomNotification'){
            sendCustomNotification(contentDocumentLinkList);  
        }
        
    }
    
    public static void sendCustomNotification(List<ContentDocumentLink> contentDocumentLinkList){
        Set<Id> workOrderIdSet = new Set<Id>();//work order Ids where new notes inserted 
        Set<Id> contentDocumentId = new Set<Id>();//holding content document id with work order main handler ID 
        Map<Id,Id> contentDocIdWorkOrderIdMap = new Map<Id,Id>();//holding work order Id with content document ID
        Map<Id,Id> mainHandlerWorkOrderIDMap = new Map<Id,Id>();
        Map<Id,Id> mainHandlerUserIdMap = new Map<Id,Id>();
        Map<Id,WorkOrder__c> contentDocIdWorkOrderObjMap = new Map<Id,WorkOrder__c>();
        //Id contactsupportId = [select id from contact where email =:contactSupportEmailId].Id;
        //ID contactsupportuserId = [select id from user where contactid =:contactsupportId].Id;
        for(ContentDocumentLink contentObj : contentDocumentLinkList){
            if(contentObj.ShareType == 'V' && String.isNotBlank(contentObj.LinkedEntityId)){
                string ObjectId = contentObj.LinkedEntityId;
                if(ObjectId.Substring(0,3) == workOrderObjectRef){
                    workOrderIdSet.add(contentObj.LinkedEntityId); 
                    contentDocIdWorkOrderIdMap.put(contentObj.ContentDocumentId,contentObj.LinkedEntityId); 
                    contentDocumentId.add(contentObj.ContentDocumentId);
                    
                }
            }
        }
        system.debug('workOrderIdSet'+workOrderIdSet);
        system.debug('contentDocIdWorkOrderIdMap'+contentDocIdWorkOrderIdMap);
        
        if(!workOrderIdSet.isEmpty()){
            try{
                
                Id typeId = [SELECT Id FROM CUstomNotificationType WHERE DeveloperName =:customNotificationDeveloperName].Id;
                for (WorkOrder__c workOrderObj : [SELECT ID,Name , MainHandler__c from WorkOrder__c where ID IN: workOrderIdSet]){
                    if(string.isNotBlank(workOrderObj.MainHandler__c)){    
                        contentDocIdWorkOrderObjMap.put(workOrderObj.Id,workOrderObj);
                        mainHandlerWorkOrderIDMap.put(workOrderObj.MainHandler__c,workOrderObj.Id);
                     }
                   
                }
                if(!mainHandlerWorkOrderIDMap.isEmpty()){
                for(USER userObj : [select id,contactid from USER where contactid IN : mainHandlerWorkOrderIDMap.keyset()]){
                    if(mainHandlerWorkOrderIDMap.containskey(userObj.contactid)){
                        mainHandlerUserIdMap.put(userObj.contactid,userObj.id); 
                    }
                }
                }
                system.debug('contentDocIdWorkOrderObjMap'+contentDocIdWorkOrderObjMap);                   
                if(!contentDocumentId.isEmpty()) {
                    List<ContentDocument> contentDocumentList = [select id from ContentDocument where  id in :contentDocumentId];   
                    for(ContentDocument conObj : contentDocumentList){
                        string workOrderId;
                        Set<String> recipientsIdSet = new Set<String>();
                        Messaging.CustomNotification notification = new Messaging.CustomNotification();
                        if(contentDocIdWorkOrderIdMap.containsKey(conObj.Id)){
                             workOrderId = contentDocIdWorkOrderObjMap.get(contentDocIdWorkOrderIdMap.get(conObj.id)).name;
                             recipientsIdSet.add(mainHandlerUserIdMap.get(contentDocIdWorkOrderObjMap.get(contentDocIdWorkOrderIdMap.get(conObj.Id)).MainHandler__c));
                        }
                        //recipientsIdSet.add(contactsupportuserId);
                        recipientsIdSet.add(Userinfo.getUserId());
                        system.debug('recipientsIdSet'+recipientsIdSet);
                        notification.setBody('A note has been added for the work order id: '+workOrderId+ ', Please check it. ');
                        notification.setTitle('New Notes created on Workorder');
                        notification.setSenderId(Userinfo.getUserId());
                        notification.setNotificationTypeId(typeId );
                        notification.setTargetId(Userinfo.getUserId()); 
                        notification.send(recipientsIdSet); // target user id.
                        
                        
                    }  
                }  
                
            }
            catch (Exception e) {
                system.debug('exception'+e);
            }
            
        } 
        
        
        
    }
}