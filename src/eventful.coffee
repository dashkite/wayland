import * as Fn from "@dashkite/joy/function"
import $ from "@dashkite/zest"
import once from "./helpers/once"
import Handle from "./handle"
import reactive from "./reactive"

snapshot = ( event ) ->
  { name, target } = event
  path = event.composedPath()
  { name, target, path }

key = Symbol( import.meta.url )

eventful = once key, ( base = Handle ) ->
  
  class extends reactive base

    @[ key ]: eventful

    @capture: ( event ) ->
      ( @listen event ).capture()

    @listen: ( event ) ->

      do ({ fx } = {}) =>

        proxy = new Proxy ( fx = [] ),
          get: ( target, name ) ->

            switch name

              when "send"
                ( alias ) ->
                  target.push ( listener ) ->
                    self = @
                    listener.apply ( event ) ->
                      self.channel.send
                        name: alias ? event.name
                        domevent: event
                        snapshot: snapshot event
                  proxy

              when "apply"
                ( handler ) ->
                  target.push ( listener ) ->                  
                    listener.apply ( handler.bind @ )
                  proxy

              else
                ( args... ) ->
                  target.push ( listener ) ->
                    listener[ name ] args...
                  proxy

        @start ->
          f = Fn.pipe fx
          listener = ( $ @root ).listen event
          f.call @, listener

        proxy

    @bind: -> @listen "bind"
    @blur: -> @listen "blur"
    @change: -> @listen "change"
    @click: -> @listen "click"
    @doubleclick: -> @listen "doubleclick"
    @focus: -> @listen "focus"
    @focusin: -> @listen "focusin"
    @focusout: -> @listen "focusout"
    @keyup: -> @listen "keyup"
    @keydown: -> @listen "keydown"
    @input: -> @listen "input"
    @invalid: -> @capture "invalid"
    @load: -> @listen "load"
    @mouseup: -> @listen "mouseup"
    @mousedown: -> @listen "mousedown"
    @mouseenter: -> @listen "mouseenter"
    @mouseover: -> @listen "mouseover"
    @mouseout: -> @listen "mouseout"
    @mousemove: -> @listen "mousemove"
    @resize: -> @listen "resize"
    @scroll: -> @listen "scroll"
    @select: -> @listen "select"
    @submit: -> @listen "submit"
    @unload: -> @listen "unload"

export { eventful }
export default eventful