class Users::RegistrantsController < Users::ApplicationController
  before_filter :check_authority
  before_filter :find_registrant, :only => [:show, :edit, :update, :destroy]

  def index
    @registrants = current_user.members.page(params[:page]).per(20)
    @no = paging(10)
  end

  def show

  end

  def new
    @user = current_user
    @registrant = User.new(:country_id => @user.country_id)
    user_type_id = @user.user_type_id
    @room_types = RoomTypesUserType.where("user_type_id = #{user_type_id} and
                                           country_type = '#{@user.country.category_type}'")
  end

  def create
    @user = current_user
    @registrant = User.new(user_params)
    @registrant.team_leader = current_user
    @registrant.user_type = @user.user_type_id
    @registrant.skip_password_validation = true
    @registrant.price = find_room_price
    if @registrant.save
      flash[:notice] = 'Member was successfully create.'
      redirect_to users_registrants_path
    else
      @room_types = RoomTypesUserType.where("user_type_id = #{user_type.id} and
                                           country_type = '#{@user.country.category_type}'")
      flash[:error] = "Member failed to create"
      render :action => :new
    end
  end

  def edit
    @user = current_user
    user_type_id = UserType.find_by_permalink("member").id
    @room_types = RoomTypesUserType.where("user_type_id = #{user_type_id} and
                                           country_type = '#{@user.country.category_type}'")
  end

  def update
    @user = current_user
    @registrant.price = find_room_price
    if @registrant.update_attributes(user_params)
      flash[:notice] = 'Member was successfully updated.'
      redirect_to users_registrants_path
    else
      user_type_id = UserType.find_by_permalink("member").id
      @room_types = RoomTypesUserType.where("user_type_id = #{user_type_id} and
                                             country_type = '#{@registrant.country.category_type}'")
      flash[:error] = "Member failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @registrant.destroy ? 'Member was successfully deleted.' :
                                           'Member was falied to delete.'
    redirect_to users_registrants_path
  end

  def update_price_by_country
    respond_to do |format|
      @user = current_user
      user_type_id = UserType.find_by_permalink("member").id
      country_type = Country.find_by_id(params[:country_id])
      @room_types = RoomTypesUserType.where("user_type_id = #{user_type_id} and
                                             country_type = '#{country_type.category_type}'")
      format.js
    end
  end

  def total_price
    respond_to do |format|
      @user = current_user
      puts params.inspect
      @total_price = User.where("id in (?)", params[:registrant_ids]).sum("price")
      puts @total_price
      format.js
    end
  end

  private

    def user_params
      # NOTE: Using `strong_parameters` gem
      params.require(:user).permit(:first_name, :last_name, :email, :user_type_id,
                                   :age, :title, :passport_number, :room_type_id,
                                   :price, :gender, :country_id )
    end

    def find_registrant
      @registrant = current_user.members.where("id = #{params[:id]}").first
      if @registrant.nil?
        flash[:alert] = "Cannot find User with id = #{params[:id]}"
        redirect_to users_registrants_path
      end
    end

    def find_room_price
      @room = RoomTypesUserType.where("user_type_id = #{@registrant.user_type_id} and
                                       room_type_id = #{@registrant.room_type_id} and
                                       country_type = '#{@registrant.country.category_type}'").first
      return 0 if @room.nil?
      @room.price
    end

    def check_authority
      unless current_user.is_team_lead?
        flash[:alert] = "You don't have authority to access this page"
        redirect_to users_path
      end
    end
end
