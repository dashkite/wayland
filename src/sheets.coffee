import * as Stylist from "@dashkite/stylist"
import { start } from "./reactors"

sheets = ( list ) ->
  ( T ) ->
    start T, ->
      Stylist.sheets @root, list
      return

export { sheets }
