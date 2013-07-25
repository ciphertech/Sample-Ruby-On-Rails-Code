class Admin::VendorsController < AdminController

  def index
  	
    @vendors = Vendor.order("name")
    @vendors = @vendors.search(params[:searchbar]) if params[:searchbar].present?
    
    respond_to do |format|
      format.html do

        if params[:local] == "true"
          @vendors = @vendors.local
        else
          @vendors = @vendors.global
        end

        @vendors = @vendors.paginate(page: params[:page], per_page: 20)
      end

      format.json { render json: @vendors.where("id <> ?", params[:vendor_id]).limit(20).to_json( :only => [:name, :id] ) }
    
    end

  end

  def show
    @vendor = Vendor.find(params[:id])
    respond_to do |format|
      format.json { render json: @vendor.to_json( ) }
    end
  end

  def new
  	@vendor = Vendor.new

    respond_to do |format|
      format.html 
    end
  end

  def edit
  	@vendor = Vendor.find(params[:id])
  end

  def create
    @vendor = Vendor.new(params[:vendor].merge!({ globally_approved: true, created_by_id: current_user.id }))

    respond_to do |format|
      if @vendor.save
	params["categories"].each do |category|
           @vendor.category_vendors.create(:category_id=>category.to_i) if !@vendor.category_vendors.exists?(:category_id=>category.to_i)
	end if params["categories"].present?
        format.html { redirect_to admin_vendors_path, notice: 'Vendor was successfully created.' }
      else
        error_on_geocode = " #{@vendor.errors.messages[:full_street_address][0]}." if @vendor.errors.messages[:full_street_address]

      	flash[:error] = "The vendor could not be saved.#{error_on_geocode}"
        format.html { render action: "new" }
      end
    end
  end

  def update
    @vendor = Vendor.find(params[:id])

    respond_to do |format|
      if @vendor.update_attributes(params[:vendor])
	params["categories"].each do |category|
           @vendor.category_vendors.create(:category_id=>category.to_i) if !@vendor.category_vendors.exists?(:category_id=>category.to_i)
	end if params["categories"].present?
        format.html { redirect_to [:admin, :vendors], notice: 'Vendor was successfully updated.' }
      else
      	flash[:error] = "The vendor could not be saved."
        format.html { render action: "edit" }
      end
    end
  end

  def approve
  	@vendor = Vendor.find(params[:id])
  	@vendor.globally_approved = true
  	respond_to do |format|
	  	if @vendor.save
	  		flash[:notice] = "Vendor was approved."
	  	else
	  		flash[:error] = "This is embarassing. Something went wrong and the vendor was not approved."
	  	end
	  	format.html { redirect_to admin_vendors_path(local: true) }
	  end
  end

  # Updates all inventory items linked to child vendor with the parent vendor id.
  # Then deletes the child vendor. 
  def merge
    @parent_vendor = Vendor.find(params[:id])
    @child_vendor = Vendor.find(params[:vendor_id])

    if @parent_vendor.id != @child_vendor.id
      @parent_vendor.delay.merge!(@child_vendor, current_user)
      notice = "Your sous chef is working to merge vendor #{@child_vendor.name}. It should be done soon."
    else
      notice = "Sorry, could not merge the vendors."
    end

    redirect_to edit_admin_vendor_path(@parent_vendor), notice: notice
  end

end
