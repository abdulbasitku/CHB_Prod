public without sharing class AccountActions {
    
    /*public static void CreateAccountRelatedListObjectOnImport(List<Account> newAccount, Map<ID, Account> newAccountMap)
    {
        
        system.debug('Method --> CreateAccountRelatedListObjectOnImport() --> Start');
        
        List<Account_Product__c> aps = new List<Account_Product__c>();        
        List<Industry_Recognition__c> irs = new List<Industry_Recognition__c>();        
        List<SLX_Infor__c> slxs = new List<SLX_Infor__c>();
        
        try
        {
            List<Product2> products = [Select Id, Name from Product2];
            List<User> users = [Select Id, Name from User];
            
            Map<string,Product2> productMaps = new Map<string,Product2>();
            Map<string,User> userMaps = new Map<string,User>();
            
            for(Product2 prod : products)
            {
                if(!productMaps.containsKey(prod.Name.toLowerCase()))
                {
                    productMaps.put(prod.Name.toLowerCase(), prod);
                }
            }
            
            for(User user : users)
            {
                if(!userMaps.containsKey(user.Name.toLowerCase()))
                {
                    userMaps.put(user.Name.toLowerCase(), user);
                }
            }
            
            for(Account account : newAccount){
                
                if(account.Account_Division__c != null)
                {
                    Account_Product__c ap = new Account_Product__c();
                    ap.Account__c = account.Id;
                    if(productMaps.containsKey(account.Account_Division__c.toLowerCase()))
                    {
                        ap.Product__c = productMaps.get(account.Account_Division__c.toLowerCase()).Id;                        
                    }
                    else
                    {
                        if(productMaps.containsKey('unknown'))
                        {
                            ap.Product__c = productMaps.get('unknown').Id;
                        }
                    }
                    
                    if(string.isNotEmpty(account.Old_SF_Owner_Name__c) && userMaps.containsKey(account.Old_SF_Owner_Name__c.toLowerCase()))
                    {
                        ap.Account_Manager__c = userMaps.get(account.Old_SF_Owner_Name__c.toLowerCase()).Id;                        
                    }
                    
                    aps.Add(ap);
                }	
                
                if(account.Account_Division_2__c != null && !string.isEmpty(account.Account_Division_2__c.trim()))
                {
                    Account_Product__c ap2 = new Account_Product__c();
                    ap2.Account__c = account.Id;
                    if(productMaps.containsKey(account.Account_Division_2__c.trim().toLowerCase()))
                    {
                        ap2.Product__c = productMaps.get(account.Account_Division_2__c.trim().toLowerCase()).Id;                        
                    }
                    
                    if(account.Account_Division_2__c == 'Customer Experience Group')
                    {
                        if((account.HB_Territory__c == 'Can - East' || account.HB_Territory__c == 'US - NorthEast') && userMaps.containsKey('donna moore'))
                        {
                            ap2.Account_Manager__c = userMaps.get('donna moore').Id;
                        }
                        
                        if((account.HB_Territory__c == 'Can - West' || account.HB_Territory__c == 'US - Central' || account.HB_Territory__c == 'US - SouthEast' || account.HB_Territory__c == 'US - West') && userMaps.containsKey('stephanie meade'))
                        {
                            ap2.Account_Manager__c = userMaps.get('stephanie meade').Id;
                        }
                    }
                    
                    aps.Add(ap2);
                }
                
                
                
                if(account.Builder_2019_Ranking__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Ranking__c = account.Builder_2019_Ranking__c;
                    ir.Year__c = '2019';
                    ir.Category__c = 'Builder';
                    irs.Add(ir);
                }	              
                
                if(account.Builder_2015_Ranking__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Ranking__c = account.Builder_2015_Ranking__c;
                    ir.Year__c = '2015';
                    ir.Category__c = 'Builder';
                    irs.Add(ir);
                }
                if(account.Builder_2014_Ranking__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Ranking__c = account.Builder_2014_Ranking__c;
                    ir.Year__c = '2014';
                    ir.Category__c = 'Builder';
                    irs.Add(ir);
                }
                if(account.Professional_Builder_2016_Ranking__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Ranking__c = account.Professional_Builder_2016_Ranking__c;
                    ir.Year__c = '2016';
                    ir.Category__c = 'Professional Builder';
                    irs.Add(ir);
                }
                if(account.Professional_Builder_2015_Ranking__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Ranking__c = account.Professional_Builder_2015_Ranking__c;
                    ir.Year__c = '2015';
                    ir.Category__c = 'Professional Builder';
                    irs.Add(ir);
                }
                if(account.Professional_Builder_2014_Ranking__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Ranking__c = account.Professional_Builder_2014_Ranking__c;
                    ir.Year__c = '2014';
                    ir.Category__c = 'Professional Builder';
                    irs.Add(ir);
                }
                
                if(account.Builder_2019_Closings__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Closings__c = account.Builder_2019_Closings__c;
                    ir.Year__c = '2019';
                    ir.Category__c = 'Builder';
                    irs.Add(ir);
                }
                if(account.Builder_2015_Closings__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Closings__c = account.Builder_2015_Closings__c;
                    ir.Year__c = '2015';
                    ir.Category__c = 'Builder';
                    irs.Add(ir);
                }
                if(account.Builder_2014_Closings__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Closings__c = account.Builder_2014_Closings__c;
                    ir.Year__c = '2014';
                    ir.Category__c = 'Builder';
                    irs.Add(ir);
                }
                if(account.Professional_Builder_2016_Closings__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Closings__c = account.Professional_Builder_2016_Closings__c;
                    ir.Year__c = '2016';
                    ir.Category__c = 'Professional Builder';
                    irs.Add(ir);
                }
                if(account.Professional_Builder_2015_Closings__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Closings__c = account.Professional_Builder_2015_Closings__c;
                    ir.Year__c = '2015';
                    ir.Category__c = 'Professional Builder';
                    irs.Add(ir);
                }
                if(account.Professional_Builder_2014_Closings__c != null)
                {
                    Industry_Recognition__c ir = new Industry_Recognition__c();
                    ir.Account__c = account.Id;
                    ir.Closings__c = account.Professional_Builder_2014_Closings__c;
                    ir.Year__c = '2014';
                    ir.Category__c = 'Professional Builder';
                    irs.Add(ir);
                } 
                
                if(string.isNotEmpty(account.SLX_ID__c))
                {
                    SLX_Infor__c slxInfor = new SLX_Infor__c();
                    slxInfor.Account__c = account.Id;
                    slxInfor.SLX_External_ID__c = account.SLX_ID__c;
                    slxs.Add(slxInfor);
                } 
                
            }
            
            
            String apsJsonString = json.serialize(aps);
            String irsJsonString = json.serialize(irs);
            String slxsJsonString = json.serialize(slxs);
            
            InsertAccountRelatedListObjectOnImport(apsJsonString, irsJsonString, slxsJsonString);            
        }
        catch(Exception e)
        {
            system.debug('Method --> CreateAccountRelatedListObjectOnImport() --> Exception Occured');
            system.debug(e);
        }
        
        system.debug('Method --> CreateAccountRelatedListObjectOnImport() --> End');
    }
    
    @future
    public static void InsertAccountRelatedListObjectOnImport(String apsJsonString, String  irsJsonString, String slxsJsonString)
    {
        
        
        System.debug('Method --> InsertAccountRelatedListObjectOnImport() --> start');
        
        List<Account_Product__c> aps = (List<Account_Product__c>)Json.deserialize(apsJsonString, List<Account_Product__c>.class);
        List<Industry_Recognition__c> irs = (List<Industry_Recognition__c>)Json.deserialize(irsJsonString, List<Industry_Recognition__c>.class);
        List<SLX_Infor__c> slxs = (List<SLX_Infor__c>)Json.deserialize(slxsJsonString, List<SLX_Infor__c>.class);
        
        //Printing the Lists
        System.debug('Method --> InsertAccountRelatedListObjectOnImport() --> After deserialize');
        
        try
        {
            List<Database.SaveResult> accountProductInsertResult = Database.insert(aps, false);                
            system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> Insert Result AccountProduct = ' + String.valueOf(accountProductInsertResult.size()));
            
        }
        catch(DmlException e)
        {
            system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> DML Exception Occured AccountProduct');
            system.debug(e);
        }
        
        try
        {
            List<Database.SaveResult> industryRecogInsertResult = Database.insert(irs, false);                
            system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> Insert Result IndustryRecog = ' + String.valueOf(industryRecogInsertResult.size()));
            
            
        }
        catch(DmlException e)
        {
            system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> DML Exception Occured IndustryRecog');
            system.debug(e);
        }
        
        try
        {
            List<Database.SaveResult> insertResult = Database.insert(slxs, false);
            
            system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> Insert Result SLX = ' + String.valueOf(insertResult.size()));
            
        }
        catch(DmlException e)
        {
            system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> DML Exception Occured SLX');
            system.debug(e);
        }
        
        system.debug('Method --> InsertAccountRelatedListObjectOnImport() --> End');
        
    }*/
}