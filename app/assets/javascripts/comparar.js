$(".remove_provider").click(function(){
  // Provider to remove
  provider_id = $(this).data().provider;
  var re = /comparar\/([0-9^(%20)]+[%20]?)+/;
  // Get the provider id's in the url and turn into array:
  providers = re.exec(location)[1].split("%20");
  var index = providers.indexOf(provider_id.toString());
  providers.splice(index, 1);
  document.location = "/comparar/".concat(providers.join(" "));
});

$(".icon-info").click(function(e){
  e.preventDefault();
});

$("#search").on( "autocompleteselect", function( event, ui ) {
  $("#add_provider").css('background', '#3FA6C9');
});
var loading = false;
$('.states').on('change', function(e) {
  e.preventDefault();
  if (!loading) {
    var depto = $(e.target).val();
    loading = true;
    $('.loader').show();
    $('.states').val(depto);
    //$("#loading").show();
    $.ajax({
      type: "GET",
      url: "#",
      data: {
        departamento: depto,
      },
      success: function(result) {
        loading = false;
      }
    });
  }
});
const specialistsRows = $('.rrhh-especialistas');
const specialistsNames = [];
$.each( specialistsRows, (index, obj) => {
  specialistsNames.push( $(obj).find('p').html().toLowerCase() );
});
console.log( "Specialists", specialistsNames);
$('#specialist-search').keyup(() => {
  var str = $('#specialist-search').val();
  console.log("SEARCH", str);
  $.each( specialistsRows, (index, obj) => {
    var name = specialistsNames[index];
    if ( !name.toLowerCase().startsWith(str) ) {
      $(obj).hide();
    }
    else {
      $(obj).show();
    }
  });
});
