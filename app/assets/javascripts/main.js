//$.ajax({
//    //url: "/na/CHATSPAMKAPPA123", // Route to the Script Controller method
//    url: "/na/baseballlover723", // Route to the Script Controller method
//    type: "GET",
//    dataType: "json",
//    complete: function() {},
//    success: function(data, textStatus, xhr) {
//        // Do something with the response here
//        console.log(data);
//    },
//    error: function() {
//        alert("Ajax error!")
//    }
//});
$(document).ready(function () {
    $("#username-input").keypress(function (eventData) {
            if (eventData.keyCode === 13) {
                mainSubmit();
            }
        }
    );
    $("#region-input").keypress(function (eventData) {
            if (eventData.keyCode === 13) {
                mainSubmit();
            }
            eventData.preventDefault();
        }
    );
    $("#enter-button").click(mainSubmit);

});

function mainSubmit() {
    console.log("hit enter");
    linkPath = gon.basePath;
    linkPath += $("#region-input").val();
    linkPath += "/";
    linkPath += $("#username-input").val();
    console.log(linkPath);
    window.location.href = linkPath;

}


