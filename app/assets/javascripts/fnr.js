// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
var colorsByName = [];

function getRandomColor(groupName, originalColor = 0, chartLevel = 0){
		if(chartLevel==1 && originalColor){
			return originalColor;
		}
		if(colorsByName[groupName]) {
			return colorsByName[groupName];
		}
		else {
			var letters = '0123456789ABCDEF';
			var color = '#';
			for (var i = 0; i < 6; i++ ) {
				color += letters[Math.floor(Math.random() * 16)];
			}
			colorsByName[groupName] = color;
			return color;
		}
}
$("#states").change(function (e) {
  sval = $('#states').val();
  $.ajax({
    type: "GET",
    url: "/fnr?departamento="+sval,
    success: function(result){
      console.log('Success, ajax');
    }
  });
  console.log('Vuelve ajax');
});
var tooltip = d3.select("body")
 .append("div")
 .style("position", "absolute")
 .style("z-index", "10")
 .style("visibility", "hidden")
 .style("background", "#fff")
 .text("a simple tooltip")
 .attr("id","d3_tooltip");

var container_id = 'graph-wait',
  w = $("#"+container_id).innerWidth(),
  h = 'inherit';
var svg = d3.select("#"+container_id).append("svg")
  .attr("width", w)
  .attr("height", h);

var max_n = 0;
for (var d in data) {
  max_n = Math.max(data[d].averageTime, max_n);
}

var dx = w / max_n;
var dy = 50;

// bars
svg.selectAll(".bar")
  .data(data)
  .enter()
  .append("rect")
  .attr("class", function(d, i) {return "bar " + d.groupName;})
  .attr("x", function(d, i) {return 170;})
  .attr("y", function(d, i) {return (dy*i)+(5*i);})
  .attr("width", function(d, i) {return dx*d.averageTime - 170})
  .attr("height", dy)
  .style("fill", function(d,i) {
    return getRandomColor(d.groupName);
  })
  .style("margin-bottom", "10px")
  .style('cursor', 'pointer')
  .on("mouseover", function(d){
    tooltip.text(d.groupName);
    return tooltip.style("visibility", "visible");
  })
  .on("mousemove", function(){
    return tooltip.style("top", (d3.event.pageY-10)+"px").style("left",(d3.event.pageX+10)+"px");
  })
  .on("mouseout", function(){
    return tooltip.style("visibility", "hidden");
  })
  .on('click', function(d){
      tooltip.style("visibility", "hidden");
      setCategoryGroupFilter(d.groupName);
   });

 // labels
 svg.selectAll("text")
   .data(data)
   .enter()
   .append("text")
   .attr("class", function(d, i) {return "text " + d.groupName;})
   .attr("x", 0)
   .attr("width", 160)
   .attr("y", function(d, i) {return dy*i + (5*i) + 30;})
   .html( function(d) {return d.groupName + "<a style='width:120px; height:25px;' href='https://catalogodatos.gub.uy/dataset/fondo-nacional-de-recursos-solicitudes-de-tramites-autorizados/resource/dd3046c9-06eb-490e-be95-ba58feb25b5e?filters=IMAE%2FCL%C3%ADnica%2FCentro%3A"+d.groupName.normalize("NFD").replace(/[\u0300-\u036f]/g, "").toUpperCase()+"'>(" + d.count  + " actos médicos)</a>";})
   .attr("font-size", "15px")

 svg.selectAll(".graph-values")
   .data(data)
   .enter()
   .append("text")
   .attr("class", function(d, i) {return "graph-values " + d.groupName;})
   .attr("x", function(d, i) {return dx*d.averageTime - 160 } )
   .attr("y", function(d, i) {return dy*i + (5*i) + 30;})
   .html( function(d) {return "Promedio: " + d.averageTime  + " días";})
   .attr("font-size", "14px")
   //.style("font-weight", "bold")
   .attr("width", 60);

var
  container_id = "graph-stats"
  width = $("#"+container_id).innerWidth()*0.79,
  height = 600;//$("#"+container_id).innerHeight(),
  radius = Math.min(width, height) / 2;

var arc = d3.svg.arc()
    .outerRadius(radius - 10)
    .innerRadius(0);

var pie = d3.layout.pie()
    .sort(null)
    .value(function(d) { return d.qtty; });

var svg = d3.select("#"+container_id).append("svg")
    .attr("width", width)
    .attr("height", height)
  .append("g")
    .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");
console.log('STATS');
console.log(data_by);
var total = 0;
$.each(data_by, function(i, item) {
  $("#list").append('<li style="cursor: pointer;"><span >'+item.groupname+'</span><div class="square" style="background-color: '+getRandomColor(item.key)+';"></div></li>');
	total += item.qtty;
});
$('#stats-total').text("Total: "+total);
var g = svg.selectAll(".arc")
    .data(pie(data_by))
  .enter().append("g")
    .attr("class", "arc");

g.append("path")
    .attr("d", arc)
    .style("fill", function(d) {
      return getRandomColor(d.data.key); })
    .style('cursor', 'pointer')
    .on("mouseover", function(d){tooltip.html("<b>"+d.data.groupname + "</b><br/>" + d.data.qtty); return tooltip.style("visibility", "visible");})
    .on("mousemove", function(){return tooltip.style("top", (d3.event.pageY-10)+"px").style("left",(d3.event.pageX+10)+"px");})
    .on("mouseout", function(){return tooltip.style("visibility", "hidden");})
    .on('click', function(d){
        tooltip.style("visibility", "hidden");
        setCategoryGroupFilter(d.data.groupname);
     });

g.append("text")
    .attr("transform", function(d) { return "translate(" + arc.centroid(d) + ")"; })
    .attr("dy", ".35em")
    .style("display","none")
    .text(function(d) { return d.data.groupname; });
