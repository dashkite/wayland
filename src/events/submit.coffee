import DOM from "@dashkite/dominator"

submit = ( T, handler ) ->
  start T, ->
    DOM.submit @root,
      handler.bind @

export { submit }
