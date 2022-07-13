public without sharing class ContactProductActions {
    
    public static void RecheckAndUpdateContactProductFamilies(List<Contact_Product__c> newAndOldContactProduct)
    {        
        system.debug('Method --> RecheckAndUpdateContactProductFamilies() --> Start');
        
        try
        {
            Map<Id, Set<Id>> contactProductMaps = new Map<Id, Set<Id>>();
            Set<Id> allProductIds = new Set<Id>();
            
            
            for(Contact_Product__c cp : newAndOldContactProduct)
            {
                if(contactProductMaps.containsKey(cp.Contact__c))
                {
                    Set<Id> products = contactProductMaps.get(cp.Contact__c);
                    products.add(cp.Product__c);
                    contactProductMaps.put(cp.Contact__c, products);
                }
                else
                {
                    Set<Id> products = new Set<Id>();
                    products.add(cp.Product__c);
                    contactProductMaps.put(cp.Contact__c, products);
                }
                
                allProductIds.add(cp.Product__c);
            }
            
            Set<Id> contactIds = contactProductMaps.keySet();
            
            List<Contact_Product_Family__c> contactProductFamilies = [Select Id, Contact__c, Product_family__c from Contact_Product_Family__c where Contact__c in :contactIds];
            List<Contact_Product__c> contactProducts = [Select Id, Contact__c, Product__c,Product__r.Product_Family__c, Product__r.Name,Product__r.Id from Contact_Product__c where Contact__c in :contactIds];
            
            Map<Id, Set<Id>> contactProductFamiliesMaps = new Map<Id, Set<Id>>();
            
            for(Contact_Product_Family__c cpf : contactProductFamilies)
            {
                if(contactProductFamiliesMaps.containsKey(cpf.Contact__c))
                {
                    Set<Id> productFamilies = contactProductFamiliesMaps.get(cpf.Contact__c);
                    productFamilies.add(cpf.Product_family__c);
                    contactProductFamiliesMaps.put(cpf.Contact__c, productFamilies);
                }
                else
                {
                    Set<Id> productFamilies = new Set<Id>();
                    productFamilies.add(cpf.Product_family__c);
                    contactProductFamiliesMaps.put(cpf.Contact__c, productFamilies);
                }
            }
            
            Set<Contact_Product_Family__c> cPFToBeInsert = new Set<Contact_Product_Family__c>();
            
            for(Contact_Product__c cp : contactProducts)
            {
                Boolean shouldProductFamilyInsert = true;
                
                Set<Id> cpProductFamilies = contactProductFamiliesMaps.get(cp.Contact__c);
                allProductIds.Add(cp.Product__c);
                if(cpProductFamilies == null)
                {
                    cpProductFamilies = new Set<Id>();
                }
                
                if(cpProductFamilies.contains(cp.Product__r.Product_Family__c))
                {
                    shouldProductFamilyInsert = false;
                }
                
                if(shouldProductFamilyInsert)
                {
                    Contact_Product_Family__c newCpf = new Contact_Product_Family__c();
                    newCpf.Contact__c = cp.Contact__c;
                    newCpf.Product_Family__c =  cp.Product__r.Product_Family__c;
                    
                    cPFToBeInsert.add(newCpf);
                    
                    contactProductFamilies.Add(newCpf);
                    
                    cpProductFamilies.add(cp.Product__r.Product_Family__c);
                    contactProductFamiliesMaps.put(cp.Contact__c,cpProductFamilies);
                    
                }
            }
            
            
            if(cPFToBeInsert.size() > 0)
            {
                try
                {               
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> Inserting New CPFs = ' + cPFToBeInsert.size());
                    Database.SaveResult[] results = Database.insert(new List<Contact_Product_Family__c>(cPFToBeInsert));
                }
                catch (DmlException e) 
                {
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> Exception Occured ');
                    system.debug(e);
                }
                
            }
            
            //latest contactProductMaps
            contactProductMaps = new Map<Id, Set<Id>>();
            for(Contact_Product__c cp : contactProducts)
            {
                if(contactProductMaps.containsKey(cp.Contact__c))
                {
                    Set<Id> products = contactProductMaps.get(cp.Contact__c);
                    products.add(cp.Product__c);
                    contactProductMaps.put(cp.Contact__c, products);
                }
                else
                {
                    Set<Id> products = new Set<Id>();
                    products.add(cp.Product__c);
                    contactProductMaps.put(cp.Contact__c, products);
                }
            }
            
            Set<Contact_Product_Family__c> cPFToBeDeleted = new Set<Contact_Product_Family__c>();
            
            for(Contact_Product_Family__c cpf : contactProductFamilies)
            {
                Boolean shouldProductFamilyDelete = true;
                
                Set<Id> cpProducts = contactProductMaps.get(cpf.Contact__c);       
                if(cpProducts == null)
                {
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> Setting empty product ids');
                    cpProducts = new Set<Id>();
                }
                
                
                Map<Id, Product2> allProductMaps = new Map<Id, Product2>([Select Id, Name, Product_Family__c from Product2 where Id in :allProductIds]);
                Set<Id> prodFamiliesOfCurrProd = new Set<Id>();
                for(Id cprodId : cpProducts)
                {
                    Product2 prod = allProductMaps.get(cprodId);
                    if(prod != null && prod.Product_Family__c != null)
                    {
                        prodFamiliesOfCurrProd.add(prod.Product_Family__c);
                    }
                }
                                
                system.debug('Method --> RecheckAndUpdateContactProductFamilies --> Exists Product Families of Product ' + prodFamiliesOfCurrProd.size());
                if(prodFamiliesOfCurrProd.contains(cpf.Product_Family__c))
                {                    
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> Product Family of Product Exists');
                    shouldProductFamilyDelete = false;
                }
                
                if(shouldProductFamilyDelete){
                    cPFToBeDeleted.add(cpf);
                }
            }
            
            if(cPFToBeDeleted.size() > 0)
            {
                try
                {               
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> DML Insert Deleting CPFs');
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> DML Insert Deleting CPFs = ' + cPFToBeDeleted.size());
                    Database.DeleteResult[] results = Database.delete(new List<Contact_Product_Family__c>(cPFToBeDeleted));
                }
                catch (DmlException e) 
                {
                    system.debug('Method --> RecheckAndUpdateContactProductFamilies --> DML Delete Exception Occured ');
                    system.debug(e);
                }                
            }
        }
        catch(Exception e)
        {
            system.debug('Method --> RecheckAndUpdateContactProductFamilies() --> Exception Occured');
            system.debug(e);
        }
        
        system.debug('Method --> RecheckAndUpdateContactProductFamilies() --> End');
    }    
}