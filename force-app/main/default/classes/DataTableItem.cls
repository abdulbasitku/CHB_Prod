@isTest
public class DataTableItem {

    private String pName;
    private String pId;
    
    @AuraEnabled
    public String Name{
        get {return pName;}
        set{pName = value;}
    }
    
    @AuraEnabled
    public String Id{
        get {return pId;}
        set{pId = value;}
    }
}