({
	myAction : function(component, event, helper) {
		
	},
    CreateDefaultQuotesBtnClick: function(component,event) {
        
        console.log("recordidjs: "+component.get("v.recordId"));
        
        var action = component.get("c.CreateDefaultQuotesByOppId");
        action.setParams({ oppId : component.get("v.recordId") });

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert(response.getReturnValue());                
            	$A.get('e.force:refreshView').fire();
				$A.get("e.force:closeQuickAction").fire();
            }
            else if (state === "INCOMPLETE") {
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                 errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        
        $A.enqueueAction(action);
    },
    
})