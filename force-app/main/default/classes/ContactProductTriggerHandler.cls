public with sharing class ContactProductTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public ContactProductTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Contact_Product__c> newContactProducts)
    {
        system.debug('ContactProduct Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Contact_Product__c> newContactProducts, Map<ID, Contact_Product__c> newContactProductMaps)
    {
        system.debug('ContactProduct Trigger On After Insert');
        ContactProductActions.RecheckAndUpdateContactProductFamilies(newContactProducts);
    }
    public void OnAfterUpdate( List<Contact_Product__c> newContactProducts, List<Contact_Product__c> oldContactProduct, Map<ID, Contact_Product__c> newContactProductMaps, Map<ID, Contact_Product__c> oldContactProductMaps)
    {
        system.debug('ContactProduct Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Contact_Product__c> newContactProducts, List<Contact_Product__c> oldContactProduct, Map<ID, Contact_Product__c> newContactProductMaps , Map<ID, Contact_Product__c> oldContactProductMaps)
    {
        system.debug('ContactProduct Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Contact_Product__c> newContactProducts)
    {
        system.debug('ContactProduct Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Contact_Product__c> oldContactProduct)
    {
        system.debug('ContactProduct Trigger On After Delete');
        ContactProductActions.RecheckAndUpdateContactProductFamilies(oldContactProduct);        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newContactProductIDs)
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