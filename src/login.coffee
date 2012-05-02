
class User extends Backbone.Model
    idAttribute: 'username'
    barrister: { entity: 'User', interface: 'AuthService', endpoint: '/api/auth' }
    
    validate: (attrs) ->
        for field in ["firstName", "lastName"]
            if not attrs[field]
                return "#{field} is required"

class LoginView extends Backbone.View
    tagName: 'form'
    events:
        'submit': 'submit'

    initialize: (router) ->
        @router  = router
        @render()

    render: =>
        tmpl = """
          <div class="message"></div>
          Username: <input type="text" name="username"><br />
          Password: <input type="password" name="password"><br />
          <input type="submit" value="Login" />
        """
        @$el.html Mustache.render(tmpl, { })
        this
        
    submit: =>
        data = @$el.serializeObject()
        @router.authSvc.login data.username, data.password, (err, user) =>
            if err
                @$('.message').html("invalid login: #{err.message}")
            else
                @router.user = new User(user)
                @router.navigate("editUser", { trigger: true })
        false

class EditUserView extends Backbone.View
    tagName: 'form'
    events:
        'submit': 'submit'
        'click a.logout': 'logout'
        
    initialize: (router, user) ->
        @router = router
        @model  = user
        @render()
        
    render: =>
        tmpl = """
          <div class="message"></div>
          Name: <input type="text" name="firstName" value="{{firstName}}">
          <input type="text" name="lastName" value="{{lastName}}">
          <input type="submit" value="Save" />
          <p>
          <a href="#logout" class="logout">logout</a>
          </p>
        """
        @$el.html Mustache.render(tmpl, @model.attributes)
        this
        
    logout: =>
        @router.navigate("logout", { trigger: true } )
        false
        
    submit: =>
        data = @$el.serializeObject()
        @model.save data, 
            success: (model, resp) =>
                @$('.message').html("Save successful")
            error: (model, resp) =>
                @$('.message').html("error: #{JSON.stringify resp}")
        false

# export classes
window.LoginView    = LoginView
window.EditUserView = EditUserView
