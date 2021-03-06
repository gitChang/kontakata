'use strict';

angular
  .module('kontakata')
  .filter('shorti', shorti);

// extract domain name
// and path from social
// profile url.
function shorti() {
  return function(str) {
    return str.replace('https://', '')
              .replace('www.','')
              .replace('.com','');
  };  
}

angular
  .module('kontakata')
  .filter('escHtml', esc_html);

// force to display text
// as html.
function esc_html($sce) { 
  return $sce.trustAsHtml; 
}