public class ErrorHandler {
    
    public static void logError(String className ,String methodName ,String description ,String stackTrace){
        ErrorLog__c  error = new ErrorLog__c ();
        error.ClassName__c  = className + ' ' +methodName;
        error.LogTime__c  = system.now();
        error.Description__c  = description;
        error.StackTrace__c  = stackTrace;
        error.SentToSlack__c=true;
        insert error;
    } 
   /* public static ErrorLog__c addError(String className ,String methodName ,String description ,String stackTrace) {
        ErrorLog__c  error = new ErrorLog__c ();
        error.ClassName__c  = className + ' ' +methodName;
        error.LogTime__c  = system.now();
        error.Description__c  = description;
        error.StackTrace__c  = stackTrace;
        return error;
    }
    
    public static void logErrors(List<ErrorLog__c> errList) {
        insert errList;
    }
    */
}