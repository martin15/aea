class Admin::PickUpSchedulesController < Admin::ApplicationController
  before_filter :find_pick_up_schedule, :only => [:edit, :update, :destroy, :delete]

  def index
    @pick_up_schedules = PickUpSchedule.all.page(params[:page]).per(20)
    @no = paging(10)
  end

  def download_schedule_report
    @pick_up_schedules = PickUpSchedule.all
    respond_to do |format|
      format.xls
    end
  end

  def new
    @pick_up_schedule = PickUpSchedule.new
  end

  def create
    @pick_up_schedule = PickUpSchedule.new(pick_up_schedule_params)
    if @pick_up_schedule.save
      flash[:notice] = 'PickUpSchedule was successfully create.'
      redirect_to admin_pick_up_schedules_path
    else
      flash[:error] = "PickUpSchedule failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @pick_up_schedule.update_attributes(pick_up_schedule_params)
      flash[:notice] = 'PickUpSchedule was successfully updated.'
      redirect_to admin_pick_up_schedules_path
    else
      flash[:error] = "PickUpSchedule failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @pick_up_schedule.destroy ? 'PickUpSchedule was successfully deleted.' :
                                           'PickUpSchedule was falied to delete.'
    redirect_to admin_pick_up_schedules_path
  end

  private

    def pick_up_schedule_params
      params.require(:pick_up_schedule).permit(:name, :pick_up_date, :pick_up_time, :airport_name, :note)
    end

    def find_pick_up_schedule
      @pick_up_schedule = PickUpSchedule.find_by_id(params[:id])
      if @pick_up_schedule.nil?
        flash[:notice] = "Cannot find the PickUpSchedule with id '#{params[:id]}'"
        redirect_to admin_pick_up_schedules_path
     end
    end
end
