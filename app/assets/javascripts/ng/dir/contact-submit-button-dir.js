'use strict';

angular
  .module('kontakata')
  .directive('btnBlock', change_text);

function change_text() {

  function link_callback(scope, elem) {

    // replace the text of the submit
    // button to html value which indicates
    // saving.
    scope.$watch('is_saving', function(val) {

      if (val) {

        scope.error = null;

        var icon_spin = '<i class="fa fa-spinner fa-pulse"></i>';

        elem.html(icon_spin + ' ' + 'Adding Contact...');
      
      } else {

        elem.html('Add Contact');
      
      }

    });

  }

  return {
    restrict: 'C',
    link: link_callback
  };
}