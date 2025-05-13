import $ from "@dashkite/zest"
import once from "./helpers/once"
import { Handle } from "./handle"
import { reactive } from "./reactive"

observable = once ( base = Handle ) ->
  
  class extends reactive base
    
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
export default observable