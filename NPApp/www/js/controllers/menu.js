NP.controller('MenuCtrl', function ($scope, $ionicModal, $timeout, $state) {
    $scope.login = function () {
        $state.go('login')
    }
})