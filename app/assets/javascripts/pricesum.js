$(function(){
  var minPrice = 300;
  var price = $("#jsPrice");
  var taxoutput = $("#jsTax");
  var totaloutput = $("#jsTotal");
  var tax = 0.1;

  price.on("keyup", function() {
    var num = $(this).val();
    $(this).val(num);
    if(num < minPrice){
      var nothing = '-';
      taxoutput.val(nothing);
      totaloutput.val(nothing);
    }
		if(num >= 300) {
      var icon = '¥'
			var sumtax = num * tax;
      taxoutput.val(icon + sumtax);
      var totalprice = num - sumtax;
      totaloutput.val(icon + totalprice);
		}
  });
});

