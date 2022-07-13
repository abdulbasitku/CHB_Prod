public with sharing class AccountProductTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public AccountProductTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Account_Product__c> newAccountProducts)
    {
        system.debug('AccountProduct Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Account_Product__c> newAccountProducts, Map<ID, Account_Product__c> newAccountProductMaps)
    {
        system.debug('AccountProduct Trigger On After Insert');
        AccountProductActions.RecheckAndUpdateAccountProductFamilies(newAccountProducts);
    }
    public void OnAfterUpdate( List<Account_Product__c> newAccountProducts, List<Account_Product__c> oldAccountProduct, Map<ID, Account_Product__c> newAccountProductMaps, Map<ID, Account_Product__c> oldAccountProductMaps)
    {
        system.debug('AccountProduct Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Account_Product__c> newAccountProducts, List<Account_Product__c> oldAccountProduct, Map<ID, Account_Product__c> newAccountProductMaps , Map<ID, Account_Product__c> oldAccountProductMaps)
    {
        system.debug('AccountProduct Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Account_Product__c> newAccountProducts)
    {
        system.debug('AccountProduct Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Account_Product__c> oldAccountProduct)
    {
        system.debug('AccountProduct Trigger On After Delete');
        AccountProductActions.RecheckAndUpdateAccountProductFamilies(oldAccountProduct);        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newAccountProductIDs)
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