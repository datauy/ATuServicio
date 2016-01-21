$('#state').change(function(){
  document.location = "/departamento/".concat( $(this).val() );
});

var selected_providers = [];
$(".add_compare").click(function(){
  var provider = {
      name: $(this).data('name'),
      id: $(this).data('id')
  };
  if ($(this).prop('checked') === true){
    if (selected_providers.length == 3){
      selected_providers.pop();
    }
    selected_providers.push(provider);
  } else {
    selected_providers.splice(selected_providers.indexOf(provider), 1);
  }
  var provider_names ='';
  selected_providers.map(function(provider){
    provider_names += '<div class="btn-tag">' +
      '<p>' + provider.name + '</p>' +
      '<a href="#"><i class="fa fa-trash"></i></a>' +
      '</div>';
  });
  $('.provider-names').html(provider_names);
});

$("#btn-compare").click(function(e){
  e.preventDefault();
  var ids = [];
  selected_providers.map(function(provider){
    ids.push(provider.id);
  });
  document.location = "/comparar/".concat(ids.join(" "));
});
