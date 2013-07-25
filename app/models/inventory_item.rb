# == Schema Information
#
# Table name: inventory_items
#
#  category_id   :integer
#  created_at    :timestamp
#  id            :integer          primary key
#  inventory_id  :integer
#  location_id   :integer
#  name          :string(255)
#  order         :integer
#  par           :integer
#  position      :integer
#  price         :float
#  price_date    :date
#  product_id    :integer
#  quantity      :float
#  rating        :integer
#  restaurant_id :integer
#  status        :integer
#  total_price   :decimal(, )
#  unit_id       :integer
#  updated_at    :timestamp
#  vendor_id     :integer
#

class InventoryItem < ActiveRecord::Base
  require "csv"
  extend StopWords
  include ActiveModel::Dirty

  belongs_to :restaurant
  belongs_to :unit
  belongs_to :inventory
  belongs_to :product
  belongs_to :location
  belongs_to :vendor
  belongs_to :category
  belongs_to :inventory_product

  acts_as_list :scope => [:restaurant_id, :inventory_id, :location_id],
    :column => :room_position

  attr_accessible :status,
                  :restaurant_id,
                  :product_id,
                  :quantity,
                  :unit_id,
                  :inventory_id,
                  :location_id,
                  :par,
                  :name,
                  :price,
                  :price_date,
                  :total_price,
                  :vendor_id,
                  :category_id,
                  :rating,
                  :order,
                  :position,
                  :inventory_product_id,
                  :type,
                  :room_position,
                  :last_price,
                  :inventory_unit_id,
                  :recipe_unit_id,
                  :inventory_unit_qty,
                  :recipe_unit_qty,
                  :inventory_unit_price,
                  :recipe_unit_price
                  :approved_products

                  


  ###
  ###  Temporay HACKS:  remove when we switch over to new inventory_product based system
  ###

  def inventory_product_exists?
    ! inventory_product_id.nil?  # don't hit the db
  end

  def name
    inventory_product_exists? ? inventory_product.name : read_attribute(:name)
  end

  #-------------- END OF HACKS ---------------------------------------------------------------

  scope :by_date_asc, order("updated_at asc")
  scope :by_date_desc,  order("updated_at desc")
  scope :by_position_asc, order("position asc")
  scope :by_room_position_asc, order("room_position asc")
  scope :non_archived, where("inventory_items.archived_at is null")
  scope :distinct_on_name_and_unit, select("DISTINCT ON (name, unit_id, product_id) *").non_archived.order("name, unit_id, product_id, created_at desc")
  scope :distinct_on_name_vendor, select("DISTINCT ON (name, vendor_id) *").non_archived.order("name, vendor_id, created_at desc")
  scope :latest, order("created_at DESC").where("price is not null").limit(1)
  scope :unapproved, where("product_id is null").where("type is null")

  delegate :name, :to => :unit, :prefix => true, :allow_nil => true
  delegate :name, :to => :category, :prefix => true, :allow_nil => true
  delegate :name, :to => :product, :prefix => true, :allow_nil => true
  delegate :name, :to => :restaurant, :prefix => true, :allow_nil => true
  delegate :name, :to => :vendor, :prefix => true, :allow_nil => true
  delegate :name, :to => :inventory, :prefix => true, :allow_nil => true
  delegate :name, :to => :location, :prefix => true, :allow_nil => true

  # Validations ===============================================================================
  validates_presence_of :name, :vendor_id
  validates :category, presence: true, unless: :vendor_inventory_item?
  validates_uniqueness_of :name, :scope => [:inventory_id, :location_id], :unless => Proc.new { |item| item.type == "VendorInventoryItem" }

  # Callbacks =================================================================================
  before_save :get_unit_from_product
  before_update :unarchive_if_price_changed
  before_create :set_last_price

  def latest_price()
    if (self.product_id.nil?)
      @price = InventoryItem.where("name=? and price is not null", self.name).last
    else
      if self.class.name == "VendorInventoryItem"
        @price = VendorInventoryItem.where("product_id=? and price is not null", self.product_id).last
      else
        @price = InventoryItem.where("product_id=? and price is not null and type is null", self.product_id).last
      end
    end
    if (@price.nil?)
      0
    else
      @price.price
    end
  end

  def set_last_price
    if last_price.blank?
      if product_id.blank?
        last_item = InventoryItem.where("name = :name and price is not null and restaurant_id = :restaurant_id and inventory_id <> :inventory_id", name: name, restaurant_id: restaurant_id, inventory_id: inventory_id).last
      else
        last_item = InventoryItem.where("product_id = :product_id and price is not null and restaurant_id = :restaurant_id and inventory_id <> :inventory_id", product_id: product_id, restaurant_id: restaurant_id, inventory_id: inventory_id).last
      end
      self.last_price = last_item.price if last_item
    end
  end

  def price_list()
    if(self.product_id.nil?)
      @prices = InventoryItem.where("name=? and price is not null", self.name).non_archived
    else
      @prices = InventoryItem.where("product_id=? and price is not null", self.product_id).non_archived
    end
    if (@prices.nil?)
      @prices = 0
    else
      @prices
    end
  end

  def min_max()
    @minmax = self.price_list.minmax_by{|x| x.price}
    if @minmax[0].nil? or @minmax[1].nil?
      @range = [0,0]
    else
      @range = [@minmax[0].price, @minmax[1].price]
    end
  end

  def median()
    @prices = self.price_list.sort{|x| x.price}
    len = @prices.length
    if (len == 0)
      return 0
    end
    median = len % 2 == 1 ? @prices[len/2].price : (@prices[len/2 - 1].price + @prices[len/2].price).to_f / 2
  end

  def spark_line(restaurant)
    if(self.product_id.nil?)
      @spark = InventoryItem.by_date_desc.where("name=? and restaurant_id=? and price is not null", self.name, restaurant)
    else
      @spark = InventoryItem.by_date_desc.where("product_id=? and restaurant_id=? and price is not null", self.product_id, restaurant)
    end 
    @spark.sort!{|x|  x.id}
    @spark_arry = []
    @spark.each_with_index {|x| @spark_arry.push(x.price)}
    @spark_arry[0..9]
  end

  def price_or_latest_price
    self.price.nil? ? self.latest_price : self.price
  end

  def price_history
    items = InventoryItem.non_archived.where(:product_id => self.product_id, :type => self.type, :vendor_id => self.vendor_id).order("created_at")
    items.collect{ |item| item.price unless item.price.blank? }
  end

  def average_price_on_date(vendor_ids=[])
    InventoryItem.where("product_id = :id and created_at between :starting and :ending and vendor_id in (:vendor_ids)", id: self.product_id, starting: self.created_at.beginning_of_day, ending: self.created_at.end_of_day, vendor_ids: vendor_ids).average("price")
  end

  def average_rating
    rating = InventoryItem.where(product_id: self.product_id, vendor_id: self.vendor_id).order("created_at desc").limit(15).average("rating")
    rating.blank? ? 0 : rating
  end

  def item_or_product_name
    if self.product_id.nil?
      self.name
    else 
      self.product_name
    end
  end

  def get_unit_from_product
    if self.product.present?
      self.unit_id = self.product.unit_id if self.unit_id.blank?
      self.name = self.product.name if self.name.blank?
    end
  end

  # An item is considered unapproved if the product_id is blank, and it is not a VendorInventoryItem.
  # To approve it, the item must be linked to an existing product.
  def approve_items(with_product)
    items = InventoryItem.where(name: name, unit_id: unit_id, category_id: category_id).where("type is null and product_id is null").where("id <> ?", id)
    items << self
    items.each do |item|
      item.name = "#{with_product.name} "#(#{with_product.unit_name})"
      item.unit_id = with_product.unit_id
      item.product_id = with_product.id
      item.save(:validate => false)
    end
  end

  def unarchive_if_price_changed
    if price_changed?
      self.archived_at = nil
    end
  end

  # Overriding these attributes to handle the date format.
  # Handling this individually for now, we can handle in a more global manner
  # if we start doing more with dates.
  def price_date=(date_string)
    if !date_string.blank? && date_string.split("/")[2].length == 2
      date = Date.strptime(date_string, "%m/%d/%y") rescue nil
    else
      date = Date.strptime(date_string, "%m/%d/%Y") rescue nil
    end
    write_attribute(:price_date,  date)
  end

  def price_date
    date = read_attribute(:price_date)
    date.strftime("%m/%d/%Y") if date
  end

  def set_matching_price_in_other_rooms
    if product.blank?
      items = InventoryItem.where(inventory_id: inventory_id, name: name)
    else
      items = InventoryItem.where(inventory_id: inventory_id, product_id: product_id)
    end
    items.each do |item|
      item.price = price
      item.save
    end
  end

  def created_at_epoch
    self.created_at.to_f
  end

  def as_json(options={})
    super(options).merge({:created_at_epoch => created_at_epoch})
  end

  def vendor_inventory_item?
    self.type == "VendorInventoryItem"
  end
  

  # class methods ===============================================================================
  def self.active_items_created_within(days)
    distinct_on_name_and_unit.created_within(days)
  end 

  def self.created_within(days) 
    where(["inventory_items.created_at >= ?", Date.today - days])
  end

  def self.items_similar_to_product(product, vendor_ids)
    finder = select("DISTINCT ON (inventory_items.name, inventory_items.vendor_id) inventory_items.*, restaurants.globally_approved")
    finder = finder.joins("LEFT OUTER JOIN restaurants on restaurants.id = inventory_items.restaurant_id")
    finder = finder.non_archived
    finder = finder.created_within(60.days)
    finder = finder.where("product_id = :id and vendor_id in (:vendor_ids)", id: product.id, vendor_ids: vendor_ids)
    finder = finder.where("restaurants.globally_approved is null or restaurants.globally_approved = true")
  end

  # Finds items similar to the procuct, or the item provided by vendors passed by an array of ids.
  # This allows us to compare items from a user's inventory that are not approved by the item name
  # instead of the product id.
  def self.items_related_to_product( product, vendor_ids, item )
    # Revised query so that it joins to the products table and does seach.
    # It also includes the rank in the distinct clause so that we can get distinct items again.
    finder = created_within(60.days)
    finder = finder.where("vendor_id in (:vendor_ids)", vendor_ids: vendor_ids)
    if item
      finder = finder.find_similar_by_item( item )
    else
      finder = finder.find_similar( product ) 
    end
  end

  # Finds similar products based on the product name.
  def self.find_similar( product )
    finder = rank_by_name( product.name )
    finder = finder.where("products.category_id = :category", category: product.category_id)
    finder = finder.where("inventory_items.product_id <> ?", product.id)
  end

  # Finds similar products based on an item name.
  # Because unapproved items may not to have a global category, a join is added to categories, 
  # and the category name is used in the search.
  def self.find_similar_by_item( item )
    finder = rank_by_name( item.name )
    finder = finder.joins(:category)
    finder = finder.where("categories.name iLike ?", "%#{item.category_name}%")
  end

  # Used by find_similar and find_similar_by_name to do a text search by name and rank the results
  def self.rank_by_name( name )
    search = strip_stop_words(name.gsub("&", "")).join(" | ")
    rank = <<-RANK 
      ts_rank(to_tsvector(products.name), to_tsquery('#{search}'))
    RANK
    finder = joins(:product).with_approved_restaurant
    finder = finder.select("DISTINCT ON (#{rank}, products.name, vendor_id) inventory_items.*, products.name, products.category_id, restaurants.globally_approved")
    finder = finder.non_archived
    finder = finder.where("products.name @@ to_tsquery(:q)", q: search)
    finder = finder.order("#{rank} desc, products.name, vendor_id")
  end

  def self.with_approved_restaurant
    finder = joins("LEFT OUTER JOIN restaurants on restaurants.id = inventory_items.restaurant_id")
    finder = finder.where("restaurants.globally_approved is null or restaurants.globally_approved = true")
  end

  def self.search_unapproved_items( params )
    name = params[:name]
    category = params[:category]
    restaruant = params[:restaurant]

    finder = joins(:restaurant).joins("LEFT OUTER JOIN categories ON categories.id = inventory_items.category_id")
    finder = finder.search(name) unless name.blank?
    finder = finder.where("categories.name ILIKE ?", "%#{category}%") unless category.blank?
    finder = finder.where("restaurants.name ILIKE ?", "%#{restaruant}%") unless restaruant.blank?
    finder = finder.unapproved
  end

  def self.search(query)
    search = query.gsub("&", "").split(" ").join(" | ")
    rank = <<-RANK 
      ts_rank(to_tsvector(inventory_items.name), to_tsquery('#{search}'))
    RANK
    finder = where("inventory_items.name @@ to_tsquery(:q)", q: search)
    finder = finder.order("#{rank} desc, inventory_items.name")
  end

  def self.create_new(item,location_id)
    new_item = InventoryItem.new(
    {
      inventory_id:   item.inventory_id,
      product_id:     item.product_id,
      name:           item.name,
      quantity:       item.quantity,
      unit_id:        item.unit_id,
      price:          item.price,
      location_id:    location_id,
      price_date:     item.price_date,
      vendor_id:      item.vendor_id,
      category_id:    item.category_id
    })
    new_item.save
  end


  # Used to customize json responses
  acts_as_api

  # a template to return key data. 
  api_accessible :items_with_rating do |template|
    template.add :id
    template.add :type
    template.add :item_or_product_name
    template.add :price
    template.add :price_history
    template.add :average_rating
    template.add :vendor
  end
end
