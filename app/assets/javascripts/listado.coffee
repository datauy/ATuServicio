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

  sortable.bind 'aftertablesort', (event, data) ->
    referencias = $('#referencias').clone();
    $('#referencias').remove();
    $('#listado tbody').prepend(referencias);
    references();

