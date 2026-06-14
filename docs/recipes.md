# Wayland Recipes

Task-based scenarios and common patterns for building Wayland components.

## Standard Reactive Component

### Task
Build a component that fetches data when connected and renders its state when the data changes.

### Wayland Approach
Combine `shadowed`, `renderable`, and `reactive` mixins. Use a reactor loop to manage state transitions.

### Example
```coffeescript
import { shadowed, renderable, reactive } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"

class extends do Fn.pipe [ shadowed, renderable, reactive ]
  @tag "user-profile"

  @reactor ( reactor ) ->
    for await event from reactor
      switch event.name
        when "connect"
          # fetch user data
          @channel.send name: "value", user: { name: "Alice" }
        when "value"
          @render "<h1>#{event.user.name}</h1>"
```

### Algorithm
1.  Define a class by piping the necessary mixins.
2.  Register the component using `@tag`.
3.  Implement a reactor function using `@reactor`.
4.  In the reactor, use a `for await...from` loop to handle lifecycle and custom events.
5.  Use `@render` to update the component's UI.

## Declarative Event Handling

### Task
Handle a button click by preventing the default behavior and sending a custom event to the component's reactor.

### Wayland Approach
Use the `eventful` mixin to define event listeners declaratively.

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
        console.log "Action triggered!"
```

### Algorithm
1.  Include the `eventful` mixin in your component's pipe.
2.  Use the static event methods (like `@click()`) to configure listeners.
3.  Chain `.prevent()` or `.stop()` as needed.
4.  Use `.send("name")` to route the DOM event to your reactor as a named event.

## Observing Attribute Changes

### Task
Automatically update the component when a specific data attribute changes.

### Wayland Approach
Use the `observable` mixin to watch for attribute modifications.

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
1.  Include the `observable` mixin.
2.  Use `@observe.attributes` to specify which attributes to watch.
3.  In the reactor, listen for the `modify` event.
4.  Retrieve the updated attribute value directly from `@dom`.
