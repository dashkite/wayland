import * as Fn from "@dashkite/joy/function"
import * as Type from "@dashkite/joy/type"
import Generic from "@dashkite/generic"

import { Handle } from "./handle"

dispatcher = ( reactor ) ->
  handlers = @constructor.handlers
  for await event from reactor
    if handlers[ event.name ]?
      for handler in handlers[ event.name ]
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
      (( Fn.pipe ( reactor.bind @ for reactor in list  )) @channel )

isHandleClass = Type.isDerivedFrom Handle

add = ( T, name ) ->
  T.handlers ?= {}
  T.handlers[ name ] ?= []

listen = ( T, name, handler ) ->
  T.handlers[ name ].push handler

nullary = ( name, mixin  ) ->

  ( Generic.make name )

    .define [ isHandleClass, Function ], ( T, handler ) -> 
      add T, name
      listen T, name, handler
      mixin? T

    .define [ Function ], ( handler ) ->
      ( T ) -> 
        add T, name
        listen T, name, handler
        mixin? T

    .define [ isHandleClass ], ( T ) ->
      add T, name
      mixin? T

unary = ( name, mixin ) ->

  ( Generic.make name )

    .define [ isHandleClass, Type.isAny, Function ], ( T, x, handler ) -> 
      ( T ) -> 
        add T, name
        listen T, name, handler
        mixin T, x

    .define [ Type.isAny, Function ], ( x, handler ) ->
      ( T ) -> 
        add T, name
        listen T, name, handler
        mixin T, x

    .define [ Type.isAny ], ( x ) ->
      ( T ) ->
        add T, name
        mixin T, x

start = nullary "start"
connect = nullary "connect"
disconnect = nullary "disconnect"

export { 
  dispatcher 
  reactor
  reactors
  # add
  # listen
  nullary
  unary
  start
  connect
  disconnect
}