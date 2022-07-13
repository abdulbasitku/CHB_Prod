public class QSRReportsDeletionBatch2 implements Database.Batchable<sobject>, Database.AllowsCallouts, Database.Stateful{ 
    
    private string forDeleteExistingOpp;
    
    public QSRReportsDeletionBatch2(string forDeleteExistingOpp)
    {        
        system.debug('Method --> QSRReportsDeletionBatch --> Object Created');
        this.forDeleteExistingOpp = forDeleteExistingOpp;
    }
    
    public database.Querylocator start(Database.BatchableContext bc) {
                
        system.debug('Method --> QSRReportsDeletionBatch.start() --> Starts');
        //string forDeleteExistingOpp = 'MKTPF_' + NN_BB + '%';
        return Database.getQueryLocator([select id, name, QSR_Metric_Value__r.external_id__c from QSR_Metric_Opportunity__c where QSR_Metric_Value__r.external_id__c like :forDeleteExistingOpp]);            
            
    }
    
    public void execute(Database.BatchableContext bc, List<sobject> records){
        
        system.debug('Method --> QSRReportsDeletionBatch.execute() --> Starts');
        
        try
        {
            List<Database.DeleteResult> qsrMetricOppsResult = Database.Delete(records);
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