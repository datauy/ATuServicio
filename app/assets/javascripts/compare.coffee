$ ->
  $("#provider").chained("#state")

  $("#state").change ->
    $("#selected_state").html($("#state").find(":selected").text())

  $("#provider").change ->
    new_provider = $("#provider").find(":selected").val()
    providers = $("#selected_providers").val().split(" ").concat(new_provider)
    new_providers_list = $("#selected_providers").val(providers.join(" ")).val()
    if new_provider
      document.location = "/comparar/?selected_providers=".concat(new_providers_list)

  $(".remove_provider").click ->
    element = $(this).data().provider
    providers = $("#selected_providers").val().split(" ")
    providers.splice(providers.indexOf(element.toString()), 1)
    new_providers_list = providers.join(" ")
    document.location = "/comparar/?selected_providers=".concat(new_providers_list)

  $("pp").hide();

  $("#selected_providers.home_providers").change ->
    id = $("#selected_providers.home_providers").find(':selected').val()
    row = $('#' + id).clone()
    $('#' + id).remove()
    row.find('td').css('background-color', "#EDF4F9")
    $('#referencias').after(row)
