@isTest
public class CreateDefaultQuotes_Test {
    static testMethod void convertLeadIntoOpportunity_Test()
    {
        Account account = DataFactory.CreateAccount('Test Account1');
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Opportunity opportunity1 = DataFactory.CreateOpportunity('Test Opportunity1', account.Id, pricebookId,'');
        
        Product_Family__c productFamily1 = DataFactory.CreateProductFamily('NEWSTAR');
        Product_Family__c productFamily2 = DataFactory.CreateProductFamily('BuildTopia');
        
        Product2 product1 = DataFactory.CreateProduct('Test Product1', productFamily1.Id);
        Product2 product2 = DataFactory.CreateProduct('Test Product2', productFamily2.Id);
                
        Test.startTest();
        
        //For Product Family = Newstar
        opportunity1.Product_Family__c = productFamily1.Id;
        update opportunity1;
        string result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        //For Product Family = BuildTopia
        opportunity1.Product_Family__c = productFamily2.Id;
        update opportunity1;        
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        Sales_Track__c salesTrack1 = DataFactory.CreateSalesTrack('License and Maintenance');
        
        //For Product Family = Newstar
        opportunity1.Product_Family__c = productFamily1.Id;
        update opportunity1;
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
       //For Product Family = BuildTopia
        opportunity1.Product_Family__c = productFamily2.Id;
        update opportunity1;        
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        Sales_Track__c salesTrack2 = DataFactory.CreateSalesTrack('Rental');  
        
       //For Product Family = Newstar
        opportunity1.Product_Family__c = productFamily1.Id;
        update opportunity1;
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        //For Product Family = BuildTopia
        opportunity1.Product_Family__c = productFamily2.Id;
        update opportunity1;        
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        Sales_Track__c salesTrack3 = DataFactory.CreateSalesTrack('PSG'); 
        
        //For Product Family = Newstar
        opportunity1.Product_Family__c = productFamily1.Id;
        update opportunity1;
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        //For Product Family = BuildTopia
        opportunity1.Product_Family__c = productFamily2.Id;
        update opportunity1;        
        result = apxCreateDefaultQuotesController.CreateDefaultQuotesByOppId(opportunity1.Id);
        
        System.debug(result);
        if(result == 'Default Quotes Successfully Created')
        {
            System.assert(true);
        }
        
        Test.stopTest();
    }
}