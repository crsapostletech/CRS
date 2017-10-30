({
    getUserInfo : function(component) {
        
        //get the Lot code for current lot id selected
        var action = component.get('c.getUserInfo');
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS")
            {
                var resp = response.getReturnValue();
                console.log('--@getDetails-')
                console.log(resp);
                if(!$A.util.isEmpty(resp)){
                    component.set("v.usrWrap", resp);                    
                }                
            }
            else {
                console.log('--Action to server failed--')
                //component.find("nextBtn").set("v.disabled", false);
            }            
        });
        $A.enqueueAction(action);         
    },
    
    insertCase : function(component) {
        
        var validateSuccess = this.doValidateForm(component);
        console.log('--validateSuccess--'+validateSuccess);
        
        var pickListvalidate = this.casePicklistValidate(component);
        
        //verfy for validation success. Proceed to server action
        if(validateSuccess && pickListvalidate){
            
            var action = component.get('c.insertCaseRec');
            action.setParams({ "caseobj" : component.get("v.caseInfo"), "usrInfoWrap" : JSON.stringify(component.get("v.usrWrap"))});
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (component.isValid() && state === "SUCCESS")
                {
                    console.log('Insert success!');
                    window.open("https://sandboxtle-crsdevtest.cs94.force.com/crs/s/case/Case/Recent", "_top");                    
                }
                else {
                    console.log('--Action to server failed--')
                    //component.find("nextBtn").set("v.disabled", false);
                }
            });
            $A.enqueueAction(action);
        }
    },
    doValidateForm : function(component)
    {        
        var reqCmps = component.find("reqObj");
        var isValidSucc = true;
        
        //If array of Tags found
        if( Array.isArray(reqCmps) )
        {
            for(var i=0;i<reqCmps.length; i++)
            {                
                var curntObj = reqCmps[i];
                var className = curntObj.get("v.class");
                var atrValue = curntObj.get("v.value");
                
                if($A.util.isEmpty(atrValue))
                {
                    isValidSucc = false;                    
                    if(!$A.util.hasClass(curntObj, "errorHigh")){
                        //$A.util.addClass(curntObj, "errorHigh");
                    }                    
                }
                else {
                    if($A.util.hasClass(curntObj, "errorHigh")){
                        //$A.util.removeClass(curntObj, "errorHigh");
                    }
                }                
            }
        } //If a single Tag found
        else if(this.isAnObject( reqCmps )){
            
            var curntObj = reqCmps;
            var className = curntObj.get("v.class");
            var atrValue = curntObj.get("v.value");
            
            if($A.util.isEmpty(atrValue)){
                isValidSucc = false;
                
                if(!$A.util.hasClass(curntObj, "errorHigh")){
                    //$A.util.addClass(curntObj, "errorHigh");
                }
            }
            else {
                if($A.util.hasClass(curntObj, "errorHigh")){
                    //$A.util.removeClass(curntObj, "errorHigh");
                }
            }            
        }
        
        //show / hide the error panel on Top
        if(!isValidSucc){
            $A.util.removeClass(component.find("errDiv"), "slds-hide");            
        }
        else if(isValidSucc){
            if(!$A.util.hasClass(component.find("errDiv"), "slds-hide")){
                $A.util.addClass(component.find("errDiv"), "slds-hide");
            }
        }
        return isValidSucc;
    },
    casePicklistValidate: function(component)
    {	
        var isValidSucc = true;
        
        
        if($A.util.isEmpty(component.get("v.caseInfo").Damaged_Property_Country__c) || 
           $A.util.isEmpty(component.get("v.caseInfo").Damaged_Property_State_Province__c) || 
           $A.util.isEmpty(component.get("v.caseInfo").Type_of_Loss__c) || 
           $A.util.isEmpty(component.get("v.caseInfo").Policy_Type__c) 
          ){
            
            isValidSucc = false;
        }
        
        //show / hide the error panel on Top
        if(!isValidSucc){
            $A.util.removeClass(component.find("errDiv"), "slds-hide");            
        }
        else if(isValidSucc){
            if(!$A.util.hasClass(component.find("errDiv"), "slds-hide")){
                $A.util.addClass(component.find("errDiv"), "slds-hide");
            }
        }
        return isValidSucc;
    },
    isAnObject: function(item)
    {        
        return (typeof item === "object" && !Array.isArray(item) && item !== null);
    },
    
    getStateValues : function(cmp,event){
        var action = cmp.get("c.getPicklistValues");
        action.setParams({"fieldName" : "Damaged_Property_State_Province__c", "sObjectName" : "Case"});
        action.setCallback(this, function(response) {
            console.log(response);
            if(cmp.isValid() && response.getState() === "SUCCESS") {
                console.log(response.getReturnValue());
                var options = response.getReturnValue();
                
                var picklistOptions = [];
                for (var i= 0; i < options.length ; i++)
                {
                    console.log('zzz..!',options[i]);
                    picklistOptions.push({
                        label : options[i].label,
                        value : options[i].pvalue
                    }); 
                }
                console.log(picklistOptions);
                cmp.find("state").set("v.options", picklistOptions);
            }
        });
        $A.enqueueAction(action);
    }
})