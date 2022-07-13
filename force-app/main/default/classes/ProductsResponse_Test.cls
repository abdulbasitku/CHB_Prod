@IsTest
public class ProductsResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'\"responseTime\": \"2019-11-25T15:05:05.7539573Z\",'+
		'    \"responseCode\": 200,'+
		'    \"responseMessage\": \"\",'+
		'    \"dataSet\": ['+
		'        {'+
		'            \"team\": \"\",'+
		'            \"productName\": \"NEWSTAR FOCUS for Enterprise\",'+
		'            \"productId\": \"Y6UJ9A000002\",'+
		'            \"status\": \"Available\",'+
		'            \"family\": \"Software\",'+
		'            \"description\": \"NEWSTAR FOCUS for Enterprise\\nQuery Tool: Formerly: DBx\\n\",'+
		'            \"quantity\": \"\",'+
		'            \"isActive\": true'+
		'        },'+
		'        {'+
		'            \"team\": \"\",'+
		'            \"productName\": \"NEWSTAR Sales\",'+
		'            \"productId\": \"Y6UJ9A000003\",'+
		'            \"status\": \"Available\",'+
		'            \"family\": \"Software\",'+
		'            \"description\": \"NEWSTAR Sales (formerly Sales Profiler)\",'+
		'            \"quantity\": \"\",'+
		'            \"isActive\": true'+
		'        }'+
		']'+
		'}';
		ProductsResponse r = ProductsResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		InforProduct objDataSet = new InforProduct(System.JSON.createParser(json));
		System.assert(objDataSet != null);
		System.assert(objDataSet.team == null);
		System.assert(objDataSet.productName == null);
		System.assert(objDataSet.productId == null);
		System.assert(objDataSet.status == null);
		System.assert(objDataSet.family == null);
		System.assert(objDataSet.description == null);
		System.assert(objDataSet.quantity == null);
		System.assert(objDataSet.isActive == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ProductsResponse objProductsResponse = new ProductsResponse(System.JSON.createParser(json));
		System.assert(objProductsResponse != null);
		System.assert(objProductsResponse.responseTime == null);
		System.assert(objProductsResponse.responseCode == null);
		System.assert(objProductsResponse.responseMessage == null);
		System.assert(objProductsResponse.InforProducts == null);
	}
}