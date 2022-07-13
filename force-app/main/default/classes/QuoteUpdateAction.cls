public class QuoteUpdateAction {
    
    @InvocableMethod(label='UpdateQuote' description='Update currencies format field')
    public static List<ID> UpdateQuote(List<Quote> quotes) {
        
        Set<Id> quotesIds = (new Map<Id,SObject>(quotes)).keySet();
        List<Quote> quotesToUpdate = [Select Id,Total_From_Hours_Charges__c,Total_From_Hours_Charges_String__c,Total_To_Hours_Charges__c,Total_To_Hours_Charges_String__c from Quote where Id in :quotesIds];
        List<Quote> quotesU = new LIST<Quote>();
        
        for(Quote quote : quotesToUpdate)
        {
        Decimal tfhc = quote.Total_From_Hours_Charges__c;
        Decimal tthc = quote.Total_To_Hours_Charges__c;
        
        List<String> args = new String[]{'0','number','###,###,###'};
        
        String tfhcs = String.format(tfhc.format(), args);
        String tthcs = String.format(tthc.format(), args);
                
        System.debug('tfhcs-'+ tfhcs);
        System.debug('tthcs-'+ tthcs);
        
        quote.Total_From_Hours_Charges_String__c = tfhcs;
        quote.Total_To_Hours_Charges_String__c = tthcs;
            
        quotesU.add(quote);
        }   
                
        Database.SaveResult[] results = Database.update(quotesU);
        List<ID> updatedQuotesIds = new List<ID>();
        for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                updatedQuotesIds.add(result.getId());
            }
        }
        return updatedQuotesIds;
    }
    
    
}