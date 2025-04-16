import * as DOM from "@dashkite/dominator"

render = ( T ) ->
  T::render = ( content ) -> 
    DOM.morph @root, content

export { render }