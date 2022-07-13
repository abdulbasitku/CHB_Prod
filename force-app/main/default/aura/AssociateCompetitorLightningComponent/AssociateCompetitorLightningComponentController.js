({
    doInit : function(component, event, helper) {
        console.log("dn1");
        var action = component.get("c.getCompetitorAccounts");
        /*action.setParams({
            "oppId": component.get("v.recordId")
        });*/
        action.setCallback(this, function(response) {
            
             console.log(response.getReturnValue());
            component.set("v.Account", response.getReturnValue());

        });
        $A.enqueueAction(action);
    },
    //Process the selected contacts
    submitBtnClick: function(component, event, helper) {
        
        var selectedContacts = [];
        var checkvalue = component.find("checkAccount");
         
        if(!Array.isArray(checkvalue)){
            if (checkvalue.get("v.value") == true) {
                selectedContacts.push(checkvalue.get("v.text"));
            }
        }else{
            for (var i = 0; i < checkvalue.length; i++) {
                if (checkvalue[i].get("v.value") == true) {
                    selectedContacts.push(checkvalue[i].get("v.text"));
                }
            }
        }
        
        console.log('selectedContacts-' + selectedContacts);
        
        var action = component.get("c.associateCompetitorAccountWithOpp");
        
        action.setParams({
            "oppId": component.get("v.recordId"),
            "selectedAccountIds": selectedContacts
        });
        
        action.setCallback(this, function(response) {
            $A.get('e.force:refreshView').fire();
            $A.get("e.force:closeQuickAction").fire();
        });
        
        $A.enqueueAction(action);
    },
     cancelBtnClick: function(component, event, helper) {
         $A.get("e.force:closeQuickAction").fire();
     }
})