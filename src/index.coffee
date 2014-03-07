Events = require("./events")
Model = require("./model")
Module = require("./module")

_3Model = @_3Model   = {}

_3Model.Events     = Events
_3Model.Module     = Module
_3Model.Model      = Model

_3Model.isBlank = Model.isBlank;


# Global events

Module.extend.call(_3Model, Events)

_3Model.Class = Module

module.exports = _3Model