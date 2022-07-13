public without sharing class ProductActions 
{
    public static void updateMaintenanceAmountByMaintenanceProduct (List<Product2> newProduct, List<Product2> oldProduct, Map<ID, Product2> newProductMap , Map<ID, Product2> oldProductMap)
    {  
        Set<id> prodIds = new Set<id>();
        Set<id> mProdIds = new Set<id>();
        for(Product2 p : newProduct )
        {
            prodIds.add(p.Id);
            if(p.Maintenance_Product__c != null)
            {
                mProdIds.add(p.Maintenance_Product__c);
            }
        }
        
        List<Product2> products = [SELECT Id,Name, Maintenance_Product_Amount__c,Maintenance_Product__c,Maintenance_Product_Amount_String__c FROM Product2 WHERE Id IN :prodIds];
        Map<ID, Product2> mProducts = new Map<ID, Product2>([SELECT Id,Name, Maintenance_Product_Amount__c, (SELECT Id, UnitPrice, Product2Id FROM PricebookEntries) FROM Product2 WHERE Id IN :mProdIds]);
        
        for(Product2 p : products)
        {
            if(p.Maintenance_Product__c != null)
            {
                if(p.Maintenance_Product__c != oldProductMap.get(p.Id).Maintenance_Product__c)
                {
                    Product2 mp = mProducts.get(p.Maintenance_Product__c);
                    if(mp.PricebookEntries != null && mp.PricebookEntries.isEmpty() == false){
                        p.Maintenance_Product_Amount__c = mp.PricebookEntries[0].UnitPrice;
                        
                        //Add Maintenance Product Amount String field to show on Conga Proposal
                        Decimal up = mp.PricebookEntries[0].UnitPrice;
                        List<String> args = new String[]{'0','number','###,###,###'};
                        //System.debug('dd-' + rA.format());
                        String ups = String.format(up.format(), args);
                        p.Maintenance_Product_Amount_String__c = ups;
                    }
                    else
                    {
                        p.Maintenance_Product_Amount__c = 0;
                        p.Maintenance_Product_Amount_String__c = '';                       
                    }
                }                
            }
        }
        
        update products;        
    }   
}