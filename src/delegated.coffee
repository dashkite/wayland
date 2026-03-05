import * as Fn from "@dashkite/joy/function"
import once from "./helpers/once"
import Handle from "./handle"
import reactive from "./reactive"

key = Symbol( import.meta.url )

delegated = once key, ( base = Handle ) ->

  class extends reactive base

    @[ key ]: delegated

    @getters
      shadow: -> @dom.shadowRoot

    @start ->
      if !@dom.shadowRoot?
        @dom.attachShadow 
          mode: "open"
          delegatesFocus: true

export { delegated }
export default delegated