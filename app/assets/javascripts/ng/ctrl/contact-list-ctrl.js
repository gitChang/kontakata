'use strict';

angular
	.module('kontakata')
	.controller('ContactListCtrl', 

	function ($rootScope, $scope, $http) {

    // get al the contacts registered.
		$http.get(Routes.all_contacts_path())
		.success(function (res) {

			$rootScope.contacts = res;
		
		})
		.error(function () {

			alert('Failed to get all contacts.');
		
		});

    $scope.set_icon = function (fa) {

      var icons = {
        fb: '<i class="fa fa-facebook"></i>',
        tw: '<i class="fa fa-twitter"></i>'
      };

      if (/facebook/.test(fa))
        return icons.fb;
      else
        return icons.tw;

    };
	});