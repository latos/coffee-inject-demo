authutil = require('./lib/authutil')
extend = require('util')._extend
_ = require 'underscore'

exports.login = (rq, userService, tokenManager, writer) ->
    userService.byUname rq.params.uname, (err, user) ->
      if err
        console.log err
        writer {error:'Internal Error'}, 500
        return

      if not user
        writer {error:'User ' + rq.params.uname + ' not found'}, 404
        return

      tokenData = user.id + ':' + (new Date().getTime())
      writer
        auth: tokenManager.createToken tokenData
