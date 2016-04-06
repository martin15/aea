class Admin::ApplicationController < ApplicationController
  protect_from_forgery
  #before_filter :require_login
  layout 'admin'
  before_filter :require_admin_login

  def require_admin_login
     if current_user.nil?
       flash[:alert] = "Only Admin are permitted to access this page"
       redirect_to new_user_session_path
       return
     elsif current_user.is_admin?
       return current_user
     else
       flash[:alert] = "Only Admin are permitted to access this page"
       redirect_to users_path
       return
    end
  end
end
