module ManagerHelper
  
  def navigation_items

    if user_signed_in?
      items = [{:title=>"Inventories", :path=>[:manager, :inventories]},
              {:title=>"Products",    :path=>[:index_restaurant, :manager, :products]},
              {:title=>"Vendors", :path=>[:manager, :vendors]},
              {:title=>"Settings", :path=>[:manager, :restaurants]}]
    else
      items = [:title=>"Pricing", :path=> [:pricing]]
    end
    items << {:title=>"Tutorials", :path=> [:howto] }
    items << {:title=>"Support", :path=> [:support_index] }
  end

  def subnav_items
    [{:title=>"Administrate Restaurants", :path=>[:manager, :restaurants]},
    {:title=>"Inventory Rooms",   :path=>[:manager, :locations]},
    {:title=>"Categories",    :path=>[:manager, :categories]}]
    #{:title=>"Units",     :path=>[:manager, :units]}]
  end

  def nested_skus(skus)
    skus.map do |sku, sub_skus|
      render(sku) + content_tag(:div, nested_skus(sub_skus), :class => "nested_skus")
    end.join.html_safe
  end


  def status(code)
    case code
    when 0
      "Active"
    when 1
      "Completed"
    end
  end

  def status_color(code)
    case code
    when 0
      "label-warning"
    when 1
      "label-success"
    end
  end

end
