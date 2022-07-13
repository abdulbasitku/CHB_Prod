global class InforAccountProductsApiBatch implements Database.Batchable<InforAccountProduct>,Database.AllowsCallouts, Database.Stateful{
    
    Integer offset = 0;
    Integer pageSize = 100000;
    boolean ignoreDate = false;
    integer timeRangeInMinutes = 60;
    
    Map<string,Account> allAccountsMap = new Map<string,Account>();    
    Map<string,Product2> allProductsMap = new Map<string,Product2>();
    Map<string,Account_Product__c> allAccountProductMaps = new Map<string,Account_Product__c>();
    
    void PopulateAccountsProductsMap(List<InforAccountProduct> inforAccountProducts){
        
        system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() --> Start');
        
        List<string> accountIds = new List<string>();
        List<string> productIds = new List<string>();
        
        try{
            
            for(InforAccountProduct inforAccountProduct : inforAccountProducts)
            {
                if(inforAccountProduct.accountId != null)
                {
                    accountIds.Add(inforAccountProduct.accountId);
                }
                if(inforAccountProduct.productId != null)
                {
                    productIds.Add(inforAccountProduct.productId);
                }
                
            }
            
            system.debug('Method --> InforAccountProductsApiBatch.start() --> Accounts Ids = ' + accountIds.Size());
            
            system.debug('Method --> InforAccountProductsApiBatch.start() --> Products Ids = ' + productIds.Size());
            
            List<Account> listAccounts = [Select Id, Name, External_ID__C FROM Account WHERE External_ID__C != ''];
            List<Product2> listProducts = [Select Id, Name, External_ID__C from Product2 where External_ID__C in :productIds];
            
            List<Account_Product__c> listAccountProducts = [Select Id, Name, Account__r.External_ID__c, Product__r.External_ID__c, External_ID_Infor__c from Account_Product__c where Account__r.External_ID__c in :accountIds];            
            listAccountProducts.addAll([Select Id, Name, Account__r.External_ID__c, Product__r.External_ID__c, External_ID_Infor__c from Account_Product__c where Product__r.External_ID__c in :productIds]);
            
            
            system.debug('Method --> InforAccountProductsApiBatch.start() --> Accounts SF = ' + listAccounts.Size());
            
            system.debug('Method --> InforAccountProductsApiBatch.start() --> Products SF = ' + listProducts.Size());
            
            for(Account account : listAccounts)
            {
                //allAccountsMap.put(account.External_ID__c, account);
                if(account.External_ID__c != null && string.isNotEmpty(account.External_ID__c))
                {
                    if(account.External_ID__c.contains(','))
                    {
                        List<string> extIds = account.External_ID__c.split(',');
                        boolean isFirst = true;
                        for(string extId : extIds)
                        {                            
                            if(extId != ',' && string.isNotEmpty(extId))
                            {
                                allAccountsMap.put(extId, account);    
                            }
                            
                        }
                    }
                    else
                    {
                        allAccountsMap.put(account.External_ID__c, account);
                    }
                }
            }
            
            for(Product2 product : listProducts)
            {
                allProductsMap.put(product.External_ID__c, product);
            }
            
            for(Account_Product__c acctprod : listAccountProducts)
            {
                if(acctprod.External_ID_Infor__c != null && string.isNotEmpty(acctprod.External_ID_Infor__c))
                {
                    /*if(acctprod.Account__r.External_ID__c.contains(','))
                    {
                        List<string> extIds = acctprod.Account__r.External_ID__c.split(',');
                        boolean isFirst = true;
                        for(string extId : extIds)
                        {                            
                            if(extId != ',' && string.isNotEmpty(extId))
                            {
                                allAccountProductMaps.put(extId + '|' + acctprod.Product__r.External_ID__c, acctprod);   
                            }                            
                        }
                    }
                    else
                    {                        
                        allAccountProductMaps.put(acctprod.Account__r.External_ID__c + '|' + acctprod.Product__r.External_ID__c, acctprod);
                    }*/
                    allAccountProductMaps.put(acctprod.External_ID_Infor__c, acctprod);
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() --> Exception Occured');
            system.debug(e);
        }
        system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() --> End');
    }
    
    public List<InforAccountProduct> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        system.debug('Method --> InforAccountProductsApiBatch.start() --> Starts');
        
        List<InforAccountProduct> allAccountProducts = new List<InforAccountProduct>();
        
        try
        {   
            boolean continueJob = true;
            
            InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer();
            AccountProductsResponse data;
            if(System.Test.isRunningTest())
            {
                data = inforDataApiConsumer.GetInforAccountProductsHourlyDataMock();               
            }
            else
            {
                data = inforDataApiConsumer.GetInforAccountProductsHourlyData(timeRangeInMinutes);
            }
            if(data != null && data.responseCode == 200 && data.InforAccountProducts != null && data.InforAccountProducts.Size() > 0){
                
                system.debug('Method --> InforAccountProductsApiBatch.start() --> Total Records = ' + data.InforAccountProducts.Size());
                
                allAccountProducts = data.InforAccountProducts;
                if(allAccountProducts != null && allAccountProducts.size() > 0)
                {
                    PopulateAccountsProductsMap(allAccountProducts);
                }
            }
            
            else
            {
                system.debug('Method --> InforAccountProductsApiBatch.start() --> Error in Response Data');
            }
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
        
        system.debug('Method --> InforAccountProductsApiBatch.start() --> End');
        return allAccountProducts;
    }
    
    public void execute(Database.BatchableContext bc, List<InforAccountProduct> records){
        
        system.debug('Method --> InforAccountProductsApiBatch.execute() --> Start');
        try
        {
            if(records != null)
            {            
                system.debug('Method --> InforAccountProductsApiBatch.execute() --> Batch Records = ' + records.size());
                
                UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();
                /*if(records != null && records.size() > 0)
                {
                    PopulateAccountsProductsMap(records);
                }*/
                updateDataFromInfor.UpdateInforAccountProductsData(records, allAccountsMap, allProductsMap, allAccountProductMaps);
                
                system.debug('Method --> InforAccountProductsApiBatch.execute() --> End');
            }
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }        
    }    
    
    public void finish(Database.BatchableContext bc){
        
        system.debug('Method --> InforAccountProductsApiBatch.finish() --> Start');
        
        // execute any post-processing operations
        try
        {
            /*DateTime now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(5);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            System.schedule('InforProductsApiScheduler',cronString, new InforProductsApiScheduler());*/
            System.scheduleBatch(new InforAccountsApiBatch(), 'InforAccountsApiBatch', 30);
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        } 
        
        system.debug('Method --> InforAccountProductsApiBatch.finish() --> End');
    }
    
}