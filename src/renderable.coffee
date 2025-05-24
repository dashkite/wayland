import $ from "@dashkite/zest"
import once from "./helpers/once"
import Handle from "./handle"

key = Symbol( import.meta.url )

renderable = once key, ( base = Handle ) ->

  class extends base

    @[ key ]: renderable

    render: ( content ) ->
      $ @root
        .render content

export { renderable }
export default renderable
