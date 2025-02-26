import { getters, properties } from "./helpers/meta"

class Handle

  constructor: ( @dom ) ->

  getters @::, 
    root: -> @shadow ? @dom
    
  properties @::,
    html:
      get: -> @root.innerHTML
      set: ( html ) -> @root.innerHTML = html

  on: ( name, handler ) -> 
    @root.addEventListener name, handler.bind @

  dispatch: ( name, detail ) ->
    @dom.dispatchEvent new CustomEvent name,
      detail: detail ? @
      bubbles: true
      cancelable: false
      composed: true

export { Handle }
