import * as Stylist from "@dashkite/stylist"
import { start } from "./events"

sheets = ( T, list ) ->
  start T, ->
    Stylist.sheets @root, list
    return

export { sheets }
