var app = angular.module('testApp', []);

function TestCtrl($scope) {
  $.get('/_a/posts/', function(result) {
    console.log(result);
    $scope.posts = result.posts;
    $scope.$apply();
  });
}

