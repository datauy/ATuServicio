$ ->
  $("#provider").chained("#state")

  $("#state").change ->
    $("#selected_state").html($("#state").find(":selected").text())

  $("#provider").change ->
    new_provider = $("#provider").find(":selected").val()
    providers = $("#selected_providers").val().split(" ").concat(new_provider)
    new_providers_list = $("#selected_providers").val(providers.join(" ")).val()
    document.location = "comparar/?selected_providers=".concat(new_providers_list)
