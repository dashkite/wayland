import $ from "@dashkite/zest"
import { reactive } from "./reactive"

snapshot = ( event ) ->
  { name, target } = event
  path = event.composedPath()
  { name, target, path }

eventful = ( base = reactive()) ->
  
  class extends base
    
    @listen: ( event ) ->

      do ({ fx } = {}) =>

        proxy = new Proxy ( fx = [] ),
          get: ( target, name ) ->

            switch name

              when "send"
                ( alias ) ->
                  target.push ( listener ) ->
                    listener.apply ( event ) =>
                      @channel.send
                        name: alias ? event.name
                        domevent: event
                        snapshot: snapshot event

              when "apply"
                ( handler ) ->
                  target.push ( listener ) ->                  
                    listener.apply ( handler.bind @ )

              else
                ( args... ) ->
                  target.push ( listener ) ->
                    listener[ name ] args...

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