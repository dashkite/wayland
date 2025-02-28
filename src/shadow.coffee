import { getters } from "./helpers/meta"
import { start } from "./reactors"

shadow = ( T ) ->
  getters T::, shadow: -> @dom.shadowRoot
  start T, ->
    @dom.attachShadow mode: "open", delegatesFocus: true

export { shadow }