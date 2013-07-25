class ApplicationController < ActionController::Base

  protect_from_forgery
  
  before_filter :check_for_restaurant_account
  
  helper_method :current_restaurant,
                :current_user_admin,
                :super_admin?,
                :local_tz
                
  def after_sign_in_path_for(resource_or_scope)
    session[:local_tz] = params[:local_tz]
    sign_in_url = url_for(:action => 'new', :controller => 'sessions', :only_path => false, :protocol => 'http')                                            
    if request.referer == sign_in_url or request.referer.include?('auth/users/password/edit?reset_password_token')                                                                                                                  
      super                                                                                                                                                 
    else                                                                                                                                                    
      stored_location_for(resource_or_scope) || request.referer || root_path                                                                                         
    end
  end
  
  def local_tz
    @local_tz = session[:local_tz].to_i
  end

  #def authenticate
    #respond_to do |format|
      #format.json { true }
      #format.html { check_auth }
    #end
  #end

  #def check_auth
    #authenticate_or_request_with_http_basic do |username, password|
      #username == "admin" && password == "bbmobile"
    #end
  #end

  #def current_user
    #@current_user ||= if params[:token]
      #User.find_by_token(params[:token])
    #elsif session[:user_id]
      #User.find(session[:user_id])
    #end
  #end
  
  def check_for_restaurant_account
    if user_signed_in? && current_restaurant.nil?
      sign_out current_user
      redirect_to root_path, :notice => "This account has no restaurant - Please contact your restaurant's admin to re-invite you"
    end
  end

  def current_module
    # returns the current "module" for the controller, if there is one.. or nll
    # ONLY VALID MODULES are allowed
    # once we are sure on what's allowed, this can be refactored
    # uses positive lookahead, which is fine with new ruby
    self.class.name.sub(/Controller$/, '').match(/^(Admin|Manager)(?=::)/).try("to_s")
  end

  def current_module?(m)
    # only considers VALIED module, case insentive, and works on symbols
    # does not allow nested modules...
    current_module =~ /^#{m.to_s}$/i
  end

  def current_restaurant
    ### JCB: this might not be safe
    ### if the session can be mucked with, the id for the current_restaurant can be changed
    ### one should check to make sure the user has privaleges for the restaurant (id)
    ### I haven't studied how teh user auth works here, so maybe it's happening already?
    ### 
      @current_restaurant ||= Restaurant.find(session[:current_restaurant] || current_user.accounts[0].restaurant.id) rescue nil
  end

  def current_user_admin(restaurant)
    @account = Account.where(:user_id => current_user.id, :restaurant_id => restaurant)
    if (@account[0].access == 1)
      true
    else
      false
    end
  end

  def super_admin?
    current_user && current_user.super_user?
  end

  def current_controller?(opts)
    hash = Rails.application.routes.recognize_path(url_for(opts))
    params[:controller] == hash[:controller]
  end

  # Options for PDF generation.
  def wicked_pdf_options(file_name, template)
    { :pdf => file_name,
      :template    => template,
      :layout      => "pdf.html",
      :formats     => [:html],
      :page_size   => "letter",
      :show_as_html => params[:debug].present?, # renders html version if you set debug=true in URL
      :footer => {
           :center => "CipherTech",
           :left => Date.today.strftime("%B %Y"),
           :right => "[page] of [topage]"
        },
      :print_media_type => true } 
  end

  def render_csv(filename = nil)
    filename ||= params[:action]
    filename += '.csv'

    if request.env['HTTP_USER_AGENT'] =~ /msie/i
      headers['Pragma'] = 'public'
      headers["Content-type"] = "text/plain" 
      headers['Cache-Control'] = 'no-cache, must-revalidate, post-check=0, pre-check=0'
      headers['Content-Disposition'] = "attachment; filename=\"#{filename}\"" 
      headers['Expires'] = "0" 
    else
      headers["Content-Type"] ||= 'text/csv'
      headers["Content-Disposition"] = "attachment; filename=\"#{filename}\"" 
    end

    render :layout => false
  end

end
