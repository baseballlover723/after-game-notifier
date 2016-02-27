$.ajax({
    //url: "/na/CHATSPAMKAPPA123", // Route to the Script Controller method
    url: "/na/baseballlover723", // Route to the Script Controller method
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

