# The Wayland Reactor Mixin Combinators

Wayland provides a set of combinators for creating reactor mixins. There are presently two of them: `nullary` and `unary`. The `unary` form allows for passing an argument into a reactor mixin. For example, the `modified` mixin takes an options argument.

Each form takes a name and an optional initialization mixin and returns a reactor mixin. The `nullary` form returns a mixin with  the following signatures:

1. _mixin T_
2. _mixin T, handler_
3. _mixin handler_

Form (1) is the classic mixin form. Form (2) adds a handler for the corresponding event (ex: `start`). Form 3 is essentially a curried form of (2) and is typically used in the context of the `mixins` class function.

The unary form produces a mixin with the following signatures:

1. _mixin T, x_
2. _mixin T, x, handler_
3. _mixin x, handler_
4. _mixin x_

These forms serve the same purpose as the `nullary` form, except that they allow for an argument. This results in an additional form, to allow currying only the argument with no handler.

This perhaps seems a bit convoluted. Why not just define each reactor mixin individually? As it turns out, there’s just enough complexity in defining a reactor mixin to justify using combinators.

A few examples of nullary reactor mixins: `start`, `connect`, `dispatch`, `activate`, and `deactivate`. For example, we can call the `start` mixin like so (form 2)

```coffeescript
start T, ->
  # do some initialization
```

Another example is the `activate` mixin, which can be used by itself, with no handler (form 1)  within the `mixins` class function simply to install the `activate` event into the component lifecycle.

Unary reactor mixins include ` modified`. From within the `mixins` class function, we might call it like so (form 4):

```coffeescript
modified attributes: "data-image"
```

This adds the `modified` event to the component lifecycle and configures a reactor when the `data-image` attribute changes.

To create a nullary reactor mixin, we simply call the combinator with the event name and an optional mixin:

```coffeescript
start = nullary "start"

activate = nullary "activate", ( T ) ->
  start T, ->
    DOM.activate @dom,
      debounce => @channel.send name: "activate"
```

The mixin will be called whenever the resultingf reactor mixin is called. In this example, we using Dominators `activate` combinator to generate activate events. For nullary mixins, this initialization mixin is only called once per type. 

To create a unary reactor mixin, we call the corresponding combinator, with a mixin that takes an argument:

```coffeescript
modified = unary "modified",  ( T, options ) ->
  start T, ->
    queue = DOM.modified options, @dom
    do =>
      for await event from queue
        @channel.send { event..., name: "modified" }
```

In this case, the initialization mixin will be called for each invocation of the reactor mixin, since the argument may vary.

The `nullary` combinator is defined as follows:

```coffeescript
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

```

We define three generics, corresponding to the three forms we enumerated above. If this is the first time we’re invoking the mixin, as indicated by the handlers being uninitialized for this type T, we call the mixin if it was provided. From there, we initialize the handlers and push the given handler, if appropriate for the given generic.

The `unary` combinator is defined as follows:

```coffeescript
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
```

The implementation here follows the same pattern except that:

- There’s one extra generic to account for the extra form
- We always call the initialization mixin (which is required)

In both implementations, we define the generics that take a Handle last so that they will not be hidden by the more general predicates (ex: `isAny` for the argument to the unary mixin).