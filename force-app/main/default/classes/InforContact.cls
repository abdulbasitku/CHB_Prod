public class InforContact {
    public String contactId {get;set;} 
    public String firstName {get;set;} 
    public String lastName {get;set;} 
    public String title {get;set;} 
    public String accountId {get;set;} 
    public String email {get;set;} 
    public String fax {get;set;} 
    public String phoneNumber {get;set;} 
    public String mobileNumber {get;set;} 
    public String mailingStreet {get;set;} 
    public String mailingCity {get;set;} 
    public String mailingStateProvince {get;set;} 
    public String mailingPostal {get;set;} 
    public String mailingCountry {get;set;} 
    public String status {get;set;} 
    public boolean doNotEmail {get;set;} 
    public boolean doNotSolicit {get;set;} 
    public boolean doNotPhone {get;set;}
    public boolean isPrimary {get;set;}
    public List<InforNpsScore> inforNpsScores {get;set;} 
    public string emailOptOutComb { get{ return string.valueOf(doNotEmail) + '--' + string.valueOf(doNotPhone) + '--' + string.valueOf(doNotSolicit);}}
    public boolean noLongerThere 
    {
        get
        {
            if(!string.isEmpty(status) && status.toLowerCase() == 'no longer there')
            {
                return true;
            }
            else                
            {
                return false;
            }
        }
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
    
    public InforContact(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'contactId') {
                        contactId = parser.getText();
                    } else if (text == 'firstName') {
                        firstName = parser.getText();
                    } else if (text == 'lastName') {
                        lastName = parser.getText();
                    } else if (text == 'title') {
                        title = parser.getText();
                    } else if (text == 'accountId') {
                        accountId = parser.getText();
                    } else if (text == 'email') {
                        email = parser.getText();
                    } else if (text == 'fax') {
                        fax = parser.getText();
                    } else if (text == 'phoneNumber') {
                        phoneNumber = parser.getText();
                    } else if (text == 'mobileNumber') {
                        mobileNumber = parser.getText();
                    } else if (text == 'mailingStreet') {
                        mailingStreet = parser.getText();
                    } else if (text == 'mailingCity') {
                        mailingCity = parser.getText();
                    } else if (text == 'mailingStateProvince') {
                        mailingStateProvince = parser.getText();
                    } else if (text == 'mailingPostal') {
                        mailingPostal = parser.getText();
                    } else if (text == 'mailingCountry') {
                        mailingCountry = parser.getText();
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'doNotEmail') {
                        doNotEmail = parser.getBooleanValue();
                    } else if (text == 'doNotSolicit') {
                        doNotSolicit = parser.getBooleanValue();
                    } else if (text == 'doNotPhone') {
                        doNotPhone = parser.getBooleanValue();
                    } else if (text == 'isPrimary') {
                        isPrimary = parser.getBooleanValue();
                    } else if (text == 'npsScores') {
						inforNpsScores = arrayOfNpsScores(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'DataSet consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    private static List<InforNpsScore> arrayOfNpsScores(System.JSONParser p) {
        List<InforNpsScore> res = new List<InforNpsScore>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new InforNpsScore(p));
        }
        return res;
    }

    public InforContact() {
        
    }
}