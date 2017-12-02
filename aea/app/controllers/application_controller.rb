class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'users'

  def after_sign_in_path_for(resource)
    seat_managements_path
  end

  def paging(per_page)
    start_number = params[:page].nil? ? 0*per_page : (params[:page].to_i-1)*per_page
    return start_number
  end

  def the_domain
    host = request.host == "localhost" ? "#{request.host}:#{request.port}" : request.host
    return host
  end

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
