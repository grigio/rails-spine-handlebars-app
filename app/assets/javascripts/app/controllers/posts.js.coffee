$ = jQuery.sub()
Post = App.Post

$.fn.item = ->
  elementID   = $(@).data('id')
  elementID or= $(@).parents('[data-id]').data('id')
  Post.find(elementID)

class New extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
    
  constructor: ->
    super
    @active @render
    
  render: ->
    @html @view('posts/new')

  back: ->
    @navigate '/posts'

  submit: (e) ->
    e.preventDefault()
    post = Post.fromForm(e.target).save()
    @navigate '/posts', post.id if post

class Edit extends Spine.Controller
  events:
    'click [data-type=back]': 'back'
    'submit form': 'submit'
  
  constructor: ->
    super
    @active (params) ->
      @change(params.id)
      
  change: (id) ->
    @item = Post.find(id)
    @render()
    
  render: ->
    @html @view('posts/edit')(@item)

  back: ->
    @navigate '/posts'

  submit: (e) ->
    e.preventDefault()
    @item.fromForm(e.target).save()
    @navigate '/posts'

class Show extends Spine.Controller
  events:
    'click [data-type=edit]': 'edit'
    'click [data-type=back]': 'back'

  constructor: ->
    super
    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Post.find(id)
    @render()

  render: ->
    @html @view('posts/show')(@item)

  edit: ->
    @navigate '/posts', @item.id, 'edit'

  back: ->
    @navigate '/posts'

class Index extends Spine.Controller
  events:
    'click [data-type=edit]':    'edit'
    'click [data-type=destroy]': 'destroy'
    'click [data-type=show]':    'show'
    'click [data-type=new]':     'new'

  constructor: ->
    super
    Post.bind 'refresh change', @render
    Post.fetch()
    
  render: =>
    posts = Post.all()
    @html @view('posts/index')(posts: posts)
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/posts', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() if confirm('Sure?')
    
  show: (e) ->
    item = $(e.target).item()
    @navigate '/posts', item.id
    
  new: ->
    @navigate '/posts/new'
    
class App.Posts extends Spine.Stack
  controllers:
    index: Index
    edit:  Edit
    show:  Show
    new:   New
    
  routes:
    '/posts/new':      'new'
    '/posts/:id/edit': 'edit'
    '/posts/:id':      'show'
    '/posts':          'index'
    
  default: 'index'
  className: 'stack posts'