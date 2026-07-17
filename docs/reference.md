# Wayland Reference

Detailed API documentation for the Wayland base class and its core mixins.

## Core Concepts

Before delving into the specific methods of the `Handle` class and the individual mixins, it is helpful to understand the architectural conventions that Wayland components rely upon.

### Mixin Application
Wayland heavily utilizes the [Mixin](https://en.wikipedia.org/wiki/Mixin) pattern. Instead of a deep inheritance tree, developers compose behaviors by piping a series of mixin functions. This functional composition enables precise control over the capabilities a component possesses, such as whether it requires a [Shadow DOM](https://developer.mozilla.org/en-US/docs/Web/API/Web_components/Using_shadow_DOM) or reactive event handling. Wayland components are defined by piping these mixins onto the base `Handle` class. Each mixin returns an extended class with new capabilities. These mixins do not require initialization arguments; they are pure functions that wrap a base class to systematically compose orthogonal features.

### Reactors and Channels
Wayland adopts a reactive architecture to manage state and events. Many Wayland mixins (such as `reactive`, `eventful`, and `observable`) depend on the component's internal reactor loop. The `@reactor` loop acts as the central coordinator for a component's lifecycle and internal data flow, ensuring that UI updates map deterministically to state changes. The reactor loop consumes a continuous stream of events from the component's internal channel. Every event dispatched into the reactor possesses a `name` property. Mixins frequently inject events into this stream automatically to inform the controller of lifecycle changes, DOM mutations, or user interactions.

## Handle

The `Handle` class acts as the primary controller for a Wayland component, entirely decoupled from the raw DOM element but managing its lifecycle and properties.

### constructor

$constructor: dom \to handle$

Creates a new Handle instance by wrapping a target DOM element. This binds the controller to the specific element it will manage.

```coffeescript
import { Handle } from "@dashkite/wayland"

element = document.createElement "div"
handle = new Handle element
assert.equal handle.dom, element
```

### root

$root \to element$

A property getter that resolves the primary container for the component's internal DOM. If the component utilizes a Shadow DOM (e.g., via the `shadowed` mixin), this returns the Shadow Root. Otherwise, it defaults to returning the base DOM element itself.

```coffeescript
# assuming the component has no shadow DOM yet
assert.equal handle.root, handle.dom
```

### html

$html \to string$

A property getter and setter that directly interfaces with the `innerHTML` of the component's root. This provides a convenient way to read or replace the raw markup of the component without manually traversing to the root node.

```coffeescript
handle.html = "<span>Updated Content</span>"
assert.equal handle.root.innerHTML, "<span>Updated Content</span>"
```

### tag

$\varphi tag: name \to \varnothing$

A static class method that defines and registers the custom element within the browser's CustomElementRegistry. This method dynamically creates an `HTMLElement` subclass that binds directly to the current `Handle` controller.

```coffeescript
class MyComponent extends Handle
  @tag "my-component"

customElement = document.createElement "my-component"
assert.ok customElement
```

### listen

$listen: name, handler \to \varnothing$

Attaches an event listener directly to the component's root element. The provided handler is automatically bound to the `Handle` instance, ensuring that `this` inside the handler references the controller rather than the raw DOM element.

```coffeescript
handle.listen "click", (event) -> 
  console.log "Clicked inside the root element"
```

### dispatch

$dispatch: name, detail \to \varnothing$

Dispatches a custom event from the component's base DOM element. This event is configured to bubble and cross the shadow boundary (`composed: true`), making it easy for parent elements to listen for events emitted by the Wayland component. The `detail` property defaults to the Handle instance itself unless specified.

```coffeescript
handle.dispatch "state-change", { active: true }
```

## shadowed

The `shadowed` mixin automatically attaches an open shadow root to the component during initialization, encapsulating its styles and internal markup.

### shadow

$shadow \to root$

A property getter that retrieves the attached open shadow root. If the shadow root has not yet been initialized, this may return undefined until the component starts.

```coffeescript
root = component.shadow
assert.ok root.host
```

## renderable

The `renderable` mixin integrates the Zest rendering engine, granting the component the ability to render dynamic templates deterministically.

### render

$render: content \to \varnothing$

Parses and renders the provided content into the component's root container. This method effectively updates the DOM based on the specified Zest-compatible representation.

```coffeescript
component.render [ "h1", "Hello World!" ]
```

## styleable

The `styleable` mixin facilitates the application of Constructable Stylesheets, allowing developers to share CSS definitions efficiently across multiple component instances.

### sheets

$\varphi sheets: list \to \varnothing$

A static method that accepts an array of `CSSStyleSheet` objects and applies them to the component's root. This ensures that the component inherits all defined styles without injecting redundant `<style>` tags.

```coffeescript
MyComponent.sheets [ layoutCss, themeCss ]
```

## reactive

The `reactive` mixin establishes the foundational asynchronous event loop for the component. It introduces a `channel` and methods for registering reactors that process incoming state changes and lifecycle events.

### reactor

$\varphi reactor: f \to \varnothing$

Registers an asynchronous generator or function as a reactor for the component. When the component initializes, it pipes its internal event channel into this reactor, allowing developers to handle events sequentially.

```coffeescript
MyComponent.reactor (reactor) ->
  for await event from reactor
    console.log "Received event: #{event.name}"
```

### reactors

$\varphi reactors: fx \to \varnothing$

Registers an array of reactor functions, adding them to the component's internal pipeline. This enables the composition of multiple independent behaviors that can intercept or process events.

```coffeescript
MyComponent.reactors [ loggingReactor, stateReactor ]
```

### start

$\varphi start: handler \to \varnothing$

Registers a callback function to be executed immediately when the `Handle` initializes and begins running its reactor loop, prior to full DOM connection.

```coffeescript
MyComponent.start -> 
  console.log "Controller initialized."
```

### connect

$\varphi connect: handler \to \varnothing$

Registers a callback function that triggers precisely when the underlying custom element is connected to the DOM document (analogous to `connectedCallback`).

```coffeescript
MyComponent.connect -> 
  console.log "Component added to the DOM."
```

### disconnect

$\varphi disconnect: handler \to \varnothing$

Registers a callback function that fires when the custom element is removed from the DOM document (analogous to `disconnectedCallback`).

```coffeescript
MyComponent.disconnect -> 
  console.log "Component removed from the DOM."
```

## observable

The `observable` mixin equips the component with methods for monitoring the DOM via MutationObserver. It automatically translates DOM mutations into `modify` events sent directly into the component's reactor.

### observe.attributes

$\varphi observe.attributes: names \to \varnothing$

Initiates an observation on the specified array of attribute names. If any of these attributes change on the host element, a `modify` event is dispatched to the reactor.

```coffeescript
MyComponent.observe.attributes [ "disabled", "role" ]
```

### observe.children

$\varphi observe.children: \to \varnothing$

Watches the component's direct DOM children for additions or removals, triggering a `modify` event upon any structural change.

```coffeescript
MyComponent.observe.children()
```

### observe.descendents

$\varphi observe.descendents: \to \varnothing$

Deeply observes all descendent nodes within the component for structural changes, converting any nested additions or removals into a `modify` event.

```coffeescript
MyComponent.observe.descendents()
```

## recurrent

The `recurrent` mixin tracks the element's visibility within the viewport using the Intersection Observer API.

### show

$\varphi show: handler \to \varnothing$

Registers a callback that is invoked when the component intersects with the visible viewport, indicating that it is now visible to the developer.

```coffeescript
MyComponent.show -> 
  console.log "Element has entered the viewport."
```

### hide

$\varphi hide: handler \to \varnothing$

Registers a callback that fires when the component leaves the visible viewport.

```coffeescript
MyComponent.hide -> 
  console.log "Element has left the viewport."
```

## eventful

The `eventful` mixin establishes a fluent, chainable API for declarative event management. It intercepts standard DOM events and effortlessly routes them into the component's reactor loop.

### listen

$\varphi listen: name \to listener$

Generates a chainable listener configuration for the specified DOM event name. This proxy allows developers to map raw DOM interactions to meaningful reactor events.

```coffeescript
MyComponent.listen("custom-trigger").prevent().send("handled")
```

### click

$\varphi click: \to listener$

A convenience method that creates a chainable listener specifically for `click` events. Note that the `eventful` mixin dynamically provides similar methods for most standard DOM events (e.g., `input`, `submit`, `focus`).

```coffeescript
MyComponent.click().prevent().send("action")
```

## field

The `field` mixin simplifies the creation of Form-Associated Custom Elements. It wires up ElementInternals and exposes the necessary properties for the component to participate in HTML forms and constraint validation natively.

### value

$value \to string$

A property getter and setter that represents the component's current form value. Updating this property automatically synchronizes with the internal form state, allowing the component to submit data seamlessly.

```coffeescript
component.value = "Active"
assert.equal component.value, "Active"
```

### validity

$validity \to state$

A property getter that provides access to the component's internal `ValidityState` object. This reflects the current constraint validation status of the field.

```coffeescript
state = component.validity
assert.ok state.valid
```
