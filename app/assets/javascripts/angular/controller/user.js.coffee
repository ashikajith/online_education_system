App.controller 'User', ['$scope', 'User', ($scope, User) ->
  $scope.users = User.query ->
    {}
]