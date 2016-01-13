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
