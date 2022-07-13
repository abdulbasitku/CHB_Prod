@isTest
public class UpdateDataFromInfor_Test {
    
    
    static testmethod void  updateInforAccountsDataTest(){
        
        Test.StartTest();
        
        Account pAcct = DataFactory.CreateAccount('TestParentAccount');
        pAcct.External_ID__c = 'TestInforAccountParentId';
        update pAcct;
        Set<string> ignoreInforList = new Set<string>();
        Map<string,Account> allParentAccountsMap = new Map<string,Account>();
        allParentAccountsMap.put('TestInforAccountParentId', pAcct);
        
        List<InforAccount> inforAccounts = new List<InforAccount>();
        InforAccount inforAccount = TestUtility.CreateInforAccount_Mock();
        
        inforAccounts.add(inforAccount);
        
        UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();       
        updateDataFromInfor.UpdateInforAccountsData(inforAccounts, allParentAccountsMap,ignoreInforList);
        
        Test.stopTest();
        
    }
    
    static testmethod void  updateInforContactsDataTest(){
        
        Test.StartTest();
        
        Account pAcct = DataFactory.CreateAccount('TestParentAccount');
        pAcct.External_ID__c = 'TestInforAccountParentId';
        update pAcct;
        
        Map<string,Contact> allContactsMap = new Map<string,Contact>();
        Map<string,Account> allAccountsMap = new Map<string,Account>();
        allAccountsMap.put('TestInforAccountParentId', pAcct);
        
        List<InforContact> inforContacts = new List<InforContact>();
        InforContact inforContact = TestUtility.CreateInforContact_Mock();
        
        inforContacts.add(inforContact);
        
        UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();       
        updateDataFromInfor.UpdateInforContactsData(inforContacts, allAccountsMap, allContactsMap, allContactsMap);
        
        Test.stopTest();        
    }
    
    static testmethod void  updateInforProductsDataTest(){
        
        Test.StartTest();
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        
        Product2 prod = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        prod.External_ID__c = 'TestInforProductId';
        update prod;
        
        Map<string,Product2> allProductsMap = new Map<string,Product2>();
        allProductsMap.put('TestInforProductId', prod);
        
        List<InforProduct> inforProducts = new List<InforProduct>();
        InforProduct inforProduct = TestUtility.CreateInforProduct_Mock();
        
        inforProducts.add(inforProduct);
        
        UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();       
        updateDataFromInfor.UpdateInforProductsData(inforProducts, allProductsMap);
        
        Test.stopTest();        
    }
    
    static testmethod void  updateInforAccountProductsDataTest(){
        
        Test.StartTest();
        
        List<InforAccountProduct> inforAccountProducts = new List<InforAccountProduct>();
        InforAccountProduct inforAccountProduct = TestUtility.CreateInforAccountProduct_Mock();
        
        inforAccountProducts.add(inforAccountProduct);
        
        Account pAcct = DataFactory.CreateAccount('TestAccount');
        pAcct.External_ID__c = 'TestInforAccountId';
        update pAcct;
        
        Map<string,Account> allAccountsMap = new Map<string,Account>();
        allAccountsMap.put('TestInforAccountId', pAcct);
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        
        Product2 prod = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        prod.External_ID__c = 'TestInforProductId';
        update prod;
        
        Map<string,Product2> allProductsMap = new Map<string,Product2>();
        allProductsMap.put('TestInforProductId', prod);
        
        
        Map<string,Account_Product__c> allAccountProductMaps = new Map<string,Account_Product__c>();
        
        UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();       
        updateDataFromInfor.UpdateInforAccountProductsData(inforAccountProducts, allAccountsMap, allProductsMap, allAccountProductMaps);
        
        Test.stopTest();        
    }
    
}