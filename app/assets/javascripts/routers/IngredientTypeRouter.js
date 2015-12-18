var IngredientTypeRouter = Backbone.Router.extend({

  routes: {
    "index": "index",
    "show": "show"
  },

  initialize: function () {
    this.ingredientTypeList = new App.Collections.IngredientTypeList();
    //this.indexIngredientView = new IndexIngredientView({
    //    collection : this.ingredientTypeList
    //});
    this.ingredientTypeList.fetch({reset: true}); // fetch collection from server
    alert(this.ingredientTypeList.length);
  }

});