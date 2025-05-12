import $ from "@dashkite/zest"

import { reactive } from "./reactive"

recurrent = ( base = reactive()) ->
  
  class extends base
    
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