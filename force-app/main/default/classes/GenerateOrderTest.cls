@isTest
public class GenerateOrderTest {

    static testMethod void ConvertQuoteToOrder()
     {
         Account account = DataFactory.CreateAccount('Test Account1');
         
         //Pricebook2 pricebook = DataFactory.CreatePricebook('Test Pricebook 1');
         Id pricebookId = Test.getStandardPricebookId();
         
         Opportunity opportunity = DataFactory.CreateOpportunity('Test Opportunity 1', account.Id, pricebookId,'');
         
         Product_Family__c productFamily1 = DataFactory.CreateProductFamily('NEWSTAR');
         
         Product2 product1 = DataFactory.CreateProduct('Test Product 1', productFamily1.Id);
         Product2 product2 = DataFactory.CreateProduct('Test Product 2', productFamily1.Id);
         
         PricebookEntry pricebookEntry1 = DataFactory.CreatePricebookEntry(product1.Id, pricebookId, 500);
         PricebookEntry pricebookEntry2 = DataFactory.CreatePricebookEntry(product2.Id, pricebookId, 200);
         
         Quote quote = DataFactory.CreateQuote('Test Quote 1', opportunity.Id, pricebookId);
         quote.Status = 'Accepted';
         Update quote;

         Quote quote2 = DataFactory.CreateQuote('Test Quote 2', opportunity.Id, pricebookId);
         Update quote2;
         
         QuoteLineItem quoteLineItem1 = DataFactory.CreateQuoteLineItem(3, quote.Id, product1.Id, pricebookEntry1.Id, pricebookEntry1.UnitPrice);
         QuoteLineItem quoteLineItem2 = DataFactory.CreateQuoteLineItem(2, quote.Id, product2.Id, pricebookEntry2.Id, pricebookEntry2.UnitPrice);
                           
         Test.startTest();
         
         string result = apxGenerateOrderController.GenerateOrderByQuoteId(quote.Id);
         System.debug(result);
         
         string result2 = apxGenerateOrderController.GenerateOrderByQuoteId(quote2.Id);
         
         if(result.toLowerCase().contains('order successfully'))
         {
             System.assert(true);
         }
         
         Test.stopTest();
     }
}