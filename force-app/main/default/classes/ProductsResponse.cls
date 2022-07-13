public class ProductsResponse {
    
    public String responseTime {get;set;} 
    public Integer responseCode {get;set;} 
    public String responseMessage {get;set;} 
    public List<InforProduct> InforProducts {get;set;} 
    
    public ProductsResponse(JSONParser parser) {
        while (parser.nextToken() != System.JSONToken.END_OBJECT) {
            if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
                String text = parser.getText();
                if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
                    if (text == 'responseTime') {
                        responseTime = parser.getText();
                    } else if (text == 'responseCode') {
                        responseCode = parser.getIntegerValue();
                    } else if (text == 'responseMessage') {
                        responseMessage = parser.getText();
                    } else if (text == 'dataSet') {
                        InforProducts = arrayOfInforProduct(parser);
                    } else {
                        System.debug(LoggingLevel.WARN, 'ProductsResponse consuming unrecognized property: '+text);
                        consumeObject(parser);
                    }
                }
            }
        }
    }
    
    public static ProductsResponse parse(String json) {
        System.JSONParser parser = System.JSON.createParser(json);
        return new ProductsResponse(parser);
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
    
    private static List<InforProduct> arrayOfInforProduct(System.JSONParser p) {
        List<InforProduct> res = new List<InforProduct>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new InforProduct(p));
        }
        return res;
    } 
}