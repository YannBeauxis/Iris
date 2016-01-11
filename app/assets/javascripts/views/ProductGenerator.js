App.Views.ProductGenerator = Backbone.View.extend({
  
  //template: JST['product_generator.jst.ejs'],
  
  initialize: function() {

  // Create collections

    this.ingredientTypes = new App.Collections.IngredientTypes(); 
    this.ingredients = new App.Collections.Ingredients(); 
    this.variants = new App.Collections.Variants(); 
    this.products = new App.Collections.Products({
      url: '/recipes/' + App.productGeneratorRaw.recipeId + '/products'
    }); 

  // Variants

    var variantSelectEl = this.$el.find('#product_variant_id');
    this.variantSelect= new App.Views.PGVariantSelect({el: variantSelectEl, collection: this.variants});
    //select the base variant
    this.variantSelect.focusBase();

    //Create Table view with ingredient types as collection
    var tableEl = this.$el.find('.table-quantities');
    this.quantitiesTable= 
      new App.Views.PGQuantitiesTable({
        el: tableEl, 
        collection: this.ingredientTypes,
        options: {
          ingredients: this.ingredients,
          appView: this
        }
      });

    //Products
    tableEl = this.$el.find('.table-products');
    this.productsTable= 
      new App.Views.PGProductsTable({
        el: tableEl, 
        collection: this.products
      });

    //populate collections
    this.ingredientTypes.add(App.productGeneratorRaw.ingredientTypes);
    this.ingredients.add(App.productGeneratorRaw.ingredients);
    this.variants.add(App.productGeneratorRaw.variants);
    this.products.fetch();
    
  //default parameters
    this.volume = 10;
    this.$el.find('#product_volume').val(this.volume);
    
    this.compute();
    
  },

  events: {
    "change #product_variant_id":  "compute",
    //"keydown #product_volume":  "isNumberKey",
    "keyup #product_volume":  "changeVolume",
    "click #modify_variant":  "modifyVariant",
    "click #create_product":  "createProduct"
  },

  compute: function() {
    var variant_id = this.variantSelect.$el.val();
    var volume = this.volume;
    this.trigger('compute', {variant_id: variant_id, volume: volume} );
  },

  changeVolume: function(e) {
    var value = e.target.value;
    if (value != this.volume) {
      this.volume = parseInt(value);
      this.compute();
    }
  },

  isNumberKey: function(evt) {
      var charCode = (evt.which) ? evt.which : event.keyCode;
      console.log(charCode);
      if (charCode > 31 && (charCode < 48 || charCode > 57 || charCode == 54)) { 
        return false; 
      }
      return true;
  },

  modifyVariant: function() {
    var variant_id = this.variantSelect.$el.val();
    var url = '/recipes/' + App.productGeneratorRaw.recipeId + '/variants/' + variant_id + '/edit';
    window.location = url;
  },

  createProduct: function() {
    this.$el.find('#ProductInfo').slideToggle();
  },

  render: function() {
    
    //this.$el.html(this.template(this.model.toJSON()));

    return this;
  },
  
  
});