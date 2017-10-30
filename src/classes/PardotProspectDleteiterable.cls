global class PardotProspectDleteiterable implements iterable<String>{
   global List<String> prospectIdList;
   global Iterator<String> Iterator(){
      return new pardotProspectCustomIterable(prospectIdList);
   }
   global pardotProspectDleteiterable(list<String> ProspectId){
       prospectIdList = ProspectId;
   }
}