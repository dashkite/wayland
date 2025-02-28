import { innerHTML } from "diffhtml"

diff = ( T ) ->
  T::render = ( content ) -> innerHTML @root, content

export { diff }