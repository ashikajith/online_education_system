App.factory 'User', ['$resource', ($resource) ->
  $resource '/portal/users/:id', id: '@id'
]