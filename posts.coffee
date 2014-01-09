path = require 'path'
_ = require 'underscore'
extend = _.extend

# in memory db hack for now

posts = []
postMap = {}

nextId = 1

exports.list = (rq, writer) ->
  writer
    posts: _.map posts, renderPost

exports.upload = (rq, writer) ->
  data = extend({id: "p" + nextId, 'blob': path.basename(rq.files.file.path)}, rq.body)
  nextId += 1

  posts.push data
  postMap[data.id] = data

  writer
    status: 'ok'

  console.log posts

exports.get = (rq, writer, send404) ->
  p = postMap[rq.params.post]
  if p
    writer renderPost(p)
  else
    send404()
  
renderPost = (data) ->
  p = extend {
    url: '/hack-uploads/' + data.blob
    }, data
  delete p.blob
  p
