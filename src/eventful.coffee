import $ from "@dashkite/zest"
import { reactive } from "./reactive"

snapshot = ( event ) ->
  { name, target } = event
  path = event.composedPath()
  { name, target, path }

eventful = ( base = reactive()) ->
  
  class extends base
    
    # TODO we want apply to be bound to @
    @listen: ( event ) ->
      new Proxy (( $ @root ).listen event ),
        get: ( target, name ) =>
          if name == "send"
            ( alias ) =>
              target.apply ( event ) =>
                @channel.send
                  name: alias ? event.name
                  event: event
                  snapshot: snapshot event
          else
            target[ name ]
      
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