 # == Schema Information
#
# Table name: vendors
#
#  address            :string(255)
#  city               :string(255)
#  created_at         :timestamp
#  email              :string(255)
#  fax                :string(255)
#  gmaps              :boolean
#  id                 :integer          primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :timestamp
#  latitude           :float
#  logo               :string(255)
#  longitude          :float
#  name               :string(255)
#  phone              :string(255)
#  rating             :float
#  rating_count       :integer          default(0)
#  state              :string(255)
#  updated_at         :timestamp
#  url                :string(255)
#  zip                :string(255)
#

class Vendor < ActiveRecord::Base

  # Associations --------------------------------------------------------------------------------
  has_many :items, :class_name => "InventoryItem"
  has_many :vendor_items, :class_name => "VendorInventoryItem"
  has_many :products, :through => :items
  has_many :invoices  # this connects vendors to restaurants
  has_one :inventory, :dependent => :destroy
  belongs_to :restaurant
  has_many :category_vendors
  has_many :categories, :through => :category_vendors

  has_attached_file :image, 
                    :styles => { :medium => "300x300>", :thumb => "100x100>" },
                    :path => "/vendors/:id/:style/:filename"

  acts_as_commentable

  #acts_as_gmappable :process_geocoding => false
  
  acts_as_gmappable :lat => 'latitude', :lng => 'longitude', :process_geocoding => :geocode?,
                    :address => :full_street_address, #:normalized_address => "address",
                    :msg => "Sorry, not even Google could figure out where that is"

  def geocode?
    (!address.blank? && (lat.blank? || lng.blank?)) || address_changed?
  end
  
  
  geocoded_by :full_street_address   # can also be an IP address

  after_validation :geocode        # auto-fetch coordinates

  # Delegations ---------------------------------------------------------------------------------
  delegate :name, :to => :restaurant, :prefix => true, :allow_nil => true

  # scopes --------------------------------------------------------------------------------------
  scope :global, where(globally_approved: true, type: nil)
  scope :local, where(globally_approved: false, type: nil)

  # Validations ---------------------------------------------------------------------------------
  validates_presence_of :name, :phone, :address, :city, :state, :zip, :country

  # Instance Methods ----------------------------------------------------------------------------
  def full_street_address
    [address, city, state, zip, country].compact.join(', ')
  end

  def items_from_vendor_for_restaurant(restaurant)
    self.items.distinct_on_name_and_unit.where(restaurant_id: restaurant.id)
  end

  def distance
    distance = (attributes['distance'].to_f*100).round/100.0
    if distance == 0.0
      return "Unable to find distance"
    else
      return distance.to_s + " Miles"
    end
  end

  # Updates inventory item from vendor with current id.
  # Destroys vendor when done.
  def merge!(vendor, user)

    return false if vendor.id == id

    self.create_inventory!(name: name, user: user) if inventory.blank?

    vendor.items.each do |item|
      item.vendor_id = id
      item.inventory_id = inventory.id if item.type == "VendorInventoryItem"
      item.save(:validate => false)
    end

    vendor.destroy

    NotificationMailer.delay.vendors_merged(user, self, vendor.name)

  end

  # Class methods ---------------------------------------------------------------------------------
  def self.global_and_local_for_restaraunt(current_restaurant, search = nil)
    finder = where{(globally_approved == true) | (restaurant_id == current_restaurant.id)}
    if search
      finder = finder.search_by_name_type_location(search)
    end
    finder.where(type: nil)
  end

  def self.global_and_local_near_restaraunt(current_restaurant, within = nil, search = nil)
    within = 200 if within.blank?
    finder = where{(globally_approved == true) | (restaurant_id == current_restaurant.id)}
    if search
      finder = finder.search(search)
    end
    finder.near([current_restaurant.latitude, current_restaurant.longitude], within.to_i).where(type: nil)
  end

  def self.search(search)
    if search
      search = search.split(" ")
      if search.length == 1
        search = search[0]
        where{name.matches("%#{search}%") | address.matches("%#{search}%") | city.matches("%#{search}%")} if search
      else
        search = search.join(" | ")
        rank = <<-RANK 
          ts_rank(to_tsvector(name), to_tsquery('#{search}')) +
          ts_rank(to_tsvector(address), to_tsquery('#{search}')) +
          ts_rank(to_tsvector(city), to_tsquery('#{search}'))
        RANK
        where("name @@ to_tsquery(:q) or address @@ to_tsquery(:q) or city @@ to_tsquery(:q)", q: search).order("#{rank} desc, name, city")
      end
    end
  end

  #method to search vendors by name, product type and location.
  def self.search_by_name_type_location(search)
    if search
        select("DISTINCT vendors.*").joins("LEFT JOIN inventory_items ON inventory_items.vendor_id = vendors.id LEFT JOIN locations ON locations.id = inventory_items.location_id LEFT JOIN products ON products.id = inventory_items.product_id").where("vendors.name ilike '%#{search}%' or products.name ilike '%#{search}%' or locations.name ilike '%#{search}%' ")
    end
  end

  def self.vendor_ids_near_restaurant(restaurant, within)
    within = 75 if within.blank?
    where(globally_approved: true).near([restaurant.latitude, restaurant.longitude], within.to_i).collect{ |vendor| vendor.id }
  end
  
  def self.vendors_near_restaurant(restaurant, within)
    within = 200 if within.blank?
    where(globally_approved: true).near([restaurant.latitude, restaurant.longitude], within.to_i)
  end

  def self.find_or_create_without_validation_by_name(name, inventory, user)
    return nil if name.blank?
    restaurant = inventory.restaurant
    vendor = vendors_near_restaurant(restaurant, 200).where(name: name).limit(1)
    vendor = Vendor.where(name: name, restaurant_id: restaurant.id).limit(1) if vendor.blank?
    if vendor.blank?
      vendor = vendor.new(name: name, restaurant_id: restaurant.id, created_by_id: user.id)
      if vendor.save(validate: false)
        vendor
      end
    else
      vendor.first
    end
  end

  # Used to customize json responses
  acts_as_api

  # a template to return only the id and name. 
  api_accessible :items_with_rating do |template|
    template.add :id
    template.add :name
  end
  
  def gmaps4rails_infowindow
        "<a href=\"#\" class= \"if-gmap\" onClick=\"$.fn.colorbox({iframe:true, transition:\'fade\', innerWidth:900, innerHeight:640, href:\'vendors\/#{self.id}\'});\" ><img src=\"#{self.image.url(:medium)}\"><br/>#{self.name}</a>"
  end

end
