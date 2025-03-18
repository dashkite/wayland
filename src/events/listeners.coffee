import DOM from "@dashkite/dominator"
import { start } from "../reactors"

Listeners =

  selector: ( name ) ->  
    ( selector, handler ) ->
      ( T ) ->
        start T, ->   
          DOM[ name ] @root, 
            selector,
            handler.bind @

  semantic: ( name ) ->
    ( handler ) ->
      ( T ) ->
        start T, ->
          DOM.submit @root,
            handler.bind @

change = Listeners.selector "change"
click = Listeners.selector "click"
submit = Listeners.semantic "submit"

export {
  change
  click
  submit
}