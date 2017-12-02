class Admin::ApplicationController < ApplicationController
  protect_from_forgery
  #before_filter :require_login
  layout 'admin'
  before_filter :require_admin_login
end
