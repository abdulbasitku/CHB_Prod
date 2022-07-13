public class QuoteLineItemUpdateAction {
    
    @InvocableMethod(label='UpdateQuoteLineItem' description='Update currencies format field')
    public static List<ID> UpdateQuoteLineItem(List<QuoteLineItem> quoteLineItems) {
        
        Set<Id> quoteLineItemIds = (new Map<Id,SObject>(quoteLineItems)).keySet();
        List<QuoteLineItem> quoteLineItemsToUpdate = 
            [Select Id,ListPrice,UnitPrice,Quantity,Subtotal,List_Price_String__c,Unit_Price_String__c,Quantity_String__c,Subtotal_String__c from QuoteLineItem where Id in :quoteLineItemIds];
        List<QuoteLineItem> quoteLineItemsW = new LIST<QuoteLineItem>();
        
        for(QuoteLineItem quoteLineItem : quoteLineItemsToUpdate)
        {
            Decimal lp = quoteLineItem.ListPrice;
        Decimal up = quoteLineItem.UnitPrice;
        Double qt = quoteLineItem.Quantity;
        Decimal sbt = quoteLineItem.Subtotal;
        
        List<String> args = new String[]{'0','number','###,###,###'};
        
        String lps = String.format(lp.format(), args);
        String ups = String.format(up.format(), args);
        String qts = String.format(qt.format(), args);
        String sbts = String.format(sbt.format(), args);
        
            System.debug('lps-'+ lps);
        System.debug('ups-'+ ups);
        System.debug('qts-'+ qts);
        System.debug('sbts-'+ sbts);
        
        quoteLineItem.List_Price_String__c = lps;
        quoteLineItem.Unit_Price_String__c = ups;
        quoteLineItem.Quantity_String__c = qts;
        quoteLineItem.Subtotal_String__c = sbts;
            
        quoteLineItemsW.add(quoteLineItem);
        }   
        
        Database.SaveResult[] results = Database.update(quoteLineItemsW);
        List<ID> updatedQuoteLineItemsIds = new List<ID>();
        for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                updatedQuoteLineItemsIds.add(result.getId());
            }
        }
        return updatedQuoteLineItemsIds;
    }
    
    
}