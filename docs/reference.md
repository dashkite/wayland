# Wayland Reference

Detailed API documentation for the Wayland base class and its core mixins.

## The `Handle` Class

`Handle` is the base class for all Wayland components. It manages the relationship between the custom element and its controller logic.

#### constructor
$constructor: dom: HTMLElement \to Handle$

Creates a new Handle instance wrapping the specified DOM element.

#### root
$root \to HTMLElement$

A getter that returns the Shadow Root (if present) or the base DOM element.

#### html
$html \to string$

Getter/setter for the `innerHTML` of the component's root.

#### tag
$\text{@tag}: name: string \to \emptyset$

Static method that defines and registers the custom element with the specified name.

#### listen
$listen: name: string, handler: function \to \emptyset$

Adds an event listener to the component's root.

#### dispatch
$dispatch: name: string, detail: any \to \emptyset$

Dispatches a custom event from the component's base DOM element.


## Core Mixins


### shadowed
Adds Shadow DOM support to the component.
- **$\text{@start}: \to \emptyset$**: Automatically attaches an open Shadow Root if one doesn't exist.
- **$shadow \to ShadowRoot$**: Getter for the component's shadow root.

### renderable
Adds declarative rendering capabilities using Zest.
- **$render: content: any \to \emptyset$**: Renders the specified content into the component's root.

### styleable
Adds support for Constructable Stylesheets.
- **$\text{@sheets}: list: array \to \emptyset$**: Static method to apply a list of stylesheets to the component's root.

### reactive
Provides the foundation for asynchronous reactor loops and event handling.
- **$\text{@reactor}: f: function \to \emptyset$**: Adds a reactor function to the component.
- **$\text{@reactors}: fx: array \to \emptyset$**: Adds multiple reactor functions.
- **$\text{@start}, \text{@connect}, \text{@disconnect}: handler: function \to \emptyset$**: Registers handlers for lifecycle events.

### observable
Provides methods for watching DOM changes.
- **$\text{@observe.attributes}: names: array \to \emptyset$**
- **$\text{@observe.children}: \to \emptyset$**
- **$\text{@observe.descendents}: \to \emptyset$**
Triggers a `modify` event on the component's channel when changes occur.

### recurrent
Adds visibility tracking via Intersection Observer.
- **$\text{@show}, \text{@hide}: handler: function \to \emptyset$**
Triggers `show` or `hide` events on the component's channel.

### eventful
Provides a fluent API for declarative event management.
- **$\text{@listen}: name: string \to ListenerProxy$**
- **$\text{@click}, \text{@input}, \text{@submit}, \dots: \to ListenerProxy$**
Enables chainable event configuration (e.g., `.prevent().send("my-event")`).

# Technical Notes

### Mixin Composition
Wayland mixins are designed to be composed using `Fn.pipe`. Each mixin ensures it is only applied once using a unique symbol key.

### Handle / Element Relationship
When `@tag` is called, Wayland creates a new `HTMLElement` subclass. When an instance of this element is created, it automatically instantiates the `Handle` (the controller) and maintains a reference to it via the `handle` property.
