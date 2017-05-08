NP.controller('LoginCtrl', function($scope, $state) {
  $scope.doLogin = function () {
    $state.go('app.top')
  }
});