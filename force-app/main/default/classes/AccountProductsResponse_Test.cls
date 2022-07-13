@IsTest
public class AccountProductsResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"responseTime\": \"2019-11-07T14:10:33.2473023Z\",'+
		'    \"responseCode\": 200,'+
		'    \"responseMessage\": \"\",'+
		'    \"dataSet\": ['+
		'        {'+
		'            \"accountId\": \"A6UJ9A000012\",'+
		'            \"accountProductId\": \"Q1VY3A400G2S\",'+
		'            \"productId\": \"Y6UJ9A00009X\",'+
		'            \"productName\": \"Expenses - US$ - Employee\",'+
		'            \"productSKU\": \"EXPUSDE\",'+
		'            \"quantity\": \"11\"'+
		'        },'+
		'        {'+
		'            \"accountId\": \"A6UJ9A000012\",'+
		'            \"accountProductId\": \"Q1VY3A400G2U\",'+
		'            \"productId\": \"Y6UJ9A00009X\",'+
		'            \"productName\": \"Expenses - US$ - Employee\",'+
		'            \"productSKU\": \"EXPUSDE\",'+
		'            \"quantity\": \"11\"'+
		'        }'+
		']'+
		'}';
		AccountProductsResponse r = AccountProductsResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		InforAccountProduct objDataSet = new InforAccountProduct(System.JSON.createParser(json));
		System.assert(objDataSet != null);
		System.assert(objDataSet.accountId == null);
		System.assert(objDataSet.accountProductId == null);
		System.assert(objDataSet.productId == null);
		System.assert(objDataSet.productName == null);
		System.assert(objDataSet.productSKU == null);
		System.assert(objDataSet.quantity == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		AccountProductsResponse objAccountProductsResponse = new AccountProductsResponse(System.JSON.createParser(json));
		System.assert(objAccountProductsResponse != null);
		System.assert(objAccountProductsResponse.responseTime == null);
		System.assert(objAccountProductsResponse.responseCode == null);
		System.assert(objAccountProductsResponse.responseMessage == null);
		System.assert(objAccountProductsResponse.InforAccountProducts == null);
	}
}