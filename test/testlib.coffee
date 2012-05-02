
# Similar to JUnit's setUp() or @Before
QUnit.testStart (obj) ->
    stop()
    root = $('#qunit-fixture')
    # destroy any existing history
    Backbone.history = null;
    Backbone.Barrister.initClient "/api/auth", (client) ->
        #client.enableTrace()
        router = new AppRouter( { root: root, authSvc: client.proxy('AuthService') } )
        Backbone.history.start()
        # always start at the login page
        router.navigate("login", { trigger: true })
        start()
        
QUnit.testDone (obj) ->
    Backbone.history.stop()
    status = if obj.failed == 0 then "PASS" else "FAIL"
    console.log "#{status}\t#{obj.name}"

#
# Simple mechanism to block test execution until AJAX requests
# have completed
#
ajaxCount = 0
jQuery('body').ajaxStart ->
    ajaxCount++
    
jQuery('body').ajaxStop ->
    ajaxCount--
        
wait = ({timeout, done}) ->
    timeout ?= 1000
    if timeout < 0
        console.log "Timeout exceeded!"
        done()
    else if ajaxCount == 0 
        done()
    else
        recurse = ->
            wait timeout: timeout-10, done: done 
        setTimeout recurse, 10
