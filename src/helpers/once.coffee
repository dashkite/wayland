once = ( key, mixin ) ->
  f = ( base ) ->
    if base?
      if base[ key ]?
        if base[ key ] == f
          base
        else
          console.warn "mixin key set incorrectly: [ #{ key} ]"
          mixin base
      else
        mixin base
    else
      mixin()

export default once
export { once }