var CipherTech = {

  // event aggregator
  // location:change {id: x}
  e: _.extend({}, Backbone.Events),

  Models: {},
  Collections: {},
  Views: {},
  Routers: {},

  initInventoryEditor: function(options){
    options = options || {};
    new CipherTech.Routers.InventoryEditor(options);
    Backbone.history.start()
  }

};
