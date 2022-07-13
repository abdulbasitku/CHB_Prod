public with sharing class AccountTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public AccountTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Account> newAccount)
    {
        system.debug('Account Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Account> newAccount, Map<ID, Account> newAccountMap)
    {
        system.debug('Account Trigger On After Insert');
        //AccountActions.CreateAccountRelatedListObjectOnImport(newAccount, newAccountMap);
    }
    public void OnAfterUpdate( List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap, Map<ID, Account> oldAccountMap)
    {
        system.debug('Account Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap)
    {
        system.debug('Account Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Account> newAccount)
    {
        system.debug('Account Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Account> oldAccount)
    {
        system.debug('Account Trigger On After Delete');        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newAccountIDs)
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