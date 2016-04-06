class Admin::RoomTypesController < Admin::ApplicationController
  before_filter :find_room_type, :only => [:edit, :update, :destroy, :delete]
  before_filter :find_indonesia, :only => [:new, :create, :edit, :update]

  def index
    @room_types = RoomType.all.page(params[:page]).per(10)
    @no = paging(10)
  end

  def new
    @room_type = RoomType.new
    @user_types = UserType.all
  end

  def create
    @room_type = RoomType.new(room_type_params)
    if @room_type.save
      save_price
      flash[:notice] = 'RoomType was successfully create.'
      redirect_to admin_room_types_path
    else
     @user_types = UserType.all
      flash[:error] = "RoomType failed to create"
      render :action => :new
    end
  end

  def edit
    @user_types = UserType.all
  end

  def update
    if @room_type.update_attributes(room_type_params)
      save_price
      flash[:notice] = 'RoomType was successfully updated.'
      redirect_to admin_room_types_path
    else
      @user_types = UserType.all
      flash[:error] = "RoomType failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @room_type.destroy ? 'RoomType was successfully deleted.' :
                                           'RoomType was falied to delete.'
    redirect_to admin_room_types_path
  end

  private

    def room_type_params
      params.require(:room_type).permit(:name)
    end

    def find_room_type
      @room_type = RoomType.find_by_id(params[:id])
      if @room_type.nil?
        flash[:notice] = "Cannot find the RoomType with id '#{params[:id]}'"
        redirect_to admin_room_types_path
     end
    end

    def find_indonesia
      @indonesia = Country.find_by_permalink("indonesia")
    end

    def save_price
      @user_types = UserType.all
      @user_types.each do |user_type|
        developed_price = RoomTypesUserType.where("user_type_id = #{user_type.id} and
                                                    room_type_id = #{@room_type.id} and
                                                    country_type = 'Developed' ").first
        developing_price = RoomTypesUserType.where("user_type_id = #{user_type.id} and
                                                    room_type_id = #{@room_type.id} and
                                                    country_type = 'Developing' ").first
        
        unless @indonesia.nil?
          price_for_indonesia = RoomTypesUserType.where("user_type_id = #{user_type.id} and
                                                         room_type_id = #{@room_type.id} and
                                                         country_type = '#{@indonesia.permalink}' ").first

          if price_for_indonesia.nil?
            price_for_indonesia = RoomTypesUserType.new(:user_type_id => user_type.id,
                                                        :room_type_id => @room_type.id,
                                                        :country_type => @indonesia.permalink,
                                                        :price => params[:price_for_indonesia])
          else
            price_for_indonesia.price = params[:price_for_indonesia]
          end
          price_for_indonesia.save
        end

        if developed_price.nil?
          developed_price = RoomTypesUserType.new(:user_type_id => user_type.id,
                                                  :room_type_id => @room_type.id,
                                                  :country_type => 'Developed',
                                                  :price => params["developed_#{user_type.permalink}"])

        else
          developed_price.price = params["developed_#{user_type.permalink}"]
        end
        if developing_price.nil?
            developing_price = RoomTypesUserType.new(:user_type_id => user_type.id,
                                                     :room_type_id => @room_type.id,
                                                     :country_type => 'Developing',
                                                     :price => params["developing_#{user_type.permalink}"])
        else
          developing_price.price = params["developing_#{user_type.permalink}"]
        end
        developed_price.save && developing_price.save
      end
    end
end
