.columns > div { clear: none !important; float: left !important; width: 42%; margin: 0 20px; }
 div.pbBody div { clear: both; float: none; }
.bPageBlock .columns .detailList .labelCol { width: 28%; }
.bPageBlock .columns .detailList .data2Col { width: 33%; }
.clear { clear: both; }
.clsCenter{text-align:center;}
.clsRight{text-align:right;}
.datePicker{z-index: 100000;}
#datePicker{z-index: 100000;}
.helpText{z-index: 100000;}
.linksCols{width:300px; text-align:left;}
.jqError {color: red;}
  
@media screen 
{
   #printSection 
   {
	 display: none;
   }
}

@media print  
{
	body *
	{
	visibility:hidden;
	}
	#saveHousingSearchButton
	{
		visibility:hidden;
	}
	#printSection, #printSection * 
	{
	visibility:visible;
	}
	
	#printSection 
	{
		position:absolute;
		left:0;
		top:0;
		font-size: 15pt;
	}
}

