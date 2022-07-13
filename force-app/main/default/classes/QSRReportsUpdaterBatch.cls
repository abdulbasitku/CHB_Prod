public class QSRReportsUpdaterBatch implements Database.Batchable<QSR_Metric_Opportunity__c>, Database.AllowsCallouts, Database.Stateful{ 
    
    private List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
    
    public QSRReportsUpdaterBatch(List<QSR_Metric_Opportunity__c> qsrmetricOpps)
    {        
        system.debug('Method --> QSRReportsUpdaterBatch --> Object Created');
        system.debug('Method --> QSRReportsUpdaterBatch() --> Added New Total QSR Opps = ' + qsrmetricOpps.size());
        allQsrMetricOpps = qsrmetricOpps;
    }
    
    public List<QSR_Metric_Opportunity__c> start(Database.BatchableContext bc) {
        
        
        system.debug('Method --> QSRReportsUpdaterBatch.start() --> Starts');
        system.debug('Method --> QSRReportsUpdaterBatch() --> Added New QSR Opps = ' + allQsrMetricOpps.size());
        return allQsrMetricOpps;
    }
    
    public void execute(Database.BatchableContext bc, List<QSR_Metric_Opportunity__c> records){
        
        system.debug('Method --> QSRReportsUpdaterBatch.execute() --> Starts')	;
        
        try
        {
            List<Database.SaveResult> qsrMetricOppsResult = Database.insert( new List<QSR_Metric_Opportunity__c>(records));
            system.debug('Method --> QSRReportsUpdaterBatch() --> Added New QSR Metric Opps in Batch = ' + qsrMetricOppsResult.size());
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
        system.debug('Method --> QSRReportsUpdaterBatch.execute() --> End');
        
    }
    
    public void finish(Database.BatchableContext bc){
        
        system.debug('Method --> QSRReportsUpdaterBatch.finish() --> Starts');
        
        
        system.debug('Method --> QSRReportsUpdaterBatch.finish() --> End');
    }
}