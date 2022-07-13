public with sharing class CampaignTriggerHandler 
{
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;
    
    public CampaignTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

    public void OnBeforeInsert(List<Campaign> newCampaign)
    {
        system.debug('Campaign Trigger On Before Insert');
    }
    public void OnAfterInsert(List<Campaign> newCampaign)
    {
        system.debug('Campaign Trigger On After Insert');
        CampaignActions.AddCampaignMemberStatuses (newCampaign);
    }
    public void OnAfterUpdate( List<Campaign> newCampaign, List<Campaign> oldCampaign, Map<ID, Campaign> newCampaignMap , Map<ID, Campaign> oldCampaignMap )
    {
        system.debug('Campaign Trigger On After Update ');
    }
    public void OnBeforeUpdate( List<Campaign> newCampaign, List<Campaign> oldCampaign, Map<ID, Campaign> newCampaignMap , Map<ID, Campaign> oldCampaignMap )
    {
        system.debug('Account Trigger On Before Update ');
    }

    public void OnBeforeDelete(List<Campaign> newCampaign)
    {
        system.debug('Campaign Trigger On Before Delete');
    }
    
    public void OnAfterDelete(List<Campaign> oldCampaign)
    {
        system.debug('Campaign Trigger On After Delete');        
    }
    
    /*@future 
    public static void OnAfterUpdateAsync(Set<ID> newCampaignIDs)
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