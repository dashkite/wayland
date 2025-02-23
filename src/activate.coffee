import DOM from "@dashkite/dominator"
import add from "#helpers/add"

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

activate = ( T ) ->
  add "activate"
  start T, ->
    DOM.activate @dom, 
      debounce => @channel.send name: "activate"

# TODO remove intersection observer?
deactivate = ( T ) ->
  add "deactivate"
  start T, ->
    DOM.deactivate @dom, 
      debounce => @channel.send name: "deactivate"

export { activate, deactivate }