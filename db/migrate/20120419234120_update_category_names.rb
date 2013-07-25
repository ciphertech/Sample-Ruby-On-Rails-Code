class UpdateCategoryNames < ActiveRecord::Migration
  def up
    Category.all.each do |cat|
      if cat.id > 22
        cat.usda = cat.name
        cat.save
        puts cat.usda
        if cat.usda == 100
          cat.name = "Dairy and Egg Products"
        elsif cat.usda == 200
          cat.name = "Spices and Herbs"
        elsif cat.usda == 300
          cat.name = "Baby Foods"
        elsif cat.usda == 400
          cat.name = "Fats and Oils"
        elsif cat.usda == 500
          cat.name = "Poultry Products"
        elsif cat.usda == 600
          cat.name = "Soups, Sauces, and Gravies"
        elsif cat.usda == 700
          cat.name = "Sausages and Luncheon Meats"
        elsif cat.usda == 800
          cat.name = "Breakfast Cereals"
        elsif cat.usda == 900
          cat.name = "Fruits and Fruit Juices"
        elsif cat.usda == 1000
          cat.name = "Pork Products"
        elsif cat.usda == 1100
          cat.name = "Vegetables and Vegetable Products"
        elsif cat.usda == 1200
          cat.name = "Nut and Seed Products"
        elsif cat.usda == 1300
          cat.name = "Beef Products"
        elsif cat.usda == 1400
          cat.name = "Beverages"
        elsif cat.usda == 1500
          cat.name = "Finfish and Shellfish Products"
        elsif cat.usda == 1600
          cat.name = "Legumes and Legume Products"
        elsif cat.usda == 1700
          cat.name = "Lamb, Veal, and Game Products"
        elsif cat.usda == 1800
          cat.name = "Baked Products"
        elsif cat.usda == 1900
          cat.name = "Sweets"
        elsif cat.usda == 2000
          cat.name = "Cereal Grains and Pasta"
        elsif cat.usda == 2100
          cat.name = "Fast Foods"
        elsif cat.usda == 2200
          cat.name = "Meals Entrees, and Sidedishes"
        elsif cat.usda == 2500
          cat.name = "Snacks"
        elsif cat.usda == 3500
          cat.name = "Ethnic Foods"
        elsif cat.usda == 3600
          cat.name = "Restaurant Foods"
        end
        puts cat.name
        cat.save
      end
    end
  end

  def down
  end
end
