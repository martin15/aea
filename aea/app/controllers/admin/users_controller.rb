class Admin::UsersController < Admin::ApplicationController
  before_filter :find_user, :only => [:edit, :update, :destroy, :delete, :confirm, :save_confirmed]

  def index
    @users = User.all.page(params[:page]).per(20)
    @no = paging(10)
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
    @user.approved_at = DateTime.now.to_s(:db)
    if @user.save
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
end
