#!/usr/bin/env python

from bottle import post, route, run, request, response, static_file
import logging
import barrister

class AuthService(object):
    
    def __init__(self):
        self.users = { }
        self.users['scott'] = { "username" : "scott", "firstName" : "Scott", "lastName" : "Smith" }
    
    def login(self, username, passwd):
        if username == "scott" and passwd == "tiger":
            return self.users['scott']
        else:
            raise barrister.RpcException(100, "Invalid username/password")

    def updateUser(self, user):
        self.users[user['username']] = user
        return True

contract = barrister.contract_from_file("idl/auth.json")
auth_svr = barrister.Server(contract)
auth_svr.add_handler("AuthService", AuthService())

########################################

JS_LIBS = """
<script src="/static/js/jquery-1.7.2.min.js"></script>
<script src="/static/js/json2.min.js"></script>
<script src="/static/js/mustache.min.js"></script>
<script src="/static/js/underscore-min.js"></script>
<script src="/static/js/backbone-min.js"></script>
<script src="/static/js/barrister.browser.min.js"></script>
<script src="/static/js/app-full.js"></script>
"""

@post('/api/auth')
def auth():
    data = request.body.read()
    resp_json = auth_svr.call_json(data)
    response.content_type = 'application/json'
    return resp_json

@route('/static/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='htdocs')
    
@route('/docs/<filepath:path>')
def server_static(filepath):
    return static_file(filepath, root='docs')
        
@route('/')
def index():
    return """<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
                        "http://www.w3.org/TR/html4/loose.dtd">
      <html>
      <head>
        <meta charset="utf-8">
        <title>Imprev</title>
      </head>
      <body>
        <div id="main"></div>
      
        %s
        <script type="text/javascript">
            jQuery(document).ready(function() {
                var authClient = Barrister.httpClient("/api/auth");
                authClient.loadContract(function(err) {
                    if (err) { 
                        alert("Unable to load contract: " + err);
                    }
                    else {
                        var authSvc = authClient.proxy("AuthService");
                        var args = {
                            root: $('#main'),
                            authSvc: authSvc
                        };
                        var router  = new AppRouter(args);
                        Backbone.history.start();
                        router.login();
                    }
                });
            });
        </script>
      </body>
      </html>
    """ % JS_LIBS
    
@route('/qunit/:test')
def qunit(test):
    f = open("htdocs/test/%s" % test)
    test_code = f.read()
    f.close()
    return """
    <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" 
                        "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    <head>
      <link rel="stylesheet" href="/static/test/qunit-git.css" type="text/css" media="screen" />
    </head>
    <body>
      <h1 id="qunit-header">QUnit example</h1>
     <h2 id="qunit-banner"></h2>
     <div id="qunit-testrunner-toolbar"></div>
     <h2 id="qunit-userAgent"></h2>
     <ol id="qunit-tests"></ol>
     <div id="qunit-fixture">test markup, will be hidden</div>
     %s
     <script type="text/javascript" src="/static/test/qunit-git.js"></script>
     <script type="text/javascript" src="/static/test/testlib.js"></script>
     <script type="text/javascript">
       $(document).ready(function(){
          %s
       });
     </script>
    </body>
    </html>
    """ % (JS_LIBS, test_code)

logger = logging.getLogger('wsgi')
logger.propagate = False
logger.disabled  = True
run(host='0.0.0.0', port=8080, server='paste')