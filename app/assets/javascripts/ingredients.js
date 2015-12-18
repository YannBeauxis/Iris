 //$(document).ready(function() {

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

var backbone_display = function() {
  
  //var app = new IngredientTypeRouter();
  //Backbone.history.start();
  
  App.ingredient_type_list = new App.Collections.IngredientTypeList();
  App.index_ingredient_type = new App.Views.IndexIngredientView({collection: App.ingredient_type_list});
  
  //App.itl = new App.Collections.IngredientTypeList();
  //App.itl.fetch({
    //success: function() {alert(App.itl.length);}
  //});
  //alert(App.itl.length);
};
