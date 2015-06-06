'use strict';

angular
	.module('kontakata')
	.directive('contactFields', change_state);

function change_state() {

	function link_callback(scope, elem) {

    // disable fieldset tag when true by adding
    // .fade class.
		scope.$watch('is_saving', function (val) {

			if (val)
				elem.addClass('fade');
			else
				elem.removeClass('fade');
		
		});

	}

	return {
		restrict: 'C',
		link: link_callback
	};
}