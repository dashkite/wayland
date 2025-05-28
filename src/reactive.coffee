import * as Fn from "@dashkite/joy/function"
import Channel from "@dashkite/reactive/channel"
import once from "./helpers/once"
import Handle from "./handle"

key = Symbol( import.meta.url )

reactive = once key, ( base = Handle ) ->

  class extends base

    @[ key ]: reactive

    @_handlers = {}
    @_reactors = []

    # reactors can be:
    # - sync fn 
    # - async fn
    # - async generator fn
    # code below (in combination w pipe) 
    # handles all 3 cases
    run: ->
      @channel = Channel.make()
      handlers = @constructor._handlers
      run = ( reactor ) =>
        for await event from reactor
          if handlers[ event.name ]?
            for handler in handlers[ event.name ]
              handler.call @
        return
      filter = Fn.pipe @constructor._reactors
      reactor = filter.call @, @channel
      ( reactor.then? run ) ? run reactor  

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

    @tag: ( name ) ->

      T = @
      
      class Element extends HTMLElement
        constructor: ->
          super()
          @handle = new T @
          @handle.run()
          @handle.channel.send name: "start"
        connectedCallback: -> @handle.channel.send name: "connect"
        disconnectedCallback: -> @handle.channel.send name: "disconnect"
      
      # redefine @tag: doesn't make sense to call it twice
      @tag = name
      @Element = Element

      customElements.define name, Element

export { reactive }
export default reactive