class RegistrationsController < Devise::RegistrationsController
  prepend_before_action :check_captcha, only: [:create] # Change this to be any actions you want to protect.

  protected
    def update_resource(resource, params)
      resource.update_without_password(params)
    end

    def after_update_path_for(resource)
      users_path(resource)
    end

    def after_inactive_sign_up_path_for(resource)
      flash[:notice] = "Thank you for sign up. Please check your email"
      new_user_session_path
    end

  private
    def check_captcha
      if verify_recaptcha
        ind = Country.find_by_name("Indonesia")
        if sign_up_params[:country_id].to_i == ind.id.to_i
          params[:user][:passport_number] = "-"
        end
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