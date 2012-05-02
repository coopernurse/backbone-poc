
Backbone.Barrister =
    clients: { }
    
    initClient: (endpoint, callback) ->
        if not Backbone.Barrister.clients[endpoint]
            client = Barrister.httpClient(endpoint)
            Backbone.Barrister.clients[endpoint] = client
            client.loadContract ->
                callback(client)
        else
            callback(Backbone.Barrister.clients[endpoint])

    sync: (method, model, options) ->
        #console.log "method=#{method} barrister=#{JSON.stringify model.barrister} model=#{JSON.stringify model} options=#{JSON.stringify options}"
        if model.barrister
            b = model.barrister
            method = "#{b.interface}.#{method}#{b.entity}"
            Backbone.Barrister.initClient b.endpoint, (client) ->
                client.request method, [ model.toJSON() ], (err, result) ->
                    if err
                        options.error(model, err)
                    else
                        options.success(model, result)
        else
            options.error model, "sync: model does not have barrister property set"
                    
# Override default Backbone.sync with the Barrister version
# This will intercept all sync calls, and turn them into RPC calls
Backbone.sync = Backbone.Barrister.sync
