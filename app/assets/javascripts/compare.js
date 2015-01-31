(function() {
  $(function() {
    $("#provider").chained("#state");
    $("#state").change(function() {
      return $("#selected_state").html($("#state").find(":selected").text());
    });
    return $("#provider").change(function() {
      var new_provider, new_providers_list, providers;
      new_provider = $("#provider").find(":selected").val();
      providers = $("#selected_providers").val().split(" ").concat(new_provider);
      new_providers_list = $("#selected_providers").val(providers.join(" ")).val();
      if( $('#provider').val() !== ''){
        return document.location = "/comparar/?selected_providers=".concat(new_providers_list);
      }
      return false;

    });
  });

}).call(this);
