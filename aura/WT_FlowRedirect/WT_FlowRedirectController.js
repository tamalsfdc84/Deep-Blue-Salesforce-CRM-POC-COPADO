({
	init : function(component, event, helper) {
		var navEvent = $A.get("e.force:navigateToSObject");
            navEvent.setParams({
               "recordId": component.get("v.recId"),
               "slideDevName": "related"
            });
            navEvent.fire();
	}
})