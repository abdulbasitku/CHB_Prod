@isTest
public class DataTableData {

    private List<Object> pDataList;
    private List<Id> pSelectedRows;
    
    @AuraEnabled
    public List<Object> DataList{
        get {return pDataList;}
        set{pDataList = value;}
    }
    
    @AuraEnabled
    public List<Id> SelectedRows{
        get {return pSelectedRows;}
        set{pSelectedRows = value;}
    }
}