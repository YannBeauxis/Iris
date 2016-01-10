App.Views.PGProduct = Backbone.View.extend({
  
  tagName: 'tr',
  
  //url: '/ingredients',
  
  template: JST['pg_product'],

  render: function () {
    this.$el.html(this.template(this.model));
    return this;
  }

});