@isTest
public class InforAccountsApiBatch_Test {

    static testmethod void  inforAccountsApiBatchTest(){
        
        Test.StartTest();
        
        InforAccountsApiBatch inforAccountsApiBatch = new InforAccountsApiBatch(); 
        Id batchId = Database.executeBatch(inforAccountsApiBatch);
        
        Test.stopTest();
    }
}