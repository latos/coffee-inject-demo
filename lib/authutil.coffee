crypto = require 'crypto'

# use url-safe base64 chars, and drop the '=' padding chars.
urlsafeb64 = (base64) -> base64.replace(/\//g,'_').replace(/\+/g,'-').replace(/[=]/g, '')

class Hmac
  constructor: (@algo, @secret, @encoding = 'base64') ->

  digest: (data) ->
    h = crypto.createHmac(@algo, @secret)
    h.update(data)
    res = h.digest(@encoding)
    res = urlsafeb64 res if @encoding is 'base64'
    res

B64_SHA256_LEN = 43
class TokenManager
  constructor: (secret) ->
    @hmac = new Hmac('sha256', secret)
  
  createToken: (cred) ->
    @hmac.digest(cred) + cred
    
  verify: (token) ->
    return null if token.length <= B64_SHA256_LEN

    data = token.substring(B64_SHA256_LEN)
    if token.substring(0, B64_SHA256_LEN) is @hmac.digest(data)
      return data
    else
      return null

# todo: make this async, don't crash if there's no entropy.
exports.uniqueId = (len = 8) ->
  urlsafeb64 crypto.randomBytes(len).toString('base64')
    
exports.Hmac = Hmac
exports.TokenManager = TokenManager
