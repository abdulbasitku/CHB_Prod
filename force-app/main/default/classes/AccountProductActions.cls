public class AccountProductActions {
    //Not used
    @InvocableMethod(label='OnAccountProductCreation' description='On creation of account product, create account product family')
    public static List<ID> OnAccountProductCreation(List<Account_Product__c> accountProductItems) {
        
        
        system.debug('Method --> OnAccountProductCreation() --> Total Account Product = ' + String.valueOf(accountProductItems.size()));
        
        Set<Id> accountProductItemIds = (new Map<Id,SObject>(accountProductItems)).keySet();
        
        List<Account_Product__c> accountProductItemsToUpdate = 
            [Select Id,Account__c,Account__r.Name, Product__c, Product__r.Product_Family__c, Product__r.Product_Family__r.Name, Account_Manager__c from Account_Product__c where Id in :accountProductItemIds];
        
        List<Account_Product_Family__c> acpfs = [Select Name,Id,Account__c, Product_Family__c from Account_Product_Family__c];
        
        Map<String, Account_Product_Family__c> accountProductFamilyExistingItems = new Map<String, Account_Product_Family__c>();
        
        List<Account_Product_Family__c> accountProductFamilyItems = new LIST<Account_Product_Family__c>();
        
        for (Account_Product_Family__c p : acpfs) 
        {
            accountProductFamilyExistingItems.put(p.Name, p);
        }
        
        for(Account_Product__c accountProductItem : accountProductItemsToUpdate)
        {
            if(accountProductItem.Product__r.Product_Family__r != null){
                string newAcctProdFamName = accountProductItem.Account__r.Name + '|' + accountProductItem.Product__r.Product_Family__r.Name;
                if(accountProductFamilyExistingItems.containsKey(newAcctProdFamName)){
                    
                }
                else
                {
                    Account_Product_Family__c accountProductFamily = new Account_Product_Family__c();
                    accountProductFamily.Name = newAcctProdFamName;
                    accountProductFamily.Account__c = accountProductItem.Account__c;
                    accountProductFamily.Product_Family__c = accountProductItem.Product__r.Product_Family__c;
                    accountProductFamily.Account_Manager__c = accountProductItem.Account_Manager__c;
                        
                    accountProductFamilyItems.add(accountProductFamily);
                }
            }
        }   
        
        List<ID> accountProductFamilyItemsIds = new List<ID>();
        
        if(accountProductFamilyItems.size() > 0){
            Database.SaveResult[] results = Database.insert(accountProductFamilyItems);
            
            for (Database.SaveResult result : results) {
                if (result.isSuccess()) {
                    accountProductFamilyItemsIds.add(result.getId());
                }
            }
        }
        
        system.debug('Method --> OnAccountProductCreation() --> Total Account Product Family = ' + String.valueOf(accountProductFamilyItemsIds.size()));
        
        return accountProductFamilyItemsIds;
    }   
    
    public static void RecheckAndUpdateAccountProductFamilies(List<Account_Product__c> newAndOldAccountProduct)
    {        
        system.debug('Method --> RecheckAndUpdateAccountProductFamilies() --> Start');
        
        try
        {
            Map<Id, Set<Id>> accountProductMaps = new Map<Id, Set<Id>>();
            Set<Id> allProductIds = new Set<Id>();
            
            
            for(Account_Product__c ap : newAndOldAccountProduct)
            {
                if(accountProductMaps.containsKey(ap.Account__c))
                {
                    Set<Id> products = accountProductMaps.get(ap.Account__c);
                    products.add(ap.Product__c);
                    accountProductMaps.put(ap.Account__c, products);
                }
                else
                {
                    Set<Id> products = new Set<Id>();
                    products.add(ap.Product__c);
                    accountProductMaps.put(ap.Account__c, products);
                }
                
                allProductIds.add(ap.Product__c);
            }
            
            Set<Id> accountIds = accountProductMaps.keySet();
            
            List<Account_Product_Family__c> accountProductFamilies = [Select Id, Account__c, Product_family__c, Account_Manager__c, Account_Type__c from Account_Product_Family__c where Account__c in :accountIds];
            List<Account_Product__c> accountProducts = [Select Id, Account__c, Account__r.Name, Account_Type__c, Product__c, Product__r.Product_Family__c, Product__r.Product_Family__r.Name, Product__r.Name, Product__r.Id, Account_Manager__c from Account_Product__c where Account__c in :accountIds];
            
            Map<Id, Set<Id>> accountProductFamiliesMaps = new Map<Id, Set<Id>>();
            
            for(Account_Product_Family__c apf : accountProductFamilies)
            {
                if(accountProductFamiliesMaps.containsKey(apf.Account__c))
                {
                    Set<Id> productFamilies = accountProductFamiliesMaps.get(apf.Account__c);
                    productFamilies.add(apf.Product_family__c);
                    accountProductFamiliesMaps.put(apf.Account__c, productFamilies);
                }
                else
                {
                    Set<Id> productFamilies = new Set<Id>();
                    productFamilies.add(apf.Product_family__c);
                    accountProductFamiliesMaps.put(apf.Account__c, productFamilies);
                }
            }
            
            Set<Account_Product_Family__c> aPFToBeInsert = new Set<Account_Product_Family__c>();
            
            for(Account_Product__c ap : accountProducts)
            {
                Boolean shouldProductFamilyInsert = true;
                
                Set<Id> apProductFamilies = accountProductFamiliesMaps.get(ap.Account__c);
                allProductIds.Add(ap.Product__c);
                if(apProductFamilies == null)
                {
                    apProductFamilies = new Set<Id>();
                }
                
                if(apProductFamilies.contains(ap.Product__r.Product_Family__c))
                {
                    shouldProductFamilyInsert = false;
                }
                
                if(shouldProductFamilyInsert)
                {
                    Account_Product_Family__c newApf = new Account_Product_Family__c();
                    
                    string newAcctProdFamName = ap.Account__r.Name + '|' + ap.Product__r.Product_Family__r.Name;
                    
                    newApf.Name = newAcctProdFamName;
                    newApf.Account__c = ap.Account__c;
                    newApf.Product_Family__c =  ap.Product__r.Product_Family__c;
                    newApf.Account_Manager__c = ap.Account_Manager__c;                    
                    newApf.Account_Type__c = ap.Account_Type__c;
                    
                    aPFToBeInsert.add(newApf);
                    
                    accountProductFamilies.Add(newApf);
                    
                    apProductFamilies.add(ap.Product__r.Product_Family__c);
                    accountProductFamiliesMaps.put(ap.Account__c,apProductFamilies);
                    
                }
            }
            
            
            if(aPFToBeInsert.size() > 0)
            {
                try
                {               
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> Inserting New APFs = ' + aPFToBeInsert.size());
                    Database.SaveResult[] results = Database.insert(new List<Account_Product_Family__c>(aPFToBeInsert));
                }
                catch (DmlException e) 
                {
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> Exception Occured ');
                    system.debug(e);
                }
                
            }
            
            //latest accountProductMaps
            accountProductMaps = new Map<Id, Set<Id>>();
            for(Account_Product__c ap : accountProducts)
            {
                if(accountProductMaps.containsKey(ap.Account__c))
                {
                    Set<Id> products = accountProductMaps.get(ap.Account__c);
                    products.add(ap.Product__c);
                    accountProductMaps.put(ap.Account__c, products);
                }
                else
                {
                    Set<Id> products = new Set<Id>();
                    products.add(ap.Product__c);
                    accountProductMaps.put(ap.Account__c, products);
                }
            }
            
            Set<Account_Product_Family__c> aPFToBeDeleted = new Set<Account_Product_Family__c>();
            
            Map<Id, Product2> allProductMaps = new Map<Id, Product2>([Select Id, Name, Product_Family__c from Product2 where Id in :allProductIds]);
            
            for(Account_Product_Family__c apf : accountProductFamilies)
            {
                Boolean shouldProductFamilyDelete = true;
                
                Set<Id> apProducts = accountProductMaps.get(apf.Account__c);       
                if(apProducts == null)
                {
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> Setting empty product ids');
                    apProducts = new Set<Id>();
                }
                
                
                Set<Id> prodFamiliesOfCurrProd = new Set<Id>();
                for(Id aprodId : apProducts)
                {
                    Product2 prod = allProductMaps.get(aprodId);
                    if(prod != null && prod.Product_Family__c != null)
                    {
                        prodFamiliesOfCurrProd.add(prod.Product_Family__c);
                    }
                }
                                
                system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> Exists Product Families of Product ' + prodFamiliesOfCurrProd.size());
                if(prodFamiliesOfCurrProd.contains(apf.Product_Family__c))
                {                    
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> Product Family of Product Exists');
                    shouldProductFamilyDelete = false;
                }
                
                if(shouldProductFamilyDelete){
                    aPFToBeDeleted.add(apf);
                }
            }
            
            if(aPFToBeDeleted.size() > 0)
            {
                try
                {               
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> DML Insert Deleting APFs');
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> DML Insert Deleting APFs = ' + aPFToBeDeleted.size());
                    Database.DeleteResult[] results = Database.delete(new List<Account_Product_Family__c>(aPFToBeDeleted));
                }
                catch (DmlException e) 
                {
                    system.debug('Method --> RecheckAndUpdateAccountProductFamilies --> DML Delete Exception Occured ');
                    system.debug(e);
                }                
            }
        }
        catch(Exception e)
        {
            system.debug('Method --> RecheckAndUpdateAccountProductFamilies() --> Exception Occured');
            system.debug(e);
        }
        
        system.debug('Method --> RecheckAndUpdateAccountProductFamilies() --> End');
    }
}