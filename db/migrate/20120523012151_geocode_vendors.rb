class GeocodeVendors < ActiveRecord::Migration
  def up
    @v = Vendor.find(:all)
    @v.each do |v|
      v.geocode
      v.save
    end
  end

end
