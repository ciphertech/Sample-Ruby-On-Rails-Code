//function parseAttributes(block){
  //return _.map(_.keys(block.hash), function(key) {
    //return key + '="' + block.hash[key] + '"';
  //}).join(' ');	
//}

//Handlebars.registerHelper("link_to", function(url, block) {
	//var attrs = parseAttributes(block);
  //return '<a href="' + url + '" ' + attrs + '>' + block(this) + '</a>';
//});

Handlebars.registerHelper("each_with_index", function(array, fn) {
  var buffer = "";
  for (var i = 0, j = array.length; i < j; i++) {
    var item = array[i];
    item.index = i;
    buffer += fn(item);
  }
  return buffer;
});

Handlebars.registerHelper('currency', function(amount){
  return accounting.formatMoney(amount);
});

Handlebars.registerHelper('select_category', function(id){
  var selectables = CipherTech.categories,
      selected,
      result;
  result = '<select name="category_id">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Category</option>';
  _.each(selectables, function(optgroup){
    result += '<optgroup label="' + optgroup[0] + '">';
    _.each(optgroup[1], function(option){
      selected = (option[1] == id) ? 'selected = "selected"' : '';
      result += '<option ' + selected + ' value="' + option[1] + '">' + option[0] + '</option>';
    });
    result += '</optgroup>';
  });
  result += '</select>';
  return result;
});

Handlebars.registerHelper('select_unit', function(id){
  var selectables = CipherTech.units,
      selected,
      result;
  result = '<select name="unit_id">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Unit</option>';
  _.each(selectables, function(option){
    selected = (option[1] == id) ? 'selected = "selected"' : '';
    result += '<option ' + selected + ' value="' + option[1] + '">' + option[0] + '</option>';
  });
  result += '</select>';
  return result;
});
Handlebars.registerHelper('purchase_unit', function(id){
  var selectables = CipherTech.units,
      selected,
      result;
  result = '<select name="unit_id" data-role="qty" id="unit_id" class="purchase_bg">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Unit</option>';
  _.each(selectables, function(option){
    selected = (option[1] == id) ? 'selected = "selected"' : '';
    result += '<option ' + selected + ' value="' + option[1] + '">' + option[0] + '</option>';
  });
  result += '</select>';
  return result;
});

Handlebars.registerHelper('inventory_unit', function(id){
  var selectables = CipherTech.units,
      selected,
      result;
  result = '<select name="inventory_unit_id" data-role="qty" id="inventory_unit_id" class="inventory_bg">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Unit</option>';
  _.each(selectables, function(option){
    selected = (option[1] == id) ? 'selected = "selected"' : '';
    result += '<option ' + selected + ' value="' + option[1] + '">' + option[0] + '</option>';
  });
  result += '</select>';
  return result;
});
Handlebars.registerHelper('recipe_unit', function(id){
  var selectables = CipherTech.units,
      selected,
      result;
  result = '<select name="recipe_unit_id" data-role="qty" id="recipe_unit_id" class="recipe_bg">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Unit</option>';
  _.each(selectables, function(option){
    selected = (option[1] == id) ? 'selected = "selected"' : '';
    result += '<option ' + selected + ' value="' + option[1] + '">' + option[0] + '</option>';
  });
  result += '</select>';
  return result;
});
Handlebars.registerHelper('unit_name', function(id){
  
  var units = CipherTech.units,
      name;
    _.each(units, function(option){
      if(option[1] == id)
        name = " (" + option[0] + ")";
  });
  return name;
});

Handlebars.registerHelper('select_locations', function(){
  var selectables = CipherTech.locations,
      selected,
      result;
  result = '<select name="location_ids" multiple="multiple">';
  _.each(selectables, function(option){
    result += '<option value="' + option['id'] + '">' + option['name'] + '</option>';
  });
  result += '</select>';
  return result;
});

Handlebars.registerHelper('show_location', function(id){
  var selectables = CipherTech.locations,
      selected,
      result;
  result = CipherTech.Collections.Locations.label.none;
  selected = _.find(selectables, function(location){
    return location['id'] == id;
  });
  if (selected) {
    result = selected.name;
  };

  return result;
});

Handlebars.registerHelper('select_location', function(id){
  var selectables = CipherTech.locations,
      selected,
      result;
  result = '<select name="location_id">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Room</option>';
  _.each(selectables, function(option){
    selected = (option['id'] == id) ? 'selected = "selected"' : '';
    result += '<option ' + selected + ' value="' + option['id'] + '">' + option['name'] + '</option>';
  });
  result += '</select>';
  return result;
});

Handlebars.registerHelper('select_copy_location', function(id){
  var selectables = CipherTech.locations,
      selected,
      result;
  result = '<select name="location_id" data-role="check-location-id">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Room</option>';
  result += '<option value=0>' + "Create New Room" + '</option>';
  _.each(selectables, function(option){
    selected = (option['id'] == id) ? 'selected = "selected"' : '';
    result += '<option ' + selected + ' value="' + option['id'] + '">' + option['name'] + '</option>';
  });
  result += '</select>';
  return result;
});

Handlebars.registerHelper('location_color', function(id){
  var selectables = CipherTech.locations,
      selected,
      cnt,      
      result;
  result = 'loc-id';
  cnt = 0;
  _.each(selectables, function(option, index){
    selected = (option['id'] == id) ? cnt%10 : '';
    result +=  selected;
    cnt++;
  });
  return result;
});

Handlebars.registerHelper('select_vendor', function(id){
  var selectables = CipherTech.vendors,
      selected,
      result;
  result = '<select name="vendor_id">';
  selected = (null == id) ? 'selected = "selected"' : '';
  result += '<option ' + selected + ' value="">Select a Vendor</option>';
  _.each(selectables, function(optgroup){
    result += '<optgroup label="' + optgroup[0] + '">';
    _.each(optgroup[1], function(option){
      selected = (option[1] == id) ? 'selected = "selected"' : '';
      result += '<option ' + selected + ' value="' + option[1] + '">' + option[0] + '</option>';
    });
    result += '</optgroup>';
  });
  result += '</select>';
  return result;
});

Handlebars.registerHelper('show_vendor', function(id){
  var vendors = CipherTech.vendors,
      vendor,
      name;
  _.each(vendors, function(vgroup){
  vendor = _.find(vgroup[1], function(vendor){
    return vendor[1] == id;
  });
  if (vendor) {
    name = vendor[0];
  };
  });
  return name;
  
});

Handlebars.registerHelper('select_rating', function(value){
  var selectables = [1, 2, 3, 4, 5],
      selected,
      result;
  result = '';
  result += '<input name="rating" type="hidden" value="' + value + '">';
  _.each(selectables, function(option){
    selected = (option == value) ? 'checked = "checked"' : '';
    result += '<input name="star_rating"' + selected + 'type="radio" value="' + option + '" class="star-rating star">';
  });
  return result;
});
Handlebars.registerHelper('show_data_fields', function(id){
  var result;
    result = (id == null) ? 'display-none-imp' : '';
  return result;
});
Handlebars.registerHelper('show_add_btn', function(id){
  var result;
  result = (id == null) ? '' : 'display-none-imp';
  return result;
});
Handlebars.registerHelper('fname', function(id){
  if($('.active').attr('data-id')=='all'){
    var selectables = CipherTech.locations,
      selected,
      result,names,initialLt="",index=0;
      result = CipherTech.Collections.Locations.label.none;
      selected = _.find(selectables, function(location){
      return location['id'] == id;
    });
    if (selected) {
      result = selected.name;
    };
    names = result.split(/\s+/);
    arr_len = names.length;
    index=0;
    $.each(names, function(){
      initialLt=initialLt.concat(this.charAt(0).toUpperCase());
    });
  return initialLt;
  }
  else
  {
    return '';
  }
});
