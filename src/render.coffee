import * as DOM from "@dashkite/dominator"

render = ( T ) ->
  T::render = ( template, context ) ->
    content = template.call @, context
    if content.then?
      content.then ( content ) => DOM.flash @root, content
    else
      DOM.flash @root, content

export { render }
