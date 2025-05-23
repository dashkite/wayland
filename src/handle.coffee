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

  # TODO should this be a mixin?
  @tag: ( name ) ->

    T = @
    
    class Element extends HTMLElement
      constructor: ->
        super()
        @handle = new T @
        @handle.run()
        @handle.channel.send name: "start"
      connectedCallback: -> @handle.channel.send name: "connect"
      disconnectedCallback: -> @handle.channel.send name: "disconnect"
    
    # redefine @tag? after all, it doesn't make sense to call it twice?
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
