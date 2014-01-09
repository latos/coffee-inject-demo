authutil = require('../lib/authutil')

#hack in mem db

exports.UserService = class UserService
  constructor: ->
    # hack hard coded user 'database'
    @usersByUsername = {
      'joe': {
        id: 'u1',
        name: 'Joe Bloggs'
      },
      'jane': {
        id: 'u2',
        name: 'Jane Doe'
      }
    }

  byUname: (uname, cb) -> cb null, @usersByUsername[uname]

