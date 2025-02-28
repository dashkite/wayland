import DOM from "@dashkite/dominator"
import { start } from "../reactors"

submit = ( T, handler ) ->
  start T, ->
    DOM.submit @root,
      handler.bind @

export { submit }
