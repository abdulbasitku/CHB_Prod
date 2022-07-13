@isTest
public class AssociateCompetitor_Test{
    testMethod
    static void getCompetitorAccounts_Test ()
    {
        Boolean testPassed = true;
        List<Account> allCompetitors = null;
        try
        {
            allCompetitors = apxAssociateCompetitorController.getCompetitorAccounts();
        }
        catch(Exception ex)
        {

        }          
         
        if(allCompetitors == null)
        {
            testPassed = false;
        }
        
        System.assertEquals(testPassed, true);
        
    }
    
    testMethod
    static void associateCompetitorAccountWithOpp_Test ()
    {
        Boolean testPassed = true;
        List<Account> allCompetitors = null;
        try
        {
            List<Id> cmpAccountIds =  new List<Id>();
            
            Account account1 = DataFactory.CreateAccount('Test Account1');
            
            Id pricebookId = Test.getStandardPricebookId();
            
            Opportunity opportunity1 = DataFactory.CreateOpportunity('Test Opportunity1', account1.Id, pricebookId,'');

            Account cmpAccount1 = DataFactory.CreateAccount('Test CmpAccount1');
            cmpAccountIds.add(cmpAccount1.Id);
            Account cmpAccount2 = DataFactory.CreateAccount('Test CmpAccount2');
            cmpAccountIds.add(cmpAccount2.Id);
            
            apxAssociateCompetitorController.associateCompetitorAccountWithOpp(opportunity1.Id, cmpAccountIds);
            
            List<Competitor__c> compList = [Select Account__r.Id from Competitor__c WHERE Opportunity__r.Id = :opportunity1.Id];
            if(compList.size() != 2)
            {
                System.assertEquals(testPassed, false);                
            }
        }
        catch(Exception ex)
        {
            
        }
        
        System.assertEquals(testPassed, true);         
    }
    
}