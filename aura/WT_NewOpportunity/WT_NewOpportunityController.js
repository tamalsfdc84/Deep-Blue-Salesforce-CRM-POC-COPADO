({
    init : function (component) {
        var pageRef = component.get("v.pageReference");
        var state = pageRef.state; 
        var base64Context = state.inContextOfRef;
        if (base64Context.startsWith("1\.")) {
            base64Context = base64Context.substring(2);
        }
        var addressableContext = JSON.parse(window.atob(base64Context));
        component.set("v.accountID", addressableContext.attributes.recordId);
        var AccountID = component.get("v.accountID");
        var flow = component.find("flowData");
        if(AccountID != null && AccountID!=''){
            var inputVariables = [
                {
                    name : "varAccountId",
                    type : "String",
                    value : addressableContext.attributes.recordId
                }
            ];
            flow.startFlow("WT_New_Opportunity", inputVariables); 
        }
        else{
            flow.startFlow("WT_New_Opportunity");
        }
    },
    handleStatusChange : function (component, event) {
   if(event.getParam("status") === "FINISHED") {
      var outputVariables = event.getParam("outputVariables");
      var outputVar;
      for(var i = 0; i < outputVariables.length; i++) {
         outputVar = outputVariables[i];
         if(outputVar.name === "varOpportunityID") {
            var urlEvent = $A.get("e.force:navigateToSObject");
            urlEvent.setParams({
               "recordId": outputVar.value,
               "isredirect": "true"
            });
            urlEvent.fire();
         }
      }
   }
},
})