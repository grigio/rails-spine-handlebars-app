#= require json2
#= require jquery
#= require spine
#= require spine/manager
#= require spine/ajax
#= require spine/route

#= require_tree ./lib
#= require_self
#= require_tree ./models
#= require_tree ./controllers
#= require_tree ./views

class App extends Spine.Controller
  constructor: ->
    super
    
    # Initialize controllers:
    #  @append(@items = new App.Items)
    #  ...
    @append(@posts = new App.Posts)
    
    Spine.Route.setup(history: true)   

window.App = App