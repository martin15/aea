class Users::PickUpScheduleController < Users::ApplicationController
  before_filter :find_pick_up_schedule

  def index
    @shuttle_buses = ShuttleBus.order("pick_up_date, pick_up_time")
  end

  def edit
    @shuttle_buses = ShuttleBus.group(:shuttle_bus_type).group_by{ |h| h.shuttle_bus_type }
    @arriving_date = ShuttleBus.find_by_shuttle_bus_type("arriving").pick_up_date
    @departing_date = ShuttleBus.find_by_shuttle_bus_type("departing").pick_up_date
    @user = current_user
  end

  def update
    if params[:need_shuttle_bus] == "true"
      @pick_up_schedule.user = current_user
      if @pick_up_schedule.update_attributes(pick_up_schedule_params)
        flash[:notice] = 'PickUpSchedule was successfully updated.'
        redirect_to users_edit_pick_up_schedule_path
      else
        @shuttle_buses = ShuttleBus.group(:shuttle_bus_type).group_by{ |h| h.shuttle_bus_type }
        @arriving_date = ShuttleBus.find_by_shuttle_bus_type("arriving").pick_up_date
        @departing_date = ShuttleBus.find_by_shuttle_bus_type("departing").pick_up_date
        @user = current_user
        flash[:error] = "PickUpSchedule failed to update"
        render :action => :edit
      end
    else
      @pick_up_schedule.delete
      @user = current_user
      flash[:notice] = 'PickUpSchedule was successfully updated.'
      redirect_to users_edit_pick_up_schedule_path
    end
  end

  private

    def pick_up_schedule_params
      params.require(:pick_up_schedule).permit(:arriving_date, :arriving_time, :arriving_flight_number,
                                               :arriving_airport, :departing_date, :departing_time,
                                               :departing_flight_number, :departing_airport, :user_id)
    end

    def find_pick_up_schedule
      puts current_user.inspect
      puts current_user.pick_up_schedule.inspect
      puts "----0000"
      @pick_up_schedule = current_user.pick_up_schedule || PickUpSchedule.new
    end
end
