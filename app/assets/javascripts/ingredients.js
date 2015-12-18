 //$(document).ready(function() {

var backbone_display = function() {
 
  App.ingredientsApp = new App.Views.Ingredients();
  
};


var ready = function() {
  //alert('C est parti !');
  old_display();
  backbone_display();
};
  
var old_display = function() {
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
