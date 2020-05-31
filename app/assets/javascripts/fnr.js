/***   VARIABLES   ***/
var colorsByName = [];
var palette = [
	[ '#003C8D', '#0047A6', '#0051BF', '#005CD9', '#0067F2',
		'#1B6F94', '#1F83AD', '#2496C7', '#28A9E0', '#2DBCFA',
		'#007F31', '#00993B',	'#00B345', '#00CC4F', '#00E659',
		'#8F6C00', '#A87F00', '#C29200', '#DCA600', '#F5B900' ],
	[	'#003C8D', '#1B6F94', '#007F31', '#8F6C00', '#0047A6',
		'#1F83AD', '#00993B', '#A87F00', '#0051BF', '#2496C7',
		'#00B345', '#C29200', '#005CD9', '#28A9E0', '#00CC4F',
		'#DCA600', '#0067F2', '#2DBCFA', '#00E659', '#F5B900'	]
];
var workingPallete = JSON.parse(JSON.stringify(palette));
var tooltip = d3.select("body")
.append("div")
.style("position", "absolute")
.style("z-index", "10")
.style("visibility", "hidden")
.style("background", "#fff")
.text("a simple tooltip")
.attr("id","d3_tooltip");

/***   FUNCTIONS   ***/
function getRandomColor(groupname, pallete_id, reload){
	//console.log(workingPallete);
	if(colorsByName[groupname]) {
		return colorsByName[groupname];
	}
	else {
		if ( !workingPallete[pallete_id].length ) {
			workingPallete[pallete_id] = JSON.parse(JSON.stringify(palette[pallete_id]));
		}
		//let random = Math.floor(Math.random()*(workingPallete.length-1));
		var color = workingPallete[pallete_id].shift();
		//workingPallete.splice(random, 1);
		colorsByName[groupname] = color;
		return color;
	}
}
function renderBars(container_id, data) {
	var dy = 60;
	w = $("#"+container_id).innerWidth(),
	h = ( dy + 6 )*data.length;

	var max_n = 0;
	for (var d in data) {
		max_n = Math.max(data[d].qtty, max_n);
	}
	var dx = w / max_n;

	var svg = d3.select("#"+container_id).append("svg")
	.attr("width", w)
	.attr("height", h);

	console.log("Rendering "+ container_id);
	// bars
	svg.selectAll(".bar")
	.data(data)
	.enter()
	.append("rect")
	.attr("class", function(d, i) {return "bar " + d.groupname;})
	.attr("x", function(d, i) {return 0;})
	.attr("y", function(d, i) {return (dy*i)+(5*i);})
	.attr("width", function(d, i) {return dx*d.qtty;})
	.attr("height", dy)
	.style("fill", function(d,i) {
		return getRandomColor(d.groupname, 0);
	})
	.style("margin-bottom", "10px")
	.style('cursor', 'pointer')
	.on("mouseover", function(d){
		tooltip.text(d.groupname);
		return tooltip.style("visibility", "visible");
	})
	.on("mousemove", function(){
		return tooltip.style("top", (d3.event.pageY-10)+"px").style("left",(d3.event.pageX+10)+"px");
	})
	.on("mouseout", function(){
		return tooltip.style("visibility", "hidden");
	})
	.on('click', function(d){
		if ( container_id == "graph-wait" ) {
			window.open( "https://catalogodatos.gub.uy/dataset/fondo-nacional-de-recursos-tiempo-de-espera-de-los-imae/resource/"+
			resource +"?filters=imaeid%3A"+ d.id );
		}
		else {
			var dest = "https://catalogodatos.gub.uy/dataset/fondo-nacional-de-recursos-solicitudes-de-tramites-autorizados/resource/"+interventionsource +"?filters=";
			if ( $('#by').val == 'imae') {
				dest += "IMAE%2FCL%C3%ADnica%2FCentro%3A"+ d.groupname.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toUpperCase();
			}
			else {
				if ( $("#statsArea").val() ) {
					dest += "prestacion_desc%3A"+ d.groupname.normalize("NFD").replace(/[\u0300-\u036f]/g, "");
				}
				else {
					dest += "area_prestacion%3A"+ d.groupname;
				}
			}
			window.open( dest );
		}
		tooltip.style("visibility", "hidden");
	});
	// labels
	//TOP
	svg.selectAll("text")
	.data(data)
	.enter()
	.append("text")
	.attr("class", function(d, i) {return "text " + d.groupname;})
	.attr("x", 20)
	.attr("y", function(d, i) {return dy*i + (5*i) + 25;})
	//.attr("width", 160)
	//.html( function(d) {return d.groupname + "<a style='width:120px; height:25px;' href='https://catalogodatos.gub.uy/dataset/fondo-nacional-de-recursos-solicitudes-de-tramites-autorizados/resource/dd3046c9-06eb-490e-be95-ba58feb25b5e?filters=IMAE%2FCL%C3%ADnica%2FCentro%3A"+d.groupname.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toUpperCase()+"'>(" + d.count  + " actos médicos)</a>";})
	.attr("font-size", "15px")
	.html( function(d) {
		return '<tspan width="100%">' +d.groupname.toUpperCase()+"</tspan>"
	});

	//BOTTOM
	svg.selectAll(".graph-values")
	.data(data)
	.enter()
	.append("text")
	//.attr("class", function(d, i) {return "graph-values " + d.groupname;})
	.attr("x", 20 )
	.attr("y", function(d, i) {return dy*i + (5*i) + 45;})
	.attr("font-size", "14px")
	//.style("font-weight", "bold")
	.attr("width", 60)
	.html( function(d) {
		if ( container_id == "graph-wait" ) {
			return "Promedio: " + d.qtty + " días ("+d.numb+" actos médicos)";
		}
		else {
			return d.qtty + " intervenciones";
		}
	});
};

function filterData() {
	$("#loading").show();
	$.ajax({
		type: "POST",
		url: "/fnr",
		data : $("form").serialize(),
		success: function(result){
			$("#loading").hide();
		}
	});
}
function renderGraphs() {
	workingPallete = JSON.parse(JSON.stringify(palette));
	// bars
	renderBars('graph-wait', data);
	renderBars('graph-stats', data_by);
	/***   Watchers   ***/
	//Waiting
	$("#area").change(function (e) {
		//reset type value
		$("#type").val('');
		filterData();
	});
	$("#type").change(function (e) {
		filterData();
	});
	//Stats
	$(".filter-by").not('.active').click(function (e) {
		e.preventDefault();
		$(".filter-by").removeClass('active');
		$(this).addClass('active');
		$('#by').val($(this)[0].id);
		filterData();
	});
	$("#states").change(function (e) {
		filterData();
	});
	$("#provider").change(function (e) {
		filterData();
	});
	$("#statsArea").change(function (e) {
		//Si va por imae lo dejamos como está
		if ($('#actos').hasClass('active')) {
			$('#by').val('intervention_type');
		}
		filterData();
	});
}
renderGraphs();
