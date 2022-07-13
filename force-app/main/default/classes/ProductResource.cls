@RestResource(urlMapping='/Products/*')
global with sharing class ProductResource {
    
    /*@HttpGet
    global static Product2 doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String productId = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        Product2 result = [SELECT Id, Name FROM Product2 WHERE Id = :productId];
        return result;
    }
    
    @HttpPost 
    global static void doPost() {
        ApiResponse result = new ApiResponse();
        result.ResponseCode = -1;
        result.ResponseMessage = 'Failed';
        
        RestRequest req = RestContext.request;
        RestResponse resp = RestContext.response;
        
        string productId=req.params.get('productId');
        string productName=req.params.get('productName'); 
        string productSKU=req.params.get('productSKU');
        
        if(productId == null || productName == null){
            result.ResponseMessage = 'Product Id & Name are required';
            
            resp.addHeader('Content-Type', 'application/json');
            resp.responseBody = Blob.valueOf(JSON.serialize(result));
            return;
        }
        Product2 product;
        List<Product2> products  = [SELECT Id, Name, StockKeepingUnit,External_ID__c FROM Product2 WHERE External_ID__c = :productId limit 1];
        
        if(products.isEmpty())
        {
            product = new Product2();
            product.External_ID__c = productId;
        }
        else
        {
            product = products[0];
        }
        
        product.Name = productName;
        if(productSKU != null && string.isNotEmpty(productSKU)){
            product.StockKeepingUnit = productSKU;
        }
        
        upsert product;
        
        result.ResponseCode = 1;
        result.ResponseMessage = 'Successfully created/updated product record';
        
        resp.addHeader('Content-Type', 'application/json');
        resp.responseBody = Blob.valueOf(JSON.serialize(result));
    }*/
    
}