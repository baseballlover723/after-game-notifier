// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$.ajax({
    url: "/na/base", // Route to the Script Controller method
    type: "GET",
    dataType: "json",
    complete: function() {},
    success: function(data, textStatus, xhr) {
        // Do something with the response here
        console.log(data);
    },
    error: function() {
        alert("Ajax error!")
    }
});

