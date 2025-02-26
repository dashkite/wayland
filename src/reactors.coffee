import * as Fn from "@dashkite/joy/function"

reactor = ( T ) ->
  T.handlers ?= {}
  T::run ?= ->
    for await event from @channel
      if T.handlers[ event.name ]?
        for handler in T.handlers[ event.name ]
          handler.call @
    return

add = ( name, mixin ) ->
  ( T, handler ) ->
    reactor T
    ( T.handlers[ name ] ?= [] ).push handler
    if mixin? then ( Fn.once mixin ).call null, T

start = add "start"
connect = add "connect"
disconnect = add "disconnect"

export { reactor, add, start, connect, disconnect }