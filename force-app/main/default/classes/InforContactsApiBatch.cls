global class InforContactsApiBatch implements Database.Batchable<InforContact>,Database.AllowsCallouts, Database.Stateful{
    
    Integer offset = 0;
    Integer pageSize = 100000;
    boolean ignoreDate = false;
    integer timeRangeInMinutes = 60;
    boolean filterInternalContactByEmail = true;
    
    Map<string,Account> allAccountsMap = new Map<string,Account>();
    Map<string,Contact> allContactsMap = new Map<string,Contact>();
    Map<string,Contact> allContactsMapWithExternalId = new Map<string,Contact>();
    
    void PopulateAccountsAndContactsMaps(List<InforContact> inforContacts){
        
        system.debug('Method --> InforContactsApiBatch.PopulateAccountsAndContactsMaps() --> Start');
        //Map<string,Account> accountsMap = new Map<string,Account>();
        
        try{
            
            List<Account> listAccounts = new List<Account>();
            List<Contact> listContacts = new List<Contact>();
            List<string> listIds = new List<string>();
            
            for(InforContact inforContact : inforContacts)
            {                
                if(inforContact.accountId != null && string.isNotEmpty(inforContact.accountId))
                {
                    listIds.Add(inforContact.accountId);
                }
            }
            
            system.debug('Method --> InforContactsApiBatch.PopulateAccountsAndContactsMaps() --> Related Account Ids = ' + listIds.size());
            
            listAccounts  = [SELECT Id, Name, External_ID__c FROM Account WHERE External_ID__c in :listIds];            
            listAccounts.AddAll([SELECT Id, Name, External_ID__c FROM Account where External_ID__c like '%,%']); 
            listContacts  = [SELECT Id, Name, FirstName, LastName, Email, External_ID__c, Business_Function__c, Title, Fax, Phone, MobilePhone, MailingStreet, MailingCity,
                             		MailingState, MailingPostalCode, MailingCountry, HasOptedOutOfEmail,No_Longer_There__c FROM Contact WHERE External_ID__c = ''];
            
            system.debug('Method --> InforContactsApiBatch.GetAccountsMap() --> Related Account SF = ' + listAccounts.size());
            
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
            
            for(Contact contact : listContacts)
            {
                allContactsMap.put(contact.FirstName + '|' + contact.LastName + '|' + contact.Email, contact);
            }
            
            listContacts  = [SELECT Id, Name, FirstName, LastName, Email, External_ID__c, Business_Function__c, Title, Fax, Phone, MobilePhone, MailingStreet, MailingCity,
                             		MailingState, MailingPostalCode, MailingCountry,HasOptedOutOfEmail FROM Contact WHERE External_ID__c != ''];
            
            for(Contact contact : listContacts)
            {
                allContactsMapWithExternalId.put(contact.External_ID__c, contact);
            }
            
            system.debug('Method --> InforContactsApiBatch.PopulateAccountsAndContactsMaps() --> Contacts without EID = ' + allContactsMap.size());
            
            system.debug('Method --> InforContactsApiBatch.PopulateAccountsAndContactsMaps() --> Contact with EID = ' + allContactsMapWithExternalId.size());
        }
        catch(Exception e)
        {
            system.debug('Method --> InforContactsApiBatch.GetAccountsMap() --> Exception Occured');
            system.debug(e);
        }
        system.debug('Method --> InforContactsApiBatch.GetAccountsMap() --> End');
        //return accountsMap;
    }
    
    public List<InforContact> start(Database.BatchableContext bc) {
        // collect the batches of records or objects to be passed to execute
        
        system.debug('Method --> InforContactsApiBatch.start() --> Starts');
        
        List<InforContact> allContacts = new List<InforContact>();
        
        try
        {   
            boolean continueJob = true;
            
            InforDataApiConsumer inforDataApiConsumer = new InforDataApiConsumer();
            ContactsResponse data;
            if(System.Test.isRunningTest())
            {
                data = inforDataApiConsumer.GetInforContactsHourlyDataMock();                
            }
            else
            {
                data = inforDataApiConsumer.GetInforContactsHourlyData(timeRangeInMinutes, filterInternalContactByEmail);
            }
            //ContactsResponse data = inforDataApiConsumer.GetInforContactsData(offset, pageSize, true, filterInternalContactByEmail);
            
            if(data != null && data.responseCode == 200 && data.InforContacts != null && data.InforContacts.Size() > 0){
                
                system.debug('Method --> InforContactsApiBatch.start --> Total Records = ' + data.InforContacts.Size());
                
                allContacts = data.InforContacts;
                if(allContacts != null && allContacts.size() > 0)
                {
                    PopulateAccountsAndContactsMaps(data.InforContacts);
                }
            }
            else
            {
                system.debug('Method --> InforContactsApiBatch.start --> Error in Response Data');
            }
        } 
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }
        
        system.debug('Method --> InforContactsApiBatch.start() --> End');
        return allContacts;
    }
    
    public void execute(Database.BatchableContext bc, List<InforContact> records){
        
        system.debug('Method --> InforContactsApiBatch.execute() --> Start');
        try
        {
            if(records != null)
            {            
                system.debug('Method --> InforContactsApiBatch.execute() --> Batch Records = ' + records.size());
                
                UpdateDataFromInfor updateDataFromInfor = new UpdateDataFromInfor();
                /*if(records != null && records.size() > 0)
                {
                    PopulateAccountsAndContactsMaps(records);
                }*/
                updateDataFromInfor.UpdateInforContactsData(records, allAccountsMap, allContactsMap, allContactsMapWithExternalId);
                
                system.debug('Method --> InforContactsApiBatch.execute() --> End');
            }
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
        }        
    }    
    
    public void finish(Database.BatchableContext bc){
        
        system.debug('Method --> InforContactsApiBatch.finish() --> Start');
        
        // execute any post-processing operations
        try
        {
            //System.scheduleBatch(new InforProductsApiBatch(), 'InforProductsApiBatch', 1);
            System.scheduleBatch(new InforAccountsApiBatch(), 'InforAccountsApiBatch', 30);
        }
        catch (Exception e) 
        {
            System.debug(e.getMessage());
            System.scheduleBatch(new InforAccountsApiBatch(), 'InforAccountsApiBatch', 30);
        } 
        
        system.debug('Method --> InforContactsApiBatch.finish() --> End');
    }
    
}