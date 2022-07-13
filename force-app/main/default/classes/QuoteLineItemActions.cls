public without sharing class QuoteLineItemActions 
{
    public static void updateQuoteAmountsByRevenueType ( List<QuoteLineItem> newQuoteLineItem)
    {
        Set<id> qIds = new Set<id>();
        for(QuoteLineItem qli : newQuoteLineItem )
        {
            qIds.add(qli.QuoteId);
        }
        
        List<Quote> quotes = [SELECT Id,Name, Total_License_Amount__c,Total_Maintenance_Amount__c,Total_License_Amount_String__c,Total_Maintenance_Amount_String__c, (SELECT Id, Subtotal, Product2.Revenue_Type__c FROM QuoteLineItems) FROM Quote WHERE Id IN :qIds];
        
        for(Quote q : quotes)
        {
            Decimal totalLicenseAmt = 0;
            Decimal totalMaintenanceAmt = 0;
            List<QuoteLineItem> quoteLineItems = q.QuoteLineItems;
            for(QuoteLineItem qli : quoteLineItems)
            {
                if(qli.Product2.Revenue_Type__c == 'License')
                {
                    totalLicenseAmt = totalLicenseAmt + qli.Subtotal;
                }
                if(qli.Product2.Revenue_Type__c == 'Maintenance')
                {
                    totalMaintenanceAmt = totalMaintenanceAmt + qli.Subtotal;
                }
            }
            q.Total_License_Amount__c = totalLicenseAmt;
            q.Total_Maintenance_Amount__c = totalMaintenanceAmt;

            //Add License & Maintenance Amount String field to show on Conga Proposal            
            List<String> args = new String[]{'0','number','###,###,###'};
                String totalLicenseAmtString = String.format(totalLicenseAmt.format(), args);
            q.Total_License_Amount_String__c = totalLicenseAmtString;            
            
            String totalMaintenanceAmtString = String.format(totalMaintenanceAmt.format(), args);
            q.Total_Maintenance_Amount_String__c = totalMaintenanceAmtString;
        }
        
        update quotes;
        
    }
}