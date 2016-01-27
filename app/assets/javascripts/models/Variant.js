App.Models.Variant = Backbone.Model.extend({

  nameSelector : function(){
    display = this.get('name');
    if (!this.get('base')) {display = 'Variante ' + display;}
    if (this.get('archived')) {display = display + ' archivée';}
    return display;
  }

});