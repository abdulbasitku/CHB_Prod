@isTest
public class ResultObject_Test {
    
    static testMethod void ResultObjectClassTest(){
        
        ResultObject resultObj = new ResultObject();
        resultObj.Data = 'asdf';
        resultObj.STATUS = ResultObject.StatusCode.SUCCESS;
        resultObj.MESSAGE = 'asdfMsg';
        string statusString = resultObj.STATUSS;
        
        system.assertEquals(resultObj.MESSAGE, 'asdfMsg');        
        
    }
}