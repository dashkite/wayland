import Generic from "@dashkite/generic"
import * as DOM from "@dashkite/dominator"
import { start } from "../reactors"


snapshot = ( event ) ->
  { name, target } = event
  path = event.composedPath()
  { name, target, path }



listen = do ->

  ( Generic.make "listen" )
  
    .define [ String, Function ], ( name, handler ) ->
      ( T ) ->
        start T, ->
          DOM.listen @root, name, ( handler.bind @ )

    .define [ String, String ], ( name, selector ) ->
      listen name, name, selector

    .define [ String, String, String ], ( name, alias, selector ) ->
      ( T ) ->
        start T, ->
          DOM.listen @root, name, ( event ) =>
            if DOM.closest selector, event
              domevent = snapshot event
              @channel.send { name: alias, domevent  }

    .define [ String, String, Function ], ( name, selector, handler ) ->
      ( T ) ->
        start T, ->
          handler = handler.bind @
          DOM.listen @root, name, ( event ) ->
            if DOM.closest selector, event
              handler event


Listeners =

  selector: ( name ) ->  

    ( Generic.make name )

      .define [ String ], ( selector ) ->
        listen name, selector

      .define [ String, String ], ( alias, selector ) ->
        listen name, alias, selector

      .define [ String, Function ], ( selector, handler ) ->
        listen name, selector, handler

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
              f @root, ( event ) => 
                domevent = snapshot event
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