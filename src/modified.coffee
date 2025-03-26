import * as Fn from "@dashkite/joy/function"
import * as DOM from "@dashkite/dominator"
import { unary, start } from "./reactors"

modified = unary "modified",  ( T, options ) ->
  start T, ->
    queue = DOM.modified options, @dom
    do =>
      for await event from queue
        @channel.send { event..., name: "modified" }

export { modified }