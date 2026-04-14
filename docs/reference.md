# Wayland Reference

Detailed API documentation for the Wayland base class and its core mixins.

## The `Handle` Class

`Handle` is the base class for all Wayland components. It manages the relationship between the custom element and its controller logic.

#### constructor
$constructor: dom \to handle$

Creates a new Handle instance wrapping the specified DOM element.

#### root
$root \to element$

A getter that returns the Shadow Root (if present) or the base DOM element.

#### html
$html \to string$

Getter/setter for the `innerHTML` of the component's root.

#### tag
$\varphi tag: name \to \varnothing$

Static method that defines and registers the custom element with the specified name.

#### listen
$listen: name, handler \to \varnothing$

Adds an event listener to the component's root.

#### dispatch
$dispatch: name, detail \to \varnothing$

Dispatches a custom event from the component's base DOM element.

## Core Mixins

### shadowed
Adds Shadow DOM support to the component.

- $shadow \to root$: Getter for the component's shadow root.

### renderable
Adds declarative rendering capabilities using Zest.

- $render: content \to \varnothing$: Renders the specified content into the component's root.

### styleable
Adds support for Constructable Stylesheets.

- $\varphi sheets: list \to \varnothing$: Static method to apply a list of stylesheets to the component's root.

### reactive
Provides the foundation for asynchronous reactor loops and event handling.

- $\varphi reactor: f \to \varnothing$: Adds a reactor function to the component.
- $\varphi reactors: fx \to \varnothing$: Adds multiple reactor functions.

Lifecycle events:

- $\varphi start: handler \to \varnothing$
- $\varphi connect: handler \to \varnothing$
- $\varphi disconnect: handler \to \varnothing$

### observable
Provides methods for watching DOM changes.

Observation methods:

- $\varphi observe.attributes: names \to \varnothing$
- $\varphi observe.children: \to \varnothing$
- $\varphi observe.descendents: \to \varnothing$

Triggers a `modify` event on the component's channel when changes occur.

### recurrent
Adds visibility tracking via Intersection Observer.

Visibility events:

- $\varphi show: handler \to \varnothing$
- $\varphi hide: handler \to \varnothing$

Triggers `show` or `hide` events on the component's channel.

### eventful
Provides a fluent API for declarative event management.

- $\varphi listen: name \to listener$

Event shortcuts:

- $\varphi click: \to listener$
- $\varphi input: \to listener$
- $\varphi submit: \to listener$

These and other standard DOM events are supported, enabling chainable event configuration (e.g., `.prevent().send("my-event")`).

# Technical Notes

### Mixin Composition
Wayland mixins are designed to be composed using `Fn.pipe`. Each mixin ensures it is only applied once using a unique symbol key.

### Handle / Element Relationship
When `@tag` is called, Wayland creates a new `HTMLElement` subclass. When an instance of this element is created, it automatically instantiates the `Handle` (the controller) and maintains a reference to it via the `handle` property.
