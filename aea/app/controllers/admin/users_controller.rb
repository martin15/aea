class Admin::UsersController < Admin::ApplicationController
  before_filter :find_user, :only => [:edit, :update, :destroy, :delete, :confirm, :save_confirmed]

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
    @country = Country.find_by_permalink(params[:country_permalink])
    if @country.nil?
      flash[:notice] = "Cannot find country with name '#{params[:country_permalink]}'" unless params[:country_permalink].nil?
      @users = User.includes([:country, :room_type, :user_type]).
                    order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
    else
      @users = @country.users.order("#{sort_column} #{sort_direction}").page(params[:page]).per(20)
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
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'User was successfully create.'
      redirect_to admin_users_path
    else
      flash[:error] = "User failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:notice] = 'User was successfully updated.'
      redirect_to admin_users_path
    else
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

  private

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :user_type_id,
                                   :age, :title, :passport_number, :room_type_id,
                                   :price, :gender, :country_id, :note, :roomate)
    end

    def find_user
      @user = User.find_by_id(params[:id])
      if @user.nil?
        flash[:notice] = "Cannot find the User with id '#{params[:id]}'"
        redirect_to admin_users_path
     end
    end

    def sort_column
      params[:sort] || "first_name"
    end

    def sort_direction
      params[:direction] || "asc"
    end
end
