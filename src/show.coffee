import * as Fn from "@dashkite/joy/function"
import * as DOM from "@dashkite/dominator"
import { nullary, start } from "./reactors"

show = nullary "show", ( T ) ->
  start T, ->
    DOM.show @dom, 
      => @channel.send name: "show"

hide = nullary "hide", ( T ) ->
  start T, ->
    DOM.hide @dom,
      => @channel.send name: "hide"

export { show, hide }