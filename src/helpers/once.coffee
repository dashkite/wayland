once = ( mixin ) ->
  ( base = metaclass()) ->
    if base._mixins.has mixin
      base
    else
      base._mixins.add mixin
      mixin base

export default once
export { once }