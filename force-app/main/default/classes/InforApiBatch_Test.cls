@isTest
public class InforApiBatch_Test {

    static testmethod void  inforAccountsApiBatchTest(){
        
        Test.StartTest();
        
        InforAccountsApiBatch inforAccountsApiBatch = new InforAccountsApiBatch(); 
        Id batchId = Database.executeBatch(inforAccountsApiBatch);
        
        Test.stopTest();
    }
    
    static testmethod void  inforContactsApiBatchTest(){
        
        Test.StartTest();
        
        InforContactsApiBatch inforContactsApiBatch = new InforContactsApiBatch(); 
        Id batchId = Database.executeBatch(inforContactsApiBatch);
        
        Test.stopTest();
    }
    
    static testmethod void  inforProductsApiBatchTest(){
        
        Test.StartTest();
        
        InforProductsApiBatch inforProductsApiBatch = new InforProductsApiBatch(); 
        Id batchId = Database.executeBatch(inforProductsApiBatch);
        
        Test.stopTest();
    }
    
    static testmethod void  inforAccountProductsApiBatchTest(){
        
        Test.StartTest();
        
        InforAccountProductsApiBatch inforAccountProductsApiBatch = new InforAccountProductsApiBatch(); 
        Id batchId = Database.executeBatch(inforAccountProductsApiBatch);
        
        Test.stopTest();
    }
}