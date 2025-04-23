import Generic from "@dashkite/generic"
import * as DOM from "@dashkite/dominator"
import { start } from "../reactors"

listen = do ->

  ( Generic.make "listen" )
  
    .define [ String, String ], ( name, selector ) ->
      listen name, selector, name

    .define [ String, String, String ], ( name, selector, alias ) ->
      ( T ) ->
        start T, ->
          DOM.listen @root, name, ( domevent ) =>
            if DOM.matches selector, domevent
              @channel.send { name: alias, domevent  }

    .define [ String, String, Function ], ( name, selector, handler ) ->
      ( T ) ->
        start T, ->
          handler = handler.bind @
          DOM.listen @root, name, ( event ) ->
            if DOM.matches selector, event
              handler event

Listeners =

  selector: ( name ) ->  
    # handler here could be an alias
    ( selector, handler ) ->
      if handler?
        listen name, selector, handler
      else
        listen name, selector

  semantic: ( name ) ->

    f = DOM[ name ]
    
    g = do ->

      ( Generic.make name )

        .define [], -> 
          ( T ) ->
            start T, -> g name

        .define [ String ], ( alias ) ->
          ( T ) ->
            start T, ->
              f @root, ( domevent ) => 
                @channel.send { name: alias, domevent }

        .define [ Function ], ( handler ) ->
          ( T ) ->
            start T, -> f @root, handler.bind @

change = Listeners.selector "change"
click = Listeners.selector "click"
submit = Listeners.semantic "submit"

export {
  listen
  change
  click
  submit
}