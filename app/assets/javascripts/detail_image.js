$(document).on('turbolinks:load',function() {
  $(function(){
    $('.image-sub').mouseover(function(){
      var selectedSrc = $(this).attr('src');
      $('.goods-photo__main').html(`<img src="${selectedSrc}" width="300px" height="300px">`)
    });
  });
});