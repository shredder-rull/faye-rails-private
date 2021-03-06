window.FayePrivate =

  subscriptions: {}

  fayeExtension:

    outgoing: (message, callback)->
      subscription = null
      if message.channel == "/meta/subscribe"
        subscription = FayePrivate.subscriptions[message.subscription]
      if !/^\/meta\//.test(message.channel)
        subscription = FayePrivate.subscriptions[message.channel]

      if subscription
        message.auth ||= {}
        message.auth[k] = v for k,v of subscription

      callback(message)

  sign: (params)->
    channel = params.channel
    delete params.channel
    FayePrivate.subscriptions[channel] = params

FayePrivate.Client = ->
  return @ if !@initialize
  @initialize.apply(@, arguments) || @;

for method in Object.getOwnPropertyNames(Faye.Client.prototype)
  FayePrivate.Client.prototype[method] = Faye.Client.prototype[method]

FayePrivate.Client::initialize = (endpoint, options)->
    Faye.Client::initialize.call @, endpoint, options
    @addExtension FayePrivate.fayeExtension
    @
