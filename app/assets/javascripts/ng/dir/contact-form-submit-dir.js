'use strict';

angular
	.module('kontakata')
	.directive('contactForm', form_submit);

function form_submit($rootScope, $http) {

	function link_callback(scope, elem) {

		elem.on('submit', function () {

      // send signal indicates
      // submission of form, to disable
      // fieldset tag.
			scope.is_saving = true;

			$http.post(Routes.contacts_path(), scope.model)
			.success(function (res) {

        // clear form fields.
				scope.reset_contact_form();

        // enable fieldset tag.
				scope.is_saving = false;

        // prepend newly saved contact to
        // contact object.
				$rootScope.contacts.unshift(res);

        // hide form.
				angular.element('.toggler').click();

			})
			.error(function (res) {

				scope.error = res.error;

				scope.is_saving = false;

			});

		});
	}

	return {
		restrict: 'C',
		link: link_callback
	};
}