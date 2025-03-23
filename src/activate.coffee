import * as Fn from "@dashkite/joy/function"
import DOM from "@dashkite/dominator"
import { nullary, start } from "./reactors"

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

# TODO ensure we don't add multiple initializers

activate = nullary "activate", ( T ) ->
  start T, ->
    DOM.activate @dom,
      debounce => @channel.send name: "activate"

deactivate = nullary "deactivate", ( T ) ->
  start T, ->
    DOM.deactivate @dom, 
      debounce => @channel.send name: "deactivate"

export { activate, deactivate }