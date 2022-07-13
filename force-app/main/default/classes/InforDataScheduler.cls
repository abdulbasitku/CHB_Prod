global class InforDataScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
                
        system.debug('Method --> InforDataScheduler.execute --> Start');
        
        //Custom approach
        //InforDataIntegrationJob obj = new InforDataIntegrationJob();
        //obj.GetInforAccountsToSF();
        
        //Batch approach
        InforAccountsApiBatch inforAccountsApiBatch = new InforAccountsApiBatch(); 
        Id batchId = Database.executeBatch(inforAccountsApiBatch);
        
        system.debug('Method --> InforDataScheduler.execute --> end - Batch ID = ' + string.valueOf(batchId));   
        
    }
    
}