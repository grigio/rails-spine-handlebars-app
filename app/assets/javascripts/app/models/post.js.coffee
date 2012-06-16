class App.Post extends Spine.Model
  @configure 'Post', 'title', 'content'
  @extend Spine.Model.Ajax
	# @url: "/posts"
	# read    → GET    /posts
	# create  → POST   /posts
	# update  → PUT    /posts/id
	# destroy → DELETE /posts/id


  # validation
  validate: ->
    "Title must be longer" unless @title.length > 3

  # virtual attributes in console => post.title_happy()
  title_happy: =>
    @title + " yiahh!"