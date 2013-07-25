class Api::V1::InventoriesController < Api::V1::BaseController

  def index
    render :json => current_restaurant.inventories.where(:status => '0')
  end

  def show
    session[:current_restaurant] = Restaurant.find(params[:restaurant_id]).id if params[:restaurant_id].present?
    inventory = current_restaurant.inventories.find(params[:id], :include => :items, :order => 'inventory_items.room_position ASC')
    

    json = inventory.to_json({
      :include => { 
        :items => {
          :include => [:product, :location]
          #:include => [:product, :location], :methods => :latest_price
        }
      }
    })

    render :json => json
  end

  def update
    inventory = current_restaurant.inventories.find(params[:id])

    respond_to do |format|
      if inventory.update_attributes(params[:inventory])
        format.json { head :ok }
      else
        format.json { render :json => inventory.errors, :status => :unprocessable_entity }
      end
    end
  end

  def duplicate
    inventory = current_restaurant.inventories.find(params[:inventory_id])
    inventory.duplicate(current_user)

    # we're not using this reponse atm in our mobile client?
    head :ok
  end

end

