import * as Fn from "@dashkite/joy/function"
import Generic from "@dashkite/generic"
import { Handle } from "./handle"

dispatcher = ( reactor ) ->
  for await event from reactor
    console.log wayland: { event, instance: @ }
    if T.handlers[ event.name ]?
      for handler in T.handlers[ event.name ]
        handler.call @
  return

reactor = ( T ) ->
  T.handlers ?= {}
  T::run = -> (( dispatcher @ ) @channel )

reactors = ( list ) ->
  list = [ list..., dispatcher ]
  ( T ) ->
    T.handlers ?= {}
    T::run = ->
      ( Fn.pipe ( reactor.bind @ for reactor in list ) @channel )

# IMPORTANT mixin fn here must be idempotent

add = ( name, mixin ) ->

  ( Generic.make name )

    .define [ Function ], ( handler ) ->
      ( T ) ->
        ( T.handlers[ name ] ?= [] ).push handler
        mixin? T

    .define [ Handle ], ( T ) ->
      mixin? T

start = add "start"
connect = add "connect"
disconnect = add "disconnect"

export { reactor, add, start, connect, disconnect, dispatcher }