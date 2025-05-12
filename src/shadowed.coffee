import * as Fn from "@dashkite/joy/function"
import Handle from "./handle"

shadowed = ( base = Handle ) ->

  class extends base

    @getters shadow: -> @dom.shadowRoot

    @start ->
      if !@dom.shadowRoot?
        @dom.attachShadow mode: "open", delegatesFocus: true

export { shadowed }