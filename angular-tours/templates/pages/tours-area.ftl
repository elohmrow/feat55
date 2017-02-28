[#assign page = cmsfn.page(content)]
[#assign jsonUrl = cmsfn.link(page)?replace('.html','.js')!]
 
<script>
    (function () {
        'use strict';
        angular.module("angularGallery", ['ngRoute','ngSanitize'])
        .config(function ($routeProvider) {
            $routeProvider
                .when('/', {
                    templateUrl: '${ctx.contextPath}/.resources/angular-tours/templates/pages/list.html',
                    controller: 'ToursController'
                })
                .when('/tour/:name/:uuid', {
                    templateUrl: '${ctx.contextPath}/.resources/angular-tours/templates/pages/detail.html',
                    controller: 'TourDetailController'
                 })
                .otherwise({redirectTo: '/'});
        })      
        .controller("ToursController", ['$scope', '$http', '$location',
            function ($scope, $http, $location) {
                $http.get('${jsonUrl}')
                    .then(function (response) {
                        $scope.items = response.data;
                    });
$scope.handleClick = function (item) {
    $location.path('/tour/' + item['@name'] + '/' + item['@id']);               
};
            }])
        .controller("TourDetailController", ['$scope', '$http', '$location', '$routeParams',
            function ($scope, $http,$location, $routeParams) {
                if ($routeParams.uuid !== null) {
                    $http.get('${jsonUrl}' + '?detail=' + $routeParams.uuid)
                        .then(function (response) {
                            $scope.item = response.data;
                        });
                }
$scope.go_back = function (item) {
    $location.path('/');               
};
         }])
    }());
</script>
 
<div ng-app="angularGallery" ng-controller="ToursController">
    <div ng-view> </div>
</div>
