public with sharing class ProductTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public ProductTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Product2> newProduct)
    {
        system.debug('Product Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Product2> newProduct)
    {
        system.debug('Product Trigger On After Insert');
    }
    public void OnAfterUpdate( List<Product2> newProduct, List<Product2> oldProduct, Map<ID, Product2> newProductMap , Map<ID, Product2> oldProductMap )
    {
        system.debug('Product Trigger On After Update ');
        ProductActions.updateMaintenanceAmountByMaintenanceProduct (newProduct, oldProduct, newProductMap, oldProductMap);
    }
    public void OnBeforeUpdate( List<Product2> newProduct, List<Product2> oldProduct, Map<ID, Product2> newProductMap , Map<ID, Product2> oldProductMap )
    {
        system.debug('Product Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Product2> newProduct)
    {
        system.debug('Product Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Product2> oldProduct)
    {
        system.debug('Product Trigger On After Delete');
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newProductIDs)
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