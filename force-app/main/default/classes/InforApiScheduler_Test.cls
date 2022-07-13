@isTest
private class InforApiScheduler_Test{
    
    static testmethod void  inforApiSchedulerTest(){
        
        Test.StartTest();
        
        String cron = '	0 0 12 1/1 * ? *';
        
        InforAccountsApiScheduler sh1 = new InforAccountsApiScheduler(); 
        system.schedule ('InforAccountsApiSchedulerTest', cron, sh1);
        
        InforContactsApiScheduler sh2 = new InforContactsApiScheduler(); 
        system.schedule ('InforContactsApiSchedulerTest', cron, sh2);
                
        InforProductsApiScheduler sh3 = new InforProductsApiScheduler(); 
        system.schedule ('InforProductsApiSchedulerTest', cron, sh3);
                
        InforAccountProductsApiScheduler sh4 = new InforAccountProductsApiScheduler(); 
        system.schedule ('InforAccountProductsApiSchedulerTest', cron, sh4);
        
        Test.stopTest();
    }
}