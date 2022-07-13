public class QSRReportsDeletionBatch implements Database.Batchable<QSR_Metric_Opportunity__c>, Database.AllowsCallouts, Database.Stateful{ 
    
    private List<QSR_Metric_Opportunity__c> allQsrMetricOpps = new List<QSR_Metric_Opportunity__c>();
    
    public QSRReportsDeletionBatch(List<QSR_Metric_Opportunity__c> qsrmetricOpps)
    {        
        system.debug('Method --> QSRReportsDeletionBatch --> Object Created');
        system.debug('Method --> QSRReportsDeletionBatch() --> Deleted New Total QSR Opps = ' + qsrmetricOpps.size());
        allQsrMetricOpps = qsrmetricOpps;
    }
    
    public List<QSR_Metric_Opportunity__c> start(Database.BatchableContext bc) {
        
        
        system.debug('Method --> QSRReportsDeletionBatch.start() --> Starts');
        system.debug('Method --> QSRReportsDeletionBatch() --> Deleted Old QSR Opps = ' + allQsrMetricOpps.size());
        return allQsrMetricOpps;
    }
    
    public void execute(Database.BatchableContext bc, List<QSR_Metric_Opportunity__c> records){
        
        system.debug('Method --> QSRReportsDeletionBatch.execute() --> Starts');
        
        try
        {
            List<Database.DeleteResult> qsrMetricOppsResult = Database.Delete( new List<QSR_Metric_Opportunity__c>(records));
            system.debug('Method --> QSRReportsDeletionBatch() --> Deleted Old QSR Metric Opps in Batch = ' + qsrMetricOppsResult.size());
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
        system.debug('Method --> QSRReportsDeletionBatch.execute() --> End');
        
    }
    
    public void finish(Database.BatchableContext bc){
        
        system.debug('Method --> QSRReportsDeletionBatch.finish() --> Starts');
        
        
        system.debug('Method --> QSRReportsDeletionBatch.finish() --> End');
    }
}