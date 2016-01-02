App.Views.PGVariantSelect = Backbone.View.extend({
  
    initialize: function() {

    this.optionTemplate = JST['pg_variant_selector_option'];
    
    this.listenTo(this.collection, 'add', this.addVariant);


  },
  
  addVariant: function(v) {
    this.$el.append(this.optionTemplate(v));
    //check if variant base and store information
    if (v.get('selected')) { this.base = v.id; }
  },
  
  //to select base variant
  focusBase: function() {
    if (this.base) {this.$el.val(this.base);}
  }
  
});