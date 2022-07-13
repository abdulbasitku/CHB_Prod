@IsTest
public class AccountsResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"responseTime\": \"2019-09-03T12:25:46.7572965Z\",'+
		'  \"responseCode\": 200,'+
		'  \"responseMessage\": \"\",'+
		'  \"dataSet\": ['+
		'    {'+
		'            \"accountId\": \"A6UJ9A00000P\",'+
		'            \"accountName\": \"Blenheim Homes\",'+
		'            \"accountType\": \"Customer\",'+
		'            \"parentAccountId\": \"\",'+
		'            \"webURL\": \"http://blenheimhomes.com/\",'+
		'            \"phoneNumber\": \"3022540100\",'+
		'            \"customerId\": \"BLENHC2576A00\",'+
		'            \"billingAddress\": \"220 Continental Drive, Suite 410\",'+
		'            \"billingCity\": \"Newark\",'+
		'            \"billingStateProvince\": \"DE\",'+
		'            \"billingPostal\": \"19713\",'+
		'            \"billingCountry\": \"USA\",'+
		'            \"status\": \"Active\",'+
		'            \"clientCode\": \"BLENHE\",'+
		'            \"mappedType\": \"Customer\"'+
		'        },'+
		'        {'+
		'            \"accountId\": \"A6UJ9A000EEU\",'+
		'            \"accountName\": \"Miller Construction\",'+
		'            \"accountType\": \"Customer\",'+
		'            \"parentAccountId\": \"\",'+
		'            \"webURL\": \"\",'+
		'            \"phoneNumber\": \"7316645440\",'+
		'            \"customerId\": \"MILLER\",'+
		'            \"billingAddress\": \"367 North Parkway, STE A-4\",'+
		'            \"billingCity\": \"JACKSON\",'+
		'            \"billingStateProvince\": \"TN\",'+
		'            \"billingPostal\": \"38305\",'+
		'            \"billingCountry\": \"USA\",'+
		'            \"status\": \"Active\",'+
		'            \"clientCode\": \"MILLERC\",'+
		'            \"mappedType\": \"Customer\"'+
		'        }'+
		'  ]'+
		'}';
		AccountsResponse r = AccountsResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		AccountsResponse objAccountsResponse = new AccountsResponse(System.JSON.createParser(json));
		System.assert(objAccountsResponse != null);
		System.assert(objAccountsResponse.responseTime == null);
		System.assert(objAccountsResponse.responseCode == null);
		System.assert(objAccountsResponse.responseMessage == null);
		System.assert(objAccountsResponse.inforAccounts == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		InforAccount objDataSet = new InforAccount(System.JSON.createParser(json));
		System.assert(objDataSet != null);
		System.assert(objDataSet.accountId == null);
		System.assert(objDataSet.accountName == null);
		System.assert(objDataSet.accountType == null);
		System.assert(objDataSet.parentAccountId == null);
		System.assert(objDataSet.webURL == null);
		System.assert(objDataSet.phoneNumber == null);
		System.assert(objDataSet.customerId == null);
		System.assert(objDataSet.billingAddress == null);
		System.assert(objDataSet.billingCity == null);
		System.assert(objDataSet.billingStateProvince == null);
		System.assert(objDataSet.billingPostal == null);
		System.assert(objDataSet.billingCountry == null);
		System.assert(objDataSet.status == null);
		System.assert(objDataSet.clientCode == null);
		System.assert(objDataSet.mappedType == null);
	}
}