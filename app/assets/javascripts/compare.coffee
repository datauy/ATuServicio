$ ->
  $("#provider").chained("#state")

  $("#state").change ->
    $("#selected_state").html($("#state").find(":selected").text())

  $("#provider").change ->
    $("#selected_provider").html($("#provider").find(":selected").val())

