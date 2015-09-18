// *****************************************
// CREATE RATINGS
// *****************************************
var data ={};
data.items = [];

$(document).ready(function() {
	$("#rateNowButton").click(function(event){
	  if ($(this).hasClass('disabled')) {
	  	alert('You must log in to rate stuff.')
	    return;
	  } 
		event.preventDefault();
	$("#rateNowButton").addClass('disabled');

  $('.draggable').each(function() {
	  name = $(this).attr('name');
	  id = $(this).attr('id');

	  containerHeight = ($(this).parent().parent().height() * 0.78 );
	  containerWidth = ($(this).parent().parent().width() * 0.895962732919255);
	  positionFromLeft = ($(this).position().left);
	  positionFromTop = ($(this).position().top);

	  x_rating = (Math.round((positionFromLeft / containerWidth) * 100 )/ 100);
	  y_rating = (Math.round((1-(positionFromTop / containerHeight))* 100 )/ 100);

  	data.items.push({"name": name, "id": id, "x_rating":x_rating, "y_rating":y_rating});
		});
 
	 $.ajax({ 
	  data: JSON.stringify(data),
	  type: "POST",
	  url: "/ratings",
	  contentType: "application/json",
	  success: function(res) {
	  	// console.log('success');
	  	location.reload(); 
	  	// console.log(res);
	  },
	  error: function(res) {
	  	console.log('error');
	  },
	  dataType:'json'});

	  $("#rateNowButton").removeClass('disabled');

	});
});