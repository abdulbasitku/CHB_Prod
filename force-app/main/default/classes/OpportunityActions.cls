public without sharing class OpportunityActions {
    
    public static void ByPassSalesInitiatedStage( Map<Id, Opportunity> oldOppsMap, List<Opportunity> newOpps)
    {        
        system.debug('Method --> ByPassSalesInitiatedStage() --> Start');
        
        try
        {
            system.debug('Method --> ByPassSalesInitiatedStage() --> Opportunity count: ' + newOpps.size());
            
            for (Opportunity opp : newOpps) {
                
                if(opp.StageName == 'Sales Initiated' &&  oldOppsMap.get(opp.Id).StageName == 'Confirmed - SQL')
                {
                    opp.StageName = 'In Process';
                }
            }
            
        }
        catch(Exception e)
        {
            system.debug('Method --> ByPassSalesInitiatedStage() --> Exception Occured');
            system.debug(e);
        }
        
        system.debug('Method --> ByPassSalesInitiatedStage() --> End');
    }
    
}