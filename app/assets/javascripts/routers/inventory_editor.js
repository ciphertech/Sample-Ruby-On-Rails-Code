CipherTech.Routers.InventoryEditor = (function () {

  var instanceProperties = {

    routes: {
      '' : 'home'
    },

    initialize: function(options) {
      CipherTech.inventory = new CipherTech.Models.Inventory(options.inventory);
    },

    home: function() {
      var view;

      // new inventory item form
      var inventoryItem = new CipherTech.Models.InventoryItem({
        inventory_id: CipherTech.inventory_id
      });
      view = new CipherTech.Views.InventoryItemNew({
        inventoryItem: inventoryItem,
        inventoryItems: CipherTech.inventory.inventoryItems
      });
      view.render();

      // inventory item locations navigation
      var locations = new CipherTech.Collections.Locations(CipherTech.locations);
      locations.add(new CipherTech.Models.Location({id: 'all', name: CipherTech.Collections.Locations.label.all, first: true, special: true}));
      locations.add(new CipherTech.Models.Location({id: null, name: CipherTech.Collections.Locations.label.none, special: true}));
      _.each(CipherTech.locations, function(params){
        var location = new CipherTech.Models.Location(params);
        locations.add(location);
      });
      view = new CipherTech.Views.InventoryItemLocations({
        locations: locations,
        inventoryItems: CipherTech.inventory.inventoryItems
      });
      locations.setFirstActive();
      view.render();

      // inventory item headers
      view = new CipherTech.Views.InventoryItemHeadersShow({
      });
      view.render();

      // inventory item forms
      view = new CipherTech.Views.InventoryItems({
        inventory: CipherTech.inventory
      });
      view.render();

    }

  };

  return Backbone.Router.extend(instanceProperties);

}());

