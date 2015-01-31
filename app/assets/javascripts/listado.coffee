$ ->
  $('#toggle_references').click ->
    visible = $("#referencias").children().find('li').first().is(':visible')
    if visible
      $("#referencias").children().find("li").hide();
      $("#toggle_references").text('Ver referencias')
    else
      $("#referencias").children().find("li").show();
      $("#toggle_references").text('Ocultar referencias')
