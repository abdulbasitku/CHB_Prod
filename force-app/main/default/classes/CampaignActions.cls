public without sharing class CampaignActions 
{
    public static void AddCampaignMemberStatuses ( List<Campaign> newCampaigns)
    {
        /*Set<Id> campaignsIds = (new Map<Id,SObject>(newCampaigns)).keySet();
        
        List<Campaign> campaignsToUpdate = [Select ID, Type FROM Campaign WHERE id in :campaignsIds];
        
        List<CampaignMemberStatus> campaignMemberStatusesToUpdate = [Select Id,Label, CampaignId FROM CampaignMemberStatus WHERE CampaignId in :campaignsIds];
        
        List<ID> updatedCampaignMemberStatusesIds = new List<ID>();
        List<CampaignMemberStatus> newCampaignMemberStatuses = new List<CampaignMemberStatus>();
        List<CampaignMemberStatus> campaignMemberStatusesSentLabel = new List<CampaignMemberStatus>();
        List<CampaignMemberStatus> campaignMemberStatusesRespondLabel = new List<CampaignMemberStatus>();
        Map<ID, List<CampaignMemberStatus>> cmpMembStsByCmpId = new Map<ID, List<CampaignMemberStatus>>();
        
        
        for(CampaignMemberStatus campaignMemberStatusToUpdate : campaignMemberStatusesToUpdate)
        {
            if(cmpMembStsByCmpId.containsKey(campaignMemberStatusToUpdate.CampaignId))
            {
                List<CampaignMemberStatus> tempCampaignMemberStatuses = cmpMembStsByCmpId.get(campaignMemberStatusToUpdate.CampaignId);
                tempCampaignMemberStatuses.add(campaignMemberStatusToUpdate);                
                cmpMembStsByCmpId.put(campaignMemberStatusToUpdate.CampaignId, tempCampaignMemberStatuses);
                
            }
            else
            {
                cmpMembStsByCmpId.put(campaignMemberStatusToUpdate.CampaignId, new List<CampaignMemberStatus>{campaignMemberStatusToUpdate});
            }
        }
        
        for(Campaign campaign : campaignsToUpdate)
        {            
            newCampaignMemberStatuses.AddAll(AddCampaignMemberStatusByType(campaign));
            
            if(cmpMembStsByCmpId != null){
                
                List<CampaignMemberStatus> currCampaignCmpMembStses = new List<CampaignMemberStatus>();
                
                if(cmpMembStsByCmpId.containsKey(campaign.Id))
                {
                    currCampaignCmpMembStses = cmpMembStsByCmpId.get(campaign.Id);
                    
                    for(CampaignMemberStatus campaignMemberStatusToUpdate : currCampaignCmpMembStses)
                    {
                        if(campaignMemberStatusToUpdate.CampaignId == campaign.Id){
                            if(campaignMemberStatusToUpdate.Label == 'Sent')
                            {
                                if(campaign.Type == 'Marketing Email' || campaign.Type == 'Direct Mail' || campaign.Type == 'ABM' || campaign.Type == 'SF Nurture')
                                {
                                    campaignMemberStatusToUpdate.IsDefault = true;
                                    campaignMemberStatusToUpdate.HasResponded = true;
                                    campaignMemberStatusesSentLabel.add(campaignMemberStatusToUpdate);
                                }
                                else
                                {
                                    campaignMemberStatusesRespondLabel.add(campaignMemberStatusToUpdate);
                                }
                            }
                            else
                            {
                                campaignMemberStatusesRespondLabel.add(campaignMemberStatusToUpdate);
                            }
                        }
                    }
                }
            }            
        }   
        
        Database.SaveResult[] results = Database.insert(newCampaignMemberStatuses);
        
        for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                updatedCampaignMemberStatusesIds.add(result.getId());
            }
        }       
        
        results = Database.update(campaignMemberStatusesSentLabel);
        
        for (Database.SaveResult result : results) {
            if (result.isSuccess()) {
                updatedCampaignMemberStatusesIds.add(result.getId());
            }
        }        
        
        Database.DeleteResult[] delResults = Database.delete(campaignMemberStatusesRespondLabel);
        
        for (Database.DeleteResult result : delResults) {
            if (result.isSuccess()) {
                updatedCampaignMemberStatusesIds.add(result.getId());
            }
        }     */           
    }
    
    public static List<CampaignMemberStatus> AddCampaignMemberStatusByType (Campaign campaign)
    {       
        
        List<CampaignMemberStatus> campaignMemberStatuses = new List<CampaignMemberStatus>();
       /* if(campaign.Type == 'Webinar')
        {
            CampaignMemberStatus campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Registered ';
            campaignMemberStatus1.IsDefault = true;
            campaignMemberStatus1.HasResponded = true;
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Attended';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting scheduled';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Not Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Could Not Reach';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Might be interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Viewed Recorded';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);           
            
        }
        if(campaign.Type == 'Marketing Email')
        {
            CampaignMemberStatus campaignMemberStatus1 = new CampaignMemberStatus();
            //campaignMemberStatus1.CampaignId = campaign.Id;
            //campaignMemberStatus1.Label = 'Sent ';
            //campaignMemberStatus1.IsDefault = true;
            //campaignMemberStatus1.HasResponded = true;
            
            //campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Not Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Clicked';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting scheduled';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);                    
            
        }
        if(campaign.Type == 'Tradeshow / Events')
        {
            CampaignMemberStatus campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Visited Booth';
            campaignMemberStatus1.IsDefault = true;
            campaignMemberStatus1.HasResponded = true;
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting scheduled';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting conducted at show';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Could Not Reach';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Not Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Might be interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
        }
        if(campaign.Type == 'Industry List')
        {
            CampaignMemberStatus campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Visited Booth';
            campaignMemberStatus1.IsDefault = true;
            campaignMemberStatus1.HasResponded = true;
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting scheduled';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting conducted at show';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Could Not Reach';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Not Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Might be interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
        }
        if(campaign.Type == 'Customer Conference')
        {
            CampaignMemberStatus campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Registered ';
            campaignMemberStatus1.IsDefault = true;
            campaignMemberStatus1.HasResponded = true;
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Attended';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'No Show';
            
            campaignMemberStatuses.Add(campaignMemberStatus1); 
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting scheduled';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting conducted at show';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Could Not Reach';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Not Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
        }
        if(campaign.Type == 'Direct Mail' || campaign.Type == 'ABM' || campaign.Type == 'SF Nurture')
        {
            CampaignMemberStatus campaignMemberStatus1 = new CampaignMemberStatus();
            //campaignMemberStatus1.CampaignId = campaign.Id;
            //campaignMemberStatus1.Label = 'Sent ';
            //campaignMemberStatus1.IsDefault = true;
            //campaignMemberStatus1.HasResponded = true;
            
            //campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Not Interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Could Not Reach';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Demo/Meeting scheduled';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);  
            
            
            campaignMemberStatus1 = new CampaignMemberStatus();
            campaignMemberStatus1.CampaignId = campaign.Id;
            campaignMemberStatus1.Label = 'Might be interested';
            
            campaignMemberStatuses.Add(campaignMemberStatus1);
        }
        */
        return campaignMemberStatuses;        
    }
    
}