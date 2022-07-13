public class InforAccountProduct {
    public String accountId {get;set;} 
    public String accountProductId {get;set;} 
    public String productId {get;set;} 
    public String productName {get;set;} 
    public String productSKU {get;set;} 
    public Decimal quantity {get;set;} 
    
    public InforAccountProduct(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'accountId') {
                        accountId = parser.getText();
                    } else if (text == 'accountProductId') {
                        accountProductId = parser.getText();
                    } else if (text == 'productId') {
                        productId = parser.getText();
                    } else if (text == 'productName') {
                        productName = parser.getText();
                    } else if (text == 'productSKU') {
                        productSKU = parser.getText();
                    } else if (text == 'quantity') {
                        quantity = decimal.valueOf(parser.getText());
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
    
    public InforAccountProduct() {
        
    }
}