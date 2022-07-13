@isTest
public class Logger_Test{
    testMethod
    static void createErrorLog(){
        try{
            Integer result = 1 / 0;
        }
        catch(Exception ex){
            new Logger().createLog(
                new Logger.ExceptionError('ApexDebugLog_Test','createErrorLog', NULL, ex, 'Test',Datetime.now())
            );

            List<Logs__c> lstLogsCreated = [
                SELECT  Id, Type__c, Apex_Class__c, Method__c
                FROM    Logs__c
                WHERE   Method__c = 'createErrorLog'
            ];

            System.assertEquals(1, lstLogsCreated.size());
            System.assertEquals('Exception', lstLogsCreated.get(0).Type__c);
            System.assertEquals('ApexDebugLog_Test', lstLogsCreated.get(0).Apex_Class__c);
        }
    }

    testMethod
    static void createInformationLog(){
        new Logger().createLog(
            new Logger.Information(
                'ApexDebugLog_Test',
                'createInformationLog',
                NULL,
                'Logging Information from an Apex Class - ApexDebugLog_Test','Test',Datetime.now()
            )
        );

        List<Logs__c> lstLogsCreated = [
            SELECT  Id, Type__c, Apex_Class__c, Method__c, Message__c
            FROM    Logs__c
            WHERE   Method__c = 'createInformationLog'
        ];

        System.assertEquals(1, lstLogsCreated.size());
        System.assertEquals('Information', lstLogsCreated.get(0).Type__c);
        System.assertEquals('ApexDebugLog_Test', lstLogsCreated.get(0).Apex_Class__c);
        System.assertEquals('Logging Information from an Apex Class - ApexDebugLog_Test', lstLogsCreated.get(0).Message__c);
    }

    testMethod
    static void ws_createErrorLog(){
        try{
            Integer result = 1 / 0;
        }
        catch(Exception ex){
            Logger.createLog(
                '{"Type" : "Error","ApexClass" : "ApexDebugLog_Test","Method" : "createErrorLog","RecordId" : "","Message" : "System.MathException: Divide by 0","StackTrace" : "Line: 1, Column: 1 System.MathException: Divide by 0"}'
            );

            List<Logs__c> lstLogsCreated = [
                SELECT  Id, Type__c, Apex_Class__c, Method__c
                FROM    Logs__c
                WHERE   Method__c = 'createErrorLog'
            ];

            System.assertEquals(1, lstLogsCreated.size());
            System.assertEquals('Error', lstLogsCreated.get(0).Type__c);
            System.assertEquals('ApexDebugLog_Test', lstLogsCreated.get(0).Apex_Class__c);
        }
    }

    testMethod
    static void ws_createInformationLog(){
        Logger.createLog(
            '{"Type" : "Information","ApexClass" : "ApexDebugLog_Test","Method" : "createInformationLog","RecordId" : "","Message" : "Logging Information from an Apex Class - ApexDebugLog_Test"}'
        );

        List<Logs__c> lstLogsCreated = [
            SELECT  Id, Type__c, Apex_Class__c, Method__c, Message__c
            FROM    Logs__c
            WHERE   Method__c = 'createInformationLog'
        ];

        System.assertEquals(1, lstLogsCreated.size());
        System.assertEquals('Information', lstLogsCreated.get(0).Type__c);
        System.assertEquals('ApexDebugLog_Test', lstLogsCreated.get(0).Apex_Class__c);
        System.assertEquals('Logging Information from an Apex Class - ApexDebugLog_Test', lstLogsCreated.get(0).Message__c);
    }
}