@page {

@top-center {

	content: element(header);

}

@bottom-left {

    content: element(footer);

}
margin-top: 80px;

margin-bottom: 80px;

}

div.header {

padding: 20px;

position: running(header);

}

div.footer {

display: block;

padding: 5px;

position: running(footer);

}


.pagenumber:before {

content: counter(page);

}

.pagecount:before {

content: counter(pages);

}