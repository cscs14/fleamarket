$(document).on('turbolinks:load', function(){

  var id = $('.item-preview__inner').length;

  function buildHTML(count) {
    var html = `<div class="item-preview__inner" id="item-preview__${count}">
                  <div class="item-image">
                    <img src="" alt="preview">
                  </div>
                  <div class="item-edit">
                    <div class="item-edit__image">
                      <label class="edit_btn">編集</label>
                    </div>
                    <div class="item-edit__delete" id="delete_btn_${count}">
                      <span>削除</span>
                    </div>
                  </div>
                </div>`
      return html;
  }

  if (window.location.href.match(/\/freemarkets\/\d+\/edit/)){
    var prevContent = $('#image-drop').prev();
    var count = $('.item-preview__inner').length;

    labelWidth = (620 - $(prevContent).css('width').replace(/[^0-9]/g, ''));
    $('#image-drop').css('width', labelWidth);

    $('.item-preview__inner').each(function(index, box){
      $(box).attr('id', `item-preview__${index}`);
    })

    $('.item-edit__delete').each(function(index, box){
      $(box).attr('id', `delete_btn_${index}`);
    })

    if (count == 5) {
      $('#image-drop').hide();
    }
  }

  function setLabel() {
    var prevContent = $('#image-drop').prev();

    labelWidth = (620 - $(prevContent).css('width').replace(/[^0-9]/g, ''));
    $('#image-drop').css('width', labelWidth);
  }

  $(document).on('change', '.hidden-field', function() {
    setLabel();
    var id = $('.item-preview__inner').length;

    $('.label-box').attr({id: `label-box--${id}`,for: `freemarket_item_images_attributes_${id}_image_url`});
    var file = this.files[0];
    var reader = new FileReader();
    reader.readAsDataURL(file);

    reader.onload = function() {
      var image = this.result;
      if ($(`#item-preview__${id}`).length == 0) {
        var count = $('.item-preview__inner').length;
        var html = buildHTML(id);
        var prevContent = $('#image-drop').prev();
        $(prevContent).append(html);
      }

      $(`#item-preview__${id} img`).attr('src', `${image}`);
      var count = $('.item-preview__inner').length;
        if (count == 5) {
          $('#image-drop').hide();
        }
        if ($(`#freemarket_item_images_attributes_${id}__destroy`)){
          $(`#freemarket_item_images_attributes_${id}__destroy`).prop('checked',false);
        }
        setLabel();
        if(count < 5){
          $('.label-box').attr({id: `label-box--${count}`,for: `freemarket_item_images_attributes_${count}_image_url`});
        }
    }
  });

  $(document).on('click', '.item-edit__delete', function() {
    var count = $('.item-preview__inner').length;
    setLabel(count);
    var id = $(this).attr('id').replace(/[^0-9]/g, '');
    $(`#freemarket_item_images_attributes_${id}__destroy`).prop('checked',true);
    $(`#item-preview__${id}`).remove();
    $(`#freemarket_item_images_attributes_${id}_image_url`).val("");
    var count = $('.item-preview__inner').length;
      if (count == 4) {
        $('#image-drop').show();
      }
      if(count < 5){
        $('.label-box').attr({id: `label-box--${id}`,for: `freemarket_item_images_attributes_${id}_image_url`});
      }
  });
});

