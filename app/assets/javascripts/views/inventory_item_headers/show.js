CipherTech.Views.InventoryItemHeadersShow = (function () {

  var instanceProperties = {

    el: '#inventory_item_headers',

    events: {
      //'click': 'changeLocation'
      'click [data-role="show-copy-room-data"]': 'showInventoryItems',
      'click [data-role="save-copy-room-data"]': 'copyInventoryItems',
      'click [data-role="check_copy_onventory_data"]': 'checkInventoryItems',
      'click [data-role="uncheck_copy_onventory_data"]': 'uncheckInventoryItems',
      'click [data-role="check-location-id"]': 'checkLocationId',
    },

    initialize: function(){
      //this.locations = this.options.locations;
      //this.inventoryItems = this.options.inventoryItems;
      this.inventoryItemList = [];
      //this.inventoryItems.on('add', this.updateCounts, this);
      //this.inventoryItems.on('remove', this.updateCounts, this);
      return this;
    },

    


    copyInventoryItems: function(e){
      e.preventDefault();
      var self = this;
      var itemList = [];
      var LocationID = "";
      var location = $(this.el).find('.select-location-id option:selected');

      var inventoryItems = jQuery(".copy-checkbox-item:checked");
      if (inventoryItems.length < 1){
        bootbox.alert("Sorry, we couldn't copy items. <br/> Reason: Items are not selected" );
      } else {
          $.each(inventoryItems, function(index, item){
            itemList.push(item.id);
        });
       
      if (location.val() == 0 ){
        var newRoom = $(this.el).find('input#new-room-name').val();
        var roomObj = new CipherTech.Models.Location({name: newRoom, itemList: itemList});
      } else {
        var roomObj = new CipherTech.Models.Location({id: location.val(),name: location.text(), itemList: itemList});
      }
      if (location.text() != "Select a Room"){
          roomObj.save({}, {
            success: function(model, attrs){
              $('.save-room-link').toggleClass('btn-alt', false);
              window.location.reload(true);
            },
            error: function(xhr, status, error){
              bootbox.alert("Sorry, we couldn't save this data. <br/> Reason: " + status.responseText);
            }
          });
        } else {
        bootbox.alert("Sorry, we couldn't save this item. <br/> Reason: Name must be selected/entered.");
      }
    }
    },

    checkLocationId:function(e){
      var location = $(this.el).find('.select-location-id option:selected');
      if (location.val() == 0 && location.text() != "Select a Room"){
        $('.copy-location-id').show('fast');
      } else{
        $('.copy-location-id').hide('fast');
      }
    },

    showInventoryItems: function(e){
      e.preventDefault();
      $("#inventory_item_locations button.active").trigger('click');
      $('.copy-item').show('fast');
      $('.copy-room-link').hide('fast');
      $('.save-room-link').show('fast');
      $('.select-location-id').show('fast');
      $('.copy-room-items').show('fast');
      $('.normal-item').hide('fast');
      $(".check-btn").hide();
      $(".uncheck-btn").show();
    },

    checkInventoryItems: function(e){
      e.preventDefault();
      $('.copy-checkbox-item').attr('checked',true);
      $(".check-btn").hide();
      $(".uncheck-btn").show();
    },

    uncheckInventoryItems: function(e){
      e.preventDefault();
      $('.copy-checkbox-item').attr('checked',false);
      $(".uncheck-btn").hide();
      $(".check-btn").show();
    },

    render: function(){
      var html = this.template(this.templateData());
      this.$el.html(html);

      this.$el.closest('input').find('[name=toggle_sort]').on('click', function(e){
        var $target = $(e.target);
        if ($target.is(":checked")) {
          $('#inventory_items .inventory-item .last').hide('fast');
        } else {
          $('#inventory_items .inventory-item .last').show('fast');
        };
      });

      return this;
    },

    templateData: function(){
      return {};
    },

    template: function(context){
      return HandlebarsTemplates['inventory_item_headers/show'](context);
    }

  };

  return Backbone.View.extend(instanceProperties);

}());