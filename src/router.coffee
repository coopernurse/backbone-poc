class AppRouter extends Backbone.Router
    
    routes:
        "editUser" : "editUser"
        "login"    : "login"
        "logout"   : "logout"
        
    initialize: (args) ->
        @root    = args.root || $('body')
        @authSvc = args.authSvc
        
    login: =>
        view = new LoginView(this)
        @root.html(view.el)
        
    logout: =>
        @user = null
        @login()
        
    editUser: =>
        if @user
            view = new EditUserView(this, @user)
            @root.html(view.el)
        else
            @login()

# export classes
window.AppRouter = AppRouter