App.Models.Variant = Backbone.Model.extend({

  nameSelector: function() {
    display = this.get('name');
    if (!this.get('base') && this.get('name')!='Base') {display = 'Variante ' + display;}
    if (this.get('archived')) {display = display + ' ancienne';}
    return display;
  }

});