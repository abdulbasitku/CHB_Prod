/*
* Description: This Apex Class exposes method(s) that can be utilized by 
* other Apex Classes to create Persistent Logs of type Error or
*/
global class Logger{
    /*
A Virtual Class that Defines the 
Structure of a Log
*/
    public virtual class Log{
        public String Type;
        public String ApexClass;
        public String Method;        
        public String RecordId;
        public String Message;
        public String ObjectType;
        public DateTime TimeOfExecution;        
        public String StackTrace;
    }
    
    /*A Class that Extends the Virtual Class - Log to define a log of type - Error*/
    public class ExceptionError extends Log{
        public ExceptionError(String cls, String routine, String recId, Exception ex, String objectType, DateTime timeOfExecution){
            this.Type = 'Exception';
            this.ApexClass = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.ObjectType = objectType;
            this.TimeOfExecution = timeOfExecution;
            this.Message = ex.getMessage();
            this.StackTrace = ex.getStackTraceString();
        }
    }
    
    /*A Class that Extends the Virtual Class - Log to define a log of type - Information*/
    public class Information extends Log{
        public Information(String cls, String routine, String recId, String msg, String objectType, DateTime timeOfExecution){
            this.Type = 'Information';
            this.ApexClass = cls;
            this.Method = routine;
            this.RecordId = recId;
            this.Message = msg;
            this.ObjectType = objectType;
            this.TimeOfExecution = timeOfExecution;
            this.StackTrace = NULL;
        }
    }
    
    /*A Public Method that can be utilized by other Apex Classes to create a record into the Apex Debug Log object stating the Error or Information.*/
    public void createLog(Log logToCreate)
    {
        try{
            /*Ensure that we're well within the Governor Limits. The creation of the Log shouldn't disturb the execution of that Apex Class that utilizes this method to create a log.*/
            if((Limits.getDMLRows() < Limits.getLimitDMLRows()) && (Limits.getDMLStatements() < Limits.getLimitDMLStatements()))
            {
                Logs__c apexDebuglog = new Logs__c(
                    Type__c         = logToCreate.Type,
                    Apex_Class__c   = logToCreate.ApexClass,
                    Method__c       = logToCreate.Method,
                    Record_Id_Data__c    = logToCreate.RecordId,
                    Message__c      = logToCreate.Message,
                    Object_Type__c      = logToCreate.ObjectType,
                    Time_Of_Execution__c      = logToCreate.TimeOfExecution,
                    Stack_Trace__c  = logToCreate.StackTrace
                );
                
                Database.insert(apexDebuglog, FALSE);
            }
            else{
                System.debug('The Governor Limits have already been exhausted and hence failed to create a Log!');
            }
        }
        catch(DMLException ex){
            System.debug('Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
        }
    }
    
    public void createLogs(List<Log> logsToCreate)
    {
        try
        {
            List<Logs__c> apexDebuglogs = new List<Logs__c>();
            
            /*Ensure that we're well within the Governor Limits. The creation of the Log shouldn't disturb the execution of that Apex Class that utilizes this method to create a log.*/
            if((Limits.getDMLRows() < Limits.getLimitDMLRows()) && (Limits.getDMLStatements() < Limits.getLimitDMLStatements()))
            {
                for(Log logToCreate : logsToCreate)
                {
                    Logs__c apexDebuglog = new Logs__c(
                        Type__c         = logToCreate.Type,
                        Apex_Class__c   = logToCreate.ApexClass,
                        Method__c       = logToCreate.Method,
                        Record_Id_Data__c    = logToCreate.RecordId,
                        Message__c      = logToCreate.Message,
                        Object_Type__c      = logToCreate.ObjectType,
                        Time_Of_Execution__c      = logToCreate.TimeOfExecution,
                        Stack_Trace__c  = logToCreate.StackTrace
                    );
                    apexDebuglogs.Add(apexDebuglog);
                }
                
                Database.insert(apexDebuglogs, FALSE);
            }
            else
            {
                System.debug('The Governor Limits have already been exhausted and hence failed to create a Log!');
            }
        }
        catch(DMLException ex)
        {
            System.debug('Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
        }
    }
    
    /*A Public Method that can be utilized from JavaScript to create record(s) [aka Logs] into the Custom Object.*/
    
    webService
    static void createLog(String log)
    {
            try{
                /*
Expects a JSON of the form - 
{
"Type"       : "---",
"ApexClass"  : "---",
"Method"     : "---",
"RecordId"   : "---",
"Message"    : "---",
"ObjectType" : "---",
"TimeOfExecution" : "---",
"StackTrace" : "---",
}
*/
                
                /*Deserialize the same to create an instance of the virtual class - ApexDebugLog.Log*/
                Logger.Log logToCreate = (Logger.Log)JSON.deserialize(log, Logger.Log.class);
                
                new Logger().createLog(logToCreate);
            }
            catch(Exception ex){
                System.debug('Something fatal has occurred and hence failed to create a Log! Error:' + ex.getMessage());
            }
        }
}