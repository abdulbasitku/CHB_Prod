global class InforAccountsApiBatch implements Database.Batchable<InforAccount>, Database.AllowsCallouts, Database.Stateful{
    
    Integer offset = 0;
    Integer pageSize = 100000;
    boolean ignoreDate = false;
    integer timeRangeInMinutes = 40;
    
    Map<string,Account> allAccountsMapWithExternalId = new Map<string,Account>();
    Set<string> ignoreInforList = new Set<string>();
    
    void PopulateAccountsInforIdMap(List<InforAccount> inforAccounts){
        
        system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() --> Start');
        
        try{
            
            List<Account> listAccounts = new List<Account>();
            List<Account> listAccountsWithCommaExtId = new List<Account>();
            
            Set<string> listIds = new Set<string>();
            
            for(InforAccount inforAccount : inforAccounts)
            {
                if(inforAccount.accountId != null && string.isNotEmpty(inforAccount.accountId))
                {
                    listIds.Add(inforAccount.accountId);
                }
                
                if(inforAccount.parentAccountId != null && string.isNotEmpty(inforAccount.parentAccountId))
                {
                    listIds.Add(inforAccount.parentAccountId);
                }
            }
            
            system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() --> Account Ids = ' + listIds.size());
            
            listAccounts  = [SELECT Id, Name, Type, ParentId, Website, Phone, Infor_Customer_ID__c, BillingAddress, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                             BillingCountry,Number_of_Homes__c, External_ID__c, GP_Code__c FROM Account WHERE External_ID__c in :listIds];
            
            listAccountsWithCommaExtId  = [SELECT Id, Name, Type, ParentId, Website, Phone, Infor_Customer_ID__c, BillingAddress, BillingStreet, BillingCity, BillingState, BillingPostalCode,
                                           BillingCountry,Number_of_Homes__c, External_ID__c, GP_Code__c FROM Account WHERE External_ID__c  LIKE '%,%'];
            
            listAccounts.addAll(listAccountsWithCommaExtId);
            
            system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() --> Account SF = ' + listAccounts.size());
            
            for(Account account : listAccounts)
            {
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
                                if(isFirst){
                                    isFirst = false;                                    
                                    //system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() Comma - ' + extId + ' - ' + account.Name);
                                    allAccountsMapWithExternalId.put(extId, account);    
                                }
                                else
                                {           
                                    //system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() Ignore List -' + extId + ' - ' + account.Name);
                                    ignoreInforList.Add(extId);
                                }
                            }
                            
                        }
                    }
                    else
                    {
                        //system.debug('Method --> InforAccountsApiBatch.PopulateAccountsInforIdMap() - ' + account.External_ID__c + ' - ' + account.Name);
                        allAccountsMapWithExternalId.put(account.External_ID__c, account);
                    }
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
    
    public List<InforAccount> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        system.debug('Method --> InforAccountsApiBatch.start() --> Starts');
        
        List<InforAccount> allAccounts = new List<InforAccount>();
        
        try
        {   
            /*for ( AsyncApexJob aJob : [ Select id ,Status, ApexClass.Name from AsyncApexJob where ApexClass.Name = 'InforContactsApiScheduler'] )
            {
                System.AbortJob(aJob.Id);    
            }*/
            
            /*
             List<CronTrigger> jobsToAbort = [select Id from CronTrigger where CronJobDetail.JobType = '7'];
             for (CronTrigger job : jobsToAbort) { System.abortJob(job.Id); }
             */
            
            boolean continueJob = true;
            
            InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer();
            AccountsResponse data;
            if(System.Test.isRunningTest())
            {
                data = inforDataApiConsumer.GetInforAccountsHourlyDataMock();                
            }
            else
            {
                data = inforDataApiConsumer.GetInforAccountsHourlyData(timeRangeInMinutes);
            }
            
            if(data != null && data.responseCode == 200 && data.InforAccounts != null && data.InforAccounts.Size() > 0){
                
                system.debug('Method --> InforAccountsApiBatch.start --> Total Records = ' + data.InforAccounts.Size());
                
                allAccounts = data.InforAccounts;
                if(allAccounts != null && allAccounts.size() > 0)
                {
                    PopulateAccountsInforIdMap(allAccounts);
                }
            }
            else
            {
                system.debug('Method --> InforAccountsApiBatch.start --> Error in Response Data');
            }
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
        
        system.debug('Method --> InforAccountsApiBatch.start() --> End');
        return allAccounts;
    }
    
    public void execute(Database.BatchableContext bc, List<InforAccount> records){
        
        system.debug('Method --> InforAccountsApiBatch.execute() --> Start');
        try
        {
            if(records != null)
            {            
                system.debug('Method --> InforAccountsApiBatch.execute() --> Batch Records = ' + records.size());
                
                UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();
                /*if(records != null && records.size() > 0)
{
PopulateAccountsInforIdMap(records);
}*/
                updateDataFromInfor.UpdateInforAccountsData(records, allAccountsMapWithExternalId, ignoreInforList);
                
                system.debug('Method --> InforAccountsApiBatch.execute() --> End');
            }
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }        
    }    
    
    public void finish(Database.BatchableContext bc){
        
        system.debug('Method --> InforAccountsApiBatch.finish() --> Start');
        
        // execute any post-processing operations
        try
        {
            system.debug('Method --> InforAccountsApiBatch.finish() --> Initialize contacts fetching');
            
            /*DateTime now  = DateTime.now();
            DateTime nextRunTime = now.addMinutes(5);
            String cronString = '' + nextRunTime.second() + ' ' + nextRunTime.minute() + ' ' + nextRunTime.hour() + ' ' + nextRunTime.day() + ' ' + 
                nextRunTime.month() + ' ? ' + nextRunTime.year(); 
            System.schedule('InforContactsApiScheduler',cronString, new InforContactsApiScheduler());*/
            System.scheduleBatch(new InforContactsApiBatch(), 'InforContactsApiBatch', 1);
            
            
            //InforContactsApiBatch inforContactsApiBatch = new InforContactsApiBatch(); 
            //Id batchId = Database.executeBatch(inforContactsApiBatch);
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        } 
        
        system.debug('Method --> InforAccountsApiBatch.finish() --> End');
    }
    
}