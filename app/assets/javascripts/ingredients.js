/*
$(document).ready ->
    $.ajax({
      type: "GET",
      url: "/ingredients/get_table",
      dataType: "json"
      success:(data) ->
        t = display_table(data, "TableContent", "stock")      
        return true
      error:(data) ->
        return false
    })
*/
   
//$(document).ready(function() {

var ready = function() {
      $.ajax({
       url : '/ingredients/get_table',
       type : 'GET',
       dataType: "json",
       success : function(data) {
         display_table(data, "TableContent", "stock");
       },
       error : function(data) {
         var div_target = document.getElementById("TableContent");
         div_target.innerText = "Raté";
       }
    });
};  

$(document).ready(ready);
$(document).on('page:load', ready);
