({
	afterScriptsLoaded : function(component, event, helper) {
		var addressArr = ['25 Bedford St, New York,USA','United States Fund for UNICEF 125 Maiden Lane, New York'];
        var map = new google.maps.Map(document.getElementById('map'), { 
            mapTypeId: google.maps.MapTypeId.TERRAIN,
            zoom: 3
        });
        var geocoder = new google.maps.Geocoder();
        for(var i=0;i<addressArr.length;i++)
        {
            geocoder.geocode({'address': addressArr[i]},function(results, status) 
             {
                 console.log(results);
                 if(status == google.maps.GeocoderStatus.OK)
                 {
                     var Marker = new google.maps.Marker({
                         position: results[0].geometry.location,
                         map: map
                     });
                     map.setCenter(results[0].geometry.location);
                     var infowindow = new google.maps.InfoWindow({
                         content: results[0].formatted_address
                     });
                     Marker.addListener('mouseover', function(){
                         infowindow.open(map, Marker);
                     });
                     Marker.addListener('mouseout', function(){
                         infowindow.close();
                     });
                 }
             });
        }
    }
})