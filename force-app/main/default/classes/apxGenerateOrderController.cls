public with sharing class apxGenerateOrderController {

    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static String GenerateOrderByQuoteId(id quoteId) {
       
        System.debug('Call method GenerateOrderByQuoteId');
        
        Quote quote = [SELECT Id, Name, Status,/*Grand_Total_Amount__c,*/ Account.Id, Opportunity.Id, (SELECT Id, Quantity, Product2Id, UnitPrice, PricebookEntryId from QuoteLineItems)
                                   FROM Quote WHERE Id = :quoteId];
        
        if(quote.Status != 'Accepted')
        {
        	return ('Error in creating order : Quote must be accepted');
        }
        
        System.debug('SOQL Executed');
        
        Order order = new Order();
        order.name = quote.Name;       
        order.EffectiveDate = Date.today();
        order.Status = 'Draft';
        order.AccountId = quote.AccountId;
        //order.Order_Amount__c = quote.Grand_Total_Amount__c;
        
        Opportunity opportunity = [SELECT Id, Pricebook2Id FROM Opportunity WHERE Id = :quote.OpportunityId];
		order.Pricebook2Id = opportunity.Pricebook2Id;
                
        if(opportunity.Pricebook2Id == null)
        {
        	return ('Error in creating order : PriceBook must be assign to Opportunity');
        }
        
        Database.SaveResult result = Database.insert(order);
        
        System.debug('Successfully created Order ID: ' + result.getId());
                
        Id orderId = order.Id;
        
        List<OrderItem> orderItems = new List<OrderItem>();
        
        for(QuoteLineItem quoteLineItem : quote.QuoteLineItems)
        {            
            OrderItem orderItem = new OrderItem();
            orderItem.OrderId = orderId;
            orderItem.Quantity = quoteLineItem.Quantity;
            orderItem.Product2Id = quoteLineItem.Product2Id;
            //PriceBookEntry priceBookEntry = [SELECT Id, UnitPrice FROM PriceBookEntry 
                                             //WHERE Product2Id=:quoteLineItem.Product2Id LIMIT 1];
            orderItem.PricebookEntryId = quoteLineItem.PricebookEntryId;
            orderItem.UnitPrice = quoteLineItem.UnitPrice;
            orderItems.add(orderItem);
        }             

        if(!orderItems.isEmpty()) {
        Database.SaveResult[] results = Database.insert(orderItems);
        
        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Successfully created OrderLineItem ID: ' + results[i].getId());
            } 
            else
            {
                System.debug('Error: could not create sobject ' + 'for array element ' + i + '.');
                System.debug('   The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n');
                return ('Error in creating order');
            }
        }      
        
        return ('Order Successfully Created : ' + order.Name);
        }
        else
        {
            return ('Error in creating order : Quote does not contain any Product');
        }
    }
}