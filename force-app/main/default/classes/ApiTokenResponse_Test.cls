@IsTest
public class ApiTokenResponse_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'    \"value\": \"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ7NkRGNTFFRjYtN0U3QS00QkIyLTg1RDktNTBERDc5MTFGMDI4IiwianRpIjoiNzg4NjAyOWMtOWIwNC00OWE4LWJiMWUtNDJlYTY2OGRlZDhjIiwiZXhwIjoxNTcwMDI1NDM5LCJpc3MiOiJDb25zdGVsbGF0aW9uIEluZm9yQ1JNLVNhbGVzRm9yY2UgRGF0YSBNaWdyYXRpb24gQVBJIiwiYXVkIjoiQ29uc3RlbGxhdGlvbl9BUEkifQ.kcydAbRfB9QLIBjRsJE1gUQOSbANbojWiaj6kjjpnbM\"'+
		'}';
		ApiTokenResponse r = ApiTokenResponse.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		ApiTokenResponse objApiTokenResponse = new ApiTokenResponse(System.JSON.createParser(json));
		System.assert(objApiTokenResponse != null);
		System.assert(objApiTokenResponse.value == null);
	}
}