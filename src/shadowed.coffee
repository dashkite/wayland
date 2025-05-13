import * as Fn from "@dashkite/joy/function"
import once from "./helpers/once"
import Handle from "./handle"

shadowed = once ( base = Handle ) ->

  class extends base

    @getters shadow: -> @dom.shadowRoot

    @start ->
      if !@dom.shadowRoot?
        @dom.attachShadow mode: "open", delegatesFocus: true

export { shadowed }