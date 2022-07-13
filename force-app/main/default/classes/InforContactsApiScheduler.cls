global class InforContactsApiScheduler implements Schedulable {
    
    global void execute(SchedulableContext ctx) {
                
        system.debug('Method --> InforContactsApiDataScheduler.execute --> Start');
                
        //Batch approach
        InforContactsApiBatch inforContactsApiBatch = new InforContactsApiBatch(); 
        Id batchId = Database.executeBatch(inforContactsApiBatch);
        
        system.debug('Method --> InforContactsApiDataScheduler.execute --> end - Batch ID = ' + string.valueOf(batchId));   
        
    }
    
}