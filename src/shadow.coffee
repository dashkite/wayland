import * as Fn from "@dashkite/joy/function"
import { getters } from "./helpers/meta"
import { start } from "./reactors"

shadow = ( T ) ->
  getters T::, shadow: -> @dom.shadowRoot
  start T, Fn.once ->
    @dom.attachShadow mode: "open", delegatesFocus: true

export { shadow }