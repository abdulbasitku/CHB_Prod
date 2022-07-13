public with sharing class QuoteLineItemTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public QuoteLineItemTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<QuoteLineItem> newQuoteLineItem)
    {
        system.debug('QuoteLineItem Trigger On Before Insert');
    }
    public void OnAfterInsert(List<QuoteLineItem> newQuoteLineItem)
    {
        system.debug('QuoteLineItem Trigger On After Insert');
        QuoteLineItemActions.updateQuoteAmountsByRevenueType (newQuoteLineItem);
    }
    public void OnAfterUpdate( List<QuoteLineItem> newQuoteLineItem, List<QuoteLineItem> oldQuoteLineItem, Map<ID, QuoteLineItem> newQuoteLineItemMap , Map<ID, QuoteLineItem> oldQuoteLineItemMap )
    {
        system.debug('QuoteLineItem Trigger On After Update ');
        QuoteLineItemActions.updateQuoteAmountsByRevenueType (newQuoteLineItem);
    }
    public void OnBeforeUpdate( List<QuoteLineItem> newQuoteLineItem, List<QuoteLineItem> oldQuoteLineItem, Map<ID, QuoteLineItem> newQuoteLineItemMap , Map<ID, QuoteLineItem> oldQuoteLineItemMap )
    {
        system.debug('Account Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<QuoteLineItem> newQuoteLineItem)
    {
        system.debug('QuoteLineItem Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<QuoteLineItem> oldQuoteLineItem)
    {
        system.debug('QuoteLineItem Trigger On After Delete');
        QuoteLineItemActions.updateQuoteAmountsByRevenueType (oldQuoteLineItem);
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newQuoteLineItemIDs)
    {

    }
    
    public boolean IsTriggerContext
    {
        get{ return m_isExecuting;}
    }
    
    public boolean IsVisualforcePageContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsWebServiceContext
    {
        get{ return !IsTriggerContext;}
    }
    
    public boolean IsExecuteAnonymousContext
    {
        get{ return !IsTriggerContext;}
    }*/
}