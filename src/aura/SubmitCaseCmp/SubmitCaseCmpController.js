({	
    doInit : function(component, event, helper)
    {
        helper.getUserInfo(component);
        //helper.getStateValues(component,event);
    },
    cancelAct : function(component, event, helper) {
        window.open("https://sandboxtle-crsdevtest.cs94.force.com/crs/s/case/Case/Recent", "_top");
    },
    createCase : function(component, event, helper) {
        helper.insertCase(component);
    },
    validateNumber : function(component, event, helper) {
        var charCode = (event.which) ? event.which : event.keyCode
        if (charCode > 31 && (charCode < 48 || charCode > 57))
            return false;
        
        return true;
    },
    getPickListValues : function(component, event, helper) {
        var pickVal = event.getParam("pickedValue");
        var isEventFired = event.getParam("eventFired");
        var pickLabel = event.getParam("pickListType");
        if(pickLabel == "state"){
            component.set("v.caseInfo.Damaged_Property_State_Province__c",pickVal);
        }
        else if(pickLabel == "country"){
            component.set("v.caseInfo.Damaged_Property_Country__c",pickVal);
        }
            else if(pickLabel == "typeLoss"){
                component.set("v.caseInfo.Type_of_Loss__c",pickVal);
            }
                else if(pickLabel == "Reason"){
                    component.set("v.caseInfo.Reason",pickVal);
                }
                    else if(pickLabel == "policyType"){
                        component.set("v.caseInfo.Policy_Type__c",pickVal);
                    }
                        else if(pickLabel == "serviceReq"){
                            component.set("v.caseInfo.Services_Requested__c",pickVal);
                        }
    },
    formatREGex : function(component, event, helper) {
        
        var inputPhone = event.getSource().get("v.value");
        
        if(!$A.util.isEmpty(inputPhone)){
            var finalVal = inputPhone.replace(/(\d{3})(\d{3})(\d{4})/, '($1) $2-$3');
            console.log('inputPhone ', finalVal); 
            event.getSource().set("v.value", finalVal);
        }
        
        
    }
})