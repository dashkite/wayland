import add from "#helpers/add"

debounce = ( f ) ->
  # ensure the first time always fires
  do ({ last, tolerance } = {}) ->
    tolerance = 500 #ms
    last = -tolerance
    ( args... ) ->
      current = performance.now()
      if tolerance <= ( current - last )
        last = current
        f args...

intersects = ( event ) -> event.isIntersecting

activate = ( T ) ->
  add "activate"
  start T, ->
    # TODO move into dominator
    observer = new IntersectionObserver debounce ( events ) =>
      ( @channel.send name: "activate" ) if ( events.find intersects )?        
    observer.observe @dom

deactivate = ( T ) ->
  add "deactivate"
  # TODO remove intersection observer?

export { activate, deactivate }