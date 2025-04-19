import Channel from "@dashkite/reactive/channel"

tag = ( name ) ->

  ( T ) ->

    T.tag = name

    class Element extends HTMLElement
      constructor: ->
        super()
        @handle = new T @
        @handle.channel = Channel.make()
        @handle.run @handle.channel
        @handle.channel.send name: "start"
      connectedCallback: -> @handle.channel.send name: "connect"
      disconnectedCallback: -> @handle.channel.send name: "disconnect"

    T.Element = Element

    # give the rest of the mixins a chance to load...
    queueMicrotask ->
      customElements.define name, Element

export { tag }