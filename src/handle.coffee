import metaclass from "./metaclass"

class Handle extends metaclass()

  constructor: ( dom ) ->
    super()
    @dom = dom

  @getters
    root: -> @shadow ? @dom
    
  @properties
    html:
      get: -> @root.innerHTML
      set: ( html ) -> @root.innerHTML = html

  @tag: ( name ) ->

    T = @
    
    class Element extends HTMLElement
      constructor: ->
        super()
        @handle = new T @
      connectedCallback: -> @handle.connect()
      disconnectedCallback: -> @handle.disconnect()
    
    # redefine @tag: doesn't make sense to call it twice
    @tag = name
    @Element = Element

    customElements.define name, Element

  listen: ( name, handler ) -> 
    @root.addEventListener name, handler.bind @

  dispatch: ( name, detail ) ->
    @dom.dispatchEvent new CustomEvent name,
      detail: detail ? @
      bubbles: true
      cancelable: false
      composed: true

export { Handle }
export default Handle
