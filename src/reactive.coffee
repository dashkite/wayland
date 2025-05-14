import * as Fn from "@dashkite/joy/function"
import Channel from "@dashkite/reactive/channel"
import once from "./helpers/once"
import Handle from "./handle"

reactive = once ( base = Handle ) ->

  class extends base

    @_handlers = {}
    @_reactors = []
    
    run: ->
      @channel = Channel.make()
      filter = Fn.pipe @constructor._reactors
      reactor = filter.call @, @channel
      handlers = @constructor._handlers
      for await event from reactor
        if handlers[ event.name ]?
          for handler in handlers[ event.name ]
            handler.call @
      return
    
    @reactor: ( f ) ->
      @_reactors.push f
      
    @reactors: ( fx ) ->
      @_reactors = [ fx..., @_reactors... ]

    @start: ( handler ) ->
      @_handlers.start ?= []
      @_handlers.start.push handler
      
    @connect: ( handler ) ->
      @_handlers.connect ?= []
      @_handlers.connect.push handler

    @disconnect: ( handler ) ->
      @_handlers.disconnect ?= []
      @_handlers.disconnect.push handler

export { reactive }
export default reactive