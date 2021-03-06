'use strict';

angular
  .module('kontakata')
  .directive('contactSocialProfileUrl', check_social_profile_url);

function check_social_profile_url($http, $timeout) {

  function link_callback(scope, elem) {

    var timer;

    elem.on('input', function () {

      if (scope.model.social_profile_url) {

        if (timer) clearTimeout(timer);

        timer = $timeout(callback, 2000);
      }

    });

    function callback() {

      var param = encodeURIComponent(scope.model.social_profile_url);

      // perform ajax request to validate entered url
      // social profile url.
      $http.get(Routes.check_social_link_contacts_path(param))
      .success(function () {
      
        scope.error = null;
      
      })
      .error(function () {
      
        scope.error = 'Invalid Social Profile URL.';
      
      });
    }

    // add .has-error class to this element
    // when the regex matches the scope.error.
    scope.$watch('error', function(err) {

      if ( /Social/i.test(err) ) {
      
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