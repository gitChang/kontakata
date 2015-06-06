'use strict';

angular
	.module('kontakata')
	.directive('contactFullName', check_dup_fullname);

function check_dup_fullname($http, $timeout) {

	function link_callback(scope, elem) {

		var timer;

		elem.on('input', function () {

      if (scope.model.full_name) {

        if (timer) clearTimeout(timer);

        timer = $timeout(timer_callback, 2000);

      }
		
		});

    // ajax request to check duplicate of full name value.
		function timer_callback() {

			$http.get(Routes.check_full_name_contacts_path(scope.model.full_name))
			.success(function (res) {

				if (res.exists === true) { 

					scope.error = 'Name already exists.';
				
				} else { 

					scope.error = null;
				
				}

			});

		}

    // add .has-error class to this element when
    // the regex matches the scope.error value.
		scope.$watch('error', function(err) {

			if ( /Name/i.test(err) ) { 
			
				elem.parent().addClass('has-error');
			
			} else {

				elem.parent().removeClass('has-error');

			}
		
		});

	}

	return {
		restrict: 'C',
		link: link_callback
	};

}
