import * as Stylist from "@dashkite/stylist"
import Handle from "./handle"

styled = ( base = Handle ) ->
  
  class extends base

    @sheets: ( list ) ->
      @start ->
        Stylist.sheets @root, list

export { styled }