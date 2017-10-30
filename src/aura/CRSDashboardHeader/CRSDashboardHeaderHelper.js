({
	createCase : function(component) {
        var case = component.get('v.cs');
        var recType = component.get('v.selectedRecordType');
        var action = component.get('c.saveCase');
        action.setParams({"c1":case,"recordType":recType});
    	action.setCallback(this,function(result){
            alert();
        });
	}
})