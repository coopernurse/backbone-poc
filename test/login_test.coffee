
submitLogin = (username, password) ->
    $('#qunit-fixture input[name=username]').val(username)
    $('#qunit-fixture input[name=password]').val(password)
    $('#qunit-fixture form').submit()
    
submitEditUser = (firstName, lastName) ->
    $('#qunit-fixture input[name=firstName]').val(firstName)
    $('#qunit-fixture input[name=lastName]').val(lastName)
    $('#qunit-fixture form').submit()
    
clickLogout = ->
    $('#qunit-fixture a.logout').click()
    
statusMsg = ->
    $('#qunit-fixture div.message').html()


#
# All tests use 'asyncTest' so that they run sequentially
# start() must be called at the end of each test so that QUnit knows
# to run the next one.
#

asyncTest "login form rendered", ->
    for name in [ "username", "password"]
        equal 1, $("#qunit-fixture input[name=#{name}]").length, "#{name} not found"
    equal 0, $('#qunit-fixture input[name=foo]').length, "foo not exists"
    start()
    
asyncTest "login submit - success", ->
    submitLogin("scott", "tiger")
    wait done: ->
        equal 1, $('#qunit-fixture input[name=firstName]').length, "firstName field not found"
        start()
        
asyncTest "login submit - failure", ->
    submitLogin("zzz", "aaa")
    wait done: ->
        ok statusMsg().indexOf('Invalid username/password') > -1, "error msg not found"
        start()
        
asyncTest "edit page - logout", ->
    submitLogin("scott", "tiger")
    wait done: ->
        clickLogout()
        equal 1, $("#qunit-fixture input[name=username]").length, "username not found"
        start()
        
asyncTest "edit user submit - failure", ->
    submitLogin("scott", "tiger")
    wait done: ->
        equal 1, $("#qunit-fixture input[name=firstName]").length, "firstName not found"
        submitEditUser("", "")
        wait done: ->
            ok statusMsg().indexOf('error: ') > -1, "error msg not found"
            start()
            
asyncTest "edit user submit - success", ->
    submitLogin("scott", "tiger")
    wait done: ->
        submitEditUser("Bob", "Jones")
        wait done: ->
            ok statusMsg().indexOf('Save successful') > -1, "success msg not found"
            # make sure updated user info stuck
            clickLogout()
            submitLogin("scott", "tiger")
            wait done: ->
                equal "Bob", $("#qunit-fixture input[name=firstName]").val()
                equal "Jones", $("#qunit-fixture input[name=lastName]").val()
                start()