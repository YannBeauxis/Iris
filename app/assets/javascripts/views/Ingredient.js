App.Views.Ingredient= Backbone.View.extend({
  
  tagName: 'tr',
  //className: 'hide',
  
  template: JST['ingredient_row'],

  initialize: function() {
    
    this.parent_id =  this.model.get('ingredient_type_id');
    this.parent_el = $('#ingredient-type-' + this.parent_id);
  },

  href: function (){
    //this.set('href', this.url + '/' + this.get('id'));
    return this.model.url + '/' + this.model.get('id');
  },

  displayStock: function(){
    return this.model.get('stock');
  },

  render: function() {
      this.$el.html(this.template(this));//.toJSON()
      return this;
  },
  
});