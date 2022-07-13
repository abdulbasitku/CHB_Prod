public with sharing class LeadTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public LeadTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Lead> newLead)
    {
        system.debug('Lead Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Lead> newLead, Map<ID, Lead> newLeadMap)
    {
        system.debug('Lead Trigger On After Insert');
        LeadActions.ConvertLeadAutomation(newLead, newLeadMap);
    }
    public void OnAfterUpdate( List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap, Map<ID, Lead> oldLeadMap)
    {
        system.debug('Lead Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Lead> newLead, List<Lead> oldLead, Map<ID, Lead> newLeadMap , Map<ID, Lead> oldLeadMap)
    {
        system.debug('Lead Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Lead> newLead)
    {
        system.debug('Lead Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Lead> oldLead)
    {
        system.debug('Lead Trigger On After Delete');        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newLeadIDs)
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