# Wayland

*Light-weight, mixin-based Web Components*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Wayland provides a set of highly composable mixins for building native Web Components using a functional and reactive approach. It decouples the UI representation from the underlying logic using a "Handle" pattern, where each component is managed by a specialized controller class.

## Features

- **Composable Mixins**: Composable logic for Shadow DOM, rendering, styling, and reactivity.
- **Reactive Architecture**: Built-in support for event reactors and data streams.
- **Functional Style**: Promotes declarative logic and clean separation of concerns.
- **Native Web Components**: Enhances standard HTML elements without complex abstractions.

## Installation

Use your package manager to install:

```bash
pnpm install @dashkite/wayland
```

## Usage

Wayland components are defined by piping mixins onto a base class and registering them with `@tag`.

```coffeescript
import { shadowed, styleable, reactive } from "@dashkite/wayland"
import * as Fn from "@dashkite/joy/function"
import css from "./css"

class MyComponent extends do Fn.pipe [ shadowed, styleable, reactive ]
  @tag "my-component"
  @sheets [ css ]
  @reactor ( reactor ) ->
    # reactive logic here
```

## Other Resources

- [Reference](./docs/reference.md): Detailed API documentation for mixins and base classes.
- [Recipes](./docs/recipes.md): Common patterns for building Wayland components.
- [Technical Notes](./docs/technical-notes.md): Implementation details and architectural context.
- [Testing](./docs/testing.md): Information regarding testing components.

## Status

This software is currently in active development and is not yet suitable for production use. Please report bugs or request features via the repository's issue tracker.
