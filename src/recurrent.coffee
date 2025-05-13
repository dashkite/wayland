import $ from "@dashkite/zest"
import once from "./helpers/once"
import Handle from "./handle"
import reactive from "./reactive"

recurrent = once ( base = Handle ) ->
  
  class extends reactve base
    
    @start ->
      $ @dom
        .show => @channel.send name: "show"
        
    @start ->
      $ @dom
        .hide => @channel.send name: "hide"
    
    @show: ( handler ) ->
      @handlers.show ?= []
      @handlers.show.push handler

    @hide: ( handler ) ->
      @handlers.hide ?= []
      @handlers.hide.push handler

export { recurrent }