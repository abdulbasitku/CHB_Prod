public class DataFactory {
    
    public static Boolean runningInASandbox {
        get {
            if (runningInASandbox == null) {
                runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            }
            return runningInASandbox;
        }
        set;
    }
    
    private static Pricebook2 stdPriceBook;
    
    public static Account CreateAccount(String name) {
        Account account = new Account();
        account.Name = name;
        account.Builder_2014_Closings__c = 1;
        account.Builder_2014_Ranking__c = 1;
        account.Builder_2015_Closings__c = 1;
        account.Builder_2015_Ranking__c = 1;
        account.Builder_2019_Closings__c = 1;
        account.Builder_2019_Ranking__c = 1;
        account.Professional_Builder_2014_Closings__c = 1;
        account.Professional_Builder_2014_Ranking__c = 1;
        account.Professional_Builder_2015_Closings__c = 1;
        account.Professional_Builder_2015_Ranking__c = 1;
        account.Professional_Builder_2016_Closings__c = 1;
        account.Professional_Builder_2016_Ranking__c = 1;
        account.SLX_ID__c = 'TestSLXInforId';
        
        account.Number_of_Homes__c = 'Unknown';
        insert account;
        return account;
    }
    
    public static Contact CreateContact(String lastName, Id accountId) {
        Contact contact = new Contact();
        contact.LastName = lastName;
        contact.AccountId = accountId;
        contact.Title = 'Marketing Manager';
        contact.Email = 'abc@abc.com';
        contact.Business_Function__c = 'Sales & Marketing';
        insert contact;
        return contact;
    }
    
    public static Opportunity CreateOpportunity(String name, Id accountId, Id pricebookId, string fromLeadId) {
        Opportunity opportunity = new Opportunity();
        opportunity.Name = Name;
        opportunity.CloseDate = Date.today();
        opportunity.StageName = 'Qualification';
        opportunity.AccountId = accountId;
        opportunity.Pricebook2Id = pricebookId;
        opportunity.From_Lead_Id__c = fromLeadId;
        insert opportunity;
        return opportunity;
    }
    
    public static OpportunityLineItem CreateOpportunityLineItem(double quantity, Id oppId, Id productId, Id pricebookEntryId, Decimal unitPrice) {
        
        OpportunityLineItem oppLineItem = new OpportunityLineItem();        
        oppLineItem.OpportunityId = oppId;
        oppLineItem.Product2Id = productId;
        oppLineItem.Quantity = quantity;                              
        oppLineItem.UnitPrice = unitPrice;                     
        oppLineItem.PricebookEntryId = pricebookEntryId;
        
        insert oppLineItem;
        return oppLineItem;
    }
    
    public static Lead CreateLead(String name, String companyName) {
        Lead lead = new Lead();
        lead.LastName = name;
        lead.Company = companyName;
        lead.Email = 'abc@abc.com';
        
        lead.Number_of_Homes__c = 'Unknown';
        
        //To be update - Refactoring
        Product_Family__c prodFamily = CreateProductFamily('Sales1440');
        Product2 prod = CreateProduct('Sales1440 Standard Edition 1 user', prodFamily.Id);
        lead.Marketing_Product_Family_Text__c = 'Sales1440';
        lead.Marketing_Product_Text__c = 'Sales1440 Standard Edition 1 user';
        //End
        
        lead.Business_Function__c = 'Sales & Marketing';
        lead.First_Source__c = 'Marketing Email';
        lead.mkto71_Acquisition_Program__c = 'First Campaign 1';
        insert lead;
        return lead;
    }
    
    public static Pricebook2 CreatePricebook(String name) {
        Pricebook2 pricebook = new Pricebook2();
        pricebook.Name = name;
        insert pricebook;
        return pricebook;
    }
    
    public static PricebookEntry CreatePricebookEntry(Id productId, Id pricebookId, Double unitPrice) {
        PricebookEntry pricebookEntry = new PricebookEntry();
        pricebookEntry.Pricebook2Id = pricebookId;
        pricebookEntry.Product2Id = productId;
        pricebookEntry.UnitPrice = unitPrice;
        pricebookEntry.IsActive = true;
        insert pricebookEntry;
        return pricebookEntry;
    }
    
    public static Product2 CreateProduct(string name, Id prodFamilyId) {
        Product2 product = new Product2();
        product.Name = name;
        product.Product_Family__c = prodFamilyId;
        insert product;
        return product;
    }
    
    public static Contact_Product__c CreateContactProduct(Id contactId, Id productId) {
        Contact_Product__c contactProduct = new Contact_Product__c();
        contactProduct.Contact__c = contactId;
        contactProduct.Product__c = productId;
        
        insert contactProduct;
        return contactProduct;
    }
    
    public static Account_Product__c CreateAccountProduct(Id accountId, Id productId) {
        Account_Product__c accountProduct = new Account_Product__c();
        accountProduct.Account__c = accountId;
        accountProduct.Product__c = productId;
        
        insert accountProduct;
        return accountProduct;
    }
    
    public static Quote CreateQuote(string name, Id opportunityId, Id pricebookId) {
        Quote quote = new Quote();
        quote.Name = name;
        quote.Pricebook2Id = pricebookId;
        //quote.AccountId = accountId;
        quote.OpportunityId = opportunityId;       
        insert quote;
        return quote;
    }
    
    public static QuoteLineItem CreateQuoteLineItem(double quantity, Id quoteId, Id productId, Id pricebookEntryId, Decimal unitPrice) {
        QuoteLineItem quoteLineItem = new QuoteLineItem();
        quoteLineItem.QuoteId = quoteId;
        quoteLineItem.Quantity = quantity;
        quoteLineItem.Product2Id = productId;
        quoteLineItem.PricebookEntryId = pricebookEntryId;
        quoteLineItem.UnitPrice = unitPrice;         
        insert quoteLineItem;
        return quoteLineItem;
    }
    
    public static Business_Group__c CreateBusinessGroup(String name) {        
        Business_Group__c businessGroup = new Business_Group__c();
        businessGroup.Name = name;
        insert businessGroup;
        return businessGroup;
    }
    
    public static Product_Family__c CreateProductFamily(String name) {        
        Business_Group__c businessGroup = CreateBusinessGroup('Test Business Group');
        Product_Family__c productFamily = new Product_Family__c();
        productFamily.Name = name;
        productFamily.Business_Group__c = businessGroup.Id;
        insert productFamily;
        return productFamily;
    }
    
    public static Product_Addon__c CreateProductAddon(string name, Id productId) {
        Product_Addon__c productAddon = new Product_Addon__c();
        productAddon.Name = name;
        productAddon.Product__c = productId;
        insert productAddon;
        return productAddon;
    }
    
    public static Sales_Track__c CreateSalesTrack(string name){
        Sales_Track__c salesTrack = new Sales_Track__c();
        salesTrack.Name = name;
        insert salesTrack;
        return salesTrack;
    }
    
    public static Campaign CreateCampaign(string name, string campaignType){
        Campaign campaign = new Campaign();
        campaign.Name = name;
        campaign.Type = campaignType;
        insert campaign;
        return campaign;
    }
    
    public static Lead UpdateLeadStatusToConvert(Lead lead1) {
        
        lead1.Status = 'Prequal';         
        update lead1;
        lead1.Status = 'Qualified';        
        update lead1;
        lead1.Status = 'Working';        
        update lead1;
        lead1.Status = 'Nurturing';        
        update lead1;
        
        return lead1;
    }
    
    public static Pricebook2 getStandardPriceBook() {
        if (stdPriceBook == null) 
            stdPriceBook = [select id, name from Pricebook2 where isStandard = true limit 1];
        return stdPriceBook;    
    }
    
    public static Task CreateTask(String subject, Id accountId, Id accountOwnerId) {
        
        Task task = new Task();
        task.Subject = subject;
        task.Status = 'Open';
        task.Priority = 'Normal';
        task.WhatId = accountId;
        //task.WhoId = accountOwnerId;
        task.OwnerId = accountOwnerId;
        
        insert task;
        return task;
    }
    
    public static OpportunityContactRole CreateOpportunityContactRole(Id contactId, ID opportunityId) {
        
        OpportunityContactRole opportunityContactRole = new OpportunityContactRole();
        opportunityContactRole.ContactId = contactId;
        opportunityContactRole.OpportunityId = opportunityId;
               
        insert opportunityContactRole;
        return opportunityContactRole;
    }
    @future
    public static void ForImmediateExecution()
    {
        
        System.debug('Method --> ForImmediateExecution() --> Start');
        
        try
        {               
            //system.debug('Method --> ForImmediateExecution --> For upadate = ' + updtContacts.size());
            //Database.SaveResult[] results = Database.update(new List<Contact>(updtContacts));
            
            //system.debug('Method --> ForImmediateExecution --> Upadated = ' + results.size());
        }
        catch (DmlException e) 
        {
            //system.debug('Method --> ForImmediateExecution --> Exception Occured ');
            //system.debug(e);
        }
        
        system.debug('Method --> ForImmediateExecution() --> End');
    }
}