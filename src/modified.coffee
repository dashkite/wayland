import * as Fn from "@dashkite/joy/function"
import DOM from "@dashkite/dominator"
import { unary, start } from "./reactors"

# TODO ensure we don't add multiple initializers

modified = unary "modified",  ( T, options ) ->
  start T, ->
    queue = DOM.modified options, @dom
    do =>
      for await event from queue
        @channel.send name: "modified"

export { modified }