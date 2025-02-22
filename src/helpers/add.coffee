reactor = ( T ) ->
  T.handlers ?= {}
  T::run ?= ->
    for await event from @channel
      if T.handlers[ event.name ]?
        for handler in T.handlers[ event.name ]
          handler.call @
    return

add = ( name ) ->
  ( T, handler ) ->
    ( T.handlers[ name ] ?= [] ).push handler
    reactor T

export default add