App.Views.ProductGenerator = Backbone.View.extend({
  
  //template: JST['product_generator.jst.ejs'],
  
  initialize: function() {

  // Create collections
    this.variants = new App.Collections.Variants(); 
    this.products = new App.Collections.Products({
      url: '/recipes/' + App.productGeneratorRaw.recipeId + '/products'
    }); 

  // Variants
    var variantSelectEl = this.$el.find('#product__variant');
    this.variantSelect= new App.Views.PGVariantSelect({el: variantSelectEl, collection: this.variants});

    //Create Table view with ingredient types as collection
    var tableEl = this.$el.find('.table-quantities');
    this.quantitiesTable= 
      new App.Views.PGQuantitiesTable({
        el: tableEl, 
        //collection: this.ingredientTypes,
        options: {
          ingredients: this.ingredients,
          appView: this
        }
      });

    this.listenTo(this.quantitiesTable, 'changeCost', this.changeCost);

    //Products
    this.productMode = 'new';
    tableEl = this.$el.find('#table-products');
    this.productsTable= 
      new App.Views.PGProductsTable({
        el: tableEl, 
        collection: this.products
      });
    this.listenTo(this.productsTable, 'displayProduct', this.displayProduct);

    //populate collections
    this.variants.add(App.productGeneratorRaw.variants);
    this.variantSelect.focusBase();
    this.products.fetch();

    //default parameters
    this.volume = 10;
    this.$el.find('#product__volume').val(this.volume);
    this.$el.find('#product__number-produced').val(1);
    //initiate date pickers
    var today = new Date();
    $('#production-date').datetimepicker({format: 'DD/MM/YYYY', defaultDate: today});
    $('#expiration-date').datetimepicker({format: 'DD/MM/YYYY'});

    this.changeVariant();
    this.compute();

    this.quantitiesTable.quantitySelectors.add([
      {quantityType: 'proportion', label: 'Proportions', selected: false},
      {quantityType: 'volume', label: 'Volume', selected: true},
      {quantityType: 'mass', label: 'Masse', selected: false},
      {quantityType: 'quantity', label: 'Quantités', selected: false},
      {quantityType: 'cost', label: 'Coûts', selected: false},
      {quantityType: 'stock', label: 'Stock', selected: false}
    ]);
    
  },

  events: {
    "change #product__variant":  "changeVariant",
    //"keydown #product__volume":  "isNumberKey",
    "keyup #product__volume":  "changeVolume",
    "change #product__volume":  "changeVolume",
    "click #modify-variant":  "modifyVariantParams",
    "click #change-ingredients":  "changeIngredients",
    "click #change-proportions":  "changeProportions",
    "click #btn--product--details":  "productDetails",
    "click #btn--product--new--initiate":  "productNewInitate",
    "click #btn--product--new--save":  "productSave"
  },

  changeVariant: function() {

    this.variantSelectedId = this.variantSelect.$el.val();
    this.quantitiesTable.ingredientTypes.reset();
    var variant = this.variants
        .findWhere({
          id: parseInt(this.variantSelectedId)
        }).toJSON();
    this.quantitiesTable.ingredientTypes.add(
      variant.ingredientTypes
    );
    this.compute();
    this.quantitiesTable.updateAllDisplayQuantityType();
  },

  compute: function() {
    this.trigger('compute', {VariantId: this.variantSelectedId, volume: this.volume});
  },
  
  changeVolume: function(e) {
    var value = e.target.value;
    if (value != this.volume) {
      this.volume = parseInt(value);
      this.compute();
    }
  },

  changeCost: function(cost) {
    this.$el.find('#product__cost__group').toggle(cost != null);
    if (cost != null) {
      cost = Math.round(cost*100)/100;
    }
    this.$el.find('#product__cost__input').val(cost);
  },
  
  isNumberKey: function(evt) {
      var charCode = (evt.which) ? evt.which : event.keyCode;
      console.log(charCode);
      if (charCode > 31 && (charCode < 48 || charCode > 57 || charCode == 54)) { 
        return false; 
      }
      return true;
  },

  modifyVariantParams: function() {
    var variant_id = this.variantSelect.$el.val();
    var url = '/recipes/' + App.productGeneratorRaw.recipeId + '/variants/' + variant_id + '/edit';
    window.location = url;
  },
  
  changeIngredients: function() {
    var variant_id = this.variantSelect.$el.val();
    var url = '/recipes/' + App.productGeneratorRaw.recipeId + '/variants/' + variant_id + '/change_ingredients_edit';
    window.location = url;
  },
  
  changeProportions: function() {
    var variant_id = this.variantSelect.$el.val();
    var url = '/recipes/' + App.productGeneratorRaw.recipeId + '/variants/' + variant_id + '/change_proportions_edit';
    window.location = url;
  },


  productDetails: function() {
    this.$el.find('#product__details').slideToggle();
    if (this.productMode == 'new') {this.$el.find('#btn--product--new--save').toggle();}
    var btnDetail = this.$el.find('#btn--product--details');
    switch (btnDetail.text()) {
      case "Créer produit":
        btnDetail.text('Annuler');
        break;
      case "Annuler":
        btnDetail.text('Créer produit');
        break;
    }
    this.$el.find('#btn--product--details').blur();
  },

  displayProduct: function(model) {

    this.productMode = 'display';
    this.currentProduct = model;
    
    // set the value
    this.volume = model.get('volume')/100;
    this.$el.find('#product__volume').val(this.volume);
    this.$el.find('#product__volume').attr('disabled','');
    this.$el.find('#product__variant').val(model.get('variant_id'));
    this.$el.find('#product__variant').attr('disabled','');
    this.$el.find('#product__container').val(model.get('container'));
    this.$el.find('#product__description').val(model.get('description'));
    this.$el.find('#production-date__input').val(App.convertDate(model.get('production_date')));
    this.$el.find('#production-date__input').attr('disabled','');
    this.$el.find('#expiration-date__input').val(App.convertDate(model.get('expiration_date')));

    this.compute();
    
    // toggle the buttons
    this.$el.find('#btn--product--new--initiate').show();
    this.$el.find('#btn--product--details').hide();
    this.$el.find('#btn--product--new--save').show();  
    this.$el.find('#btn--product--new--save').text('Enregistrer modifications');  
    
    // display details
    this.$el.find('#product__details').slideDown();
    
    // scroll to product info
        $('html, body').animate({
      scrollTop:this.$el.offset().top - 8
      }, 'slow');
      
  },

  productNewInitate: function(model) {
    
    this.productMode = 'new';
    this.$el.find('#product__volume').removeAttr('disabled');
    this.$el.find('#product__variant').removeAttr('disabled','');
    this.$el.find('#production-date__input').removeAttr('disabled','');
    this.$el.find('#btn--product--details').text('Annuler').show();
    this.$el.find('#btn--product--new--initiate').hide();
    this.$el.find('#btn--product--new--save').text('Enregistrer nouveau produit');  
    this.$el.find('.product--save--alert')
            .text('').slideUp();
    
  },

  productSave: function() {
    if (this.productMode == 'display') {
      var expDate = this.$el.find('#expiration-date__input').val();
      (expDate != '') ? expDate = App.invertDate(expDate) : expDate = null;
      var params = {
        container: this.$el.find('#product__container').val(),
        description: this.$el.find('#product__description').val(),
        expiration_date: expDate
      };
      var self = this;
      this.currentProduct.save(params, {
        success: function() {
          $('.product--save--alert')
              .text('Produit enregistré avec succès')
              .addClass('alert-success').slideDown();
            self.displayProduct(self.currentProduct);
        }, 
        error: function() {
          $('.product--save--alert')
            .text('Erreur dans l\'enregisterement du produit')
            .addClass('alert-danger').slideDown();
        }
      });
      this.$el.find('#btn--product--new--save').blur();
    } else if (this.productMode == 'new') {
      var prodDate = this.$el.find('#production-date__input').val();
      (prodDate != '') ? prodDate = App.invertDate(prodDate) : prodDate = null;
      var expDate = this.$el.find('#expiration-date__input').val();
      (expDate != '') ? expDate = App.invertDate(expDate) : expDate = null;
      var params = {
        variant_id: parseInt(this.$el.find('#product__variant').val()),
        variant: {name: this.$el.find('#product__variant option:selected').text()},
        volume: this.$el.find('#product__volume').val()*100,
        container: this.$el.find('#product__container').val(),
        description: this.$el.find('#product__description').val(),
        production_date: prodDate,
        expiration_date: expDate
      };
      var self = this;
      this.currentProduct = this.products.create(params, {
        success: function() {
          $('.product--save--alert')
            .text('Produit enregistré avec succès')
            .addClass('alert-success').slideDown();
          self.displayProduct(self.currentProduct);
        }, 
        error: function(err) {
          $('.product--save--alert')
            .text('Erreur dans l\'enregisterement du produit')
            .addClass('alert-danger').slideDown();
            console.log(err);
            App.test = false;
        }
      });
    }
  },

  render: function() {
    return this;
  },
  
});