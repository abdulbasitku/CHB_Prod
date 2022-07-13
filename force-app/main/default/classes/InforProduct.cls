public class InforProduct {
    public String team {get;set;} 
    public String productName {get;set;} 
    public String productId {get;set;} 
    public String status {get;set;} 
    public String family {get;set;} 
    public String description {get;set;} 
    public String quantity {get;set;}
    public boolean isActive {get;set;}  
    
    public InforProduct(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'team') {
                        team = parser.getText();
                    } else if (text == 'productName') {
                        productName = parser.getText();
                    } else if (text == 'productId') {
                        productId = parser.getText();
                    } else if (text == 'status') {
                        status = parser.getText();
                    } else if (text == 'family') {
                        family = parser.getText();
                    } else if (text == 'description') {
                        description = parser.getText();
                    } else if (text == 'quantity') {
                        quantity = parser.getText();
                    } else if (text == 'isActive') {
                        isActive = parser.getBooleanValue();
                    } else {
                        System.debug(LoggingLevel.WARN, 'DataSet consuming unrecognized property: '+text);
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
    
    public InforProduct() {
        
    }
}