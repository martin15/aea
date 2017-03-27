class AreaNamesController < ApplicationController
  before_filter :find_area_name, :only => [:edit, :update, :update_from_api, :destroy, :delete]

  def index
    @area_names = AreaName.all.page(params[:page]).per(10)
    @no = paging(10)
  end

  def new
    @area_name = AreaName.new
  end

  def create
    @area_name = AreaName.new(area_name_params)
    if @area_name.save
      save_price
      flash[:notice] = 'AreaName was successfully create.'
      redirect_to area_names_path
    else
      flash[:error] = "AreaName failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @area_name.update_attributes(area_name_params)
      flash[:notice] = 'AreaName was successfully updated.'
      redirect_to area_names_path
    else
      flash[:error] = "AreaName failed to update"
      render :action => :edit
    end
  end

  def update_from_api
    if @area_name.update_attributes(:main_column => params["main_column"], 
                                    :total_row => params["total_row"], 
                                    :seats_per_row => params["seats_per_row"],
                                    :status => params[:status] )
      flash[:notice] = 'AreaName was successfully updated.'
      redirect_to area_names_path
    else
      flash[:error] = "AreaName failed to update"
      render :action => :edit
    end
  end

  def get_all_area_names_json
    @area_names = AreaName.all

    raise "Area Name is Empty" if @area_names.blank?

    resp = {return_code: 1, error_msg: "", area_names: @area_names}
  rescue Exception => e
    TitanException.log(e)
    resp = {return_code: 0, error_msg: e.message}

  ensure
    render json: MultiJson.dump(resp)
  end

  def destroy
    flash[:notice] =  @area_name.destroy ? 'AreaName was successfully deleted.' :
                                           'AreaName was falied to delete.'
    redirect_to area_names_path
  end

  private

    def area_name_params
      params.require(:area_name).permit(:name, :main_column, :total_row, :seats_per_row, 
                                        :status, :permalink)
    end

    def find_area_name
      @area_name = AreaName.find_by_id(params[:id])
      if @area_name.nil?
        flash[:notice] = "Cannot find the RoomType with id '#{params[:id]}'"
        redirect_to area_names_path
     end
    end
end
