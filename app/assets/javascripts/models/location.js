CipherTech.Models.Location = (function () {

  var instanceProperties = {

    defaults: {
      active: false,
      first: false
    },

    urlRoot: function(){
      return '/manager/locations/';// + this.get('inventory_id') + '/inventory_items';
    },

    initialize: function () {
    },
    
  };

  return Backbone.Model.extend(instanceProperties);

}());

