@isTest
public class AccountResource_Test {
    
     @testSetup
    static void dataSetup() {
        Account acc = new Account(Name = 'Testing');
        acc.Number_of_Homes__c = 'Unknown';
        insert acc;
        
        acc = new Account(Name = 'Parent Testing');
        acc.Number_of_Homes__c = 'Unknown';
        acc.External_ID__c = 'dfdfdfdfasd';
        insert acc;
    }
    
    static testMethod void GetAccountApi_Test(){
        
        Account acc = [ SELECT Id FROM Account LIMIT 1 ];
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/Accounts/' + acc.Id;
        req.httpMethod = 'GET';
        RestContext.request = req;
        RestContext.response= res;
        Account acctResp = AccountResource.doGet();
        system.assertEquals(acctResp.Name, 'Testing');
        
    }
    
    static testMethod void testPost() {
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();             
        req.requestURI = '/services/apexrest/Accounts/';
        req.httpMethod = 'POST';
        
        
        //Account pacc = [ SELECT Id FROM Account WHERE Name =: 'Parent Testing'];
        
        req.addParameter('accountId', '6kkllsssmasd6');
        req.addParameter('accountName', 'Test Account Rest Api');
        req.addParameter('accountType','Analyst');
        req.addParameter('parentAccountId','dfdfdfdfasd');
        req.addParameter('webURL','www.google.com');
       req.addParameter('phoneNumber','123456789');
        req.addParameter('customerID','dfsdfsdfs');
        req.addParameter('billingStreet','45');
        req.addParameter('billingCity','Markham');
        req.addParameter('billingStateProvince','ON');
        req.addParameter('billingPostal','74900');
        req.addParameter('billingCountry','Canada');
        
        RestContext.request = req;
        RestContext.response= res;
        AccountResource.doPost();
        Account acc = [ SELECT Id, Name, Description, External_ID__c FROM Account WHERE External_ID__c =: '6kkllsssmasd6' ];
        system.assertEquals(acc.Name, 'Test Account Rest Api');
    }
    
    static testMethod void testDelete() {
        /*Account acc = [ SELECT Id FROM Account LIMIT 1 ];
RestRequest req = new RestRequest(); 
RestResponse res = new RestResponse();             
req.requestURI = '/services/apexrest/Account/' + acc.Id;
req.httpMethod = 'DELETE';
RestContext.request = req;
RestContext.response= res;
SampleRest.doDelete();
system.assertEquals( [ SELECT COUNT() FROM Account ], 0);*/
    }
}