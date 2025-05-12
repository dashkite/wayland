import * as Fn from "@dashkite/joy/function"
import Channel from "@dashkite/reactive/channel"
import Handle from "./handle"

reactive ( base = Handle ) ->

  class extends base

    @_handlers = {}
    @_reactors = []
    
    run: ->
      filter = Fn.bpipe @constructor._reactors
      @channel = Channel.make()
      for await event from filter.call @, @channel
        if handlers[ event.name ]?
          for handler in handlers[ event.name ]
            handler.call @
      return
    
    @reactor: ( f ) ->
      @_reactors.push f
      
    @reactors: ( fx ) ->
      @_reactors = [ fx..., @_reactors... ]

    @start: ( handler ) ->
      @handlers.start ?= []
      @handlers.start.push handler
      
    @connect: ( handler ) ->
      @handlers.connect ?= []
      @handlers.connect.push handler

    @disconnect: ( handler ) ->
      @handlers.disconnect ?= []
      @handlers.disconnect.push handler

export { reactive }