import $ from "@dashkite/zest"
import once from "./helpers/once"
import Handle from "./handle"

renderable = once ( base = Handle ) ->

  class extends base

    # TODO go back to ( template, content )?
    # otherwise we have the issue of binding to the template
    render: ( content ) ->
      $ @root
        .render content

export { renderable }
