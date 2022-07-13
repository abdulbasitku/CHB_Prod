public without sharing class LeadActions {
    
    public static boolean isExecuting = false;
    
    public static void ConvertLeadAutomation(List<Lead> newLead, Map<ID, Lead> newLeadMap)
    {
        try
        {            
            system.debug('Method --> ConvertLeadAutomation() --> Start');
            
            List<Logger.Log> logsToCreate = new List<Logger.Log>();
            
            string className = 'LeadActions';
            string methodName = 'ConvertLeadAutomation';
            
            Logger.Information info;
            Logger.ExceptionError exError;
            
            info = new Logger.Information(className, methodName, '-', 'Method Starts', 'Lead', DateTime.now());
            logsToCreate.add(info);
            
            String userName = UserInfo.getUserName();
            system.debug('Method --> ConvertLeadAutomation() --> Username = ' + userName);
            
            info = new Logger.Information(className, methodName, '-', 'Username = ' + userName, 'Lead', DateTime.now());
            logsToCreate.add(info);
            
            
            if(System.Test.isRunningTest())
            {
                system.debug('Method --> ConvertLeadAutomation() --> Testcases are running');
                info = new Logger.Information(className, methodName, '-', 'Testcases are running', 'Lead', DateTime.now());
                logsToCreate.add(info);
            }
            else
            {
                if(DataFactory.runningInASandbox)
                {
                    system.debug('Method --> ConvertLeadAutomation() --> Is in Sandbox');
                    info = new Logger.Information(className, methodName, '-', 'Is in Sandbox', 'Lead', DateTime.now());
                    logsToCreate.add(info);
                }        
                else
                {
                    if(userName != 'marketo-salesforce@constellationhb.com')               
                    {
                        //if(userName != 'abdul.aziz@constellationhb.com')
                        //{
                            system.debug('Method --> ConvertLeadAutomation() --> End - Update is not from Marketo');
                            info = new Logger.Information(className, methodName, '-', 'Method Ends - Update is not from Marketo', 'Lead', DateTime.now());
                            logsToCreate.add(info);
                            new Logger().createLogs(logsToCreate);
                            return;
                        //}
                    }
                }
            }
            
            
            
            isExecuting = true;
            system.debug('Method --> ConvertLeadAutomation() --> New Leads = ' + String.valueOf(newLead.size()));
            info = new Logger.Information(className, methodName, '-', 'New Leads = ' + String.valueOf(newLead.size()), 'Lead', DateTime.now());
            logsToCreate.add(info);
            
            Set<string> emails = new Set<string>(); 
            Set<string> companyNames = new Set<string>();
            Set<string> productNames = new Set<string>();
            
            
            Set<Id> leadIdsExistingAccount = new Set<Id>();
            Set<Id> leadIdsExistingContact = new Set<Id>();
            Set<Id> leadIdsExistingOpportunity = new Set<Id>();
            
            for(Lead lead : newLead)
            {
                string emailId= lead.Email;
                if(string.isNotEmpty(emailId))
                {
                    emails.Add(emailId);    
                }
                
                //Company/Account name logic
                string company= lead.Company;
                if(string.isNotEmpty(company))
                {
                    companyNames.Add(company);    
                }
                
                //Product coming with Lead
                string product = lead.Marketing_Product_Text__c;
                if(string.isNotEmpty(product))
                {
                    productNames.Add(product.trim().toLowerCase());    
                }
            }
            
            List<Contact> listContacts  = [SELECT Id, Name, Email, AccountId FROM Contact WHERE Email in :emails];
            //Company/Account name logic
            List<Account> listAccounts  = [SELECT Id, Name FROM Account WHERE Name in :companyNames];
            
            productNames.Add('unknown');
            List<Product2> listProducts  = [SELECT Id, Name, Product_Family__c FROM Product2 WHERE Name in :productNames];
            
            List<User> users = [SELECT Id, Name FROM User];
            
            system.debug('Method --> ConvertLeadAutomation() --> Existing Contacts = ' + String.valueOf(listContacts.size()));
            info = new Logger.Information(className, methodName, '-', 'Existing Contacts = ' + String.valueOf(listContacts.size()), 'Lead', DateTime.now());
            logsToCreate.add(info);
            
            Map<string, Contact> contactMaps =   new Map<string, Contact>();
            Map<string, Account> accountMaps =   new Map<string, Account>();
            Map<string, Product2> productMaps =   new Map<string, Product2>();
            Map<string, User> userMaps = new Map<string, User>();
            
            Set<Id> productIds =  new Set<Id>();
            Set<Id> contactIds =  new Set<Id>();
            Set<Id> accountIds = new Set<Id>();
            
            Set<Id> contactOppsIds =  new Set<Id>();
            Map<ID, List<Opportunity>> contactOppMaps  =   new Map<ID, List<Opportunity>>();
            Map<ID, List<Opportunity>> accountOppMaps  =   new Map<ID, List<Opportunity>>();
            
            //Contacts coming in Leads - Generating Maps
            for(Contact contact : listContacts)
            {
                string emailId= contact.Email;
                string accountId = contact.AccountId;
                contactIds.Add(contact.Id);
                
                if(string.isNotEmpty(emailId))
                {
                    contactMaps.put(emailId,contact);
                }
                if(string.isNotEmpty(accountId))
                {
                    accountIds.Add(accountId);
                }
            }
            
            //Accounts coming in Leads - Generating Maps
            for(Account account : listAccounts)
            {
                string accountId = account.Id;
                string accountName = account.Name;
                if(string.isNotEmpty(accountName))
                {
                    accountMaps.put(accountName,account);
                }
                if(!accountIds.contains(accountId))
                {
                    accountIds.Add(accountId);
                }
            }
            
            //Products coming in Leads - Generating Maps
            for(Product2 product : listProducts)
            {
                string productId = product.Id;
                string productName = product.Name;
                if(string.isNotEmpty(productName))
                {
                    productMaps.put(productName.trim().toLowerCase(),product);
                    productIds.add(productId);
                }
            }
            
            
            for (User us : users)
            {
                if(!userMaps.containsKey(us.Name))
                {
                    userMaps.put(us.Name, us);
                }
            }
            
            List<OpportunityContactRole> oppContactList  = [SELECT Id, OpportunityId, ContactId FROM OpportunityContactRole WHERE ContactId in :contactIds];
            
            for(OpportunityContactRole oppContRole : oppContactList)
            {
                contactOppsIds.Add(oppContRole.OpportunityId);
            }
            
            Map<Id, Opportunity> opportunitiesMaps  = new Map<Id,Opportunity>([SELECT Id, Name, Type, Description, AccountId, StageName, Pricebook2Id, First_Source__c,
                                                                               First_Specific_Source__c, Last_Source__c, Last_Specific_Source__c, Product_Family__c,
                                                                               Product_Family__r.Name, OwnerID, Owner.Name, (SELECT Product2.Name FROM OpportunityLineItems)
                                                                               FROM Opportunity WHERE Id in :contactOppsIds OR AccountId in :accountIds]);
            List<Opportunity> opportunitiesList = opportunitiesMaps.values();
            
            system.debug('Method --> ConvertLeadAutomation() --> Existing Opportunities = ' + String.valueOf(opportunitiesList.size()));
            info = new Logger.Information(className, methodName, '-', 'Existing Opportunities = ' + String.valueOf(opportunitiesList.size()), 'Lead', DateTime.now());
            logsToCreate.add(info);
            
            
            for(OpportunityContactRole oppContRole : oppContactList)
            {
                List<Opportunity> contactOpps = new List<Opportunity>();
                string contactId = oppContRole.ContactId;
                
                Opportunity opp = opportunitiesMaps.get(oppContRole.OpportunityId);
                
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
            
            for(Opportunity opp : opportunitiesList)
            {
                List<Opportunity> acctOpps = new List<Opportunity>();
                string accountId = opp.AccountId;
                if(string.isNotEmpty(accountId))
                {                
                    if(accountOppMaps.containsKey(accountId)){
                        
                        acctOpps = accountOppMaps.get(accountId);
                        if(!acctOpps.contains(opp))
                        {
                            acctOpps.Add(opp);                    
                            accountOppMaps.put(accountId,acctOpps);
                        }
                        
                    }
                    else
                    {
                        acctOpps.Add(opp);
                        accountOppMaps.put(accountId,acctOpps);
                    }
                }
            }
            
            List<Database.LeadConvert> lcs = new List<Database.LeadConvert>();
            
            Set<Id> leadAllNewConversion = new Set<Id>();
            LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
                
            for(Lead lead : newLead)
            {
                /*if(lead.Marketo_Update_Reason__c == 'Link Click')
                {
                    info = new Logger.Information(className, methodName, lead.Id, 'Lead Change Trigger From Link Click', 'Lead', DateTime.now());
                    logsToCreate.add(info);
                    Continue;
                }*/
                
                Database.LeadConvert lc = new database.LeadConvert();
                lc.setLeadId(lead.Id);
                string leadProductName = lead.Marketing_Product_Text__c;
                if(string.isEmpty(leadProductName))
                {
                    leadProductName = 'unknown';
                }
                
                boolean isOpportunitySet = false;
                
                if(contactMaps.containsKey(lead.Email))
                {
                    Contact leadContact = contactMaps.get(lead.Email);
                    
                    system.debug('Method --> ConvertLeadAutomation() --> Existing Contact Found');
                    
                    info = new Logger.Information(className, methodName, leadContact.Id, 'Existing Contact Found', 'Contact', DateTime.now());
                    logsToCreate.add(info);
                    
                    lc.setContactId(leadContact.Id);
                    leadIdsExistingContact.Add(lead.Id);
                    if(string.isNotEmpty(leadContact.AccountId))
                    {
                        system.debug('Method --> ConvertLeadAutomation() --> Existing Account Found - After Contact');
                        
                        info = new Logger.Information(className, methodName, leadContact.AccountId, 'Existing Account Found - After Contact', 'Account', DateTime.now());
                        logsToCreate.add(info);
                        
                        lc.setAccountId(leadContact.AccountId);
                        leadIdsExistingAccount.Add(lead.Id);
                        if(contactOppMaps.containsKey(leadContact.Id))
                        {
                            List<Opportunity> contactOpps = contactOppMaps.get(leadContact.Id);
                            
                            system.debug('Method --> ConvertLeadAutomation() --> Contact Existing Opportunities - After Contact & Account = ' + String.valueOf(contactOpps.size()));  
                            
                            info = new Logger.Information(className, methodName, leadContact.Id, 'Contact Existing Opportunities - After Contact & Account = ' + String.valueOf(contactOpps.size()), 'Contact', DateTime.now());
                            logsToCreate.add(info);
                            
                            for(Opportunity leadOpp : contactOpps)
                            {                            
                                
                                if(IsOpportunityOpenAndProductExistsInLineItem(lead, leadOpp))
                                {
                                    system.debug('Method --> ConvertLeadAutomation() --> Criteria Match with Opportunity - After Contact & Account');
                                    
                                    info = new Logger.Information(className, methodName, leadOpp.Id, 'Criteria Match with Opportunity - After Contact & Account', 'Opportunity', DateTime.now());
                                    logsToCreate.add(info);
                                    
                                    lc.setOpportunityId(leadOpp.Id);
                                    leadIdsExistingOpportunity.Add(lead.Id);
                                    break;
                                }
                            }
                        }
                    }
                }
                else
                {
                    if(accountMaps.containsKey(lead.Company))
                    {                  
                        Account leadAccount = accountMaps.get(lead.Company);
                        
                        system.debug('Method --> ConvertLeadAutomation() --> Existing Account by Company Name Found');
                        
                        info = new Logger.Information(className, methodName, leadAccount.Id, 'Existing Account by Company Name Found', 'Account', DateTime.now());
                        logsToCreate.add(info);
                        
                        lc.setAccountId(leadAccount.Id);
                        leadIdsExistingAccount.Add(lead.Id);
                        if(accountOppMaps.containsKey(leadAccount.Id))
                        {                        
                            List<Opportunity> leadOpps = accountOppMaps.get(leadAccount.Id);//errer
                            
                            system.debug('Method --> ConvertLeadAutomation() --> Account Existing Opportunities - After Account = ' + String.valueOf(leadOpps.size()));  
                            
                            info = new Logger.Information(className, methodName, leadAccount.Id, 'Account Existing Opportunities - After Account = ' + String.valueOf(leadOpps.size()), 'Account', DateTime.now());
                            logsToCreate.add(info);
                            
                            for(Opportunity leadOpp : leadOpps)
                            {                            
                                
                                if(IsOpportunityOpenAndProductExistsInLineItem(lead, leadOpp))
                                {
                                    system.debug('Method --> ConvertLeadAutomation() --> Criteria Match with Opportunity - After Account');
                                    
                                    info = new Logger.Information(className, methodName, leadOpp.Id, 'Criteria Match with Opportunity - After Contact & Account', 'Opportunity', DateTime.now());
                                    logsToCreate.add(info);
                                    
                                    //Mapping Lead with Existing Opportunity
                                    lc.setOpportunityId(leadOpp.Id);
                                    leadIdsExistingOpportunity.Add(lead.Id);
                                    break;
                                }
                            }
                        }
                    }
                    else
                    {
                        //Mapping Lead with New Account Contact Opportunity - By Default
                        leadAllNewConversion.Add(lead.Id);
                        system.debug('Method --> ConvertLeadAutomation() --> Creates New Account/Contact/Opportunity');
                        
                        info = new Logger.Information(className, methodName, '-', 'Creates New Account/Contact/Opportunity', '-', DateTime.now());
                        logsToCreate.add(info);
                    }
                }
                
                lc.setConvertedStatus(convertStatus.MasterLabel);
                
                lcs.Add(lc);            
            }
            
            
            Set<Id> oppIds = new Set<Id>();
            Set<Id> acctIds = new Set<Id>();
            Set<Id> ctIds = new Set<Id>();
            
            //Converting Leads
            List<Database.LeadConvertResult> lcrs = new List<Database.LeadConvertResult>();
            try
            {
                if(lcs.size() > 0)
                {
                    lcrs = Database.convertLead(lcs);            
                    system.debug('Method --> ConvertLeadAutomation() --> Converted All Leads = ' + String.valueOf(lcrs.size()));
                    
                    info = new Logger.Information(className, methodName, '-', 'Converted All Leads = ' + String.valueOf(lcrs.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            catch(Exception e)
            {
                system.debug('Method --> ConvertLeadAutomation() --> DML Exception Occured Lead Conversion');
                system.debug(e);
                
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
            }
            
            for(Database.LeadConvertResult lcr : lcrs)
            {
                if(lcr.isSuccess())
                {
                    info = new Logger.Information(className, methodName, lcr.leadid, 'Converted Lead', 'Lead', DateTime.now());
                    logsToCreate.add(info);
                    
                    Id oppId = lcr.opportunityid;
                    oppIds.add(oppId);
                    
                    Id acctId = lcr.accountid;
                    acctIds.add(acctId);
                    
                    Id ctId = lcr.contactid;
                    ctIds.add(ctId);
                    
                    info = new Logger.Information(className, methodName, lcr.leadid, 'Converted Lead - Account/Contact/Opportunity||' + acctId + '/' + ctId + '/' + oppId , 'Lead', DateTime.now());
                    logsToCreate.add(info);
                }
            }
            
            Map<Id,Account> allConvertedAcctMaps  = new Map<ID, Account>([SELECT Id, Name, Type, ShippingCountry, ShippingState FROM Account WHERE Id in :acctIds]);
            Map<Id,Contact> allConvertedCtMaps  = new Map<ID, Contact>([SELECT Id, Name, MailingCountry, MailingState,HasOptedOutOfEmail, First_Source__c, mkto71_Acquisition_Program__c, Last_Source__c, Last_Specific_Source__c, OwnerID, Owner.Name, Marketing_Product_Text__c FROM Contact WHERE Id in :ctIds]);
            Map<Id,Opportunity> allConvertedOppMaps  = new Map<ID, Opportunity>([SELECT Id, Name, Type, Description, AccountId, StageName, Pricebook2Id, First_Source__c, First_Specific_Source__c, Last_Source__c, Last_Specific_Source__c, Product_Family__c, OwnerID, Owner.Name, Contact_Role__c FROM Opportunity WHERE Id in :oppIds]);
            
            Set<Contact_Product__c> allContactProductsForInsert = new Set<Contact_Product__c>();            
            Set<Account_Product__c> allAccountProductsForInsert = new Set<Account_Product__c>();
            Set<OpportunityLineItem> allOppLineItemsForInsert = new Set<OpportunityLineItem>();
            
            Set<Account> allAccountsForUpdate = new Set<Account>();            
            Set<Contact> allContactsForUpdate = new Set<Contact>();           
            Set<Opportunity> allOppsForUpdate = new Set<Opportunity>();           
            
            Id pricebookId;
            if(Test.isRunningTest())
            {
                pricebookId  = Test.getStandardPricebookId();
            }
            else
            {
                priceBookId = DataFactory.getStandardPriceBook().Id;
            }
            
            List<PriceBookEntry> allProdPriceBookEntries = [SELECT Product2.Id, UnitPrice, PriceBook2Id FROM PriceBookEntry Where Product2.Id IN :productIds];
            
            system.debug('Method --> ConvertLeadAutomation() --> Product Price Book Entries Found = ' + String.valueOf(allProdPriceBookEntries.size()));
            
            info = new Logger.Information(className, methodName, '-', 'Product Price Book Entries Found # = ' + String.valueOf(allProdPriceBookEntries.size()), '-', DateTime.now());
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
            
            for(Database.LeadConvertResult lcr : lcrs)
            {
                if(lcr.isSuccess())
                {
                    Lead lead = newLeadMap.get(lcr.getLeadId()); 
                    string leadProductName = lead.Marketing_Product_Text__c;
                    if(string.isEmpty(leadProductName))
                    {
                        leadProductName = 'unknown';
                    }
                    else
                    {
                        leadProductName = leadProductName.trim().toLowerCase();	
                    }
                    
                    info = new Logger.Information(className, methodName, lcr.leadid , 'Lead Came With Product Name = ' + leadProductName, 'Lead', DateTime.now());
                    logsToCreate.add(info);
                    
                    Account acct = allConvertedAcctMaps.get(lcr.accountid);
                    Contact ct = allConvertedCtMaps.get(lcr.contactid);
                    Product2 prod = productMaps.get(leadProductName);                    
                    Opportunity opp = allConvertedOppMaps.get(lcr.opportunityid);
                    
                    //Mapping lead country and state field to Account field - when account is New
                    if(!leadIdsExistingAccount.contains(lead.Id))
                    {                        
                        if(acct != null)
                        {
                            info = new Logger.Information(className, methodName, acct.Id , 'New Account - Updating Shipping Address & Type', 'Account', DateTime.now());
                            logsToCreate.add(info);
                            
                            acct.ShippingCountry = lead.Country;
                            acct.ShippingState = lead.State;
                            acct.Type = 'Prospect';
                            allAccountsForUpdate.Add(acct);
                        }                        
                    }
                    
                    
                    //Mapping lead country and state field to Contact field 
                    if(ct != null)
                    {   
                        ct.HasOptedOutOfEmail = lead.HasOptedOutOfEmail;
                        ct.Marketo_Change_Trigger_Reason__c = 'None';
                        
                        //If New Contact
                        if(!leadIdsExistingContact.contains(lead.Id))
                        {
                            info = new Logger.Information(className, methodName, ct.Id , 'New Contact - Mailing Address, Product Name, Owner(Marco), First,Last & First,Last Specific Source', 'Contact', DateTime.now());
                            logsToCreate.add(info);
                            
                            ct.MailingCountry = lead.Country;
                            ct.MailingState = lead.State;
                            ct.First_Source__c = lead.First_Source__c;
                            ct.mkto71_Acquisition_Program__c = lead.mkto71_Acquisition_Program__c;
                            
                            ct.Last_Source__c = lead.Last_Source__c;
                            ct.Last_Specific_Source__c = lead.Last_Specific_Source__c;
                            ct.Marketing_Product_Text__c = lead.Marketing_Product_Text__c;
                            
                            if(userMaps.containsKey('Marco Caracciolo'))
                            {
                                ct.OwnerID = userMaps.get('Marco Caracciolo').Id;
                            }
                        }
                        else
                        {  
                            info = new Logger.Information(className, methodName, ct.Id , 'Existing Contact - Mailing Address, Product Name, Last & Last Specific Source', 'Contact', DateTime.now());
                            logsToCreate.add(info);
                            
                            ct.MailingCountry = lead.Country;
                            ct.MailingState = lead.State;  
                            ct.Last_Source__c = lead.Last_Source__c;
                            ct.Last_Specific_Source__c = lead.Last_Specific_Source__c;
                            
                            ct.Marketing_Product_Text__c = lead.Marketing_Product_Text__c; //Added when adding logging
                        }
                        allContactsForUpdate.Add(ct);
                    }
                    
                    if(opp != null)
                    {                        
                        opp.Description = ConcatenateDescription(opp.Description, lead.Description);                        
                        opp.Last_Updated_From_Contact__c = ct.Id;
                        
                        //Mapping Opportunity fields if new Opp                  
                        if(!leadIdsExistingOpportunity.contains(lead.Id))
                        {  
                            info = new Logger.Information(className, methodName, opp.Id , 'New Opportunity - First,Last & First,Last Specific Source', 'Opportunity', DateTime.now());
                            logsToCreate.add(info);
                            
                            opp.First_Source__c = lead.First_Source__c;
                            opp.First_Specific_Source__c = lead.mkto71_Acquisition_Program__c;
                            
                            opp.Last_Source__c = lead.Last_Source__c;
                            opp.Last_Specific_Source__c = lead.Last_Specific_Source__c;
                            
                            if(ct != null)
                            { 
                                //Add ContactRole field on Opp
                                opp.Contact_Role__c = ct.Id;
                            }
                            if(userMaps.containsKey('Marco Caracciolo'))
                            {
                                opp.OwnerID = userMaps.get('Marco Caracciolo').Id;
                            }
                            
                            opp.Pricebook2Id = priceBookId;
                            
                            if(prod != null)
                            {
                                PricebookEntry prodPriceBookEntry = allProdPriceBookEntMaps.get(prod.Id);
                                opp.Product_Family__c = prod.Product_Family__c;
                                
                                OpportunityLineItem oppLineItem = new OpportunityLineItem();
                                
                                oppLineItem.OpportunityId = opp.Id;
                                oppLineItem.Product2Id = prod.Id;
                                oppLineItem.Quantity = 1;
                                if(prodPriceBookEntry != null)
                                {
                                    oppLineItem.UnitPrice = prodPriceBookEntry.UnitPrice;
                                    
                                    //move into if check-bcz of no product pricing and its exception
                                    allOppLineItemsForInsert.Add(oppLineItem);
                                }
                                
                                opp.Name = opp.Name + ' - ' + prod.Name;
                            }
                            
                            //Mapping Opportunity fields if new account/company 
                            if(!leadIdsExistingAccount.contains(lead.Id))
                            {
                                opp.Type = 'New Business';
                            }
                            else
                            {
                                if(acct != null)
                                {
                                    if(acct.Type == 'Prospect'){
                                        opp.Type = 'New Business';                                        
                                    }
                                    if(acct.Type == 'Customer'){
                                        opp.Type = 'Existing Business - Existing Product';                                        
                                    }
                                    if(acct.Type == 'Former Customer' || acct.Type == 'Dormant'){
                                        opp.Type = 'Existing Business - New Product';                                        
                                    }
                                }
                            }
                        }
                        else
                        {
                            info = new Logger.Information(className, methodName, opp.Id , 'Existing Opportunity - Last & Last Specific Source', 'Opportunity', DateTime.now());
                            logsToCreate.add(info);
                            
                            //Mapping Opportunity fields if existing opportunity use
                            opp.Last_Source__c = lead.Last_Source__c;
                            opp.Last_Specific_Source__c = lead.Last_Specific_Source__c;
                            
                        }
                        allOppsForUpdate.Add(opp);
                    }
                    
                    //Mapping AccountProduct and ContactProduct
                    if(prod != null && productMaps.containsKey(leadProductName.trim().toLowerCase()))
                    {                     
                        Account_Product__c acctProd = new Account_Product__c();
                        acctProd.Account__c = lcr.accountid;                    
                        acctProd.Product__c = prod.Id;
                        if(acct != null)
                        {
                            acctProd.Account_Type__c = 'Prospect';
                        }
                        
                        allAccountProductsForInsert.Add(acctProd);
                        
                        Contact_Product__c contactProd = new Contact_Product__c();
                        contactProd.Contact__c = lcr.contactid;                    
                        contactProd.Product__c = prod.Id;
                        
                        allContactProductsForInsert.Add(contactProd);
                    }
                }
            }
            
            try
            {                
                if(allOppsForUpdate.size() > 0){
                    List<Database.SaveResult> oppResult = Database.update( new List<Opportunity>(allOppsForUpdate));
                    system.debug('Method --> ConvertLeadAutomation() --> Opportunities updated = ' + String.valueOf(oppResult.size()));
                    info = new Logger.Information(className, methodName, '-' , 'Opportunities updated = ' + String.valueOf(oppResult.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
                
                if(allAccountProductsForInsert.size() > 0){
                    List<Database.SaveResult> accountProductResult = Database.insert(new List<Account_Product__c>(allAccountProductsForInsert));
                    system.debug('Method --> ConvertLeadAutomation() --> AccountProduct Created = ' + String.valueOf(accountProductResult.size()));
                    info = new Logger.Information(className, methodName, '-' , 'AccountProduct updated = ' + String.valueOf(accountProductResult.size()), '-', DateTime.now());
                    logsToCreate.add(info);
                }
                
                if(allContactProductsForInsert.size() > 0){
                    List<Database.SaveResult> contactProductResult = Database.insert(new List<Contact_Product__c>(allContactProductsForInsert));
                    system.debug('Method --> ConvertLeadAutomation() --> ContactProduct Created = ' + String.valueOf(contactProductResult.size()));
                    info = new Logger.Information(className, methodName, '-' , 'ContactProduct updated = ' + String.valueOf(contactProductResult.size()), '-', DateTime.now());
                    logsToCreate.add(info); 
                }         
                
                if(allAccountsForUpdate.size() > 0){
                    List<Database.SaveResult> accountResult = Database.update(new List<Account>(allAccountsForUpdate));
                    system.debug('Method --> ConvertLeadAutomation() --> Account Updated = ' + String.valueOf(accountResult.size()));
                    info = new Logger.Information(className, methodName, '-' , 'Account updated = ' + String.valueOf(accountResult.size()), '-', DateTime.now());
                    logsToCreate.add(info); 
                }
                
                if(allContactsForUpdate.size() > 0){
                    List<Database.SaveResult> contactResult = Database.update(new List<Contact>(allContactsForUpdate));
                    system.debug('Method --> ConvertLeadAutomation() --> Contact Updated = ' + String.valueOf(contactResult.size()));
                    info = new Logger.Information(className, methodName, '-' , 'Contact updated = ' + String.valueOf(contactResult.size()), '-', DateTime.now());
                    logsToCreate.add(info); 
                }
                
                if(allOppLineItemsForInsert.size() > 0){
                    List<Database.SaveResult> oppLineItemResult = Database.insert(new List<OpportunityLineItem>(allOppLineItemsForInsert));
                    system.debug('Method --> ConvertLeadAutomation() --> OpportunityLineItem Created = ' + String.valueOf(oppLineItemResult.size()));
                    info = new Logger.Information(className, methodName, '-' , 'OpportunityLineItem Created = ' + String.valueOf(oppLineItemResult.size()), '-', DateTime.now());
                    logsToCreate.add(info);  
                }
            }
            catch(DmlException e)
            {
                system.debug('Method --> ConvertLeadAutomation() --> DML Exception Occured post conversion DML');
                system.debug(e);
                exError = new Logger.ExceptionError(className, methodName, '-', e, '-', DateTime.now());
                logsToCreate.add(exError);
                
                isExecuting = false;
            }
            
            info = new Logger.Information(className, methodName, '-' , 'Method Ends', '-', DateTime.now());
            logsToCreate.add(info);
            new Logger().createLogs(logsToCreate);
            
        }
        catch(Exception e)
        {
            system.debug('Method --> ConvertLeadAutomation() --> Exception Occured');
            system.debug(e);
            
            isExecuting = false;
            
        }
        
        isExecuting = false;
        system.debug('Method --> ConvertLeadAutomation() --> End');
        
    }
    
    private static boolean IsOpportunityOpenAndProductExistsInLineItem(Lead lead, Opportunity opp)
    {
        system.debug('Method --> IsProductExistsInLineItem() --> Start');
        
        boolean IsExists = false;
        string leadProductName = lead.Marketing_Product_Text__c;
        if(string.isEmpty(leadProductName))
        {
            leadProductName = 'unknown';
        }
        
        for(OpportunityLineItem oppLineItem :  opp.OpportunityLineItems){
            
            if(oppLineItem.Product2.Name.trim().toLowerCase() == leadProductName.trim().toLowerCase())
            {
                if(opp.First_Source__c == lead.First_Source__c && (opp.StageName == 'Unqualified' || opp.StageName == 'Marketing Qualified' 
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
    
    private static string ConcatenateDescription(string oppDescription, string leadDescription)
    {
        
        system.debug('Method --> ConcatenateDescription() --> Start');
        string newOppDescription = '';
        if(string.isNotEmpty(oppDescription))
        {
            newOppDescription = oppDescription + '\n\n';
        }
        if(string.isNotEmpty(leadDescription))
        {
            newOppDescription = newOppDescription + string.valueOf(DateTime.now()) + '\n' + leadDescription;
        }
        
        system.debug('Method --> ConcatenateDescription() --> End');
        return newOppDescription;
    }
}