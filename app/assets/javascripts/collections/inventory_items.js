CipherTech.Collections.InventoryItems = (function () {

  var instanceProperties = {

    model: CipherTech.Models.InventoryItem,

    initialize: function(){
      this.on('remove', this.repositionInventoryItemsForLocation, this);
    },

    repositionInventoryItemsForLocation: function(model, collection){
      var inventoryItems,
          deletedLocationID = model.get('location_id'),
          deletedRoomPosition = model.get('room_position');

      inventoryItems = collection.filter(function(record){
        var locationID, roomPosition;

        locationID = record.get('location_id');
        roomPosition = record.get('room_position');

        return (locationID === deletedLocationID && roomPosition > deletedRoomPosition);
      });

      _(inventoryItems).each(function(record){
        var position = record.get('room_position');
        record.set('room_position', position - 1);
      });

      this.sort();
    },

    selectedStrategy: "created_at",

    comparator: function (inventoryItem) {
      return this.strategies[this.selectedStrategy](inventoryItem);
    },

    strategies: {
      created_at: function (inventoryItem) {
        return parseFloat(inventoryItem.get('created_at_epoch')) * -1 || 0; 
      },

      room_position: function (inventoryItem) {
        return parseInt(inventoryItem.get('room_position'), 10) || 0; 
      }
    },

    changeSort: function (strategy) {
      this.selectedStrategy = strategy;
      this.sort();
    },

    filterByLocation: function(id){
      var results = this.filter(function(inventoryItem) {
        if (id === 'all') {
          return true;
        } else if (id === null) {
          return inventoryItem.get('location_id') == null;
        } else {
          return inventoryItem.get('location_id') == id;
        };
      });

      return _(results);
    }

  };

  return Backbone.Collection.extend(instanceProperties);

}());
