App.Views.PGProduct = Backbone.View.extend({
  
  tagName: 'tr',
  
  template: JST['pg_product'],

  render: function () {
    console.log(this.model.toJSON());
    this.$el.html(this.template(this.model.toJSON()));
    return this;
  }

});