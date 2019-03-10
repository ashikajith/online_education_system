App.controller 'Autocomplete', ['$scope', 'User', ($scope, User) ->
  $scope.names = []
  $scope.user  = User.query ->
    for user in $scope.user
      $scope.names.push label: user.user_detail.first_name, value: user.email
]