({
	createAdjusterTransfer : function(component, event, helper) {
        component.set('v.showPopup',true);
        component.set('v.selectedRecordType','ADJUSTERTRANSFER');
	},
    createClaimSubmission : function(component, event, helper) {
        component.set('v.showPopup',true);
		component.set('v.selectedRecordType','CLAIMSUBMISSION');
	},
    createHotelExtension : function(component, event, helper) {
        component.set('v.showPopup',true);
		component.set('v.selectedRecordType','HOTELEXTENTION');
	},
 	createHousingExtension : function(component, event, helper) {
        component.set('v.showPopup',true);
		component.set('v.selectedRecordType','HOUSINGEXTENTION');
	},
    createNewCase : function(component, event, helper) {
        component.set('v.showPopup',true);
		component.set('v.selectedRecordType','NEWCASE');
	},
    closePopup : function(component, event, helper){
        component.set('v.showPopup',false);
        component.set('v.selectedRecordType','');
    },
    saveCase : function(component, event, helper){
        helper.createCase(component);
    }
})