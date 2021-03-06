App.Views.PGVariantSelect = Backbone.View.extend({
  
    initialize: function() {

    this.optionTemplate = JST['pg_variant_selector_option'];
    
    this.listenTo(this.collection, 'add', this.addVariant);
    this.listenTo(this.collection, 'reset', this.removeVariant);

  },
  
  addVariant: function(variant) {
    this.listenTo(variant,'displaySelect',this.displaySelect);
    if (!variant.get('archived')) {this.displaySelect(variant);}
    //this.$el.append(this.optionTemplate(v));
    //check if variant base and store information
    if (variant.get('base')) { this.base = variant.id; }
  },
  
  removeVariant: function(variant) {
    // ??? not should remove all variant, to be checked
    this.$el.empty();
  },
  
  displaySelect: function(variant) {
    this.$el.append(this.optionTemplate(variant));
  },
  
  //to select base or variant if param
  focusVariant: function() {

    var variant_id = App.getParameterByName('variant_id');
    if (variant_id != null && variant_id != "") {
      this.$el.val(parseInt(variant_id));
    }
    else if (this.base) {
      this.$el.val(this.base);
      }
  }
  
});