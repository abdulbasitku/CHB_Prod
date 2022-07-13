public class InforDataApiConsumer {
    
	//ConstellationCentral QA
    /*string apiUrl = 'https://inforapi-qa.constellationhb.com';
    string userName = '{6DF51EF6-7E7A-4BB2-85D9-50DD7911F028';
    string pswd = 'B6C30946-D7A0-4831-B6AA-4AE1E0E0FBFF}';*/
        
	//ConstellationCentral Prod
    string apiUrl = 'https://inforapi.constellationhb.com';
    string userName = '{6DF51EF6-7E7A-4BB2-85D9-50DD7911F028';
    string pswd = 'B6C30946-D7A0-4831-B6AA-4AE1E0E0FBFF}';
    
    public ApiTokenResponse GetAuthorizeToken(){
        
        system.debug('Method --> InforDataApiConsumer.GetAuthorizeToken --> Start');
        List<Account> accountList;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        //Set end-point & Auth Token using Named Creds
        request.setEndpoint(apiUrl + '/token');
        request.setMethod('GET');
        request.setHeader('accept', 'application/json');        
        request.setHeader('Content-Type', 'application/json-patch+json');
        
        
        // Set the body as a JSON object
        
        request.setBody('{ "username": "'+ userName +'", "password": "' + pswd + '"}');
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            System.debug('The status code returned was not expected: ' +
                         response.getStatusCode() + ' ' + response.getStatus());
        } else {
            System.debug(response.getBody());
        }
        
        system.debug('Method --> InforDataApiConsumer.GetAuthorizeToken --> End');
        
        return ApiTokenResponse.parse(response.getBody());
    }
    
    /*public AccountsResponse GetInforAccountsData(Integer offset, Integer pageSize, boolean ignoreDate){
        
        system.debug('Method --> InforDataApiConsumer.GetInforAccountsData --> Start');
        
        List<Account> accountList;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( apiUrl + '/api/Accounts?offset=' + offset + '&pageSize=' + pageSize + '&ignoreDate=' + ignoreDate + '&onDate=' + string.valueof(date.today()));
        
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);       
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforAccountsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            //return new AccountsResponse();            
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforAccountsData --> End');
        
        return AccountsResponse.parse(response.getBody());
    }
    
    public ContactsResponse GetInforContactsData(Integer offset, Integer pageSize, boolean ignoreDate, boolean filterInternalContactByEmail){
        
        system.debug('Method --> InforDataApiConsumer.GetInforContactsData --> Start');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( apiUrl + '/api/Contacts?offset=' + offset + '&pageSize=' + pageSize + '&ignoreDate=' + ignoreDate + '&onDate=' + string.valueof(date.today()) + '&filterInternalContactsByEmail=' + filterInternalContactByEmail);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforContactsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());                       
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforContactsData --> End');
        
        return ContactsResponse.parse(response.getBody());
    }
    
    public ProductsResponse GetInforProductsData(Integer offset, Integer pageSize, boolean ignoreDate){
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> Start');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(apiUrl + '/api/Products?offset=' + offset + '&pageSize=' + pageSize + '&ignoreDate=' + ignoreDate + '&onDate=' + string.valueof(date.today()));
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);       
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());                       
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
        
        return ProductsResponse.parse(response.getBody());
    }
        
    public AccountProductsResponse GetInforAccountProductsData(Integer offset, Integer pageSize, boolean ignoreDate){
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> Start');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( apiUrl + '/api/AccountProducts?offset=' + offset + '&pageSize=' + pageSize + '&ignoreDate=' + ignoreDate + '&onDate=' + string.valueof(date.today()));
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);       
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());                       
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
        
        return AccountProductsResponse.parse(response.getBody());
    }
*/
    
    //Hourly
    public AccountsResponse GetInforAccountsHourlyData(Integer timeRangeInMinutes){
        
        system.debug('Method --> InforDataApiConsumer.GetInforAccountsData --> Start');
        
        List<Account> accountList;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint( apiUrl + '/api/AccountsHourly?timeRange=' + timeRangeInMinutes);
        
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);       
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforAccountsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
            //return new AccountsResponse();            
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforAccountsData --> End');
        
        return AccountsResponse.parse(response.getBody());
    }
    
    public ContactsResponse GetInforContactsHourlyData(Integer timeRangeInMinutes, boolean filterInternalContactByEmail){
        
        system.debug('Method --> InforDataApiConsumer.GetInforContactsData --> Start');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( apiUrl + '/api/ContactsHourly?timeRange=' + timeRangeInMinutes + '&filterInternalContactsByEmail=' + filterInternalContactByEmail);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforContactsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());                       
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforContactsData --> End');
        
        return ContactsResponse.parse(response.getBody());
    }
    
    public ProductsResponse GetInforProductsHourlyData(Integer timeRangeInMinutes){
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> Start');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint(apiUrl + '/api/ProductsHourly?timeRange=' + timeRangeInMinutes);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);       
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());                       
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
        
        return ProductsResponse.parse(response.getBody());
    }
        
    public AccountProductsResponse GetInforAccountProductsHourlyData(Integer timeRangeInMinutes){
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> Start');
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        
        request.setEndpoint( apiUrl + '/api/AccountProductsHourly?timeRange=' + timeRangeInMinutes);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + GetAuthorizeToken().value);       
        request.setTimeout(120000);
        
        System.debug(request.toString());
        HttpResponse response = http.send(request);
        
        System.debug(response.toString());
        System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        // Parse the JSON response        
        if (response.getStatusCode() != 200) {
            
            system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
            System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());                       
        }    
        
        system.debug('Method --> InforDataApiConsumer.GetInforProductsData --> End');
        
        return AccountProductsResponse.parse(response.getBody());
    }
    
	//HourlyMock    
	//Hourly
    public AccountsResponse GetInforAccountsHourlyDataMock(){
        
        return AccountsResponse.parse('{\"responseTime\":\"2022-02-28T13:46:43.3231834Z\",\"responseCode\":200,\"responseMessage\":\"Datafound:16recordsfound.\",\"dataSet\":[{\"accountId\":\"A6UJ9A00006Z\",\"accountName\":\"TaylorMorrison,Inc.\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"www.taylormorrison.com\",\"phoneNumber\":\"4808408100\",\"customerId\":\"TAYWOC2603A00\",\"billingAddress\":\"4900N.ScottsdaleRoad,Suite2000\",\"billingCity\":\"Scottsdale\",\"billingStateProvince\":\"AZ\",\"billingPostal\":\"85251\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"TAYLOR\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9A0017D9\",\"accountName\":\"RizeAlliancePropertiesLtd\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.rizealliance.com\",\"phoneNumber\":\"6046816723\",\"customerId\":\"RIZE\",\"billingAddress\":\"1055DunsmuirSt\",\"billingCity\":\"Vancouver\",\"billingStateProvince\":\"BC\",\"billingPostal\":\"V7X1L4\",\"billingCountry\":\"Canada\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000V2\",\"accountName\":\"ChallengerHomes\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.mychallengerhomes.com\",\"phoneNumber\":\"7195985192\",\"customerId\":\"CHALLENGER\",\"billingAddress\":\"8605ExplorerDrive\",\"billingCity\":\"ColoradoSprings\",\"billingStateProvince\":\"CO\",\"billingPostal\":\"80920\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000VC\",\"accountName\":\"DreamFindersHomes\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.dreamfindershomes.com/\",\"phoneNumber\":\"9046447670\",\"customerId\":\"DREAMFINDER\",\"billingAddress\":\"360CorporateWay\",\"billingCity\":\"OrangePark\",\"billingStateProvince\":\"FL\",\"billingPostal\":\"32073\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000VT\",\"accountName\":\"McBride&SonHomes\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.mcbridehomes.com/\",\"phoneNumber\":\"6365372000\",\"customerId\":\"MCBRIDE\",\"billingAddress\":\"17415NorthOuterFortyRoad\",\"billingCity\":\"Chesterfield\",\"billingStateProvince\":\"MO\",\"billingPostal\":\"63003\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000VU\",\"accountName\":\"McKelveyHomes\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.mckelveyhomes.com/\",\"phoneNumber\":\"6365306900\",\"customerId\":\"MCKELVEY\",\"billingAddress\":\"218ChesterfieldTowneCentre\",\"billingCity\":\"Chesterfield\",\"billingStateProvince\":\"MO\",\"billingPostal\":\"63005\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000VW\",\"accountName\":\"NewmarkHomesHouston,LLC\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://newmarkhomes.com/\",\"phoneNumber\":\"7133460200\",\"customerId\":\"NEWMARK\",\"billingAddress\":\"23033GrandCircleBlvd.\",\"billingCity\":\"Katy\",\"billingStateProvince\":\"TX\",\"billingPostal\":\"77449\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000W0\",\"accountName\":\"PartnersinBuilding\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.partnersinbuilding.com/\",\"phoneNumber\":\"7139371121\",\"customerId\":\"PARTNERS\",\"billingAddress\":\"17361VillageGreenDrive\",\"billingCity\":\"Houston\",\"billingStateProvince\":\"TX\",\"billingPostal\":\"77040\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000W2\",\"accountName\":\"PiedmontResidential\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.piedmontresidential.com/\",\"phoneNumber\":\"6783666470\",\"customerId\":\"PIEDMONT\",\"billingAddress\":\"285Parkway575\",\"billingCity\":\"Woodstock\",\"billingStateProvince\":\"GA\",\"billingPostal\":\"30075\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0000W7\",\"accountName\":\"ScottFelderHomes\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"http://www.scottfelderhomes.com/\",\"phoneNumber\":\"5124185400\",\"customerId\":\"SCOTTFELDER\",\"billingAddress\":\"6414RiverplaceBlvd\",\"billingCity\":\"Austin\",\"billingStateProvince\":\"TX\",\"billingPostal\":\"78730\",\"billingCountry\":\"USA\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9C0007OV\",\"accountName\":\"LincolnbergCommunitiesInc.(Donotuse)\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"\",\"phoneNumber\":\"7804318800\",\"customerId\":\"LINCO\",\"billingAddress\":\"1665-91StreetSW\",\"billingCity\":\"Edmonton\",\"billingStateProvince\":\"AB\",\"billingPostal\":\"T6X0W8\",\"billingCountry\":\"Canada\",\"status\":\"Inactive\",\"clientCode\":\"Linco\",\"mappedType\":\"FormerCustomer\"},{\"accountId\":\"A6UJ9C000AWF\",\"accountName\":\"BondsGroup\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"\",\"phoneNumber\":\"7783738566\",\"customerId\":\"HOWEST\",\"billingAddress\":\"500\",\"billingCity\":\"Vancouver\",\"billingStateProvince\":\"BC\",\"billingPostal\":\"V6Z2N1\",\"billingCountry\":\"Canada\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9D0001TL\",\"accountName\":\"DilworthHomes\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"\",\"phoneNumber\":\"2507638232\",\"customerId\":\"\",\"billingAddress\":\"206-2365GordonDrive\",\"billingCity\":\"kelowna\",\"billingStateProvince\":\"BC\",\"billingPostal\":\"V1W3C2\",\"billingCountry\":\"Canada\",\"status\":\"Active\",\"clientCode\":\"\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9D00029F\",\"accountName\":\"11654128CanadaInc\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"\",\"phoneNumber\":\"8195681723\",\"customerId\":\"116CAN2021A00\",\"billingAddress\":\"768BoulevardSaint-JosephBlvd.,Suite100\",\"billingCity\":\"Gatineau\",\"billingStateProvince\":\"QC\",\"billingPostal\":\"J8Y4B8\",\"billingCountry\":\"Canada\",\"status\":\"Active\",\"clientCode\":\"11654\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9D0002AV\",\"accountName\":\"AnthemPropertiesNS\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"\",\"phoneNumber\":\"16046893040\",\"customerId\":\"ANTHEM2021B03\",\"billingAddress\":\"500DunsmuirStreet,Suite1000\",\"billingCity\":\"Vancouver\",\"billingStateProvince\":\"BC\",\"billingPostal\":\"V7X1K8\",\"billingCountry\":\"Canada\",\"status\":\"Active\",\"clientCode\":\"ANTHE\",\"mappedType\":\"Customer\"},{\"accountId\":\"A6UJ9D0002L3\",\"accountName\":\"RebelDevelopment\",\"accountType\":\"Customer\",\"parentAccountId\":\"\",\"webURL\":\"\",\"phoneNumber\":\"9706899345\",\"customerId\":\"300019\",\"billingAddress\":\"4775LarimerParkwaySuite220\",\"billingCity\":\"Johnstown\",\"billingStateProvince\":\"CO\",\"billingPostal\":\"80534\",\"billingCountry\":\"\",\"status\":\"Active\",\"clientCode\":\"REBELD\",\"mappedType\":\"Customer\"}]}'); 
    }
    
    public ContactsResponse GetInforContactsHourlyDataMock(){
        
        return ContactsResponse.parse('{\"responseTime\":\"2022-02-28T14:39:49.3307022Z\",\"responseCode\":200,\"responseMessage\":\"Datafound:88recordsfound.\",\"dataSet\":[{\"contactId\":\"C6UJ9A002UST\",\"firstName\":\"David\",\"lastName\":\"Page\",\"title\":\"\",\"accountId\":\"A6UJ9A00179X\",\"email\":\"david@aragon.ca\",\"fax\":\"6047326178\",\"phoneNumber\":\"4165316361\",\"mobileNumber\":\"\",\"mailingStreet\":\"1628W1stAve\",\"mailingCity\":\"Vancouver\",\"mailingStateProvince\":\"BC\",\"mailingPostal\":\"V6J1G1\",\"mailingCountry\":\"Canada\",\"status\":\"Active\",\"doNotEmail\":false,\"doNotSolicit\":false,\"doNotPhone\":false,\"isPrimary\":false,\"npsScores\":[]},{\"contactId\":\"C6UJ9B00005L\",\"firstName\":\"Rajanisan\",\"lastName\":\"Jesurasan\",\"title\":\"\",\"accountId\":\"A6UJ9A00006K\",\"email\":\"rjesurasan@sorbara.com\",\"fax\":\"9058506166\",\"phoneNumber\":\"4167987254x237\",\"mobileNumber\":\"\",\"mailingStreet\":\"3700SteelesAvenueWest\",\"mailingCity\":\"Woodbridge\",\"mailingStateProvince\":\"ON\",\"mailingPostal\":\"L4L8M9\",\"mailingCountry\":\"Canada\",\"status\":\"Active\",\"doNotEmail\":false,\"doNotSolicit\":false,\"doNotPhone\":false,\"isPrimary\":false,\"npsScores\":[{\"npsId\":\"Q6UJ9C0AQOJF\",\"contactId\":\"C6UJ9B00005L\",\"score\":\"10\",\"npsDate\":\"11/05/20207:00AM\",\"source\":\"AnnualSurvey\",\"reference\":\"\"}]},{\"contactId\":\"C6UJ9B000162\",\"firstName\":\"Kim\",\"lastName\":\"Winden\",\"title\":\"\",\"accountId\":\"A6UJ9A00006Z\",\"email\":\"kwinden@taylormorrison.com\",\"fax\":\"\",\"phoneNumber\":\"4808408142\",\"mobileNumber\":\"4808408142\",\"mailingStreet\":\"4900N.ScottsdaleRoad,Suite2000\",\"mailingCity\":\"Scottsdale\",\"mailingStateProvince\":\"AZ\",\"mailingPostal\":\"85251\",\"mailingCountry\":\"USA\",\"status\":\"Active\",\"doNotEmail\":false,\"doNotSolicit\":false,\"doNotPhone\":false,\"isPrimary\":false,\"npsScores\":[]},{\"contactId\":\"C6UJ9B0008TJ\",\"firstName\":\"Chelsea\",\"lastName\":\"Clark\",\"title\":\"\",\"accountId\":\"A6UJ9A00004A\",\"email\":\"chelsea@libertyhomes.com\",\"fax\":\"8015612550\",\"phoneNumber\":\"8016172817\",\"mobileNumber\":\"\",\"mailingStreet\":\"9075South1300East\",\"mailingCity\":\"Sandy\",\"mailingStateProvince\":\"UT\",\"mailingPostal\":\"84094\",\"mailingCountry\":\"USA\",\"status\":\"Active\",\"doNotEmail\":false,\"doNotSolicit\":false,\"doNotPhone\":false,\"isPrimary\":false,\"npsScores\":[]}]}');
    }
    
    public ProductsResponse GetInforProductsHourlyDataMock(){

        return ProductsResponse.parse('{\"responseTime\":\"2022-02-25T16:58:46.3015114Z\",\"responseCode\":200,\"responseMessage\":\"Datafound:352recordsfound.\",\"dataSet\":[{\"team\":\"\",\"productName\":\"NEWSTARFOCUSforEnterprise\",\"productId\":\"Y6UJ9A000002\",\"status\":\"Available\",\"family\":\"Software\",\"description\":\"NEWSTARFOCUSforEnterprise\\nQueryTool:Formerly:DBx\\n\",\"quantity\":\"\",\"isActive\":true},{\"team\":\"\",\"productName\":\"NEWSTARSales\",\"productId\":\"Y6UJ9A000003\",\"status\":\"Available\",\"family\":\"Software\",\"description\":\"NEWSTARSales(formerlySalesProfiler)\",\"quantity\":\"\",\"isActive\":true},{\"team\":\"\",\"productName\":\"NEWSTARCosting\",\"productId\":\"Y6UJ9A000004\",\"status\":\"Available\",\"family\":\"Software\",\"description\":\"NEWSTARGeneralCosting\",\"quantity\":\"\",\"isActive\":true\"productId\":\"Y6UJ9A00000B\",\"status\":\"Available\",\"family\":\"Software\",\"description\":\"NEWSTARMICR-includesonelogoandonesignature\",\"quantity\":\"\",\"isActive\":true}]}');
    }
    
    public AccountProductsResponse GetInforAccountProductsHourlyDataMock(){
        
        return AccountProductsResponse.parse('{\"responseTime\":\"2022-02-28T14:42:20.5605821Z\",\"responseCode\":200,\"responseMessage\":\"Datafound:4recordsfound.\",\"dataSet\":[{\"accountId\":\"A6UJ9A000V8Q\",\"accountProductId\":\"Q6UJ9C0AGA92\",\"productId\":\"Y6UJ9A0000C9\",\"productName\":\"BTBuilderActiveUsers\",\"productSKU\":\"BTBuilderUsers\",\"quantity\":\"-18\"},{\"accountId\":\"A6UJ9A0017CT\",\"accountProductId\":\"Q6UJ9C0AGA8Z\",\"productId\":\"YVKNPAV0000O\",\"productName\":\"Conasys:IntegratedPlatform\",\"productSKU\":\"Conasys\",\"quantity\":\"51\"},{\"accountId\":\"A6UJ9A0017CT\",\"accountProductId\":\"Q6UJ9C0AGA90\",\"productId\":\"YVKNPAV0000P\",\"productName\":\"Conasys:PrintedHomeownerGuide\",\"productSKU\":\"ConasysPrintedGuides\",\"quantity\":\"51\"},{\"accountId\":\"A6UJ9A0017CT\",\"accountProductId\":\"Q6UJ9C0AGA91\",\"productId\":\"YVKNPAV0000V\",\"productName\":\"Conasys:HomeownerCareapp\",\"productSKU\":\"ConasysCareApp\",\"quantity\":\"1\"}]}');
    }
}