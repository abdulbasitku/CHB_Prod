@isTest
public class ComboBoxData {

    private List<ComboBoxClass> pDataList;
    private ComboBoxClass pSelectedItem;
    
    @AuraEnabled
    public List<ComboBoxClass> DataList{
        get {return pDataList;}
        set{pDataList = value;}
    }
    
    @AuraEnabled
    public ComboBoxClass SelectedItem{
        get {return pSelectedItem;}
        set{pSelectedItem = value;}
    }
}