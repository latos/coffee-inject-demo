tmpl = require('./lib/tpl').tmpl
Injector = require('./lib/inject').Injector
authutil = require('./lib/authutil')
users = require('./service/user')

# Application-scoped dependencies
# I.e. deps whose life-cycle is the same as the whole server
exports.appProviders =
  tokenManager: Injector.providerFromCtor authutil.TokenManager
  userService: Injector.providerFromCtor users.UserService

# Request-scoped dependencies
# I.e. deps whose life-cycle is tied to a particular http request.
exports.requestProviders =
  mainPageWriter: (rs) ->
    (params, status = 200) ->
      #params.title = params.title || '(No title)'
      content = params.content or params.error or '(No content)'
      rs.writeHead(status, {"Content-Type": "text/html"})
      #rs.write(tmpl('main', params))
      rs.write(content)
      rs.end()

  jsonWriter: (rs) ->
    (data, status = 200) ->
      rs.writeHead(status, {"Content-Type": "application/json"})
      rs.write JSON.stringify(data)
      rs.end()

  send404: (writer) ->
    ->
      writer({'error': 'Not found'}, 404)


