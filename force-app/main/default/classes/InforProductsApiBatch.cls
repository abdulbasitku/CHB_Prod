global class InforProductsApiBatch implements Database.Batchable<InforProduct>,Database.AllowsCallouts, Database.Stateful{
    
    Integer offset = 0;
    Integer pageSize = 100000;
    boolean ignoreDate = false;
    integer timeRangeInMinutes = 40;
       
    
	 Map<string,Product2> allProductsMap = new Map<string,Product2>(); 
     void PopulateProductsInforIdMap(List<InforProduct> inforProducts){
        
        system.debug('Method --> InforProductsApiBatch.PopulateProductsInforIdMap() --> Start');
        
        try{
            
            List<Product2> listProducts = new List<Product2>();
            
            Set<string> listIds = new Set<string>();
            
            for(InforProduct inforProduct : inforProducts)
            {
                if(inforProduct.productId != null && string.isNotEmpty(inforProduct.productId))
                {
                    listIds.Add(inforProduct.productId);
                }
            }
            
            system.debug('Method --> InforProductsApiBatch.PopulateProductsInforIdMap() --> Product Ids = ' + listIds.size());
            
            listProducts  = [SELECT Id, Name, isActive, External_ID__c FROM Product2 WHERE External_ID__c in :listIds];
                        
            for(Product2 product : listProducts)
            {
                if(product.External_ID__c != null && string.isNotEmpty(product.External_ID__c))
                {
                    allProductsMap.put(product.External_ID__c, product);                    
                }
            }
            
            system.debug('Method --> InforProductsApiBatch.PopulateProductsInforIdMap() --> Product SF = ' + listProducts.size());
            
        }
        catch(Exception e)
        {
            system.debug('Method --> InforProductsApiBatch.PopulateProductsInforIdMap() --> Exception Occured');
            system.debug(e);
        }
        system.debug('Method --> InforProductsApiBatch.PopulateProductsInforIdMap() --> End');
    }
    
    public List<InforProduct> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        system.debug('Method --> InforProductsApiBatch.start() --> Starts');
        
        List<InforProduct> allProducts = new List<InforProduct>();
        
        try
        {   
            boolean continueJob = true;
            
            InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer();
            ProductsResponse data;
            if(System.Test.isRunningTest())
            {
                data = inforDataApiConsumer.GetInforProductsHourlyDataMock();               
            }
            else
            {
                data = inforDataApiConsumer.GetInforProductsHourlyData(timeRangeInMinutes);
            }
            
            if(data != null && data.responseCode == 200 && data.InforProducts != null && data.InforProducts.Size() > 0){
                
                system.debug('Method --> InforProductsApiBatch.start --> Total Records = ' + data.InforProducts.Size());
                
                allProducts = data.inforProducts;
                if(allProducts != null && allProducts.size() > 0)
                {
                    PopulateProductsInforIdMap(allProducts);
                }
            }
            else
            {
                system.debug('Method --> InforProductsApiBatch.start --> Error in Response Data');
            }
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
        
        system.debug('Method --> InforProductsApiBatch.start() --> End');
        return allProducts;
    }
    
    public void execute(Database.BatchableContext bc, List<InforProduct> records){
        
        system.debug('Method --> InforProductsApiBatch.execute() --> Start');
        try
        {
            if(records != null)
            {            
                system.debug('Method --> InforProductsApiBatch.execute() --> Batch Records = ' + records.size());
                
                UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();
                updateDataFromInfor.UpdateInforProductsData(records, allProductsMap);
                
                system.debug('Method --> InforProductsApiBatch.execute() --> End');
            }
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }        
    }    
    
    public void finish(Database.BatchableContext bc){
        
        system.debug('Method --> InforProductsApiBatch.finish() --> Start');
        
        // execute any post-processing operations
        try
        {
            system.debug('Method --> InforProductsApiBatch.finish() --> Initialize Accounts Products fetching');
            
            /*DateTime now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(5);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            System.schedule('InforAccountProductsApiScheduler',cronString, new InforAccountProductsApiScheduler());*/
            System.scheduleBatch(new InforAccountProductsApiBatch(), 'InforAccountProductsApiBatch', 1);            
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        } 
        
        system.debug('Method --> InforProductsApiBatch.finish() --> End');
    }
    
}