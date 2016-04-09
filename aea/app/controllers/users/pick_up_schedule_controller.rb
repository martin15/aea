class Users::PickUpScheduleController < Users::ApplicationController
  before_filter :find_pick_up_schedule

  def index
    @shuttle_buses = ShuttleBus.order("pick_up_date, pick_up_time")
  end

  def edit
  end

  def update
    if @pick_up_schedule.update_attributes(pick_up_schedule_params)
      flash[:notice] = 'UserType was successfully updated.'
      redirect_to users_pick_up_schedule_path
    else
      flash[:error] = "UserType failed to update"
      render :action => :edit
    end
  end

  private

    def pick_up_schedule_params
      params.require(:pick_up_schedule).permit(:arriving_date, :arriving_time, :arriving_flight_number,
                                               :arriving_airport, :departing_date, :departing_time,
                                               :departing_flight_number, :departing_airport)
    end

    def find_pick_up_schedule
      puts current_user.inspect
      puts current_user.pick_up_schedule.inspect
      puts "----0000"
      @pick_up_schedule = current_user.pick_up_schedule || PickUpSchedule.new
    end
end
