$(document).ready(function() {  
  
  $('#new-inventory-item-submit').bind('click', function() {
    var params = {};
    var url = $("#vendor_inventory").attr("data-url");
    if(selectedProduct == null) {
      params.product = {"name": $('#new-inventory-item').val()};
    } else {
      params.product = selectedProduct;
    }
    $("#copy-vendor-inventory").remove();
    $.post(url, params, function(data){
      var id = data.id;
    	$('#inventory-items').prepend(data.html);

      bind_editable();
      $('#item_' + id).find(".inventory_edit_trigger").click();
    });

    if($('#new-inventory-item').val() != "") {
      $('#new-inventory-item').val("");
      selectedProduct = null;
    }
    return false
  });

  bind_editable();

  $(".cancel").live("click", function(e){
    e.preventDefault();
    $(this).closest("tr").html(cached_row);
    cached_row = null;
    row_being_edited = null;
    bind_editable();
  });

  $("#copy-vendor-inventory #vendor").select2({
    placeholder: "Select a Vendor",
    allowClear: true,
    minimumInputLength: 2
  });

});

$(window).keypress(function(event) {
    if (!(event.which == 115 && event.ctrlKey) && !(event.which == 19)) return true;
    $("#edit_row_submit").click();
    return false;
});

var cached_row;
var row_being_edited;

function initialize_form(row){
  //console.time('cache');
  var data = row.children(".name").attr("data");
  data = data.split("|")
  
  $("#edit_row_form #item_name").html(data[1]);
  
  row.html($("#edit_row_form").html());

  $("#category").val(data[2]);
  $("#unit").val(data[3]);
  $("#price").val(data[4]);
  $("#item_id").val(data[0]);
  bind_save_row();
  //console.timeEnd('cache');
}

function bind_save_row(){
  $("#edit_row_submit").on("click", function(){
    //console.time('cache');
    var url         = '/admin/vendors/' + vendor_id() + '/vendor_inventory/update_attribute.js';
    var params      = {};
    params.id       = $("#item_id").val();
    params.unit     = $("#unit").val();
    params.category = $("#category").val();
    params.price    = $("#price").val();
    $.ajax({
      type: 'POST',
      url: url,
      data: params,
      success: function(data){ 
        var id = data.id;
        var row = $("#edit_row_submit").closest("tr");
        row.html(data.html); 
        row.attr("id", "item_" + id);
        cached_row = null;
        row_being_edited = null;
        bind_editable();
      },
      dataType: "json"
    });
    //console.timeEnd('cache');
  });
}

function item_units(){
  if (typeof units_for_editor != 'undefined'){
    return units_for_editor;
  }else{
    return [];
  }
}

function item_categories(){
 if (typeof categories_for_editor != 'undefined'){
    return categories_for_editor;
  }else{
    return [];
  }
}

function bind_row_editor(){
  $(".inventory_edit_trigger").bind("click", function(e){
    //console.time('cache');
    e.preventDefault();
    var id = $(this).attr("data-id");
    var row = $("#item_" + id);
    //console.log(id);
    if(cached_row != null && row_being_edited != null) {
      row_being_edited.html(cached_row);
      bind_editable();
    }

    cached_row = row.html();
    row_being_edited = row;

    initialize_form(row);
    //console.timeEnd('cache');
  });
}

function bind_editable() {
  bind_price_editor();
  bind_unit_editor();
  bind_category_editor();
  bind_row_editor();
}

function bind_price_editor() {
  $('.edit-price').editable('/admin/vendors/' + vendor_id() + '/vendor_inventory/update_attribute', {
    name   : "price",
    cssclass : 'form-inline',
    indicator : '<img src="/images/ajax-loader.gif">',
    tooltip   : 'Click to edit...'
  });
}

function bind_unit_editor() {
  $('.edit-unit').editable('/admin/vendors/' + vendor_id() + '/vendor_inventory/update_attribute', {
    name   : "unit",
    data   : item_units(),
    type   : 'select',
    cssclass : 'form-inline',
    onblur : 'submit',
    indicator : '<img src="/images/ajax-loader.gif">',
    tooltip   : 'Click to edit...'
  });
}

function bind_category_editor() {
  $('.edit-category').editable('/admin/vendors/' + vendor_id() + '/vendor_inventory/update_attribute', {
    name   : "category",
    data   : item_categories(),
    type   : 'select',
    cssclass : 'form-inline',
    onblur : 'submit',
    indicator : '<img src="/images/ajax-loader.gif">',
    tooltip   : 'Click to edit...'
  });
}

function vendor_id(){
  return url = $("#vendor_inventory").attr("data-id");
}