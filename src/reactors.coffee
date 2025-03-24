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

listen = ( T, name, handler ) ->
  T.handlers[ name ].push handler

nullary = ( name, mixin  ) ->

  ( Generic.make name )

    .define [ Function ], ( handler ) ->
      ( T ) ->
        ( mixin? T ) if ! T.handlers?[ name ]?
        T.handlers ?= {}
        T.handlers[ name ] ?= []
        T.handlers[ name ].push handler

    .define [ isHandleClass ], ( T ) ->
      ( mixin? T ) if ! T.handlers?[ name ]?
      T.handlers ?= {}
      T.handlers[ name ] ?= []

    .define [ isHandleClass, Function ], ( T, handler ) -> 
      ( mixin? T ) if ! T.handlers?[ name ]?
      T.handlers ?= {}
      T.handlers[ name ] ?= []
      T.handlers[ name ].push handler

unary = ( name, mixin ) ->

  ( Generic.make name )

    .define [ Type.isAny, Function ], ( x, handler ) ->
      ( T ) -> 
        T.handlers ?= {}
        T.handlers[ name ] ?= []
        T.handlers[ name ].push handler
        mixin T, x

    .define [ Type.isAny ], ( x ) ->
      ( T ) ->
        T.handlers ?= {}
        T.handlers[ name ] ?= []
        mixin T, x

    .define [ isHandleClass, Type.isAny, Function ], ( T, x, handler ) -> 
      T.handlers ?= {}
      T.handlers[ name ] ?= []
      T.handlers[ name ].push handler
      mixin T, x

    .define [ isHandleClass, Type.isAny, Function ], ( T, x ) -> 
      T.handlers ?= {}
      T.handlers[ name ] ?= []
      mixin T, x

start = nullary "start"
connect = nullary "connect"
disconnect = nullary "disconnect"

export { 
  dispatcher 
  reactor
  reactors
  nullary
  unary
  start
  connect
  disconnect
}