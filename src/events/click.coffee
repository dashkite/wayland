import DOM from "@dashkite/dominator"

click = ( T, selector, handler ) ->
  start T, ->
    @on "click", ( event ) ->
      if DOM.within selector
        DOM.intercept event
        handler.call @, event

export { click }