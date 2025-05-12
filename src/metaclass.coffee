import { properties, getters } from "@dashkite/joy/metaclass"

metaclass = ( base = Object ) ->

  class extends base

    @getters: ( dictionary ) -> getters dictionary, @::

    @properties: ( dictionary ) -> properties dictionary, @::

export { metaclass }
export default metaclass