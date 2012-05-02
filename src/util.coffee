
# IE doesn't have console.log, so create a no-op object
# to avoid errors
if not window.console
    window.console = 
        log: ->

#
# jQuery extension to convert a form's fields to an object
# From: http://stackoverflow.com/questions/1184624/convert-form-data-to-js-object-with-jquery
jQuery.fn.serializeObject = ->
    o = {}
    a = this.serializeArray()
    $.each a, ->
        if o[this.name]?
            if not o[this.name].push
                o[this.name] = [ o[this.name] ]
            o[this.name].push this.value || ''
        else 
            o[this.name] = this.value || ''
    return o
