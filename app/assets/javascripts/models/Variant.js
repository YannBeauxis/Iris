App.Models.Variant = Backbone.Model.extend({

  nameSelector : function(){
    display = this.get('name');
    if (this.get('archived')) {display = display + ' archivée';}
    return display;
  }

});