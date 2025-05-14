import $ from "@dashkite/zest"
import once from "./helpers/once"
import Handle from "./handle"
import reactive from "./reactive"

observable = once ( base = Handle ) ->
  
  class extends reactive base
    
    @classGetters

      observe: ->

        handler = -> @channel.send name: "modify"

        attributes: ( names ) =>
          @start ->
            $ @dom
              .modify
              .attributes names, handler.bind @

        children: =>
          @start ->
            $ @dom
              .modify
              .children handler.bind @
 
        descendents: =>
          @start ->
            $ @dom
              .modify
              .descendents handler.bind @
            
    @modify: ( handler ) ->
      @handlers.modify ?= []
      @handlers.modify.push handler

export { observable }
export default observable