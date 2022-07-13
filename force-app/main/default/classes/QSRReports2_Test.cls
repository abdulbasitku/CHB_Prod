@isTest
public class QSRReports2_Test {
    
    @testSetup
    static void dataSetup() {
        
        Product_Family__c productFamily = DataFactory.CreateProductFamily('TestProductFamily');
        Product2 product = DataFactory.CreateProduct('TestProduct', productFamily.Id); 
        PricebookEntry prcBkEntry = DataFactory.CreatePricebookEntry(product.Id, Test.getStandardPricebookId(), 56);
        Account account = DataFactory.CreateAccount('TestAccount');
        Contact contact = DataFactory.CreateContact('TestContact', account.Id);
        Opportunity opportunity = DataFactory.CreateOpportunity('TestOpportunity', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity2 = DataFactory.CreateOpportunity('TestOpportunity2', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity3 = DataFactory.CreateOpportunity('TestOpportunity3', account.Id, Test.getStandardPricebookId(),'');
        
        
        Opportunity opportunity4 = DataFactory.CreateOpportunity('TestOpportunity4', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity4a = DataFactory.CreateOpportunity('TestOpportunity4a', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity4b = DataFactory.CreateOpportunity('TestOpportunity4b', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity5 = DataFactory.CreateOpportunity('TestOpportunity5', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity5a = DataFactory.CreateOpportunity('TestOpportunity5a', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity5b = DataFactory.CreateOpportunity('TestOpportunity5b', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity5c = DataFactory.CreateOpportunity('TestOpportunity5c', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity6 = DataFactory.CreateOpportunity('TestOpportunity6', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity6a = DataFactory.CreateOpportunity('TestOpportunity6a', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity6b = DataFactory.CreateOpportunity('TestOpportunity6b', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity6c = DataFactory.CreateOpportunity('TestOpportunity6c', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity7 = DataFactory.CreateOpportunity('TestOpportunity7', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity7a = DataFactory.CreateOpportunity('TestOpportunity7a', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity7b = DataFactory.CreateOpportunity('TestOpportunity7b', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity7c = DataFactory.CreateOpportunity('TestOpportunity7c', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity8 = DataFactory.CreateOpportunity('TestOpportunity8', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity8a = DataFactory.CreateOpportunity('TestOpportunity8a', account.Id, Test.getStandardPricebookId(),'');        
        Opportunity opportunity8b = DataFactory.CreateOpportunity('TestOpportunity8b', account.Id, Test.getStandardPricebookId(),'');        
        Opportunity opportunity8c = DataFactory.CreateOpportunity('TestOpportunity8c', account.Id, Test.getStandardPricebookId(),'');
        
        
        Opportunity opportunity9 = DataFactory.CreateOpportunity('TestOpportunity9', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity9a = DataFactory.CreateOpportunity('TestOpportunity9a', account.Id, Test.getStandardPricebookId(),'');        
        Opportunity opportunity9b = DataFactory.CreateOpportunity('TestOpportunity9b', account.Id, Test.getStandardPricebookId(),'');        
        Opportunity opportunity9c = DataFactory.CreateOpportunity('TestOpportunity9c', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity10 = DataFactory.CreateOpportunity('TestOpportunity10', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity11 = DataFactory.CreateOpportunity('TestOpportunity11', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity11a = DataFactory.CreateOpportunity('TestOpportunity11a', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity11b = DataFactory.CreateOpportunity('TestOpportunity11b', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity11c = DataFactory.CreateOpportunity('TestOpportunity11c', account.Id, Test.getStandardPricebookId(),'');
                
        Opportunity opportunity12 = DataFactory.CreateOpportunity('TestOpportunity11', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity12a = DataFactory.CreateOpportunity('TestOpportunity11a', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity12b = DataFactory.CreateOpportunity('TestOpportunity11b', account.Id, Test.getStandardPricebookId(),'');
        Opportunity opportunity12c = DataFactory.CreateOpportunity('TestOpportunity11c', account.Id, Test.getStandardPricebookId(),'');
        
        Opportunity opportunity13 = DataFactory.CreateOpportunity('TestOpportunity13', account.Id, Test.getStandardPricebookId(),'');
        //allOppStageHistory.add(new OpportunityFieldHistory(OpportunityId=opportunity.Id, Field='StageName'));
        
        opportunity.Type = 'New Business';        
        opportunity2.Type = 'New Business';
        opportunity3.Type = 'New Business';                
        opportunity4.Type = 'New Business';               
        opportunity4a.Type = 'New Business';               
        opportunity4b.Type = 'New Business';
        
        opportunity5.Type = 'New Business';
        opportunity5a.Type = 'New Business';
        opportunity5b.Type = 'New Business';
        opportunity5c.Type = 'New Business';
        
        opportunity6.Type = 'New Business';
        opportunity6a.Type = 'New Business';
        opportunity6b.Type = 'New Business';
        opportunity6c.Type = 'New Business';
        
        opportunity7.Type = 'New Business';
        opportunity7a.Type = 'New Business';
        opportunity7b.Type = 'New Business';
        opportunity7c.Type = 'New Business';
        
        opportunity8.Type = 'New Business';
        opportunity8a.Type = 'New Business';
        opportunity8b.Type = 'New Business';
        opportunity8c.Type = 'New Business';   
        
        opportunity9.Type = 'New Business';
        opportunity9a.Type = 'New Business';
        opportunity9b.Type = 'New Business';
        opportunity9c.Type = 'New Business';
        
        opportunity10.Type = 'New Business';
        
        opportunity11.Type = 'New Business';
        opportunity11a.Type = 'New Business';
        opportunity11b.Type = 'New Business';
        opportunity11c.Type = 'New Business';
        
        opportunity12.Type = 'New Business';
        opportunity12a.Type = 'New Business';
        opportunity12b.Type = 'New Business';
        opportunity12c.Type = 'New Business';
        
        opportunity13.Type = 'New Business';
        
        opportunity.Product_Family__C = productFamily.Id;        
        opportunity2.Product_Family__C = productFamily.Id; 
        opportunity3.Product_Family__C = productFamily.Id; 
        opportunity4.Product_Family__C = productFamily.Id; 
        opportunity4a.Product_Family__C = productFamily.Id;                
        opportunity4b.Product_Family__C = productFamily.Id; 
        
        opportunity5.Product_Family__C = productFamily.Id; 
        opportunity5a.Product_Family__C = productFamily.Id; 
        opportunity5b.Product_Family__C = productFamily.Id; 
        opportunity5c.Product_Family__C = productFamily.Id; 
        
        opportunity6.Product_Family__C = productFamily.Id; 
        opportunity6a.Product_Family__C = productFamily.Id; 
        opportunity6b.Product_Family__C = productFamily.Id; 
        opportunity6c.Product_Family__C = productFamily.Id; 
        
        opportunity7.Product_Family__C = productFamily.Id; 
        opportunity7a.Product_Family__C = productFamily.Id; 
        opportunity7b.Product_Family__C = productFamily.Id; 
        opportunity7c.Product_Family__C = productFamily.Id; 
        
        opportunity8.Product_Family__C = productFamily.Id; 
        opportunity8a.Product_Family__C = productFamily.Id; 
        opportunity8b.Product_Family__C = productFamily.Id; 
        opportunity8c.Product_Family__C = productFamily.Id; 
        
        opportunity9.Product_Family__C = productFamily.Id; 
        opportunity9a.Product_Family__C = productFamily.Id; 
        opportunity9b.Product_Family__C = productFamily.Id; 
        opportunity9c.Product_Family__C = productFamily.Id; 
        
        opportunity10.Product_Family__C = productFamily.Id; 
        
        opportunity11.Product_Family__C = productFamily.Id; 
        opportunity11a.Product_Family__C = productFamily.Id; 
        opportunity11b.Product_Family__C = productFamily.Id; 
        opportunity11c.Product_Family__C = productFamily.Id; 
        
        opportunity12.Product_Family__C = productFamily.Id; 
        opportunity12a.Product_Family__C = productFamily.Id; 
        opportunity12b.Product_Family__C = productFamily.Id; 
        opportunity12c.Product_Family__C = productFamily.Id; 
        
        opportunity.StageName = 'Unqualified';
        opportunity2.StageName = 'Marketing Qualified';
        opportunity3.StageName = 'Confirmed - SQL';
        
        opportunity4.StageName = 'Closed Won';
        opportunity4a.StageName = 'Closed Won';
        opportunity4b.StageName = 'Closed Won';
        
        opportunity5.StageName = 'Closed - Nurture'; 
        opportunity5a.StageName = 'Closed - Nurture';
        opportunity5b.StageName = 'Closed - Nurture';
        opportunity5c.StageName = 'Closed - Nurture';
        
        opportunity6.StageName = 'Closed - Not Interested';
        opportunity6a.StageName = 'Closed - Not Interested';
        opportunity6b.StageName = 'Closed - Not Interested';
        opportunity6c.StageName = 'Closed - Not Interested';
        
        opportunity7.StageName = 'Closed - Disqualified';
        opportunity7a.StageName = 'Closed - Disqualified';
        opportunity7b.StageName = 'Closed - Disqualified';
        opportunity7c.StageName = 'Closed - Disqualified';
        
        opportunity8.StageName = 'Closed Won';
        opportunity8a.StageName = 'Closed Won';
        opportunity8b.StageName = 'Closed Won';
        opportunity8c.StageName = 'Closed Won';
        
        opportunity9.StageName = 'Closed Won';
        opportunity9a.StageName = 'Closed Won';
        opportunity9b.StageName = 'Closed Won';
        opportunity9c.StageName = 'Closed Won';
        
        opportunity11.StageName = 'Closed Lost';
        opportunity11a.StageName = 'Closed Lost';
        opportunity11b.StageName = 'Closed Lost'; 
        opportunity11c.StageName = 'Closed Lost'; 
        
        opportunity12.StageName = 'Closed No Decision';
        opportunity12a.StageName = 'Closed No Decision';
        opportunity12b.StageName = 'Closed No Decision'; 
        opportunity12c.StageName = 'Closed No Decision'; 
        
        opportunity4.First_Source__c = 'Website Resources';
        opportunity4a.First_Source__c = 'Website';
        opportunity4b.Last_Source__c = 'Webinar';               
        
        opportunity8.First_Source__c = 'Direct mail';
        opportunity8a.First_Source__c = 'Event/Tradeshow';
        opportunity8b.First_Source__c = 'Industry List';
        opportunity8c.First_Source__c = 'Industry Referral';
        
        opportunity9.Last_Source__c = 'Marketing email';
        opportunity9a.Last_Source__c = 'Online banner';
        opportunity9b.Last_Source__c = 'Pay per click Ads';
        opportunity9c.Last_Source__c = 'Social Media';
        
        //Test.setCreatedDate(opportunity10.Id, Datetime.Now());
        
        Datetime lq = Datetime.now().addmonths(-3);
        Test.setCreatedDate(opportunity5.Id, lq);
        opportunity5.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6.Id, lq);
        opportunity6.CloseDate = lq.date();
        Test.setCreatedDate(opportunity7.Id, lq);
        opportunity7.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8.Id, lq);
        opportunity8.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9.Id, lq);
        opportunity9.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11.Id, lq);
        opportunity11.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12.Id, lq);
        opportunity12.CloseDate = lq.date();
        
        lq = Datetime.now().addmonths(-6);
        Test.setCreatedDate(opportunity5a.Id, lq);
        opportunity5a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6a.Id, lq);
        opportunity6a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity7a.Id, lq);
        opportunity7a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8a.Id, lq);
        opportunity8a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9a.Id, lq);
        opportunity9a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11a.Id, lq);
        opportunity11a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12a.Id, lq);
        opportunity12a.CloseDate = lq.date();
        
        lq = Datetime.now().addmonths(-9);
        Test.setCreatedDate(opportunity5b.Id, lq);
        opportunity5b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6b.Id, lq);
        opportunity6b.CloseDate = lq.date();        
        Test.setCreatedDate(opportunity7b.Id, lq);
        opportunity7b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8b.Id, lq);
        opportunity8b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9b.Id, lq);
        opportunity9b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11b.Id, lq);
        opportunity11b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12b.Id, lq);
        opportunity12b.CloseDate = lq.date();
        
        lq = Datetime.now().addmonths(-12);
        Test.setCreatedDate(opportunity5c.Id, lq);
        opportunity5c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6c.Id, lq);
        opportunity6c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity7c.Id, lq);
        opportunity7c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8c.Id, lq);
        opportunity8c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9c.Id, lq);
        opportunity9c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11c.Id, lq);
        opportunity11c.CloseDate = lq.date();        
        Test.setCreatedDate(opportunity12c.Id, lq);
        opportunity12c.CloseDate = lq.date();
        
        opportunity.Amount = 100;        
        opportunity2.Amount = 100;
        opportunity3.Amount = 100;                
        opportunity4.Amount = 100;               
        opportunity4a.Amount = 100;               
        opportunity4b.Amount = 100;
        opportunity5.Amount = 100;
        opportunity6.Amount = 100;
        opportunity7.Amount = 100;
        
        opportunity8.Amount = 100;
        opportunity8a.Amount = 100;
        opportunity8b.Amount = 100;
        opportunity8c.Amount = 100;  
        
        opportunity9.Amount = 100;
        opportunity9a.Amount = 100;
        opportunity9b.Amount = 100;
        opportunity9c.Amount = 100;  
        
        opportunity10.Amount = 100;  
        
        opportunity11.Amount = 100;
        opportunity11a.Amount = 100;
        opportunity11b.Amount = 100;
        opportunity11c.Amount = 100;  
        
        opportunity12.Amount = 100;
        opportunity12a.Amount = 100;
        opportunity12b.Amount = 100;
        opportunity12c.Amount = 100;  
        
        opportunity13.Amount = 100;  
        
        List<Opportunity> opps = new List<Opportunity>();
        opps.add(opportunity);
        opps.add(opportunity2);
        opps.add(opportunity3);
        
        opps.add(opportunity4); 
        opps.add(opportunity4a);
        opps.add(opportunity4b);
        
        opps.add(opportunity5);
        opps.add(opportunity5a);
        opps.add(opportunity5b);        
        opps.add(opportunity5c);
        
        opps.add(opportunity6);
        opps.add(opportunity6a);
        opps.add(opportunity6b);        
        opps.add(opportunity6c);
        
        opps.add(opportunity7);
        opps.add(opportunity7a);
        opps.add(opportunity7b);        
        opps.add(opportunity7c);
        
        opps.add(opportunity8);
        opps.add(opportunity8a);
        opps.add(opportunity8b);        
        opps.add(opportunity8c);        
        
        opps.add(opportunity9);
        opps.add(opportunity9a);
        opps.add(opportunity9b);        
        opps.add(opportunity9c);
        
        opps.add(opportunity10);
        
        opps.add(opportunity11);
        opps.add(opportunity11a);
        opps.add(opportunity11b);
        opps.add(opportunity11c);
        
        opps.add(opportunity12);
        opps.add(opportunity12a);
        opps.add(opportunity12b);
        opps.add(opportunity12c);
        
        opps.add(opportunity13);
        
        update opps;
        
        opportunity = DataFactory.CreateOpportunity('TestOpportunity', account.Id, Test.getStandardPricebookId(),'');
        opportunity2 = DataFactory.CreateOpportunity('TestOpportunity2', account.Id, Test.getStandardPricebookId(),'');
        opportunity3 = DataFactory.CreateOpportunity('TestOpportunity3', account.Id, Test.getStandardPricebookId(),'');
        
        
        opportunity4 = DataFactory.CreateOpportunity('TestOpportunity4', account.Id, Test.getStandardPricebookId(),'');
        opportunity4a = DataFactory.CreateOpportunity('TestOpportunity4a', account.Id, Test.getStandardPricebookId(),'');
        opportunity4b = DataFactory.CreateOpportunity('TestOpportunity4b', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity5 = DataFactory.CreateOpportunity('TestOpportunity5', account.Id, Test.getStandardPricebookId(),'');
        opportunity5a = DataFactory.CreateOpportunity('TestOpportunity5a', account.Id, Test.getStandardPricebookId(),'');
        opportunity5b = DataFactory.CreateOpportunity('TestOpportunity5b', account.Id, Test.getStandardPricebookId(),'');
        opportunity5c = DataFactory.CreateOpportunity('TestOpportunity5c', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity6 = DataFactory.CreateOpportunity('TestOpportunity6', account.Id, Test.getStandardPricebookId(),'');
        opportunity6a = DataFactory.CreateOpportunity('TestOpportunity6a', account.Id, Test.getStandardPricebookId(),'');
        opportunity6b = DataFactory.CreateOpportunity('TestOpportunity6b', account.Id, Test.getStandardPricebookId(),'');
        opportunity6c = DataFactory.CreateOpportunity('TestOpportunity6c', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity7 = DataFactory.CreateOpportunity('TestOpportunity7', account.Id, Test.getStandardPricebookId(),'');
        opportunity7a = DataFactory.CreateOpportunity('TestOpportunity7a', account.Id, Test.getStandardPricebookId(),'');
        opportunity7b = DataFactory.CreateOpportunity('TestOpportunity7b', account.Id, Test.getStandardPricebookId(),'');
        opportunity7c = DataFactory.CreateOpportunity('TestOpportunity7c', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity8 = DataFactory.CreateOpportunity('TestOpportunity8', account.Id, Test.getStandardPricebookId(),'');
        opportunity8a = DataFactory.CreateOpportunity('TestOpportunity8a', account.Id, Test.getStandardPricebookId(),'');        
        opportunity8b = DataFactory.CreateOpportunity('TestOpportunity8b', account.Id, Test.getStandardPricebookId(),'');        
        opportunity8c = DataFactory.CreateOpportunity('TestOpportunity8c', account.Id, Test.getStandardPricebookId(),'');
        
        
        opportunity9 = DataFactory.CreateOpportunity('TestOpportunity9', account.Id, Test.getStandardPricebookId(),'');
        opportunity9a = DataFactory.CreateOpportunity('TestOpportunity9a', account.Id, Test.getStandardPricebookId(),'');        
        opportunity9b = DataFactory.CreateOpportunity('TestOpportunity9b', account.Id, Test.getStandardPricebookId(),'');        
        opportunity9c = DataFactory.CreateOpportunity('TestOpportunity9c', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity10 = DataFactory.CreateOpportunity('TestOpportunity10', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity11 = DataFactory.CreateOpportunity('TestOpportunity11', account.Id, Test.getStandardPricebookId(),'');
        opportunity11a = DataFactory.CreateOpportunity('TestOpportunity11a', account.Id, Test.getStandardPricebookId(),'');
        opportunity11b = DataFactory.CreateOpportunity('TestOpportunity11b', account.Id, Test.getStandardPricebookId(),'');
        opportunity11c = DataFactory.CreateOpportunity('TestOpportunity11c', account.Id, Test.getStandardPricebookId(),'');
                
        opportunity12 = DataFactory.CreateOpportunity('TestOpportunity12', account.Id, Test.getStandardPricebookId(),'');
        opportunity12a = DataFactory.CreateOpportunity('TestOpportunity12a', account.Id, Test.getStandardPricebookId(),'');
        opportunity12b = DataFactory.CreateOpportunity('TestOpportunity12b', account.Id, Test.getStandardPricebookId(),'');
        opportunity12c = DataFactory.CreateOpportunity('TestOpportunity12c', account.Id, Test.getStandardPricebookId(),'');
        
        opportunity13 = DataFactory.CreateOpportunity('TestOpportunity13', account.Id, Test.getStandardPricebookId(),'');
        
        //allOppStageHistory.add(new OpportunityFieldHistory(OpportunityId=opportunity.Id, Field='StageName'));
        
        opportunity.Type = 'Existing Business - Existing Product';        
        opportunity2.Type = 'Existing Business - Existing Product';
        opportunity3.Type = 'Existing Business - Existing Product';   
        
        
        opportunity4.Type = 'Existing Business - Existing Product';   
        opportunity4a.Type = 'Existing Business - Existing Product';   
        opportunity4b.Type = 'Existing Business - Existing Product'; 
        
        opportunity5.Type = 'Existing Business - Existing Product';   
        opportunity5a.Type = 'Existing Business - Existing Product';   
        opportunity5b.Type = 'Existing Business - Existing Product';   
        opportunity5c.Type = 'Existing Business - Existing Product';   
        
        opportunity6.Type = 'Existing Business - Existing Product';   
        opportunity6a.Type = 'Existing Business - Existing Product';   
        opportunity6b.Type = 'Existing Business - Existing Product';   
        opportunity6c.Type = 'Existing Business - Existing Product';   
        
        opportunity7.Type = 'Existing Business - Existing Product';   
        opportunity7a.Type = 'Existing Business - Existing Product';   
        opportunity7b.Type = 'Existing Business - Existing Product';   
        opportunity7c.Type = 'Existing Business - Existing Product';   
        
        opportunity8.Type = 'Existing Business - Existing Product';   
        opportunity8a.Type = 'Existing Business - Existing Product';   
        opportunity8b.Type = 'Existing Business - Existing Product';   
        opportunity8c.Type = 'Existing Business - Existing Product';   
        
        opportunity9.Type = 'Existing Business - Existing Product';   
        opportunity9a.Type = 'Existing Business - Existing Product';   
        opportunity9b.Type = 'Existing Business - Existing Product';   
        opportunity9c.Type = 'Existing Business - Existing Product';   
        
        opportunity10.Type = 'Existing Business - Existing Product';
        
        opportunity11.Type = 'Existing Business - Existing Product';
        opportunity11a.Type = 'Existing Business - Existing Product';
        opportunity11b.Type = 'Existing Business - Existing Product';
        opportunity11c.Type = 'Existing Business - Existing Product';
        
        opportunity12.Type = 'Existing Business - Existing Product';
        opportunity12a.Type = 'Existing Business - Existing Product';
        opportunity12b.Type = 'Existing Business - Existing Products';
        opportunity12c.Type = 'Existing Business - Existing Product';
        
        opportunity13.Type = 'Existing Business - Existing Product';
        
        opportunity.Product_Family__C = productFamily.Id;        
        opportunity2.Product_Family__C = productFamily.Id; 
        opportunity3.Product_Family__C = productFamily.Id; 
        opportunity4.Product_Family__C = productFamily.Id; 
        opportunity4a.Product_Family__C = productFamily.Id;                
        opportunity4b.Product_Family__C = productFamily.Id; 
        
        opportunity5.Product_Family__C = productFamily.Id; 
        opportunity5a.Product_Family__C = productFamily.Id; 
        opportunity5b.Product_Family__C = productFamily.Id; 
        opportunity5c.Product_Family__C = productFamily.Id; 
        
        opportunity6.Product_Family__C = productFamily.Id; 
        opportunity6a.Product_Family__C = productFamily.Id; 
        opportunity6b.Product_Family__C = productFamily.Id; 
        opportunity6c.Product_Family__C = productFamily.Id; 
        
        opportunity7.Product_Family__C = productFamily.Id; 
        opportunity7a.Product_Family__C = productFamily.Id; 
        opportunity7b.Product_Family__C = productFamily.Id; 
        opportunity7c.Product_Family__C = productFamily.Id; 
        
        opportunity8.Product_Family__C = productFamily.Id; 
        opportunity8a.Product_Family__C = productFamily.Id; 
        opportunity8b.Product_Family__C = productFamily.Id; 
        opportunity8c.Product_Family__C = productFamily.Id; 
        
        opportunity9.Product_Family__C = productFamily.Id; 
        opportunity9a.Product_Family__C = productFamily.Id; 
        opportunity9b.Product_Family__C = productFamily.Id; 
        opportunity9c.Product_Family__C = productFamily.Id;  
        
        opportunity10.Product_Family__C = productFamily.Id;
        
        opportunity11.Product_Family__C = productFamily.Id; 
        opportunity11a.Product_Family__C = productFamily.Id; 
        opportunity11b.Product_Family__C = productFamily.Id; 
        opportunity11c.Product_Family__C = productFamily.Id; 
        
        opportunity12.Product_Family__C = productFamily.Id; 
        opportunity12a.Product_Family__C = productFamily.Id; 
        opportunity12b.Product_Family__C = productFamily.Id; 
        opportunity12c.Product_Family__C = productFamily.Id; 
        
        opportunity.StageName = 'Unqualified';
        opportunity2.StageName = 'Marketing Qualified';
        opportunity3.StageName = 'Confirmed - SQL';
        
        opportunity4.StageName = 'Closed Won';
        opportunity4a.StageName = 'Closed Won';
        opportunity4b.StageName = 'Closed Won';
        
        opportunity5.StageName = 'Closed - Nurture'; 
        opportunity5a.StageName = 'Closed - Nurture';
        opportunity5b.StageName = 'Closed - Nurture';
        opportunity5c.StageName = 'Closed - Nurture';
        
        opportunity6.StageName = 'Closed - Not Interested';
        opportunity6a.StageName = 'Closed - Not Interested';
        opportunity6b.StageName = 'Closed - Not Interested';
        opportunity6c.StageName = 'Closed - Not Interested';
        
        opportunity7.StageName = 'Closed - Disqualified';
        opportunity7a.StageName = 'Closed - Disqualified';
        opportunity7b.StageName = 'Closed - Disqualified';
        opportunity7c.StageName = 'Closed - Disqualified';
        
        opportunity8.StageName = 'Closed Won';
        opportunity8a.StageName = 'Closed Won';
        opportunity8b.StageName = 'Closed Won';
        opportunity8c.StageName = 'Closed Won';
        
        opportunity9.StageName = 'Closed Won';
        opportunity9a.StageName = 'Closed Won';
        opportunity9b.StageName = 'Closed Won';
        opportunity9c.StageName = 'Closed Won';
        
        opportunity11.StageName = 'Closed Lost';
        opportunity11a.StageName = 'Closed Lost';
        opportunity11b.StageName = 'Closed Lost'; 
        opportunity11c.StageName = 'Closed Lost'; 
        
        opportunity12.StageName = 'Closed No Decision';
        opportunity12a.StageName = 'Closed No Decision';
        opportunity12b.StageName = 'Closed No Decision'; 
        opportunity12c.StageName = 'Closed No Decision'; 
        
        opportunity4.First_Source__c = 'Website Resources';
        opportunity4a.First_Source__c = 'Website';
        opportunity4b.Last_Source__c = 'Webinar';               
        
        opportunity8.First_Source__c = 'Direct mail';
        opportunity8a.First_Source__c = 'Event/Tradeshow';
        opportunity8b.First_Source__c = 'Industry List';
        opportunity8c.First_Source__c = 'Industry Referral';
        
        opportunity9.Last_Source__c = 'Marketing email';
        opportunity9a.Last_Source__c = 'Online banner';
        opportunity9b.Last_Source__c = 'Pay per click Ads';
        opportunity9c.Last_Source__c = 'Social Media';
                
        //Test.setCreatedDate(opportunity10.Id, Datetime.Now());
        
        lq = Datetime.now().addmonths(-3);
        Test.setCreatedDate(opportunity5.Id, lq);
        opportunity5.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6.Id, lq);
        opportunity6.CloseDate = lq.date();
        Test.setCreatedDate(opportunity7.Id, lq);
        opportunity7.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8.Id, lq);
        opportunity8.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9.Id, lq);
        opportunity9.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11.Id, lq);
        opportunity11.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12.Id, lq);
        opportunity12.CloseDate = lq.date();
        
        lq = Datetime.now().addmonths(-6);
        Test.setCreatedDate(opportunity5a.Id, lq);
        opportunity5a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6a.Id, lq);
        opportunity6a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity7a.Id, lq);
        opportunity7a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8a.Id, lq);
        opportunity8a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9a.Id, lq);
        opportunity9a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11a.Id, lq);
        opportunity11a.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12a.Id, lq);
        opportunity12a.CloseDate = lq.date();
        
        lq = Datetime.now().addmonths(-9);
        Test.setCreatedDate(opportunity5b.Id, lq);
        opportunity5b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6b.Id, lq);
        opportunity6b.CloseDate = lq.date();        
        Test.setCreatedDate(opportunity7b.Id, lq);
        opportunity7b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8b.Id, lq);
        opportunity8b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9b.Id, lq);
        opportunity9b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11b.Id, lq);
        opportunity11b.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12b.Id, lq);
        opportunity12b.CloseDate = lq.date();
        
        lq = Datetime.now().addmonths(-12);
        Test.setCreatedDate(opportunity5c.Id, lq);
        opportunity5c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity6c.Id, lq);
        opportunity6c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity7c.Id, lq);
        opportunity7c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity8c.Id, lq);
        opportunity8c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity9c.Id, lq);
        opportunity9c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity11c.Id, lq);
        opportunity11c.CloseDate = lq.date();
        Test.setCreatedDate(opportunity12c.Id, lq);
        opportunity12c.CloseDate = lq.date();
        
        opportunity.Amount = 100;        
        opportunity2.Amount = 100;
        opportunity3.Amount = 100;                
        opportunity4.Amount = 100;               
        opportunity4a.Amount = 100;               
        opportunity4b.Amount = 100;
        opportunity5.Amount = 100;
        opportunity6.Amount = 100;
        opportunity7.Amount = 100;
        
        opportunity8.Amount = 100;
        opportunity8a.Amount = 100;
        opportunity8b.Amount = 100;
        opportunity8c.Amount = 100;  
        
        opportunity9.Amount = 100;
        opportunity9a.Amount = 100;
        opportunity9b.Amount = 100;
        opportunity9c.Amount = 100;  
        
        opportunity10.Amount = 100; 
                
        opportunity11.Amount = 100;
        opportunity11a.Amount = 100;
        opportunity11b.Amount = 100;
        opportunity11c.Amount = 100;  
        
        opportunity12.Amount = 100;
        opportunity12a.Amount = 100;
        opportunity12b.Amount = 100;
        opportunity12c.Amount = 100; 
        
        opportunity13.Amount = 100; 
        
        opps = new List<Opportunity>();
        opps.add(opportunity);
        opps.add(opportunity2);
        opps.add(opportunity3);
        
        opps.add(opportunity4); 
        opps.add(opportunity4a);
        opps.add(opportunity4b);
        
        opps.add(opportunity5);
        opps.add(opportunity5a);
        opps.add(opportunity5b);        
        opps.add(opportunity5c);
        
        opps.add(opportunity6);
        opps.add(opportunity6a);
        opps.add(opportunity6b);        
        opps.add(opportunity6c);
        
        opps.add(opportunity7);
        opps.add(opportunity7a);
        opps.add(opportunity7b);        
        opps.add(opportunity7c);
        
        opps.add(opportunity8);
        opps.add(opportunity8a);
        opps.add(opportunity8b);        
        opps.add(opportunity8c);        
        
        opps.add(opportunity9);
        opps.add(opportunity9a);
        opps.add(opportunity9b);        
        opps.add(opportunity9c);
        
        opps.add(opportunity10);
        
        opps.add(opportunity11);
        opps.add(opportunity11a);
        opps.add(opportunity11b);
        opps.add(opportunity11c);
        
        opps.add(opportunity12);
        opps.add(opportunity12a);
        opps.add(opportunity12b);
        opps.add(opportunity12c);

        opps.add(opportunity13);
        
        update opps;
        
    }
    
    static testMethod void GenerateQSRReports_Test()
    {
        system.debug('Method --> GenerateQSRReports_Test --> Start');        
        List<OpportunityFieldHistory> allOppStageHistory = new List<OpportunityFieldHistory>();
        List<Opportunity> opps = [Select Id, name from Opportunity];
                
        allOppStageHistory = Test.loadData(OpportunityFieldHistory.sObjectType, 'OppFieldHistoryDataWithoutOpp');
        
        QSRReports2.GenerateQSRReportMarketingByProductFamilyB(Date.today(), true);
        QSRReports2.GenerateQSRReportMarketingByProductFamilyB(Date.today(), false);
        
        system.debug('Method --> GenerateQSRReports_Test --> end');
        
    }
    
}