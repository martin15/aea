class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  layout 'users'

  def after_sign_in_path_for(resource)
    users_path
  end

  def paging(per_page)
    start_number = params[:page].nil? ? 0*per_page : (params[:page].to_i-1)*per_page
    return start_number
  end
end
