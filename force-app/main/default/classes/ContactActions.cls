public without sharing class ContactActions {
    
    /*public static void CreateContactRelatedListObjectOnImport(List<Contact> newContact, Map<ID, Contact> newContactMap)
{

system.debug('Method --> CreateContactRelatedListObjectOnImport() --> Start');

List<Contact_Product__c> cps = new List<Contact_Product__c>();

try
{
List<Product2> products = [Select Id, Name from Product2];
Map<string,Product2> productMaps = new Map<string,Product2>();
for(Product2 prod : products)
{
if(!productMaps.containsKey(prod.Name.toLowerCase()))
{
productMaps.put(prod.Name.toLowerCase(), prod);
}
}


for(Contact contact : newContact){

if(string.isNotEmpty(contact.Contact_Division__c))
{
Contact_Product__c cp = new Contact_Product__c();
cp.Contact__c = contact.Id;
if(productMaps.containsKey(contact.Contact_Division__c.toLowerCase()))
{
cp.Product__c = productMaps.get(contact.Contact_Division__c.toLowerCase()).Id;                        
}
else
{                        
if(productMaps.containsKey('unknown'))
{
cp.Product__c = productMaps.get('unknown').Id;
}
}
cps.Add(cp);
}	
}

String cpsJsonString = json.serialize(cps);

InsertContactRelatedListObjectOnImport(cpsJsonString);   

}
catch(Exception e)
{
system.debug('Method --> CreateContactRelatedListObjectOnImport() --> Exception Occured');
system.debug(e);
}

system.debug('Method --> CreateContactRelatedListObjectOnImport() --> End');
}

@future
public static void InsertContactRelatedListObjectOnImport(String cpsJsonString)
{


System.debug('Method --> InsertContactRelatedListObjectOnImport() --> start');

List<Contact_Product__c> cps = (List<Contact_Product__c>)Json.deserialize(cpsJsonString, List<Contact_Product__c>.class);

//Printing the Lists
System.debug('Method --> InsertContactRelatedListObjectOnImport() --> After deserialize');

try
{                                
List<Database.SaveResult> contactProductInsertResult = Database.insert(cps, false);                
system.debug('Method --> InsertContactRelatedListObjectOnImport() --> Insert Result ContactProduct = ' + String.valueOf(contactProductInsertResult.size()));

}
catch(DmlException e)
{
system.debug('Method --> InsertContactRelatedListObjectOnImport() --> DML Exception Occured ContactProduct');
system.debug(e);
}         

system.debug('Method --> InsertContactRelatedListObjectOnImport() --> End');

}*/
    
    public static void UpdateOrCreateOpportunityOnMarketoSyncUpdate( List<Contact> newContacts, List<Contact> oldContacts, Map<ID, Contact> newContactMaps, Map<ID, Contact> oldContactMaps)
    {           
        
        List<Logger.Log> logsToCreate = new List<Logger.Log>();
        
        string className = 'ContactActions';
        string methodName = 'UpdateOrCreateOpportunityOnMarketoSyncUpdate';
        
        Logger.Information info;
        Logger.ExceptionError exError;
        
        info = new Logger.Information(className, methodName, '-' , 'Contacts Updated From Triggered: ' + newContacts.size() , '-', DateTime.now());
        logsToCreate.add(info);
        
        try
        {
            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Start');
            
            info = new Logger.Information(className, methodName, '-', 'Method Starts', '-', DateTime.now());
            logsToCreate.add(info);
            
            String userName = UserInfo.getUserName();
            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Username = ' + userName);
            
            info = new Logger.Information(className, methodName, '-', 'Username = ' + userName, '-', DateTime.now());
            logsToCreate.add(info);
            
            if(LeadActions.isExecuting)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> LeadConversion Executing - So Return');
                info = new Logger.Information(className, methodName, '-', 'LeadConversion Executing - So Return', '-', DateTime.now());
                logsToCreate.add(info);
                
                new Logger().createLogs(logsToCreate);
                return;
            }
            
            if(System.Test.isRunningTest())
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Testcases are running');
                info = new Logger.Information(className, methodName, '-', 'Testcases are running', '-', DateTime.now());
                logsToCreate.add(info);
            }
            else
            {
                if(DataFactory.runningInASandbox)
                {
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Is in Sandbox');
                    info = new Logger.Information(className, methodName, '-', 'Is in Sandbox', '-', DateTime.now());
                    logsToCreate.add(info);
                }        
                else
                {
                    if(userName != 'marketo-salesforce@constellationhb.com')               
                    {
                        //if(userName != 'abdul.aziz@constellationhb.com')
                        //{
                            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> End - Update is not from Marketo');
                            info = new Logger.Information(className, methodName, '-', 'Method Ends - Update is not from Marketo', '-', DateTime.now());
                            logsToCreate.add(info);
                            new Logger().createLogs(logsToCreate);
                            return;
                        //}
                    }
                }
            }
            
            Map<ID,Contact> prodUpdatedContact = new Map<ID,Contact>();
            
            Set<string> productNames = new Set<string>();
            
            Set<ID> accountIds = new Set<ID>();        
            Set<Id> productIds =  new Set<Id>();     
            Set<Id> contactIds =  new Set<Id>();
            Set<Id> linkClickContactIds =  new Set<Id>();
            
            //Map<ID, List<Opportunity>> acctOppMaps  =   new Map<ID, List<Opportunity>>();
            Map<ID, List<Opportunity>> contactOppMaps  =   new Map<ID, List<Opportunity>>();
            
            Map<string, Contact_Product__c> contactProdMaps  =   new Map<string, Contact_Product__c>();
            Map<string, Account_Product__c> accountProdMaps  =   new Map<string, Account_Product__c>();
            Map<string, User> userMaps = new Map<string, User>();
            
            Map<string, Product2> productMaps =   new Map<string, Product2>();            
            Map<ID, Account> accountMaps  =   new Map<ID, Account>();
            
            Set<Opportunity> allOppsForInsert = new Set<Opportunity>();
            Set<Opportunity> allOppsForUpdate = new Set<Opportunity>();
            
            Set<Contact_Product__c> allContactProductsForInsert = new Set<Contact_Product__c>(); 
            Set<Account_Product__c> allAccountProductsForInsert = new Set<Account_Product__c>();        
            
            Set<Id> contactOppsIds =  new Set<Id>();
            Set<Id> insertedOppIds =  new Set<Id>();
            
            Set<OpportunityLineItem> allOppLineItemsForInsert = new Set<OpportunityLineItem>();
            
            for(Contact contact : newContacts)
            {
                if(contact.Marketo_Change_Trigger_Reason__c != 'Submission of Form')
                {                        
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Contact Change Trigger Not From Submission of Form');
                    linkClickContactIds.Add(contact.Id);
                    info = new Logger.Information(className, methodName, contact.Id, 'Contact Change Trigger Not From Submission of Form', 'Contact', DateTime.now());
                    logsToCreate.add(info);
                }
                else
                {
                    if(!prodUpdatedContact.containsKey(contact.Id))
                    {
                        if(IsChangeFromMarketo(oldContactMaps.get(contact.Id), contact, logsToCreate))
                        {
                            
                            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Contact Changed From Marketok');
                            info = new Logger.Information(className, methodName, contact.Id, 'Contact Changed From Marketo', 'Contact', DateTime.now());
                            logsToCreate.add(info);
                            
                            prodUpdatedContact.put(contact.Id, contact);
                            accountIds.Add(contact.AccountId);
                            contactIds.Add(contact.Id);
                            string product = contact.Marketing_Product_Text__c;
                            if(string.isNotEmpty(product))
                            {
                                productNames.Add(product.trim().toLowerCase());    
                            }                         
                        }
                    }
                }
            }
            if(prodUpdatedContact.size() < 1)
            {
                info = new Logger.Information(className, methodName, '-', 'No Changes From Marketo', '-', DateTime.now());
                logsToCreate.add(info);
                new Logger().createLogs(logsToCreate);
                
                try
                {
                    if(linkClickContactIds.size() > 0)
                    {
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Emptying Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()));
                    info = new Logger.Information(className, methodName, '-' , 'Emptying Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                    
                    UpdateContactMarketoReasonField(newContactMaps.keySet(), linkClickContactIds);
                    
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Emptied Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()));
                    info = new Logger.Information(className, methodName, '-' , 'Emptied Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                    }
                }
                Catch(Exception e)
                {
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Emptying Contact Previous Data Exception Occured');
                    system.debug(e);
                    exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                    logsToCreate.add(exError);
                }
                
                return;
            }
            
            List<Account> listAccounts  = [SELECT Id, Name, Type FROM Account WHERE Id in :accountIds];
            
            List<Account_Product__c> listAccountProducts  = [SELECT Id, Account__c, Product__c FROM Account_Product__c WHERE Account__r.Id in :accountIds];
            List<Contact_Product__c> listContactProducts  = [SELECT Id, Contact__c, Product__c FROM Contact_Product__c WHERE Contact__r.Id in :contactIds];
            
            List<OpportunityContactRole> oppContactList  = [SELECT Id, OpportunityId, ContactId FROM OpportunityContactRole WHERE ContactId in :contactIds];
            
            for(OpportunityContactRole oppContRole : oppContactList)
            {
                contactOppsIds.Add(oppContRole.OpportunityId);
            }
            
            Map<Id, Opportunity> oppMaps  = new Map<Id,Opportunity>([SELECT Id, Name, Type, Description, AccountId, StageName, Pricebook2Id, First_Source__c, First_Specific_Source__c, Last_Source__c, Last_Specific_Source__c, Product_Family__c, Product_Family__r.Name, OwnerID, Owner.Name, (SELECT Product2.Name FROM OpportunityLineItems) FROM Opportunity WHERE Id in :contactOppsIds]);
            List<Opportunity> oppList = oppMaps.values();
            
            List<User> users = [SELECT Id, Name FROM User];
            
            for (User us : users)
            {
                if(!userMaps.containsKey(us.Name))
                {
                    userMaps.put(us.Name, us);
                }
            }
            
            for(Account account : listAccounts)
            {
                string accountId = account.Id;
                accountMaps.put(accountId,account);            
            }
            
            for(Account_Product__c accountProduct : listAccountProducts)
            {
                string accountId = accountProduct.Account__c;
                string productId = accountProduct.Product__c;
                accountProdMaps.put(accountId + '-' + productId, accountProduct);            
            }
            
            for(Contact_Product__c contactProduct : listContactProducts)
            {
                string contactId = contactProduct.Contact__c;
                string productId = contactProduct.Product__c;
                contactProdMaps.put(contactId + '-' + productId, contactProduct);            
            }
            
            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Existing Opportunities = ' + String.valueOf(oppList.size()));
            info = new Logger.Information(className, methodName, '-', 'Existing Opportunities = ' + String.valueOf(oppList.size()), '-', DateTime.now());
            logsToCreate.add(info);
            
            for(OpportunityContactRole oppContRole : oppContactList)
            {
                List<Opportunity> contactOpps = new List<Opportunity>();
                string contactId = oppContRole.ContactId;
                
                Opportunity opp = oppMaps.get(oppContRole.OpportunityId);
                
                if(string.isNotEmpty(contactId))
                {                
                    if(contactOppMaps.containsKey(contactId)){
                        
                        contactOpps = contactOppMaps.get(contactId);
                        if(!contactOpps.contains(opp))
                        {
                            contactOpps.Add(opp);                    
                            contactOppMaps.put(contactId,contactOpps);
                        }
                        
                    }
                    else
                    {
                        contactOpps.Add(opp);
                        contactOppMaps.put(contactId,contactOpps);
                    }
                }
            }
            
            Id priceBookId;
            
            if(Test.isRunningTest())
            {
                priceBookId = Test.getStandardPricebookId();
            }
            else
            {
                Pricebook2 priceBook = DataFactory.getStandardPriceBook();                
                priceBookId = priceBook.Id;
            }
            
            productNames.Add('unknown');
            List<Product2> listProducts  = [SELECT Id, Name, Product_Family__c FROM Product2 WHERE Name in :productNames];
            
            
            for(Product2 product : listProducts)
            {
                string productId = product.Id;
                string productName = product.Name;
                if(string.isNotEmpty(productName))
                {
                    productMaps.put(productName.toLowerCase(),product);
                    productIds.add(productId);
                }
            }
            
            List<PriceBookEntry> allProdPriceBookEntries = [SELECT Product2.Id, UnitPrice, PriceBook2Id FROM PriceBookEntry Where Product2.Id IN :productIds];
            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Product Price Book Entries Found = ' + String.valueOf(allProdPriceBookEntries.size()));
            info = new Logger.Information(className, methodName, '-', 'Product Price Book Entries Found = ' + String.valueOf(allProdPriceBookEntries.size()), '-', DateTime.now());
            logsToCreate.add(info);
            
            Map<Id,PricebookEntry> allProdPriceBookEntMaps = new Map<Id,PricebookEntry>();
            
            //PriceBookEntry for products- Generating Maps
            for(PriceBookEntry prodPriceBookEnt : allProdPriceBookEntries)
            {
                if(prodPriceBookEnt != null && prodPriceBookEnt.Pricebook2Id == priceBookId)
                {
                    Id prodId = prodPriceBookEnt.Product2Id;                
                    allProdPriceBookEntMaps.put(prodId,prodPriceBookEnt);                
                }
            }
            
            Date closeDate = [Select EndDate From Period Where type = 'Quarter' and StartDate = THIS_FISCAL_QUARTER].EndDate;
            
            for(Id contactId : prodUpdatedContact.keySet())
            {
                Contact contact = prodUpdatedContact.get(contactId);
                Contact oldContact = oldContactMaps.get(contact.Id);
                
                List<Opportunity> contactOpps = contactOppMaps.get(contactId);
                
                boolean createNewOpp = true;
                
                if(contactOpps != null && contactOpps.size() > 0)
                {
                    for(Opportunity contactOpp : contactOpps)
                    {                            
                        if(IsOpportunityOpenAndProductExistsInLineItem(contact, contactOpp))
                        {
                            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Criteria Match with Opportunity - Found');
                            
                            info = new Logger.Information(className, methodName, contactOpp.Id, 'Criteria Match with Opportunity - Found', 'Opportunity', DateTime.now());
                            logsToCreate.add(info);
                            
                            createNewOpp = false;
                            
                            if(contact.Last_Source__c != oldContact.Last_Source__c){
                                contactOpp.Last_Source__c = contact.Last_Source__c;
                            }
                            
                            if(contact.Last_Specific_Source__c != oldContact.Last_Specific_Source__c){
                                contactOpp.Last_Specific_Source__c = contact.Last_Specific_Source__c;
                            }
                            contactOpp.Last_Updated_From_Contact__c = contact.Id;
                            
                            info = new Logger.Information(className, methodName, contactOpp.Id , 'Existing Opportunity - Last & Last Specific Source', 'Opportunity', DateTime.now());
                            logsToCreate.add(info);
                            
                            allOppsForUpdate.Add(contactOpp);       
                            
                        }
                    }
                }
                
                if(createNewOpp)
                {
                    info = new Logger.Information(className, methodName, '-' , 'New Opportunity - Product, First,Last & First,Last Specific Source, ContactRole', 'Opportunity', DateTime.now());
                    logsToCreate.add(info);
                    
                    Opportunity newOpp = new Opportunity();
                    newOpp.StageName = 'Unqualified';
                    newOpp.CloseDate = closeDate;
                    newOpp.First_Source__c = contact.Last_Source__c;
                    newOpp.First_Specific_Source__c = contact.Last_Specific_Source__c;
                    newOpp.Last_Source__c = contact.Last_Source__c;
                    newOpp.Last_Specific_Source__c = contact.Last_Specific_Source__c;
                    newOpp.Pricebook2Id = priceBookId;
                    newOpp.Marketing_Product_Text__c = contact.Marketing_Product_Text__c;
                    newOpp.AccountId = contact.AccountId;
                    newOpp.ContactId = contact.Id;
                    newOpp.Contact_Role__c = contact.Id;
                    newOpp.Last_Updated_From_Contact__c = contact.Id;
                    
                    if(userMaps.containsKey('Marco Caracciolo'))
                    {
                        newOpp.OwnerID = userMaps.get('Marco Caracciolo').Id;
                    }
                    
                    Account acct = accountMaps.get(contact.AccountId);
                    if(acct != null)
                    {
                        if(acct.Type == 'Prospect'){
                            newOpp.Type = 'New Business';                                        
                        }
                        if(acct.Type == 'Customer'){
                            newOpp.Type = 'Existing Business - Existing Product';                                        
                        }
                        if(acct.Type == 'Former Customer' || acct.Type == 'Dormant'){
                            newOpp.Type = 'Existing Business - New Product';                                        
                        }
                    }
                    
                    string contactProductName = contact.Marketing_Product_Text__c;
                    if(string.IsEmpty(contactProductName))
                    {
                        contactProductName = 'unknown';
                    }
                    Product2 prod = productMaps.get(contactProductName.trim().toLowerCase());
                    
                    if(prod != null)
                    {
                        contactProductName = prod.Name;
                        newOpp.Marketing_Product_Text__c = prod.Name;
                        newOpp.Product_Family__c = prod.Product_Family__c;
                        
                        string cpKey = contact.Id + '-' + prod.Id;
                        if(!contactProdMaps.containsKey(cpKey))
                        {
                            Contact_Product__c contProd = new Contact_Product__c();
                            contProd.Contact__c = contact.Id;
                            contProd.Product__c = prod.Id;
                            
                            
                            allContactProductsForInsert.add(contProd);
                        }
                        
                        string apKey = contact.AccountId + '-' + prod.Id;
                        if(!accountProdMaps.containsKey(apKey))
                        {
                            Account_Product__c accountProd = new Account_Product__c();
                            accountProd.Account__c = contact.AccountId;
                            accountProd.Product__c = prod.Id;
                            accountProd.Account_Type__c = 'Prospect';
                            
                            allAccountProductsForInsert.add(accountProd);
                        }
                    }
                    
                    newOpp.Name = accountMaps.get(contact.AccountId).Name + ' - ' + contactProductName;
                    allOppsForInsert.add(newOpp);
                }
                createNewOpp = true;
                
            }
            
            try
            {
                if(linkClickContactIds.size() > 0)
                {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Emptying Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()));
                info = new Logger.Information(className, methodName, '-' , 'Emptying Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()), '-', DateTime.now());
                logsToCreate.add(info);
                UpdateContactMarketoReasonField(newContactMaps.keySet(), linkClickContactIds);
                
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Emptied Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()));
                info = new Logger.Information(className, methodName, '-' , 'Emptied Contact Previous Data [Future] = ' + String.valueOf(newContacts.size()), '-', DateTime.now());
                logsToCreate.add(info);
                }
                
            }
            Catch(Exception e)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Emptying Contact Previous Data Exception Occured');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            try
            {            
                //Updating Existing Opportunities
                if(allOppsForUpdate.size() > 0){
                    List<Database.SaveResult> oppForUpdateResults = Database.update( new List<Opportunity>(allOppsForUpdate));
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Updating Existing Opportunities = ' + String.valueOf(oppForUpdateResults.size()));
                    
                    info = new Logger.Information(className, methodName, '-' , 'Updating Existing Opportunities = ' + String.valueOf(oppForUpdateResults.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            catch(DmlException e)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Updating Existing Opportunities -DML Exception Occured');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            try
            {            
                //Creating new ContactProduct
                if(allContactProductsForInsert.size() > 0){
                    List<Database.SaveResult> contProdResults = Database.insert( new List<Contact_Product__c>(allContactProductsForInsert));
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Contact_Product Inserted = ' + String.valueOf(contProdResults.size()));
                    
                    info = new Logger.Information(className, methodName, '-' , 'Contact_Product Inserted = ' + String.valueOf(contProdResults.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            catch(DmlException e)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Contact_Product Insertion - DML Exception Occured');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            try
            {            
                //Creating new AccountProduct
                if(allAccountProductsForInsert.size() > 0){
                    List<Database.SaveResult> acctProdResults = Database.insert( new List<Account_Product__c>(allAccountProductsForInsert));
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Account_Product Inserted = ' + String.valueOf(acctProdResults.size()));
                    
                    info = new Logger.Information(className, methodName, '-' , 'Account_Product Inserted = ' + String.valueOf(acctProdResults.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            catch(DmlException e)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Contact_Product Insertion - DML Exception Occured');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            List<Database.SaveResult> oppResults = new List<Database.SaveResult>();
            
            try
            {            
                //Creating new Opportunities
                if(allOppsForInsert.size() > 0){
                    oppResults = Database.insert( new List<Opportunity>(allOppsForInsert));
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> New Opportunities Inserted = ' + String.valueOf(oppResults.size()));
                    
                    info = new Logger.Information(className, methodName, '-' , 'New Opportunities Inserted = ' + String.valueOf(oppResults.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            catch(DmlException e)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Opportunities DML Exception Occured post conversion DML');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            for (Database.SaveResult oppResult : oppResults) {
                if (oppResult.isSuccess()) {
                    
                    info = new Logger.Information(className, methodName, oppResult.getId() , 'New Opportunity Inserted Successfully', 'Opportunity', DateTime.now());
                    logsToCreate.add(info);
                    
                    insertedOppIds.add(oppResult.getId());
                }
            }
            
            List<Opportunity> insertedOpps = [SELECT Id, Name, Marketing_Product_Text__c FROM Opportunity WHERE Id IN :insertedOppIds];
            
            info = new Logger.Information(className, methodName, '-' , 'New Opportunities Inserted Successfully = ' + String.valueOf(insertedOpps.size()), '-', DateTime.now());
            logsToCreate.add(info);
            
            //Setting Opp Id for OppLineItem
            for(Opportunity insertedOpp : insertedOpps)
            {
                string oppProductName = insertedOpp.Marketing_Product_Text__c;
                if(string.IsEmpty(oppProductName))
                {
                    oppProductName = 'unknown';
                }
                Product2 prod = productMaps.get(oppProductName.trim().toLowerCase());
                
                if(prod != null)
                {                    
                    PricebookEntry prodPriceBookEntry = allProdPriceBookEntMaps.get(prod.Id);
                    
                    OpportunityLineItem oppLineItem = new OpportunityLineItem();
                    
                    oppLineItem.OpportunityId = insertedOpp.Id;
                    oppLineItem.Product2Id = prod.Id;
                    oppLineItem.Quantity = 1;
                    if(prodPriceBookEntry != null)
                    {
                        info = new Logger.Information(className, methodName, '-' , 'New Opportunity line Item Added', 'OpportunityLineItem', DateTime.now());
                        logsToCreate.add(info);
                        
                        oppLineItem.UnitPrice = prodPriceBookEntry.UnitPrice;
                        allOppLineItemsForInsert.Add(oppLineItem);
                    }
                    else
                    {
                        system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> PricebookEntry not found for ' + insertedOpp.Marketing_Product_Text__c);
                        
                        info = new Logger.Information(className, methodName, '-' , 'PricebookEntry not found for ' + insertedOpp.Marketing_Product_Text__c, '-', DateTime.now());
                        logsToCreate.add(info);
                    }
                }
            }
            
            try
            {            
                //Creating new Opportunity line items
                if(allOppLineItemsForInsert.size() > 0){
                    List<Database.SaveResult> oppLineItemResults = Database.insert(new List<OpportunityLineItem>(allOppLineItemsForInsert));
                    system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> OpportunityLineItem Inserted = ' + String.valueOf(oppLineItemResults.size()));
                    
                    info = new Logger.Information(className, methodName, '-' , 'OpportunityLineItem Inserted = ' + String.valueOf(oppLineItemResults.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            catch(DmlException e)
            {
                system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> OpportunityLineItem DML Exception Occured post conversion DML');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            info = new Logger.Information(className, methodName, '-' , 'Method Ends', '-', DateTime.now());
            logsToCreate.add(info);
            
            new Logger().createLogs(logsToCreate);
        }
        catch(Exception e)
        {
            system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> Exception Occured');
            system.debug(e);
            
            exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
            logsToCreate.add(exError);
            info = new Logger.Information(className, methodName, '-' , 'Method Ends with Exception', '-', DateTime.now());
            logsToCreate.add(info);
            
            new Logger().createLogs(logsToCreate);            
        }
        
        system.debug('Method --> UpdateOrCreateOpportunityOnMarketoSyncUpdate() --> End');
    }
    
    private static boolean IsOpportunityOpenAndProductExistsInLineItem(Contact contact, Opportunity opp)
    {
        system.debug('Method --> IsOpportunityOpenAndProductExistsInLineItem() --> Start');
        
        boolean IsExists = false;
        string contactProductName = contact.Marketing_Product_Text__c;
        if(string.isEmpty(contactProductName))
        {
            contactProductName = 'unknown';
        }
        
        for(OpportunityLineItem oppLineItem :  opp.OpportunityLineItems)
        {            
            if(oppLineItem.Product2.Name.trim().toLowerCase() == contactProductName.trim().toLowerCase())
            {
                if(opp.First_Source__c == contact.First_Source__c && (opp.StageName == 'Unqualified' || opp.StageName == 'Marketing Qualified' 
                                                                      || opp.StageName == 'In Process' || opp.StageName == 'Demo' 
                                                                      || opp.StageName == 'Confirmed - SQL' || opp.StageName == 'Proposal - Submitted'))
                {
                    system.debug('Method --> IsOpportunityOpenAndProductExistsInLineItem() --> Exists');
                    return true;
                }
            }
            
        }
        
        system.debug('Method --> IsOpportunityOpenAndProductExistsInLineItem() --> End');
        return IsExists;
    }
    
    private static boolean IsChangeFromMarketo(Contact oldContact, Contact newContact, List<Logger.Log> logsToCreate)
    {
        boolean isChange = false;
        
        string className = 'ContactActions';
        string methodName = 'IsChangeFromMarketo';
        
        Logger.Information info;
        Logger.ExceptionError exError;
        
        try{
            
            if(string.isEmpty(oldContact.Marketing_Product_Text__c) && string.isEmpty(newContact.Marketing_Product_Text__c))
            {
                if(string.isEmpty(oldContact.First_Source__c) && string.isNotEmpty(newContact.First_Source__c))
                {
                    isChange = true;
                    return isChange;
                }
                if(string.isEmpty(oldContact.mkto71_Acquisition_Program__c) && string.isNotEmpty(newContact.mkto71_Acquisition_Program__c))
                {
                    isChange = true;
                    return isChange;
                }
                
                if(string.isEmpty(oldContact.Last_Source__c) && string.isNotEmpty(newContact.Last_Source__c))
                {
                    isChange = true;
                    return isChange;
                }
                if(string.isNotEmpty(oldContact.Last_Source__c) && string.isNotEmpty(newContact.Last_Source__c) && oldContact.Last_Source__c.trim().toLowerCase() != newContact.Last_Source__c.trim().toLowerCase())
                {                
                    isChange = true;
                    return isChange;
                }
                
                if(string.isEmpty(oldContact.Last_Specific_Source__c) && string.isNotEmpty(newContact.Last_Specific_Source__c))
                {
                    isChange = true;
                    return isChange;
                }
                if(string.isNotEmpty(oldContact.Last_Specific_Source__c) && string.isNotEmpty(newContact.Last_Specific_Source__c) && oldContact.Last_Specific_Source__c.trim().toLowerCase() != newContact.Last_Specific_Source__c.trim().toLowerCase())
                {                
                    isChange = true;
                    return isChange;
                }        
            }
            
            if(string.isEmpty(oldContact.Marketing_Product_Text__c) && string.isNotEmpty(newContact.Marketing_Product_Text__c) )
            {
                isChange = true;
                return isChange;
            }
            
            if(string.isEmpty(newContact.Marketing_Product_Text__c) && string.isNotEmpty(oldContact.Marketing_Product_Text__c) )
            {
                isChange = true;
                return isChange;
            }
            
            if(string.isNotEmpty(oldContact.Marketing_Product_Text__c) && string.isNotEmpty(newContact.Marketing_Product_Text__c) && oldContact.Marketing_Product_Text__c.trim().toLowerCase() != newContact.Marketing_Product_Text__c.trim().toLowerCase())
            {
                isChange = true;
                return isChange;
            }
            
            if(string.isNotEmpty(oldContact.Marketing_Product_Text__c) && string.isNotEmpty(newContact.Marketing_Product_Text__c) && oldContact.Marketing_Product_Text__c.trim().toLowerCase() == newContact.Marketing_Product_Text__c.trim().toLowerCase())
            {
                if(string.isEmpty(oldContact.First_Source__c) && string.isNotEmpty(newContact.First_Source__c))
                {
                    isChange = true;
                    return isChange;
                }
                if(string.isEmpty(oldContact.mkto71_Acquisition_Program__c) && string.isNotEmpty(newContact.mkto71_Acquisition_Program__c))
                {
                    isChange = true;
                    return isChange;
                }
                
                if(string.isEmpty(oldContact.Last_Source__c) && string.isNotEmpty(newContact.Last_Source__c))
                {
                    isChange = true;
                    return isChange;
                }
                if(oldContact.Last_Source__c.trim().toLowerCase() != newContact.Last_Source__c.trim().toLowerCase())
                {                
                    isChange = true;
                    return isChange;
                }
                
                if(string.isEmpty(oldContact.Last_Specific_Source__c) && string.isNotEmpty(newContact.Last_Specific_Source__c))
                {
                    isChange = true;
                    return isChange;
                }
                if(oldContact.Last_Specific_Source__c.trim().toLowerCase() != newContact.Last_Specific_Source__c.trim().toLowerCase())
                {                
                    isChange = true;
                    return isChange;
                }
            }
            
            if(newContact.mkto_si__Last_Interesting_Moment_Date__c != null)
            {
                if((oldContact.mkto_si__Last_Interesting_Moment_Date__c == null && newContact.mkto_si__Last_Interesting_Moment_Date__c != null) || 
                   (oldContact.mkto_si__Last_Interesting_Moment_Date__c < newContact.mkto_si__Last_Interesting_Moment_Date__c))
                {
                    isChange = true;
                    return isChange;
                }
            }
        }
        catch(Exception e)
        {
            system.debug('Method --> IsChangeFromMarketo() --> Exception Occured');
            system.debug(e);
            
            exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
            logsToCreate.add(exError);
            info = new Logger.Information(className, methodName, newContact.Id , 'Method Ends with Exception', 'Contact', DateTime.now());
            logsToCreate.add(info);       
        }
        
        return isChange;
    }
    
    @future
    private static void UpdateContactMarketoReasonField(Set<Id> contactIds, Set<Id> linkClickContactIds)
    {
        
        system.debug('Method --> UpdateContactMarketoReasonField() --> Start');
        
        List<Contact> contacts = [Select id, Marketo_Change_Trigger_Reason__c, Marketing_Product_Text__c from Contact where Id in :contactIds];
        
        for(Contact ct : contacts)
        {
            if(ct.Marketo_Change_Trigger_Reason__c != 'Submission of Form' && linkClickContactIds.contains(ct.Id))
            {
                ct.Marketing_Product_Text__c = '';
            }
            ct.Marketo_Change_Trigger_Reason__c = 'None';
        }
        
        try
        {            
            if(contacts.size() > 0){
                List<Database.SaveResult> contactResults = Database.update(new List<Contact>(contacts));
                system.debug('Method --> UpdateContactMarketoReasonField() --> Contact Updated = ' + String.valueOf(contactResults.size()));                                  }
        }
        catch(DmlException e)
        {
            system.debug('Method --> UpdateContactMarketoReasonField() --> Contact DML Exception Occured');
            system.debug(e);
        }
        
        system.debug('Method --> UpdateContactMarketoReasonField() --> End');
        
    }
}