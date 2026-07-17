# Testing

This document outlines the testing strategy for the Wayland library.

Wayland utilizes the `amen` testing framework combined with `@dashkite/assert` for its test assertions. The testing architecture focuses on verifying that mixins apply correctly to the base Handle and that reactive components respond predictably to simulated events.

To execute the test suite, developers run the Genie task runner:

```bash
npx genie test
```

If the Genie task runner is unavailable in the environment, the tests can be triggered via `node` directly on the test entry point.
