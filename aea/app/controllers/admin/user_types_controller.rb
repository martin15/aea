class Admin::UserTypesController < Admin::ApplicationController
  before_filter :find_user_type, :only => [:edit, :update, :destroy, :delete]

  def index
    @user_types = UserType.all.page(params[:page]).per(10)
    @no = paging(10)
  end

  def new
    @user_type = UserType.new
  end

  def create
    @user_type = UserType.new(user_type_params)
    if @user_type.save
      flash[:notice] = 'UserType was successfully create.'
      redirect_to admin_user_types_path
    else
      flash[:error] = "UserType failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @user_type.update_attributes(user_type_params)
      flash[:notice] = 'UserType was successfully updated.'
      redirect_to admin_user_types_path
    else
      flash[:error] = "UserType failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @user_type.destroy ? 'UserType was successfully deleted.' :
                                           'UserType was falied to delete.'
    redirect_to admin_user_types_path
  end

  private

    def user_type_params
      params.require(:user_type).permit(:name, :permalink)
    end

    def find_user_type
      @user_type = UserType.find_by_id(params[:id])
      if @user_type.nil?
        flash[:notice] = "Cannot find the UserType with id '#{params[:id]}'"
        redirect_to admin_user_types_path
      end
    end
end
