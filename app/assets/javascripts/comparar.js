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
const filterRows = $('.table tr').not(".no-filter");
const filterNames = [];
console.log( "filterRows", filterRows);
$.each( filterRows, (index, obj) => {
  var parag = $(obj).find('td:first-child p');
  if ( parag != undefined && parag.length == 1 ) {
    filterNames.push( parag.html().toLowerCase() );
  }
  else {
    filterNames.push('');
  }
});
console.log( "filterNames", filterNames);
$('#filter').keyup(() => {
  var str = $('#filter').val();
  console.log("FILTER", str);
  $.each( filterRows, (index, obj) => {
    var name = filterNames[index];
    if ( !name.toLowerCase().includes(str) ) {
      $(obj).hide();
    }
    else {
      $(obj).show();
    }
  });
});
