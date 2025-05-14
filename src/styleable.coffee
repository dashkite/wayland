import * as Stylist from "@dashkite/stylist"
import once from "./helpers/once"
import Handle from "./handle"
import reactive from "./reactive"

styleable = once ( base = Handle ) ->
  
  class extends reactive base

    @sheets: ( list ) ->
      @start ->
        Stylist.sheets @root, list

export { styleable }
export default styleable