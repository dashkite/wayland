import DOM from "@dashkite/dominator"
import { start } from "../reactors"

click = ( T, selector, handler ) ->
  start T, ->   
    DOM.click @root, 
      selector,
      handler.bind @

export { click }