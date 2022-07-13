@isTest
public class Triggers_Test {
    
    static testmethod void  accountTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        
        account.Name = 'TestAccountUpdated';
        
        update account;
        
        delete account;
        
        Test.stopTest();        
    }
    
    static testmethod void  contactTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        Contact contact = DataFactory.CreateContact('TestContact', account.Id);
        Contact contact2 = DataFactory.CreateContact('TestContact2', account.Id);
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        Product2 product = DataFactory.CreateProduct('Newstar', productFamily.Id);
        //product.Product_Family__c = productFamily1.Id;
        
        //update product;
        
        
        Pricebook2 prcBk = DataFactory.CreatePricebook('TestPrcBk'); 
        
        PricebookEntry pricebookEntry1 = DataFactory.CreatePricebookEntry(product.Id, Test.getStandardPricebookId(), 500);
              
        Account_Product__c accountProduct = DataFactory.CreateAccountProduct(account.Id, product.Id); 
        Contact_Product__c contactProduct = DataFactory.CreateContactProduct(contact.Id, product.Id);
        Opportunity opportunity = DataFactory.CreateOpportunity('TestOpportunity', account.Id, prcBk.Id, '');
        OpportunityContactRole opportunityContactRole = DataFactory.CreateOpportunityContactRole(contact.Id, opportunity.Id);   
            
        contact.Contact_Division__c = 'NEWSTAR';
        contact.Marketing_Product_Text__c = 'Newstar';
        contact.Marketo_Change_Trigger_Reason__c = 'Submission of Form';
        update contact;
        
        delete contact2;
        
        Test.stopTest();        
    }
    
    static testmethod void  leadTriggerEventTest(){
        
        Test.StartTest();
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id); 
        PricebookEntry prcBkEntry = DataFactory.CreatePricebookEntry(product.Id, Test.getStandardPricebookId(), 56);
        Account account = DataFactory.CreateAccount('TestAccount');
        Contact contact = DataFactory.CreateContact('TestContact', account.Id);
        Opportunity opportunity = DataFactory.CreateOpportunity('TestOpportunity', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity2 = DataFactory.CreateOpportunity('TestOpportunity2', account.Id, Test.getStandardPricebookId(),'');
        Lead lead = DataFactory.CreateLead('TestLead', 'TestLeadCompany');
        
        lead.LastName = 'TestLeadUpdated';
        
        update lead;
        
        delete lead;
        
        Test.stopTest();        
    }
    
    static testmethod void  opportunityTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        Lead lead = DataFactory.CreateLead('TestLead', 'TestLeadCompany');        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        Product_Addon__c productAddon = DataFactory.CreateProductAddon('TestProductAddon', product.Id);
        
        Opportunity opp = DataFactory.CreateOpportunity('TestOpportunity', account.Id, Test.getStandardPricebookId(), string.valueOf(lead.Id));
        
        opp.Name = 'TestOpportunityUpdated';
        
        update opp;
        
        opp.StageName = 'Confirmed - SQL';
        
        update opp;
        
        opp.StageName = 'Sales Initiated';
        
        update opp;
        
        delete opp;
        
        Test.stopTest();        
    }
    
    static testmethod void  contactProductTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        Contact contact = DataFactory.CreateContact('TestContact', account.Id);
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        
        //Product_Family__c productFamily1 = DataFactory.CreateProductFamily('TestProductFamily');
        //product.Product_Family__c = productFamily1.Id;
        //update product;
        
        Contact_Product__c contactProduct = DataFactory.CreateContactProduct(contact.Id, product.Id);        
        
        Product2 product2 = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        
        contactProduct.Product__c = product2.Id;
        
        update contactProduct;        
        
        delete contactProduct;
        
        Test.stopTest();        
    }
        
    static testmethod void  accountProductTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        
        //Product_Family__c productFamily1 = DataFactory.CreateProductFamily('TestProductFamily');
        //product.Product_Family__c = productFamily1.Id;
        //update product;
        
        Account_Product__c accountProduct = DataFactory.CreateAccountProduct(account.Id, product.Id);        
        
        Product2 product2 = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        
        accountProduct.Product__c = product2.Id;
        
        update accountProduct;        
        
        delete accountProduct;
        
        Test.stopTest();        
    }    
    
    static testmethod void  productTriggerEventTest(){
        
        Test.StartTest();
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        
        Product2 prod = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        prod.Name = 'TestProductUpdated';
        prod.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Product').getRecordTypeId();        
        prod.Revenue_Type__c = 'License';
        
        /*Product_Family__c productFamily1 = DataFactory.CreateProductFamily('TestProductFamily');
        prod.Product_Family__c = productFamily1.Id;
        
        update prod;*/
        
        AvoidRecursion.refreshFirstRunForUnitTest(); //Allow trigger to fire again in this transaction
        
        Product2 mProd = DataFactory.CreateProduct('TestProduct2', productFamily.Id);        
        //mProd.RecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('Maintenance').getRecordTypeId();        
        mProd.Revenue_Type__c = 'Maintenance';
        
        /*mprod.Product_Family__c = productFamily1.Id;*/
        update mProd;
        
        AvoidRecursion.refreshFirstRunForUnitTest(); //Allow trigger to fire again in this transaction
        
        prod.Maintenance_Product__c = mProd.Id;
        PricebookEntry prcBkEntry = DataFactory.CreatePricebookEntry(mProd.Id, Test.getStandardPricebookId(), 56);
        update prod;
        
        delete prod;
        
        Test.stopTest();        
    }
    
    static testmethod void  opportunityLineItemTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        
        Opportunity opportunity = DataFactory.CreateOpportunity('TestOpportunity', account.Id, Test.getStandardPricebookId(), '');
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        
        Quote quote = DataFactory.CreateQuote('TestQuote', opportunity.Id, Test.getStandardPricebookId());
        
        PricebookEntry pricebookEntry = DataFactory.CreatePricebookEntry(product.Id, Test.getStandardPricebookId(), 500);
        
        OpportunityLineItem oppLineItem = DataFactory.CreateOpportunityLineItem(10, opportunity.Id, product.Id, pricebookEntry.Id, pricebookEntry.UnitPrice);
        
        oppLineItem.Description = 'TestOpportunityLineItemDescUpdated';
        
        update oppLineItem;
        
        delete oppLineItem;
        
        Test.stopTest();        
    }
    
    static testmethod void  quoteLineItemTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        
        Opportunity opportunity = DataFactory.CreateOpportunity('TestOpportunity', account.Id, Test.getStandardPricebookId(), '');
        
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id);
        
        Quote quote = DataFactory.CreateQuote('TestQuote', opportunity.Id, Test.getStandardPricebookId());
        
        PricebookEntry pricebookEntry = DataFactory.CreatePricebookEntry(product.Id, Test.getStandardPricebookId(), 500);
        
        QuoteLineItem qlItem = DataFactory.CreateQuoteLineItem(10, quote.Id, product.Id, pricebookEntry.Id, 56);
        
        qlItem.Description = 'TestQuoteLineItemDescUpdated';
        
        update qlItem;
        
        delete qlItem;
        
        Test.stopTest();        
    }
    
    static testmethod void  campaignTriggerEventTest(){
        
        Test.StartTest();        
        
        Campaign campaign = DataFactory.CreateCampaign('TestCampaign','Webinar');        
        campaign.Name = 'TestCampaignUpdated';
        update campaign;
        
        Campaign campaign2 = DataFactory.CreateCampaign('TestCampaign1','Webinar');
        
        Campaign campaign3 = DataFactory.CreateCampaign('TestCampaign1','Marketing Email');
        
        Campaign campaign4 = DataFactory.CreateCampaign('TestCampaign1','Tradeshow / Events');
        
        Campaign campaign5 = DataFactory.CreateCampaign('TestCampaign1','Direct Mail');
        
        delete campaign;
        
        Test.stopTest();        
    }
    
    static testmethod void  taskTriggerEventTest(){
        
        Test.StartTest();
        
        Account account = DataFactory.CreateAccount('TestAccount');
        
        Task task = DataFactory.CreateTask('Task Test', account.Id, UserInfo.getUserId());
        task.Description = 'abc';
        update task;
        try{
        delete task;
        }
        catch(Exception ex)
        {
            
        }
        Test.stopTest();        
    }
    
}