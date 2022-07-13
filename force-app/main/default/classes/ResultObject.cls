@isTest
public class ResultObject {

    public enum StatusCode {SUCCESS, ERROR, SUCCESSWITHERROR}
    private StatusCode pStatus;
    private String pMessage;
    private Object pData; 
    
    public StatusCode STATUS{
        get {return pStatus;}
        set{pStatus = value;}
    }
        
    @AuraEnabled
    public String STATUSS{
        get { return String.valueOf(pStatus).toLowerCase(); }
    }
    
    @AuraEnabled
    public String MESSAGE{
        get {return pMessage;}
        set{pMessage = value;}
    }
        
    @AuraEnabled
    public Object Data{
        get {return pData;}
        set{pData = value;}
    }
}