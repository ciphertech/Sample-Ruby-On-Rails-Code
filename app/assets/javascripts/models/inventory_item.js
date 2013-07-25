CipherTech.Models.InventoryItem = (function () {

  var instanceProperties = {

    urlRoot: function(){
      return '/manager/inventories/' + this.get('inventory_id') + '/inventory_items';
    },

    initialize: function () {
      this.on('change:quantity', this.calculateToTalPrice, this);
      this.on('change:price', this.calculateToTalPrice, this);
      
      if(!this.has('location') && this.has('location_id')) {
        var locations = new CipherTech.Collections.Locations(CipherTech.locations);
        var location = locations.get(this.get("location_id"));
        this.set({ location: { name: location.get("name") } });
      }
    },

    calculateToTalPrice: function(){
      var quantity, price, latestPrice, totalPrice;

      quantity = parseFloat(accounting.toFixed(this.get('quantity'), 2));
      price = parseFloat(accounting.toFixed(this.get('price'), 2));
      latestPrice = parseFloat(accounting.toFixed(this.get('latest_price'), 2));
      if (price == 0) {
        totalPrice = (quantity * latestPrice);
      } else { 
        totalPrice = (quantity * price);
      }

      this.set('total_price', accounting.formatMoney(totalPrice));
    },

  };

  return Backbone.Model.extend(instanceProperties);

}());
