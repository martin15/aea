class Admin::ShuttleBusesController < Admin::ApplicationController
  before_filter :find_shuttle_bus, :only => [:edit, :update, :destroy, :delete, :show, :export_as_xls]

  def index
    @shuttle_buses = ShuttleBus.all.page(params[:page]).per(10)
    @no = paging(10)
  end

  def new
    @shuttle_bus = ShuttleBus.new
  end

  def create
    @shuttle_bus = ShuttleBus.new(shuttle_bus_params)
    if @shuttle_bus.save
      flash[:notice] = 'ShuttleBus was successfully create.'
      redirect_to admin_shuttle_buses_path
    else
      flash[:error] = "ShuttleBus failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @shuttle_bus.update_attributes(shuttle_bus_params)
      flash[:notice] = 'ShuttleBus was successfully updated.'
      redirect_to admin_shuttle_buses_path
    else
      flash[:error] = "ShuttleBus failed to update"
      render :action => :edit
    end
  end

  def show
    @users = @shuttle_bus.users
  end

  def destroy
    flash[:notice] =  @shuttle_bus.destroy ? 'ShuttleBus was successfully deleted.' :
                                           'ShuttleBus was falied to delete.'
    redirect_to admin_shuttle_buses_path
  end

  def export_as_xls
    @users = @shuttle_bus.users
    respond_to do |format|
      #format.xls { send_data @users, :filename => "#{@shuttle_bus.name}-#{Date.today.strftime('%d-%b-%Y')}"}
      format.xls
    end
  end

  private

    def shuttle_bus_params
      params.require(:shuttle_bus).permit(:name, :pick_up_date, :pick_up_time, :airport_name, :note,
                                          :shuttle_bus_type )
    end

    def find_shuttle_bus
      @shuttle_bus = ShuttleBus.find_by_id(params[:id])
      if @shuttle_bus.nil?
        flash[:notice] = "Cannot find the ShuttleBus with id '#{params[:id]}'"
        redirect_to admin_shuttle_buses_path
     end
    end
end
