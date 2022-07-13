public class InforAccount {
    public String accountId {get;set;} 
    public String accountName {get;set;} 
    public String accountType {get;set;} 
    public String parentAccountId {get;set;} 
    public String webURL {get;set;} 
    public String phoneNumber {get;set;} 
    public String customerId {get;set;} 
    public String billingAddress {get;set;} 
    public String billingCity {get;set;} 
    public String billingStateProvince {get;set;} 
    public String billingPostal {get;set;} 
    public String billingCountry {get;set;}
    public String status {get;set;}
    public String clientCode {get;set;}
    public String mappedType {get;set;}
    public String statusAndType {get {return status + '--' + accountType;}}
    //public String billingStreet {get;set;}  //It is in BillingAddress field
    
    public InforAccount()
    {
        
    }
    
    public static void consumeObject(System.JSONParser parser) {
        Integer depth = 0;
        do {
            System.JSONToken curr = parser.getCurrentToken();
            if (curr == System.JSONToken.START_OBJECT || 
                curr == System.JSONToken.START_ARRAY) {
                    depth++;
                } else if (curr == System.JSONToken.END_OBJECT ||
                           curr == System.JSONToken.END_ARRAY) {
                               depth--;
                           }
        } while (depth > 0 && parser.nextToken() != null);
    }
    
    public InforAccount(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'accountId') {
                        accountId = parser.getText();
                    } else if (text == 'accountName') {
                        accountName = parser.getText();
                    } else if (text == 'accountType') {
                        accountType = parser.getText();
                    } else if (text == 'parentAccountId') {
                        parentAccountId = parser.getText();
                    } else if (text == 'webURL') {
                        webURL = parser.getText();
                    } else if (text == 'phoneNumber') {
                        phoneNumber = parser.getText();
                    } else if (text == 'customerId') {
                        customerId = parser.getText();
                    } else if (text == 'billingAddress') {
                        billingAddress = parser.getText();
                    } else if (text == 'billingCity') {
                        billingCity = parser.getText();
                    } else if (text == 'billingStateProvince') {
                        billingStateProvince = parser.getText();
                    } else if (text == 'billingPostal') {
                        billingPostal = parser.getText();
                    } else if (text == 'billingCountry') {
                        billingCountry = parser.getText();
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'clientCode') {
                        clientCode = parser.getText();
                    } else if (text == 'mappedType') {
                        mappedType = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'InforAccount consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
}