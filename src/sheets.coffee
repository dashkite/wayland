import * as Stylist from "@dashkite/stylist"
import { start } from "./reactors"

sheets = ( T, list ) ->
  start T, ->
    Stylist.sheets @root, list
    return

export { sheets }
