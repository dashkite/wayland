import * as DOM from "@dashkite/dominator"

render = ( T ) ->
  T::render = ( content ) -> 
    DOM.flash @root, content

export { render }