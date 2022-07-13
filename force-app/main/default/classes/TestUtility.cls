public class TestUtility {
    
    public static InforAccount CreateInforAccount_Mock() {
        
        InforAccount inforAccount = new InforAccount();
        
        inforAccount.accountId = 'TestInforAccountId';
        inforAccount.accountName = 'TestInforAccount'; 
        inforAccount.accountType = 'Customer';
        inforAccount.parentAccountId = 'TestInforAccountParentId';
        inforAccount.webURL ='www.google.com';
        inforAccount.phoneNumber = '123456789';
        inforAccount.customerId = 'TestCustomerId';
        inforAccount.billingCity = 'Karachi';
        inforAccount.billingStateProvince = 'Sindh';
        inforAccount.billingPostal = '74900';
        inforAccount.billingCountry = 'Pakistan';
        inforAccount.status = 'Active';
        inforAccount.clientCode = 'TP01';
        inforAccount.mappedType = 'Customer';
        
        return inforAccount;
    }
    
    public static InforContact CreateInforContact_Mock() {
        
        InforContact inforContact = new InforContact();
        
        inforContact.contactId = 'TestInforContactId' ;
        inforContact.accountId = 'TestInforAccountId';
        inforContact.title='Marketing Manager';
        inforContact.email='abc@abc.com'; 
        inforContact.fax='1234567890';
        inforContact.phoneNumber = '123456789';
        inforContact.lastName = 'TestInforContactLast';
        inforContact.firstName = 'TestInforContactFirst';
        inforContact.mobileNumber = '123456789';
        inforContact.mailingStreet = '23';
        inforContact.mailingCity = 'Karachi';
        inforContact.mailingStateProvince = 'Sindh';
        inforContact.mailingPostal = '74900';
        inforContact.mailingCountry = 'Pakistan';
        inforContact.status = 'Active';
        inforContact.doNotEmail = false;
        inforContact.doNotSolicit= false;
        inforContact.doNotPhone = false;
        inforContact.isPrimary=false;
        
        return inforContact;
    }
    
    public static InforProduct CreateInforProduct_Mock() {
        
        InforProduct inforProduct = new InforProduct();
        
        inforProduct.productId = 'TestInforProductId' ;
        inforProduct.productName = 'TestInforProduct' ;
        inforProduct.isActive = true;
        
        return inforProduct;
    }
    
    public static InforAccountProduct CreateInforAccountProduct_Mock() {
        
        InforAccountProduct inforAccountProduct = new InforAccountProduct();
        
        inforAccountProduct.productId = 'TestInforProductId' ;
        inforAccountProduct.accountId = 'TestInforAccountId' ;
        inforAccountProduct.accountProductId = 'TestInforAccountProductId' ;
        inforAccountProduct.quantity = 10 ;
        
        return inforAccountProduct;
    }
}