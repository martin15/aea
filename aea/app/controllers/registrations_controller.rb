class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def after_update_path_for(resource)
      users_path(resource)
    end

    def after_sign_up_path_for(resource)
      flash[:notice] = "You have been nominated as delegate/participant for the Asia Evangelical 
                        alliance General assembly – Church in Mission Congress,
                        please signup and register, atau please sign up and confirm your participation?"
      root_path
    end

  private
    def check_captcha
      if verify_recaptcha
        true
      else
        self.resource = resource_class.new sign_up_params
        respond_with_navigational(resource) { render :new }
      end
    end

    def sign_up_params
      params.require(:user).permit(:first_name, :last_name, :age, :title, :passport_number, 
                                   :email, :password, :password_confirmation,
                                   :gender, :user_type_id, :country_id, :phone)
    end

    def account_update_params
      params.require(:user).permit(:first_name, :last_name, :email, :password,
                                   :age, :title, :passport_number, :password_confirmation,
                                   :current_password,:gender, :user_type_id, :country_id, :phone)
    end
end