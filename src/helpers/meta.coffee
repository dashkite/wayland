import * as Meta from "@dashkite/joy/metaclass"

properties = ( T, dictionary ) -> Meta.properties dictionary, T::
getters = ( T, dictionary ) -> Meta.getters dictionary, T::

export { properties, getters }