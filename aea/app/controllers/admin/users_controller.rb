class Admin::UsersController < Admin::ApplicationController
  before_filter :find_user, :only => [:edit, :update, :destroy, :delete]

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

  private

    def user_params
      params.require(:user).permit(:name, :permalink)
    end

    def find_user
      @user = User.find_by_id(params[:id])
      if @user.nil?
        flash[:notice] = "Cannot find the User with id '#{params[:id]}'"
        redirect_to admin_users_path
     end
    end
end
