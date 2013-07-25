class AdminController < ApplicationController

  include AdminHelper

  before_filter :authenticate_admin!

protected

  def authenticate_admin!
    unless super_admin?
      redirect_to root_path, :alert => "Access Denied"
    end
  end

end
