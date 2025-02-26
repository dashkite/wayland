import { innerHTML } from "diffhtml"
import { properties } from "./helpers/meta"

diff = ( T ) ->
  properties T::,
    html:
      get: ->
        await @_render if @_render?
        @root.innerHTML
      set: ( html ) ->
        @_render = innerHTML @root, html

export { diff }