# Wayland Recipes

This document provides task-based scenarios demonstrating how to build components with Wayland. The examples progress from basic reactive elements to complex integrations.

## Building a Standard Reactive Component

### Task

Create a component that fetches internal data when connected and renders its visual state whenever that data changes.

### Wayland Approach

Developers combine the `shadowed`, `renderable`, and `reactive` mixins. The component uses a reactor loop to manage state transitions deterministically, ensuring that rendering only occurs in response to explicit events.

### Example

```coffeescript
import { shadowed, renderable, reactive } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed, renderable, reactive ]
  @tag "developer-profile"

  @reactor ( reactor ) ->
    for await event from reactor
      switch event.name
        when "connect"
          # fetch entity data
          @channel.send name: "value", entity: { name: "Alice" }
        when "value"
          @render "<h1>#{event.entity.name}</h1>"
```

### Algorithm

1. Define a class by piping the necessary mixins.
2. Register the component using the `@tag` method.
3. Implement a reactor function using the `@reactor` method.
4. Use a `for await...from` loop within the reactor to handle lifecycle and custom events.
5. Trigger the `@render` method to push state changes to the component's UI.

## Applying Component Styles

### Task

Apply isolated CSS to the component without injecting redundant style tags.

### Wayland Approach

Developers use the `styleable` mixin to apply Constructable Stylesheets. This approach shares a single stylesheet instance across all instances of the custom element, conserving browser memory.

### Example

```coffeescript
import { shadowed, styleable } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

theme = new CSSStyleSheet()
theme.replaceSync "h1 { color: blue; }"

class extends do Fn.pipe [ shadowed, styleable ]
  @tag "styled-heading"
  
  @sheets [ theme ]
```

### Algorithm

1. Include the `styleable` mixin in the component's pipeline.
2. Initialize and configure a native `CSSStyleSheet` instance.
3. Pass the stylesheet instance to the static `@sheets` array on the component.

## Adding Declarative Event Handling

### Task

Handle a button click by preventing the default behavior and dispatching a mapped custom event into the component's internal reactor stream.

### Wayland Approach

Developers use the `eventful` mixin to define event listeners declaratively, transforming raw DOM events into clean reactor events.

### Example

```coffeescript
import { shadowed, reactive, eventful } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed, reactive, eventful ]
  @tag "action-button"

  @click().prevent().send "perform-action"

  @reactor ( reactor ) ->
    for await event from reactor
      if event.name == "perform-action"
        console.log "Action triggered."
```

### Algorithm

1. Include the `eventful` mixin in the component's pipeline.
2. Use a static event method (such as `@click()`) to begin configuring a listener.
3. Chain modifications like `.prevent()` or `.stop()` to control DOM bubbling and default behaviors.
4. Conclude the chain with `.send("name")` to route the DOM event into the reactor as a named event.

## Observing Attribute Changes

### Task

Automatically update the component when a specific data attribute on the DOM element changes.

### Wayland Approach

Developers use the `observable` mixin to establish watchers on specific element attributes, enabling the component to react to external state modifications.

### Example

```coffeescript
import { shadowed, reactive, observable } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed, reactive, observable ]
  @tag "themed-box"

  @observe.attributes [ "data-theme" ]

  @reactor ( reactor ) ->
    for await event from reactor
      if event.name == "modify"
        theme = @dom.getAttribute "data-theme"
        console.log "Theme changed to: #{theme}"
```

### Algorithm

1. Include the `observable` mixin in the component's pipeline.
2. Invoke `@observe.attributes` with an array specifying which attributes to watch.
3. Wait for the `modify` event within the component's reactor loop.
4. Retrieve the updated attribute value directly from the `@dom` reference.

## Tracking Element Visibility

### Task

Execute logic specifically when the component scrolls into or out of the browser viewport.

### Wayland Approach

Developers use the `recurrent` mixin to automatically wire up an Intersection Observer.

### Example

```coffeescript
import { shadowed, reactive, recurrent } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed, reactive, recurrent ]
  @tag "lazy-image"

  @show -> @channel.send name: "visible"
  @hide -> @channel.send name: "hidden"

  @reactor ( reactor ) ->
    for await event from reactor
      if event.name == "visible"
        console.log "Component is now on screen."
```

### Algorithm

1. Include the `recurrent` mixin in the component's pipeline.
2. Register callbacks using the static `@show` and `@hide` methods.
3. Send distinct events to the component's channel from within the callbacks.
4. Process those events in the reactor loop to trigger behaviors like lazy loading.

## Building Form-Associated Elements

### Task

Create a custom element that integrates natively into HTML forms, participating in validation and data submission.

### Wayland Approach

Developers use the `field` mixin. This mixin automatically configures the custom element to be form-associated, wiring up the necessary internals.

### Example

```coffeescript
import { shadowed, field, eventful } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed, field, eventful ]
  @tag "custom-input"

  @input().send "update"

  @reactor ( reactor ) ->
    for await event from reactor
      if event.name == "update"
        @value = event.snapshot.target.value
        @dom.checkValidity()
```

### Algorithm

1. Include the `field` mixin alongside other reactive mixins in the pipeline.
2. Listen for native browser interaction events, such as `input`.
3. Within the reactor, assign the new state to the component's `@value` property.
4. Trigger `@dom.checkValidity()` to ensure the form accurately reflects the element's current validation state.

## Manipulating the Base Controller Directly

### Task

Manage events and DOM nodes manually when declarative mixins cannot satisfy a highly specific requirement.

### Wayland Approach

Developers drop down to the underlying `Handle` instance methods. The base controller provides low-level tools for raw DOM manipulation and event dispatching.

### Example

```coffeescript
import { shadowed } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed ]
  @tag "raw-component"

  @connect ->
    @html = "<span>Manual Rendering</span>"
    
    @listen "click", (event) ->
      # compute manual logic here
      @dispatch "custom-bubbling-event", status: "completed"
```

### Algorithm

1. Utilize the `@connect` lifecycle hook to gain execution context when the component mounts.
2. Directly modify the component's template using the `@html` setter.
3. Attach raw event listeners to the root using `@listen`.
4. Fire composed custom events upward to parent elements using `@dispatch`.
