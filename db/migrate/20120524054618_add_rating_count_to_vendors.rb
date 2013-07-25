class AddRatingCountToVendors < ActiveRecord::Migration
  def change
    add_column :vendors, :rating_count, :integer, :default => 0
    @vendors = Vendor.find(:all)
    @vendors.each do |vendor|
      @comments = vendor.comments
      if (@comments.length > 0)
        vendor.rating_count = @comments.length
        vendor.save
      end
    end
  end
end
