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
    @post = Post.fromForm(e.target).save()
    @navigate '/posts', @post.id if @post

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
    # on create id is c-XX like :(
    Post.bind 'change', (i) =>
      @navigate '/posts', i.id

    @active (params) ->
      @change(params.id)

  change: (id) ->
    @item = Post.find(id)
    @render()

  render: ->
    # JST['app/views/posts/show']({title:'ciao'});
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
    Post.bind 'create', (e) -> $('#log').append '<li>C => '+JSON.stringify(e)+'</li>' if e
    Post.bind 'update', (e) -> $('#log').append '<li>U => '+JSON.stringify(e)+'</li>' if e
    Post.bind 'delete', (e) -> $('#log').append '<li>D => '+JSON.stringify(e)+'</li>' if e
    Post.bind 'ajaxSuccess', (e) -> $('#log').append '<li>AS => '+JSON.stringify(e)+'</li>' if e
    Post.bind 'ajaxError', (r, xhr, settings, error) -> $('#log').append '<li>AE => '+JSON.stringify(r)+xhr.statusText+'</li>' if r

    
  render: =>
    posts = Post.all()
    @html @view('posts/index')(posts: posts)
    # href is is only for bots
    $('a[data-type]').each (index)->
      $(@).removeAttr('href')
    
  edit: (e) ->
    item = $(e.target).item()
    @navigate '/posts', item.id, 'edit'
    
  destroy: (e) ->
    item = $(e.target).item()
    item.destroy() #if confirm('Sure?')
    
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