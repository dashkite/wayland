# The `add` Reactor Helper

The `add` function takes a name and an optional mixin and returns a Wayland mixin function. The resulting mixin has the following signatures:

1. _mixin T_
2. _mixin handler_
3. _mixin T, handler_

Form (1) is the classic mixin form. Form (2) effectively allows a handler to be curried with the mixin. Form (3) is a convenience function for (2), allowing the type argument to passed in without using the `mixins` function.

At first glance, this seems convoluted. However, it’s difficult to simplify without adding a bunch of boilerplate code elsewhere.