import * as Stylist from "@dashkite/stylist"
import once from "./helpers/once"
import Handle from "./handle"
import reactive from "./reactive"

key = Symbol( import.meta.url )

styleable = once key, ( base = Handle ) ->
  
  class extends reactive base

    @[ key ]: styleable

    @sheets: ( list ) ->
      @start ->
        Stylist.sheets @root, list

export { styleable }
export default styleable