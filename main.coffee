require('coffee-script')

DEV = true

application = require('./application')
express = require 'express'

inject = require('./lib/inject')
Injector = inject.Injector

_ = require('underscore')
extend = _.extend

appScope = new Injector null, {
    # TODO: settings
    secret: 'blah test secret'
  },
  application.appProviders
appScope.name = 'appscope'

handler = (h, mappings = {}) ->
  providers = extend {},
    Injector.mappedProviders(mappings),
    application.requestProviders

  (rq, rs) ->
    scope = appScope.child {rq:rq, rs:rs}, providers
    scope.name = 'rqscope'
    scope.invoke h

ajaxHandler = (h) -> handler(h, {writer:'jsonWriter'})

fs = require('fs')

fileContents = (name) ->
  fs.readFileSync('tpl/' + name + '.html').toString('utf8')


app = express()
app.use express.bodyParser({ keepExtensions: true, uploadDir: "uploads" })

# tmp hack for uploads
app.use '/hack-uploads', express.static(__dirname + '/uploads')

if DEV
  app.use '/static', express.directory( __dirname + '/static')

app.use '/static', express.static(__dirname + '/static')
app.use '/common', express.static(__dirname + '/common')

app.get '/', handler(require('./index').handler, { writer:'mainPageWriter'})

posts = require './posts'
app.get '/_a/posts', ajaxHandler(posts.list)
app.post '/_a/posts', ajaxHandler(posts.upload)
app.get '/_a/posts/:post', ajaxHandler(posts.get)

login = require './login'
app.get '/_a/login/:uname', ajaxHandler(login.login)

app.all '/test/upload', (rq, rs) ->
  if rq.files.file
    # rq.files will contain the uploaded file(s),                                          
    # keyed by the input name (in this case, "file")                                            

    # show the uploaded file name                                                               
    console.log("file name", rq.files.file.name)
    console.log("file path", rq.files.file.path)
    console.log("blah", rq.body)

  rs.writeHead(200, {"Content-Type": "text/html"})
  rs.write fileContents('upload')
  rs.end()

port = 8888
app.listen(port)

console.log("Server has started yeeeeeh! on port " + port)
