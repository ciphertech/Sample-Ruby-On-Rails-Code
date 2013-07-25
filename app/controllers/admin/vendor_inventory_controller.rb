class Admin::VendorInventoryController < AdminController

  before_filter :get_vendor

  def index
    if params[:searchbar].present?
      items = @inventory.vendor_items.search_inventory(params[:searchbar])
    else
      items =  @inventory.vendor_items.get_distinct_non_archived
    end
    @items = items.includes(:product, :category, :unit).paginate(page: params[:page], per_page: 100)
  end

  def create    
    if !params[:product].blank?
      product = params[:product]

      @item = VendorInventoryItem.new(vendor_id: @vendor.id, product_id: product[:id], category_id: product[:category_id], name: product[:name], unit_id: product[:unit_id], inventory_id: @inventory.id)
      if @item.save
        respond_to do |format|
          format.json
        end
      end
    else
      # If user clicked the add button with nothing
      # in the field do nothing.
      render nothing: true
    end
  end

  def update_attribute
    @original_item = VendorInventoryItem.find(params[:id])
    if @original_item.price.blank?
      @item = @original_item
    else
      @item = @original_item.dup
    end

    @item.unit_id = params[:unit] if params[:unit].present?
    @item.category_id = params[:category] if params[:category].present?
    @item.price = params[:price] if params[:price].present?

    if @item.save
      respond_to do |format|
        format.json
        format.js 
      end
    end
  end

  def destroy
    # TS Note: We are archiving vendor inventories rather than deleting. An item with an archived_at 
    # date is considered deleted. This approach should work fine for our current needs.
    # A more comprehensive and scalable approach would be to create a audit table where we insert 
    # deleted items. This would allow for undeletes etc. and would minimize table size. 
    @item = VendorInventoryItem.find(params[:id])

    # Also archive items with same unit and product ids.
    items = @inventory.vendor_items.where(product_id: @item.product_id, unit_id: @item.unit_id, vendor_id: @vendor.id)
    items << @item

    items.each do |item|
      item.archived_at = Time.now
      item.save
    end 

    redirect_to admin_vendor_vendor_inventory_index_path(@vendor)
  end

  def copy_inventory
    if params[:vendor].blank?
      flash[:notice] = "Please select a vendor to copy items from."
    else
      source_vendor = Vendor.find(params[:vendor])
      source_vendor.inventory.delay.copy_vendor_inventory_to(@vendor, @inventory, current_user)
      flash[:notice] = "Your sous chef is working hard to copy this inventory. It should be done soon."
    end
    redirect_to admin_vendor_vendor_inventory_index_path(@vendor)
  end

  private #----------------------------------------------------------------------------
  
  def get_vendor
  	@vendor = Vendor.find(params[:vendor_id])
  	get_or_create_inventory
  end

  def get_or_create_inventory
  	@inventory = @vendor.inventory
  	if @inventory.blank?
  		@inventory = @vendor.create_inventory!(name: @vendor.name, user: current_user)
  	end
  end

end
