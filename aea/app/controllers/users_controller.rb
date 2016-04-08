class UsersController < ApplicationController

  before_filter :authenticate_user!
  layout 'users'

  def edit
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update(user_params)
      # Sign in the user by passing validation in case their password changed
      sign_in @user, :bypass => true
      redirect_to root_path
    else
      render "edit"
    end
  end

  def register_event
    @user = current_user
    user_id = @user.user_type_id.blank? ? UserType.first.id : @user.user_type_id
    @country_type = @user.country.name.downcase == "indonesia" ? @user.country.permalink :
                                                                 @user.country.category_type
    @room_types = RoomTypesUserType.where("user_type_id = #{user_id} and
                                           country_type = '#{@country_type}'")
  end

  def save_register_event
    @user = current_user
    if @user.country.name.downcase == "indonesia"
      @room_type = RoomTypesUserType.where("country_type = '#{@user.country.permalink}'").first
      params[:user][:user_type_id] = UserType.find_by_permalink('representative-of-local-leaders').id
    else
      @room_type = RoomTypesUserType.where("user_type_id = #{params[:user][:user_type_id]} and
                                            room_type_id = #{params[:user][:room_type_id]} and
                                            country_type = '#{@user.country.category_type}'").first
    end
    
    @user.price = @room_type.price
    params[:user][:roomate] = "" if @room_type.room_type.name.downcase == "single"
    if @user.update(user_params)
      if @user.payment_type == "bank_bca"
        #kirim email
        render "transfer_bank"
        return
      elsif @user.payment_type == "on_the_spot"
        #kirim email
        render "on_the_spot"
        return
      end
    else
      flash[:error] = "Please complete all field"
      render "register_event"
    end
  end

  def update_price
    respond_to do |format|
      @user = current_user
      @user.room_type_id = params[:room_type_id]
      @room_types = RoomTypesUserType.where("user_type_id = #{params[:user_type_id]} and
                                             country_type = '#{@user.country.category_type}'")
      format.js
    end
  end

  private

  def user_params
    # NOTE: Using `strong_parameters` gem
    params.require(:user).permit(:password, :password_confirmation, :user_type_id, :room_type_id,
                                 :age, :title, :passport_number, :payment_type, :roomate, :price )
  end
end