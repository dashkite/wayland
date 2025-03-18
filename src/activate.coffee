import * as Fn from "@dashkite/joy/function"
import DOM from "@dashkite/dominator"
import { add, start } from "./reactors"

debounce = ( f ) ->
  # ensure the first time always fires
  do ({ last, tolerance } = {}) ->
    tolerance = 500 #ms
    last = -tolerance
    ( args... ) ->
      current = performance.now()
      if tolerance <= ( current - last )
        last = current
        f args...

activate = add "activate", ( T ) ->
  start T, Fn.once ->
    DOM.activate @dom, 
      debounce => @channel.send name: "activate"

deactivate = add "deactivate", ( T ) ->
  start T, Fn.once ->
    DOM.deactivate @dom, 
      debounce => @channel.send name: "deactivate"

export { activate, deactivate }