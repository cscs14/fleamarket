$(document).on('turbolinks:load', function() {
  var $q = $('#click-balloon');
  var flg = true;
  var speed = 300;

  $q.on('click', function() {
    if (flg) {
      flg = false;
      var $balloon = $(this).next('.balloon');

      if ($balloon.hasClass('is-active')) {
        $balloon.removeClass('is-active').fadeOut(speed);
      } else {
        $('.balloon')
          .removeClass('is-active')
          .fadeOut(speed);
        $balloon.addClass('is-active').fadeIn(speed);
      }
      setTimeout(function() {
        flg = true;
      }, speed);
    }
    $(document).on('click', function(e) {
      if (!$(e.target).closest('.balloon').length) {
        $('.balloon')
          .removeClass('is-active')
          .fadeOut(speed);
      }
    });
    return false;
  });
});
