class AddRatingToVendors < ActiveRecord::Migration
  def change
    @vendors = Vendor.find(:all)
    @vendors.each do |vendor|
      @comments = vendor.comments
      @rating = 0
      if (@comments.length > 0)
        @comments.each do |comment|
          @rating = @rating + comment.rating
        end
        @rating = @rating/@comments.length
      end
      vendor.rating = @rating
      vendor.save
    end
  end
end
