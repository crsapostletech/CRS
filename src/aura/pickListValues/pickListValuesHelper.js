({
	onloadValues : function(component,event) {
		var action = component.get("c.getPicklistValues");
        action.setParams({"fieldName" : component.get("v.fieldName"), "sObjectName" : component.get("v.sObjectName")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state == "SUCCESS")
            {   
                var picklistresult = response.getReturnValue();
                console.log(picklistresult);
                var options = [];
                options.push({
                    label : '--Select--',
                    value : ''
                });
                for(var i =0;i<picklistresult.length;i++)
                {
                    options.push({
                        label : picklistresult[i].label,
                        value : picklistresult[i].pvalue
                    });
                }
                component.find("dynamicSelect").set("v.options",options);
            }
            
        });	
        $A.enqueueAction(action); 
	},
    
    changePickValue : function(component,event) {
        //var updateEvent = component.getEvent("selectedPickValue");
        var updateEvent = $A.get("e.c:pickListValuesEvent");

        var selectedValue = component.get('v.fieldName');
        var isRequiredValue = component.get("v.isRequired");
        var fieldLabel = component.get("v.labelName");
        $A.util.addClass(component.find("originRequired"), "slds-hide");
        if(isRequiredValue && selectedValue == ""){
            $A.util.removeClass(component.find("originRequired"), "slds-hide");
        }
        updateEvent.setParams({
            "pickedValue" : selectedValue,
            "eventFired" : true,
            "pickListType" : fieldLabel 
        });
        console.log(selectedValue+''+fieldLabel+''+isRequiredValue);
        updateEvent.fire(); 
    }
})