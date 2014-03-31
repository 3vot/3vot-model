ajax_request = require("./ajax_request")
AjaxUtils = require("./ajax_utils")
_3Model = require("3vot-model")

class Query
  constructor: (@model) ->
    if( typeof Visualforce != "undefined" ) then ajax_request = require("./vf_request")

  manualQuery: (query, options = {}) ->
    options.url = _3Model.Model.host + "/query?query=" + query
    
    ajax_request.queueRequest.get({}, options, @model).end (err, res) =>
      if err then return @failResponse(err, options )
      else if res.status >= 400 then return @failResponse(res.text, options )
      @model.refresh(res.body, options)
      @recordsResponse(res, options);
    return true

  # Private

  recordsResponse: (data, options) =>
    @model.trigger('ajaxSuccess', data)
    options.done?.apply(@model, [data] )

  failResponse: (error, options) =>
    @model.trigger('ajaxError', error)
    options.fail?.apply(@model, [error] )

module.exports = Query


getQuery: (options = {"": true} ) =>
  options = [options] if !RSpine.isArray(options)
  
  #add Conditions based on Options
  return @queryString() + @getQueryCondition(options) 

#each condition should be an object
#condition values: {key:value , juntion: "and|or"} or { orderBy: "columnd DESC|ASC" }
getQueryCondition: (conditions) ->
  return "" if Object.keys(@filters).length == 0

  stringFilters = []
  queryFilterString = ""
  orderFilterString = ""
  querySinceLastUpdated = @querySinceLastUpdate

  for filter in conditions
    filter.junction = "and" if !filter.junction
    filter.junction = "where" if stringFilters.length ==0
    
    filterKey= ""
    for key in Object.keys(filter)
      filterKey = key if key != "junction"
    
    querySinceLastUpdate = true if key == "sinceLastUpdate"
    querySinceLastUpdate = false if key == "avoidLastUpdate"

    if filterKey != "orderBy" and filterKey != "sinceLastUpdate" and key != "avoidLastUpdate"
      thisFilter = @filters[filterKey]
      thisFilter = thisFilter.replace("?",filter[filterKey]);
      stringFilters.push thisFilter
      queryFilterString += " #{filter.junction} #{thisFilter}"
    else if filterKey == "orderBy"
      orderFilterString = " ORDER #{filter[filterKey]}"

  queryFilterString = " and LastModifiedDate >= #{@lastUpdate}" if querySinceLastUpdated
  queryFilterString + orderFilterString
      
queryString: () =>
  query = "select "
  for attribute in @attributes
    query += attribute + "," if @avoidQueryList?.indexOf(attribute) == -1            
      
  query += "Id  "
  query +=  "from #{@className}" 
  query += " "
  query