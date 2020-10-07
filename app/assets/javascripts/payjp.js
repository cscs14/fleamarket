$(document).on('turbolinks:load', function() {
  var form = $('#charge-form');
  Payjp.setPublicKey('pk_test_0709874f15e2c03103c40713');

  form.on('click', '#token_submit', function(e) {
    e.preventDefault();
    form.find('#token_submit').prop('disabled', true);

    var card = {
      number: $('#number').val(),
      cvc: $('#cvc').val(),
      exp_month: $('#exp_month').val(),
      exp_year: $('#exp_year').val(),
    };

    Payjp.createToken(card, function(status, response) {
      if (status == 200) {
        $('#number').removeAttr('name');
        $('#cvc').removeAttr('name');
        $('#exp_month').removeAttr('name');
        $('#exp_year').removeAttr('name');

        var token = response.id;

        form.append($('<input type="hidden" name="payjp_token">').val(token));
        form.get(0).submit();

        $('#token_submit').css({
          cssText: 'background: #888; border: #888;',
        });
      } else {
        form.find('#token_submit').prop('disabled', false);

        if ($('#number').val() == '' && $('#cvc').val() == '') {
          form.find('.required-num, .required-cvc').text('必須項目です');
          $('#number, #cvc').css({
            cssText: 'border-color: #ea352d;',
          });
        } else if ($('#number').val() == '') {
          form.find('.required-num').text('必須項目です');
          $('#number').css({
            cssText: 'border-color: #ea352d;',
          });
        } else if ($('#cvc').val() == '') {
          form.find('.required-cvc').text('必須項目です');
          $('#cvc').css({
            cssText: 'border-color: #ea352d;',
          });
        } else if (response.error.message == 'Invalid card number') {
          form.find('.required-num').text('カード番号が正しくありません');
          $('#number').css({
            cssText: 'border-color: #ea352d;',
          });
        } else if (response.error.message == 'Invalid cvc code') {
          form
            .find('.payment-errors')
            .html(
              'セキュリティーコードが正しくありません。クレジットカード情報を入力しなおしてください。<br><br><br>'
            );
        } else {
          form
            .find('.payment-errors')
            .html(
              'このカードはご利用になれません。ご利用のクレジットカード会社へお問い合わせください。<br><br><br>'
            );
        }
      }
    });
  });
});
