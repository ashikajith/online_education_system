App.directive "autoComplete", () ->
  (scope, element, attribute) ->
    scope.$watch attribute.uiItems, ((values) ->
      element.autocomplete
        source: values
        select: ->
          setTimeout (->
            element.trigger "input"
          ), 0
    ), true
