@isTest
public class DataFactory_Test {
    
    /*static testMethod void CreateAccountOppPriceBkTest() {
        
        Account acct = DataFactory.CreateAccount('TestAccountDft');
        System.assert(acct != null);
        System.assertEquals(acct.Name,'TestAccountDft');
        
        Pricebook2 prcBk = DataFactory.CreatePricebook('TestPrcBk');        
        System.assert(prcBk != null);
        System.assertEquals(prcBk.Name,'TestPrcBk');
        
        Lead ld = DataFactory.CreateLead('TestLead', 'TestLeadCompany');
        System.assert(ld != null);
        System.assertEquals(ld.LastName,'TestLead');
        
        Product_Family__c prodFam = DataFactory.CreateProductFamily('TestProductFamily');
        System.assert(prodFam != null);
        System.assertEquals(prodFam.Name,'TestProductFamily');
        
        Product2 prod = DataFactory.CreateProduct('TestProduct', prodFam.Id);
        System.assert(prod != null);
        System.assertEquals(prod.Name,'TestProduct');
        
        
        Sales_Track__c salesTrack = DataFactory.CreateSalesTrack('TestSalesTrack');
        System.assert(salesTrack != null);
        System.assertEquals(salesTrack.Name,'TestSalesTrack');
        
        Campaign campaign = DataFactory.CreateCampaign('TestCampaign', 'Webinar');
        System.assert(campaign != null);
        System.assertEquals(campaign.Name,'TestCampaign');
        
        Contact contact = DataFactory.CreateContact('TestContactDft', acct.Id);
        System.assert(contact != null);
        System.assertEquals(contact.LastName,'TestContactDft');
        
        Contact_Product__c contactProduct = DataFactory.CreateContactProduct(contact.Id, prod.Id);        
        System.assert(contactProduct != null);
        
        Opportunity opp = DataFactory.CreateOpportunity('TestOpp', acct.Id, Test.getStandardPricebookId(),'');        
        System.assert(opp != null);
        System.assertEquals(opp.Name,'TestOpp');
        
        PricebookEntry prcBkEntry = DataFactory.CreatePricebookEntry(prod.Id, Test.getStandardPricebookId(), 56);        
        System.assert(prcBkEntry != null);
        
        OpportunityLineItem opportunityLineItem = DataFactory.CreateOpportunityLineItem(5, opp.Id, prod.Id, prcBkEntry.Id, prcBkEntry.UnitPrice);       
        System.assert(opportunityLineItem != null);
        
        Quote qt = DataFactory.CreateQuote('TestQuote',opp.Id, Test.getStandardPricebookId());        
        System.assert(qt != null);
        System.assertEquals(qt.Name,'TestQuote');
        
        QuoteLineItem qtLineItem = DataFactory.CreateQuoteLineItem(5, qt.Id, prod.Id, prcBkEntry.Id, 56);       
        System.assert(qtLineItem != null);
        
        Product_Addon__c prodAddon = DataFactory.CreateProductAddon('TestProdAddon', prod.Id);        
        System.assert(prodAddon != null);
        System.assertEquals(prodAddon.Name,'TestProdAddon');
                
        ld = DataFactory.UpdateLeadStatusToConvert(ld);
        System.assertEquals(ld.Status, 'Nurturing');
        
        
    }*/
    
    
    
}