global class InforProductsApiScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        
        system.debug('Method --> InforProductsApiScheduler.execute --> Start');
        
        //Batch approach
        
        InforProductsApiBatch inforProductsApiBatch = new InforProductsApiBatch(); 
        Id batchId = Database.executeBatch(inforProductsApiBatch);
        
        system.debug('Method --> InforProductsApiScheduler.execute --> end - Batch ID = ' + string.valueOf(batchId));   
        
    }
    
}