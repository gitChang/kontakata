'use strict';

angular
	.module('kontakata')
	.directive('contactMobileNumber', check_numericality);

function check_numericality($timeout) {

	function link_callback(scope, elem) {

		var timer;


		elem.on('input', function () {

			if (scope.model.mobile_number) {
			
				if (timer) clearTimeout(timer);
				
				timer = $timeout(callback, 2000);

			}

		});

    // check for validity of characters
    // for mobile number field.
		function callback() {

			var number_valid = /^[0-9-]+$/.test(scope.model.mobile_number);

			if(number_valid) {
				
				scope.error = null;
			
			} else {

				scope.error = 'Unacceptable Mobile Number.';
			
			}
				
		}

    // add .has-error class to this element
    // when scope.error matches the regex.
		scope.$watch('error', function(err) {

			if ( /Mobile Number/i.test(err) )
				elem.parent().addClass('has-error');
			else
				elem.parent().removeClass('has-error');

		});

	}

	return {
		restrict: 'C',
		link: link_callback
	};

}