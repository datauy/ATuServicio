$ ->
  references = () ->
    $('#toggle_references').click ->
      visible = $("#referencias").children().find('li').first().is(':visible')
      if visible
        $("#referencias").children().find("li").hide();
        $("#toggle_references").text('Ver referencias')
      else
        $("#referencias").children().find("li").show();
        $("#toggle_references").text('Ocultar referencias')
  references()

  $('#home-filter #state').change ->
    document.location = "/departamento/".concat( $(this).val() )

  $("#prestador_info").click ->
    $("#prestador-modal-content").modal();
    return false;

  $("#tiempos_info").click ->
    $("#tiempos-modal-content").modal();
    return false;

  $("#derechos_info").click ->
    $("#derechos-modal-content").modal();
    return false;

  $("#tickets_info").click ->
    $("#tickets-modal-content").modal();
    return false;

  $("#metas_info").click ->
    $("#metas-modal-content").modal();
    return false;

  $("#socios_info").click ->
    $("#socios-modal-content").modal();
    return false;

  $("#rrhh_info").click ->
    $("#rrhh-modal-content").modal();
    return false;

  sortable = $("#listado").stupidtable();

  sortable.bind 'beforetablesort', (event, data) ->
    $('#loading').css('display', 'block')
    # We want the "no-data" values to always be at the bottom:
    switch data.column
      when 1 then element = $('.clock-no-data-value')
      when 3 then element = $('.money-no-data-value')
    if data.direction == "desc"
      element.text('-1')
      $(element).parent().updateSortVal(-1)
    else
      element.text('999999999999')
      $(element).parent().updateSortVal('999999999999')

  sortable.bind 'aftertablesort', (event, data) ->
    referencias = $('#referencias').clone();
    $('#referencias').remove();
    $('#listado tbody').prepend(referencias);
    references();
    # This code won't work if we change the order of the columns. I'm
    # checking if the column is "tickets" or "times" by their index:
    switch data.column
      when 1 then element = $('#time-sort')
      when 3 then element = $('#ticket-sort')
    if data.direction == "desc"
      $(element).attr('class', 'icon-down-open')
    else
      $(element).attr('class', 'icon-up-open')
    $('#loading').hide()

  # Initialize tooltips
  $('[data-toggle="tooltip"]').tooltip()

  # Fixed header for table
    #$('#listado').stickyTableHeaders();
