import $ from "@dashkite/zest"

import { reactive } from "./reactive"

observable = ( base = reactive()) ->
  
  class extends base
    
    @getter

      observe: ->

        handler = => @channel.send name: "modify"

        attributes: ( names ) =>
          $ @dom
            .modify
            .attributes names, handler

        children: =>
          $ @dom
            .modify
            .children handler
 
        descendents: =>
          $ @dom
            .modify
            .descendents handler
            
    @modify: ( handler ) ->
      @handlers.modify ?= []
      @handlers.modify.push handler

export { observable }