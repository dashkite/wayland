import * as Stylist from "@dashkite/stylist"
import once from "./helpers/once"
import Handle from "./handle"


styled = once ( base = Handle ) ->
  
  class extends base

    @sheets: ( list ) ->
      @start ->
        Stylist.sheets @root, list

export { styled }