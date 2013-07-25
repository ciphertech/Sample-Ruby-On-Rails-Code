var vendorAjaxHelper = ( function () {

  var vendor_url,
      button_id,
      container_id,
      base_vendor_id,
      token;

  bind_button_click = function(){
    $(button_id).on("click", function(e){
      var id = $("#vendor_id").val()
      e.preventDefault();
      if (id) {
        $.ajax({
          url: vendor_url + id,
          success: function( data ){
            display_data(data);
          }
        }); 
      }
    });
  };

  display_data = function( data ) {
    $(container_id).html( build_element( data ) );
  };

  build_element = function( data ) {
    var element = '<h4>' + data.name + '</h4>';
    element += '<form action="/admin/vendors/' + base_vendor_id + '/merge" method="post">';
    element += '<input name="authenticity_token" type="hidden" value="' + token +'">'
    element += '<input id="vendor_id" name="vendor_id" type="hidden" value="' + data.id + '">';
    element += '<p><div>' + data.address + '</div>';
    element += '<div>' + data.city + ', ' + data.state + ', ' + data.zip + '</div>';
    element += '<div>' + data.country + '</div>';
    element += '<div>Phone: ' + data.phone + '</div>';
    element += '<div>Globally Approved: ' + ( data.globally_approved ? 'Yes' : 'No' )+ '</div></p>';
    element += '<p><strong>Clicking Merge and Remove will merge all the data and delete the vendor: <br/>"' + data.name + '."</strong></p>';
    element += '<p>';
    element += '<input class="btn btn-danger" name="commit" type="submit" value="Merge and Remove"> ';
    element += '<a href="/admin/vendors/' + data.id + '/vendor_inventory" class="btn" target="_blank">View Inventory</a>';
    element += '</p>';
    element +=  '</form>'
    return $(element);
  };

  return { 

    setup: function(options) {
      vendor_url = options.url;
      button_id = options.button_id;
      container_id = options.container_id;
      base_vendor_id = options.base_vendor_id;
      token = options.token;
      bind_button_click();
    }

  };

})();