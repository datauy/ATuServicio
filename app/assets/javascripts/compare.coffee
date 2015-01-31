$ ->
  $("#provider").chained("#state")

  $("#state").change ->
    $("#selected_state").html($("#state").find(":selected").text())

  $("#provider").change ->
    new_provider = $("#provider").find(":selected").val()
    providers = $("#selected_providers").val().split(" ").concat(new_provider)
    $("#selected_providers").val(providers.join(" "))
    $("#selected_providers").parent('form').submit()
