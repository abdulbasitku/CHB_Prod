public with sharing class apxAssociateCompetitorController {

    @AuraEnabled
    public static List<Account> getCompetitorAccounts() {
        
        List<Account> allAcct = new List<Account>();
        
        try
        {
            allAcct = [SELECT Id, name FROM Account WHERE type = 'Competitor' ORDER BY createdDate DESC];            
        }
        catch(Exception ex)
        {
            
        }
        return allAcct;
    }
    
    @AuraEnabled
    public static void associateCompetitorAccountWithOpp (id oppId, List<Id> selectedAccountIds) {
                
        List<Competitor__c> compList = [Select Account__r.Id from Competitor__c WHERE Opportunity__r.Id = :oppId];
		List<Id> linkedAccounts = new List<Id>();
        
        List<Competitor__c> competitors = new List<Competitor__c>();
        
        for(Competitor__c comp : compList)
        {
                linkedAccounts.Add(comp.Account__r.Id);           
        }
        
        for (Id acctId : selectedAccountIds)
        {
            if(!linkedAccounts.contains(acctId))
            {
                Competitor__c competitor = new Competitor__c();
                competitor.Opportunity__c = oppId;
                competitor.Account__c = acctId;
                competitors.Add(competitor);
            }
        }
        
        insert(competitors);        
    }    
    
}