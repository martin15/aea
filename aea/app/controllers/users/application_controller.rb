class Users::ApplicationController < ApplicationController
  before_action :authenticate_user!
  layout 'users'
  include ApplicationHelper
  include Devise::Controllers::Helpers

end
