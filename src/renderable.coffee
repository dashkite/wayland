import $ from "@dashkite/zest"
import Handle from "./handle"

renderable = ( base = Handle ) ->

  class extends base

    # TODO go back to ( template, content )?
    # otherwise we have the issue of binding to the template
    render: ( content ) ->
      $ @root
        .render content

export { renderable }
