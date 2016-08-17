class Admin::UsersController < Admin::ApplicationController
  before_filter :find_user, :only => [:edit, :update, :destroy, :delete, :confirm, :save_confirmed,
                                      :edit_confirmed_user]

  def index
    if params[:country_permalink].nil?
      @users = User.not_admin
      @users = @users.inactive_user  if params[:type] == 'inactive'
      @users = @users.active_user  if params[:type] == 'active'

      @users = @users.includes([:country, :room_type, :user_type]).
                      order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
      @no = paging(20)
    else
      @country = Country.find_by_permalink(params[:country_permalink])
      if @country.nil?
        flash[:notice] = "Cannot find country with name '#{params[:country_permalink]}'"
        redirect_to admin_users_path
        return
      end
      @users = @country.users.includes([:country, :room_type, :user_type]).
                              order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
      @no = paging(20)
    end
  end

  def user_rooms
    @room_type = RoomType.find_by_name(params[:room_type])
    if @room_type.nil?
      flash[:notice] = "Cannot find country with name '#{params[:country_permalink]}'" unless params[:country_permalink].nil?
      @users = User.includes([:country, :room_type, :user_type]).
                    order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    else
      @users = @room_type.users.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    end
    @no = paging(20)
  end

  def order_by
    if params[:order_by].nil?
      @users = User.not_admin.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
      @no = paging(20)
    else
      @users = User.where("status = '#{params[:order_by]}'").
                    order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
      @no = paging(20)
    end
  end

  def new
    @user = User.new
    @room_types = RoomType.all
  end

  def create
    puts params.inspect
    params[:user][:passport_number] = "-" if params[:user][:passport_number].blank?
    @user = User.new(user_params)
    @user.confirmed_at = DateTime.now.to_s(:db)
    country = Country.find_by_id(@user.country_id)
    room_type = RoomTypesUserType.where("room_type_id = #{@user.room_type_id} and
                                         user_type_id = #{@user.user_type_id} and
                                         country_type = '#{country.category_type}'").first
    price = room_type.nil? ? 0 : room_type.price
    @user.price = price
    @user.skip_password_validation = true
    if @user.save
      unless params[:filename].nil?
        Ticket.create(:filename => params[:filename], :user_id => @user.id)
      end
      #kirim email ke user tersebut
      flash[:notice] = 'User was successfully create.'
      redirect_to admin_users_path
    else
      @room_types = RoomType.all
      flash[:error] = "User failed to create"
      render :action => :new
    end
  end

  def edit
    @room_types = RoomType.all
  end

  def update
    c_id = params[:user][:country_id].nil? ? @user.country_id : params[:user][:country_id]
    rt_id = params[:user][:room_type_id].nil? ? @user.room_type_id : params[:user][:room_type_id]
    ut_id = params[:user][:user_type_id].nil? ? @user.user_type_id : params[:user][:user_type_id]
    country = Country.find_by_id(c_id)
    room_type = RoomTypesUserType.where("room_type_id = #{rt_id} and
                                         user_type_id = #{ut_id} and
                                         country_type = '#{country.category_type}'").first
    price = room_type.nil? ? 0 : room_type.price
    params[:user][:price] = price
    if @user.update_attributes(user_params)
      unless params[:filename].nil?
        Ticket.create(:filename => params[:filename], :user_id => @user.id)
      end
      flash[:notice] = 'User was successfully updated.'
      if !params[:user][:arriving_id].nil? && !params[:user][:departing_id].nil?
        #kirim email ke user tersebut
        redirect_to admin_user_confirmed_users_path
      else
        redirect_to admin_users_path
      end
    else
      @room_types = RoomType.all
      flash[:error] = "User failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @user.destroy ? 'User was successfully deleted.' :
                                           'User was falied to delete.'
    redirect_to admin_users_path
  end

  def confirm
  end

  def save_confirmed
    @user.status = "Approved"
    @user.registration_number = @user.get_registration_number
    @user.approved_at = DateTime.now.to_s(:db)
    if @user.save
      ApproveRegistrationMailer.approve_registration_for_user(@user, the_domain).deliver_now
      ApproveRegistrationMailer.approve_registration_for_admin(@user, the_domain).deliver_now
      flash[:notice] = 'User was successfully Confirmed.'
      redirect_to admin_users_path
    else
      flash[:error] = "User failed to Confirmed"
      render :action => :confirm
    end
  end

  def confirmed_users
    @users = User.confirmed_user.includes([:country, :room_type, :user_type]).
                  order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
                puts "-------"
                puts @users.inspect
    @no = paging(20)
  end

  def validate_user
    @users = User.confirmed_user.includes([:country, :room_type, :user_type]).
                  order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    @no = paging(20)
  end

  def edit_confirmed_user
    @room_types = RoomType.all
    @departing_list = ShuttleBus.departing_list.order(:pick_up_time)
    @arriving_list = ShuttleBus.arriving_list.order(:pick_up_time)
  end

  def export_as_xls
    @users = User.not_admin.includes([:user_type, :country, :room_type])
    respond_to do |format|
      format.xls
    end
  end

  def search_user
    @users = User.not_admin

    @users = @users.where("first_name like '%#{params[:search]}%' OR
                           last_name like '%#{params[:search]}%' OR
                           email like '%#{params[:search]}%' OR
                           registration_number like '%#{params[:search]}%' ").
                    includes([:country, :room_type, :user_type]).
                    order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    @no = paging(20)
  end

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :user_type_id,
                                   :age, :title, :passport_number, :room_type_id,
                                   :price, :gender, :country_id, :note, :roomate, 
                                   :room_number, :arriving_id, :departing_id, :need_accomodation)
    end

    def find_user
      @user = User.find_by_id(params[:id])
      if @user.nil?
        flash[:notice] = "Cannot find the User with id '#{params[:id]}'"
        redirect_to admin_users_path
     end
    end

    def sort_column
      params[:sort] || "confirmed_at"
    end

    def sort_direction
      params[:direction] || "asc"
    end
end
