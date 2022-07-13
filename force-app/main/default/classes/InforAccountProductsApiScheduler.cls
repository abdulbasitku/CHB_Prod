global class InforAccountProductsApiScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
        
        system.debug('Method --> InforAccountProductsApiScheduler.execute --> Start');
        
        //Batch approach
        
        InforAccountProductsApiBatch inforAccountProductsApiBatch = new InforAccountProductsApiBatch(); 
        Id batchId = Database.executeBatch(inforAccountProductsApiBatch);
        
        system.debug('Method --> InforAccountProductsApiScheduler.execute --> end - Batch ID = ' + string.valueOf(batchId));   
        
    }
    
}