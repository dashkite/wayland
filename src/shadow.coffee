import * as Fn from "@dashkite/joy/function"
import { getters } from "./helpers/meta"
import { start } from "./reactors"

# TODO ensure we don't add multiple initializers

shadow = ( T ) ->
  getters T, shadow: -> @dom.shadowRoot
  start T, ->
    @dom.attachShadow mode: "open", delegatesFocus: true

export { shadow }