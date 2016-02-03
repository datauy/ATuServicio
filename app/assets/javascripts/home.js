// Redirect to state providers on state change:
$('#state').change(function(){
  if ($(this).val() === 'todos'){
    document.location = '/'.concat('#filter');
  } else {
    document.location = "/departamento/".concat( $(this).val() ).concat('#filter');
  }
});

// Add providers to menu and selected providers to compare them
var selected_providers = [];

$(".add_compare").click(function(){
  var provider = {
      name: $(this).data('name'),
      id: $(this).data('id')
  };
  if ($(this).prop('checked') === true){
    if (selected_providers.length == 3){
      var to_remove = selected_providers.pop();
      var box = $(".checkbox").find("[data-id='" + to_remove.id + "']");
      box.prop('checked', false);
    }
    selected_providers.push(provider);
  } else {
    selected_providers.splice(selected_providers.indexOf(provider), 1);
  }
  add_providers_buttons(selected_providers);

  // Delete button
  $(".fa-trash").on("click", function(e){
    e.preventDefault();
    var button = $(this).closest('.btn-tag');
    var provider = {
      name: button.data('name'),
      id: button.data('id')
    };
    button.remove();
    selected_providers.splice(selected_providers.indexOf(provider), 1);
    selected_providers.splice();

    check_compare_button();

    var box = $(".checkbox").find("[data-id='" + provider.id + "']");
    box.prop('checked', false);
  });

  check_compare_button();
});

$( window ).load(function() {
  $(".add_compare").each(function(){
    if( $(this).prop('checked')){
      var provider = {
        name: $(this).data('name'),
        id: $(this).data('id')
      };
      selected_providers.push(provider);
      add_providers_buttons(selected_providers);
      check_compare_button();
    }
  });
});

function add_providers_buttons(selected_providers){
  var provider_names ='';
  selected_providers.map(function(provider){
    provider_names += '<div class="btn-tag" data-id="'+ provider.id +
      '" data-name="' + provider.name + '">' +
      '<p>' + provider.name + '</p>' +
      '<a href="#"><i class="fa fa-trash" data-id="' + provider.id + '"></i></a>' +
      '</div>';
  });
  $('.provider-names').html(provider_names);
}


function check_compare_button(){
  if(selected_providers.length > 0){
    $('.btn-compare').removeClass('hidden').addClass('visible');
  } else {
    $('.btn-compare').removeClass('visible').addClass('hidden');
  }
}

// Go to compare with selected providers
$(".btn-compare").click(function(e){
  e.preventDefault();
  var ids = [];
  selected_providers.map(function(provider){
    ids.push(provider.id);
  });
  document.location = "/comparar/".concat(ids.join(" "));
});

// See structure on button click
$('.structure').click(function(e){
  e.preventDefault();
  var id = $(this).data('id');
  var structure  = $('#structure_' + id);
  structure.removeClass('hidden').addClass('visible');
});

// Close stuff
$('.close').click(function(e){
  e.preventDefault();
  $(this).parent().removeClass('visible').addClass('hidden');
});

// Fixed table header
$(window).scroll(function() {
  if ($(window).scrollTop() > 900) {
    $("#fixed-versus").show();
  }
  else {
    $("#fixed-versus").hide();
  }
});

// Providers dropdown
$('#selected_providers').change(function(){
  document.location = "/comparar/".concat($(this).val());
});
