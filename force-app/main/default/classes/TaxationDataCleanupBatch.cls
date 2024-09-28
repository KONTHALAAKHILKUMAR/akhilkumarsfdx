global class TaxationDataCleanupBatch implements Database.Batchable<sObject>,Schedulable
{

	global Database.QueryLocator start(Database.BatchableContext BC)
	{
        String query = 'SELECT Id,Ready_to_consider__c FROM Taxation__c WHERE Ready_to_consider__c = false';
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Taxation__c> scope)
    {
        if(!scope.isEmpty()){
            delete scope;
        }
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
    global void execute(SchedulableContext SC) {
 	    database.executebatch(new TaxationDataCleanupBatch());
    }
}