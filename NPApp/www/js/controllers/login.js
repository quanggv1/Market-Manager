NP.controller('LoginCtrl', function ($scope, $state, $http, $ionicLoading) {
  var headers = { 'Access-Control-Allow-Origin': "*" };

  var str = $.param({ cost: 12345, insertBy: 'testUser' });

  $scope.doLogin = function () {
    console.log(str);
    // $ionicLoading.show();
    // $http({
    //   method: "GET",
    //   headers: headers,
    //   url: "http://localhost:5000/authen?userName=admin&password=admin"
    // }).then(function mySucces(response) {
    //   $ionicLoading.hide();
    //   console.log(response);
    // }, function myError(response) {
    //   $ionicLoading.hide();
    //   console.log(response);
    // });

    $.get("http://localhost:5000/authen?userName=admin&password=admin", function(data, status){
        alert("Data: " + data + "\nStatus: " + status);
    });
  }
});
