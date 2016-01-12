$('#myModal').on('shown.bs.modal', function () {
  $('#myInput').focus();
});

$(window).scroll(function() {
  if ($(window).scrollTop() > 500) {
    $("#fixed-versus").show();
  }
  else {
    $("#fixed-versus").hide();
  }
});
