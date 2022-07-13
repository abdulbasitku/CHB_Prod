@isTest
public class ComboBoxClass {
    
    private String pLabel;
    private String pValue;
    private String pName;
    
     private String pSelected;
    
    @AuraEnabled
    public String  selected{
        get {return pSelected;}
        set{pSelected = value;}
    }
    
    @AuraEnabled
    public String label{
        get {return pLabel;}
        set{pLabel = value;}
    }
    
    @AuraEnabled
    public String value{
        get {return pValue;}
        set{pValue = value;}
    }
    
    @AuraEnabled
    public String name{
        get {return pName;}
        set{pName = value;}
    }
}