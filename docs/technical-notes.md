# Technical Notes

This document provides architectural context and implementation details for the Wayland library that do not belong in the standard API reference.

### Native Web Components

Wayland is built on top of [Web Components](https://developer.mozilla.org/en-US/docs/Web/API/Web_components), a suite of technologies allowing developers to create reusable custom elements. Wayland simplifies the creation of these custom elements while embracing their native behavior rather than completely abstracting them away. This ensures compatibility across frameworks.

### Architectural Goal and Composition

The overall goal of Wayland is to serve as the logical base for custom Web Components. Wayland packages the repeatable aspects of Web Components—such as behaviors, specialized interfaces, and smoothed versions of low-level APIs—and makes these orthogonal capabilities available for composition. 

Unlike a purely functional composition, the anchor point for a Wayland composition is the Web Component class itself. While developers construct a component using Joy's `pipe`, the result of that composition is a robust class that can continue to be extended. 

Wayland provides specialized interfaces to support the extension of specific HTML templates and CSS stylesheets. It also provides an interface to attach reactors, allowing developers to seamlessly compose a given Web Component class with the reactive behavior engine.

### Facilitating the RMVC+R Model

Collectively, the composition of these orthogonal behaviors enables the realization of the RMVC+R (Resource, Model, View, Controller, and Reactor) architectural model. 

Wayland is deliberately decoupled from the specific implementation of how these constituents are derived. Developers maintain the complete freedom to choose how they create HTML templates, how they derive the CSS stylesheets that style the component, and how the reactor logic is assembled and connected to network resources. While Wayland is not intrinsically required to implement RMVC, it is explicitly designed to facilitate it.

### Mixin Idempotency

Wayland mixins are designed to be composed using `Fn.pipe`. Each mixin ensures it is only applied once using a unique symbol key. This idempotency prevents accidental duplication of behavior or state when multiple mixins share dependencies in the pipeline.

### Handle and Element Relationship

Wayland separates the custom DOM element from its logic using a Handle pattern. The `Handle` class serves as the controller, while the raw custom element strictly acts as the view layer. This ensures that the component's logic can be developed and tested independently of browser DOM idiosyncrasies. When `@tag` is called, Wayland dynamically creates a new `HTMLElement` subclass. When the browser instantiates this element, it automatically instantiates the `Handle` (the controller) and maintains a reference to it via the `handle` property. This abstraction keeps the business logic decoupled from the direct browser API lifecycle.

### Reactive Reactor Loops

The `reactive` mixin enables asynchronous generator functions as reactors. Wayland automatically routes incoming events (such as DOM lifecycle events, custom events, or `observable` mutations) into the unified stream that the reactor loops over.
