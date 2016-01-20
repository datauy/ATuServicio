$('#state').change(function(){
  document.location = "/departamento/".concat( $(this).val() );
});
