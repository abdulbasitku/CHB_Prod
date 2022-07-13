@IsTest
public class ContactsResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"responseTime\": \"2019-10-18T15:40:10.3977065Z\",'+
		'    \"responseCode\": 200,'+
		'    \"responseMessage\": \"\",'+
		'    \"dataSet\": ['+
		'        {'+
		'            \"contactId\": \"C6UJ9A0013Q2\",'+
		'            \"firstName\": \"Sue\",'+
		'            \"lastName\": \"Griffin\",'+
		'            \"title\": \"Contract Administrator\",'+
		'            \"accountId\": \"A6UJ9A000052\",'+
		'            \"email\": \"sgriffin@newurbancommunities.com\",'+
		'            \"fax\": \"5612723951\",'+
		'            \"phoneNumber\": \"5612798706x206\",'+
		'            \"mobileNumber\": \"5619453174\",'+
		'            \"mailingStreet\": \"398 NE 6th Avenue\",'+
		'            \"mailingCity\": \"Delray Beach\",'+
		'            \"mailingStateProvince\": \"FL\",'+
		'            \"mailingPostal\": \"33483\",'+
		'            \"mailingCountry\": \"USA\",'+
		'            \"status\": \"Active\",'+
		'            \"doNotEmail\": false,'+
		'            \"doNotSolicit\": false,'+
		'            \"doNotPhone\": false,'+
		'            \"isPrimary\": false'+
		'        },'+
		'        {'+
		'            \"contactId\": \"C6UJ9A001F7F\",'+
		'            \"firstName\": \"Charlene\",'+
		'            \"lastName\": \"Teague\",'+
		'            \"title\": \"Accountant\",'+
		'            \"accountId\": \"A6UJ9A000GND\",'+
		'            \"email\": \"cteague@lgihomes.com\",'+
		'            \"fax\": \"2813628892\",'+
		'            \"phoneNumber\": \"2812102621\",'+
		'            \"mobileNumber\": \"\",'+
		'            \"mailingStreet\": \"1450 Lake Robbins Drive\",'+
		'            \"mailingCity\": \"The Woodlands\",'+
		'            \"mailingStateProvince\": \"TX\",'+
		'            \"mailingPostal\": \"77380\",'+
		'            \"mailingCountry\": \"USA\",'+
		'            \"status\": \"Active\",'+
		'            \"doNotEmail\": false,'+
		'            \"doNotSolicit\": false,'+
		'            \"doNotPhone\": false,'+
		'            \"isPrimary\": true'+
		'        }'+
		'    ]'+
		'}';
		ContactsResponse r = ContactsResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		InforContact objDataSet = new InforContact(System.JSON.createParser(json));
		System.assert(objDataSet != null);
		System.assert(objDataSet.contactId == null);
		System.assert(objDataSet.firstName == null);
		System.assert(objDataSet.lastName == null);
		System.assert(objDataSet.title == null);
		System.assert(objDataSet.accountId == null);
		System.assert(objDataSet.email == null);
		System.assert(objDataSet.fax == null);
		System.assert(objDataSet.phoneNumber == null);
		System.assert(objDataSet.mobileNumber == null);
		System.assert(objDataSet.mailingStreet == null);
		System.assert(objDataSet.mailingCity == null);
		System.assert(objDataSet.mailingStateProvince == null);
		System.assert(objDataSet.mailingPostal == null);
		System.assert(objDataSet.mailingCountry == null);
		System.assert(objDataSet.status == null);
		System.assert(objDataSet.doNotEmail == null);
		System.assert(objDataSet.doNotSolicit == null);
		System.assert(objDataSet.doNotPhone == null);
		System.assert(objDataSet.isPrimary == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ContactsResponse objContactsResponse = new ContactsResponse(System.JSON.createParser(json));
		System.assert(objContactsResponse != null);
		System.assert(objContactsResponse.responseTime == null);
		System.assert(objContactsResponse.responseCode == null);
		System.assert(objContactsResponse.responseMessage == null);
		System.assert(objContactsResponse.inforContacts == null);
	}
}