public class InforNpsScore {
    public String npsId {get;set;} 
    public String contactId {get;set;} 
    public String score {get;set;} 
    public String npsDate {get;set;} 
    public String source {get;set;} 
    public String reference {get;set;} 

    public InforNpsScore(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'npsId') {
                        npsId = parser.getText();
                    } else if (text == 'contactId') {
                        contactId = parser.getText();
                    } else if (text == 'score') {
                        score = parser.getText();
                    } else if (text == 'npsDate') {
                        npsDate = parser.getText();
                    } else if (text == 'source') {
                        source = parser.getText();
                    } else if (text == 'reference') {
                        reference = parser.getText();
                    } else {
                        System.debug(LoggingLevel.WARN, 'NpsScores consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
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
}