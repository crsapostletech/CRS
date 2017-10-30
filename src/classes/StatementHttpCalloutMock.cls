@isTest
global class StatementHttpCalloutMock implements HttpCalloutMock
{
	global HTTPResponse respond(HTTPRequest req)
    {
        HttpResponse hr = new HttpResponse();
         hr.setHeader('Content-Type', 'application/xml');
        hr.setBody(' ');
        hr.setStatusCode(200);
        return hr;
    }
}