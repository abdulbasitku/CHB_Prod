@isTest
public class InforDataApiConsumer_Test {

    static testmethod void  GetInforAccountsHourlyData_Test(){
        
        Test.StartTest();
        try{
        InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer(); 
        inforDataApiConsumer.GetInforAccountsHourlyData(60);
        }
        Catch(Exception ex)
        {

        }
        Test.stopTest();
    }
    
    static testmethod void  GetInforContactsHourlyData_Test(){
        
        Test.StartTest();
        try{
        InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer(); 
        inforDataApiConsumer.GetInforContactsHourlyData(60, true);
    }
    Catch(Exception ex)
    {
        
    }
        Test.stopTest();
    }
    
    static testmethod void  GetInforProductsHourlyData_Test(){
        
        Test.StartTest();
        try{
        InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer(); 
        inforDataApiConsumer.GetInforProductsHourlyData(60);
    }
    Catch(Exception ex)
    {
        
    }
        Test.stopTest();
    }
    
    static testmethod void  GetInforAccountProductsHourlyData_Test(){
        
        Test.StartTest();
        try{
        InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer(); 
        inforDataApiConsumer.GetInforAccountProductsHourlyData(60);
    }
    Catch(Exception ex)
    {
        
    }
        Test.stopTest();
    }
}