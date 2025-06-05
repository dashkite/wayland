import $ from "@dashkite/zest"
import once from "./helpers/once"
import Handle from "./handle"
import metaclass from "./metaclass"
import reactive from "./reactive"

key = Symbol( import.meta.url )

field = once key, ( base = Handle ) ->
  
  class extends reactive base


    @[ key ]: field

    
    # overload tag class method leads to some repeated code
    # but we could refactor that into another mixin...

    # TODO refactor shared Element code into element mixin
    @tag: ( name ) ->

      T = @
      
      class Element extends metaclass HTMLElement

        @formAssociated = true

        @properties
          
          value:
            get: -> @_value
            set: ( value ) ->
              @internals.setFormValue value
              @_value = value

          form:
            get: -> @internals.form

          name:
            get: -> @getAttribute "name"

          type:
            get: -> @localName

          validity:
            get: -> @internals.validity

          validationMessage:
            get: -> @internals.validationMessage

          willValidate:
            get: -> @internals.willValidate

        constructor: ->
          super()
          @handle = new T @
          @attachShadow 
            mode: "open"
            delegatesFocus: true
          @internals = @attachInternals()
          @handle.run()
          @handle.channel.send name: "start"

        connectedCallback: -> @handle.channel.send name: "connect"

        disconnectedCallback: -> @handle.channel.send name: "disconnect"

        setValidity: ( args...) -> @internals.setValidity args...

        checkValidity: -> @internals.checkValidity()

        reportValidity: -> @internals.reportValidity()
      
      @tag = name
      @Element = Element

      customElements.define name, Element

export { field }
export default field