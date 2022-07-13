@isTest
private class InforDataScheduler_Test{
    
    static testmethod void  inforDataSchedulerTest(){
        
        Test.StartTest();
        
        InforDataScheduler sh1 = new InforDataScheduler();  
        //sh1.execute();
        String sch = '	0 0 12 1/1 * ? *';
        system.schedule ('Test', sch, sh1);
        
        Test.stopTest();
    }
}