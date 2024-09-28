global class HttpCalloutMockClass implements HttpCalloutMock  {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/JSON');
        res.setBody('Your body');
        res.setStatusCode(200);
        return res;
    }
     
}