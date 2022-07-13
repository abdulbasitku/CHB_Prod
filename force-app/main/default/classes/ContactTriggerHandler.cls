public with sharing class ContactTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public ContactTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Contact> newContact)
    {
        system.debug('Contact Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Contact> newContact, Map<ID, Contact> newContactMap)
    {
        system.debug('Contact Trigger On After Insert');
        //ContactActions.CreateContactRelatedListObjectOnImport(newContact, newContactMap);
    }
    public void OnAfterUpdate( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap, Map<ID, Contact> oldContactMap)
    {
        system.debug('Contact Trigger On After Update ');        
        ContactActions.UpdateOrCreateOpportunityOnMarketoSyncUpdate(newContact,oldContact, newContactMap,oldContactMap);
    }
    public void OnBeforeUpdate( List<Contact> newContact, List<Contact> oldContact, Map<ID, Contact> newContactMap , Map<ID, Contact> oldContactMap)
    {
        system.debug('Contact Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Contact> newContact)
    {
        system.debug('Contact Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Contact> oldContact)
    {
        system.debug('Contact Trigger On After Delete');        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newContactIDs)
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