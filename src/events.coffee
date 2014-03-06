trim= (text) ->
  rtrim = /^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g;
  text == null ? "" : ( text + "" ).replace( rtrim, "" );
  text;

Events =
  bind: (ev, callback) ->
    evs   = ev.split(' ')

    if @hasOwnProperty('_callbacks') and @_callbacks
       calls = @_callbacks
    else 
      @_callbacks = {}
      calls = @_callbacks

    for name in evs
      calls[name] or= []
      calls[name].push(callback)
    this

  one: (ev, callback) ->
    @bind ev, handler = ->
      @unbind(ev, handler)
      callback.apply(this, arguments)

  trigger: (args...) ->
    ev = args.shift()
    list = @hasOwnProperty('_callbacks') and @_callbacks?[ev]
    return unless list
    for callback in list
      if callback.apply(this, args) is false
        break
    true

  listenTo: (obj, ev, callback) ->
    obj.bind(ev, callback)
    @listeningTo or= []
    @listeningTo.push {obj, ev, callback}
    this

  listenToOnce: (obj, ev, callback) ->
    listeningToOnce = @listeningToOnce or = []
    obj.bind ev, handler = ->
      idx = -1
      for lt, i in listeningToOnce when lt.obj is obj
        idx = i if lt.ev is ev and lt.callback is callback
      obj.unbind(ev, handler)
      listeningToOnce.splice(idx, 1) unless idx is -1
      callback.apply(this, arguments)
    listeningToOnce.push {obj, ev, callback, handler}
    this

  stopListening: (obj, events, callback) ->
    if arguments.length is 0
      for listeningTo in [@listeningTo, @listeningToOnce]
        continue unless listeningTo
        for lt in listeningTo
          lt.obj.unbind(lt.ev, lt.handler or lt.callback)
      @listeningTo = undefined
      @listeningToOnce = undefined

    else if obj
      for listeningTo in [@listeningTo, @listeningToOnce]
        continue unless listeningTo
        events = if events then events.split(' ') else [undefined]
        for ev in events
          for idx in [listeningTo.length-1..0]
            lt = listeningTo[idx]
            if (not ev) or (ev is lt.ev)
              lt.obj.unbind(lt.ev, lt.handler or lt.callback)
              listeningTo.splice(idx, 1) unless idx is -1
            else if ev
              evts = lt.ev.split(' ')
              if ~(i = evts.indexOf(ev))
                evts.splice(i, 1)
                lt.ev = trim(evts.join(' '))
                lt.obj.unbind(ev, lt.handler or lt.callback)

  unbind: (ev, callback) ->
    if arguments.length is 0
      @_callbacks = {}
      return this
    return this unless ev
    evs = ev.split(' ')
    for name in evs
      list = @_callbacks?[name]
      continue unless list
      unless callback
        delete @_callbacks[name]
        continue
      for cb, i in list when (cb is callback)
        list = list.slice()
        list.splice(i, 1)
        @_callbacks[name] = list
        break
    this

Events.on = Events.bind
Events.off = Events.unbind


module.exports = Events