public with sharing class apxCreateDefaultQuotesController {

    //Use @AuraEnabled to enable client- and server-side access to the method
    @AuraEnabled
    public static String CreateDefaultQuotesByOppId(id oppId) {
       
        System.debug('Call method CreateDefaultQuotesByOppId');
        
        List<Quote> defaultQuotes = new List<Quote>();
        Opportunity opportunity = [SELECT Id, Name, Product_Family__c, Product_Family__r.Name FROM Opportunity WHERE Id = :oppId];
        List<Sales_Track__c> salesTrackList = [SELECT Id, Name FROM Sales_Track__c];
        if(salesTrackList.size() < 1)
        {
            return ('Add Sale Tracks and Try again');
        }
        
        if(opportunity.Product_Family__c == null)
        {
            return ('Add Product Family and Try again');
        }

        Map<String, Sales_Track__c> salesTrack = new Map<String,Sales_Track__c>();
        for(Sales_Track__c st : salesTrackList)
        {
            salesTrack.put(st.Name, st);
        }
        
        System.debug('SOQL Executed');
        
        if(opportunity.Product_Family__r.Name == 'NEWSTAR'){
            
            Quote quote = new Quote();
            quote.name = 'License and Annual Maintenance';
            quote.OpportunityId = opportunity.Id;
            quote.Product_Family__c = opportunity.Product_Family__c;
            Sales_Track__c tempST = salesTrack.get('License and Maintenance');
            if(tempST == null)
            {
                return ('Add "License and Maintenance" Sale Track and Try again');            
            }
            quote.Sales_Track__c = tempST.Id;
            quote.Quote_Type__c = 'General';
            
            defaultQuotes.add(quote);
            
            quote = new Quote();
            quote.name = 'Pricing for Optional Modules';
            quote.OpportunityId = opportunity.Id;
            quote.Product_Family__c = opportunity.Product_Family__c;
            quote.Sales_Track__c = tempST.Id;
            quote.Quote_Type__c = 'Optional';
            defaultQuotes.add(quote);
            
            quote = new Quote();
            quote.name = 'Annual Rental';
            quote.OpportunityId = opportunity.Id;
            quote.Product_Family__c = opportunity.Product_Family__c;
            tempST = salesTrack.get('Rental');
            if(tempST == null)
            {
                return ('Add "Rental" Sale Track and Try again');            
            }
            quote.Sales_Track__c = tempST.Id;
            quote.Quote_Type__c = 'General';
            defaultQuotes.add(quote);
            
            quote = new Quote();
            quote.name = 'Pricing for Optional Modules - Rental';
            quote.OpportunityId = opportunity.Id;
            quote.Product_Family__c = opportunity.Product_Family__c;
            quote.Sales_Track__c = tempST.Id;
            quote.Quote_Type__c = 'Optional';
            defaultQuotes.add(quote);
            
            quote = new Quote();
            quote.name = 'Implementation and Training Estimate';
            quote.OpportunityId = opportunity.Id;
            quote.Product_Family__c = opportunity.Product_Family__c;
            tempST = salesTrack.get('PSG');
            if(tempST == null)
            {
                return ('Add "PSG" Sale Track and Try again');            
            }
            quote.Sales_Track__c = tempST.Id;
            quote.Quote_Type__c = 'PSG';
            defaultQuotes.add(quote);
        }
        
       if(opportunity.Product_Family__r.Name == 'BuildTopia'){
           
           Quote quote = new Quote();
           quote.name = 'Licenses';
           quote.OpportunityId = opportunity.Id;
           quote.Product_Family__c = opportunity.Product_Family__c;
           Sales_Track__c tempST = salesTrack.get('License and Maintenance');
           if(tempST == null)
           {
               return ('Add "License and Maintenance" Sale Track and Try again');            
           }
           quote.Sales_Track__c = tempST.Id;
           quote.Quote_Type__c = 'General';
           defaultQuotes.add(quote);
           
           quote = new Quote();
           quote.name = 'Implementation and Training Estimate';
           quote.OpportunityId = opportunity.Id;
           quote.Product_Family__c = opportunity.Product_Family__c;
           tempST = salesTrack.get('PSG');
           if(tempST == null)
           {
               return ('Add "PSG" Sale Track and Try again');            
           }
           quote.Sales_Track__c = tempST.Id;
           quote.Quote_Type__c = 'PSG';
           defaultQuotes.add(quote);
       }
        
        Database.SaveResult[] results = Database.insert(defaultQuotes);
        
        // Check results.
        for (Integer i = 0; i < results.size(); i++) {
            if (results[i].isSuccess()) {
                System.debug('Successfully created OrderLineItem ID: ' + results[i].getId());
            } 
            else
            {
                System.debug('Error: could not create sobject ' + 'for array element ' + i + '.');
                System.debug('   The error reported was: ' + results[i].getErrors()[0].getMessage() + '\n');
                return ('Error in creating order');
            }
        }      
        
        return ('Default Quotes Successfully Created');
    }
    
    /*private static List<Quote> CreateQuotesForNewstar()
    {
        List<Quote> defaultQuotes = new List<Quote>();        
           
        return defaultQuotes;
    }
    
    private static List<Quote> CreateQuotesForBuildTopia()
    {
        List<Quote> defaultQuotes = new List<Quote>();       
        
        return defaultQuotes;
    }*/
    
}