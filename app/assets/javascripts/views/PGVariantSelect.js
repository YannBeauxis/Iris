App.Views.PGVariantSelect = Backbone.View.extend({
  
    initialize: function() {

    this.optionTemplate = JST['pg_variant_selector_option'];
    
    this.listenTo(this.collection, 'add', this.addVariant);


  },
  
  addVariant: function(variant) {
    this.listenTo(variant,'displaySelect',this.displaySelect);
    if (!variant.get('archived')) {this.displaySelect(variant);}
    //this.$el.append(this.optionTemplate(v));
    //check if variant base and store information
    if (variant.get('base')) { this.base = variant.id; }
  },
  
  displaySelect: function(variant) {
    this.$el.append(this.optionTemplate(variant));
  },
  
  //to select base variant
  focusBase: function() {
    if (this.base) {
      this.$el.val(this.base);
      }
  }
  
});