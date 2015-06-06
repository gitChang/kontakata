'use strict';

angular
	.module('kontakata')
	.directive('select', select_picture);

function select_picture() {

	var file_input = document.getElementById('fileInput');
	var	photo = document.getElementsByClassName('select')[0];
  var	file;

	function link_callback(scope, elem) {

		// to prevent erubis for interpolating img.src, we set
    // src = '' and place default value using this line.
    elem.attr('src', scope.img_placehold);

    // fire up input file tag for selecting a photo.
		elem.on('click', function() { file_input.click(); });

    // get the base64 data of the selected photo
    // to be the value of img_data object in the
    // payload and pass it on img.select tag to display.
		file_input.addEventListener('change', function () {
			
			var reader = new FileReader();
      var imageType = /image.*/;

      file = this.files[0];

      if (file.type.match(imageType)) {

        scope.error = null;
        scope.$apply();

        reader.onload = function () {

          scope.model.image_data = reader.result;

          scope.model.file_name = file.name;

          photo.setAttribute('src', reader.result);

        };

          reader.readAsDataURL(file);

      } else {

        scope.error = 'File is not an image.';
        scope.$apply();

      }

		});
	
	}

	return {
		restrict: 'C',
		link: link_callback
	};

}