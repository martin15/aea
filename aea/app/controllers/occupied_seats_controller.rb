class OccupiedSeatsController < ApplicationController
  before_filter :find_occupied_seat, :only => [:edit, :update, :update_from_api, :destroy, :delete]

  def index
    @occupied_seats = OccupiedSeat.all.page(params[:page]).per(10)
    @no = paging(10)
  end

  def new
    @occupied_seat = OccupiedSeat.new
  end

  def create
    @occupied_seat = OccupiedSeat.new(area_name_params)
    if @occupied_seat.save
      save_price
      flash[:notice] = 'OccupiedSeat was successfully create.'
      redirect_to occupied_seats_path
    else
      flash[:error] = "OccupiedSeat failed to create"
      render :action => :new
    end
  end

  def edit
  end

  def update
    if @occupied_seat.update_attributes(occupied_seat_params)
      flash[:notice] = 'OccupiedSeat was successfully updated.'
      redirect_to occupied_seats_path
    else
      flash[:error] = "OccupiedSeat failed to update"
      render :action => :edit
    end
  end

  def destroy
    flash[:notice] =  @occupied_seat.destroy ? 'OccupiedSeat was successfully deleted.' :
                                           'OccupiedSeat was falied to delete.'
    redirect_to occupied_seats_path
  end

  def get_all_occupied_seats_json
    puts params.inspect
    area_name = AreaName.find_by_permalink(params[:area_name])
    raise "Cannot find Area Name" if area_name.nil?
    @occupied_seats = area_name.occupied_seats
    resp = {return_code: 1, error_msg: "", occupied_seats: @occupied_seats}
  rescue Exception => e
    resp = {return_code: 0, error_msg: e.message}

  ensure
    render json: MultiJson.dump(resp)
  end

  #{:area_name => "front", :column_name => "I", :seat_coordinate => ['0-1-1', '0-2-1','0-3-0', '0-4-1']}
  def update_occupied_seats_api
    #params = {:area_name => "front", :column_name => "I", :seat_coordinate => ['0-1-0', '0-2-0','0-3-1', '0-4-0']}
    area_name = AreaName.find_by_permalink(params[:area_name])
    raise "Cannot find Area Name" if area_name.nil?
    raise "Seat Coordinate is blank" if params[:seat_coordinate].blank?
    ActiveRecord::Base.transaction do
      params[:seat_coordinate].each do |location|
        location = location.split("-")
        coordinate = "#{location[0]}-#{location[1]}"
        state = location[2]
        occupied_seat = OccupiedSeat.where("column_name = '#{params[:column_name]}' AND
                                            seat_coordinate = '#{coordinate}' AND
                                            area_name_id = #{area_name.id} ").first
        if occupied_seat.blank?
          occupied_seat = OccupiedSeat.new
          occupied_seat.column_name = params[:column_name]
          occupied_seat.seat_coordinate = coordinate
          occupied_seat.status = state
          occupied_seat.area_name_id = area_name.id
        else
          occupied_seat.status = state
        end

        raise "Cannot Save Seat with location '#{location}' \n #{occupied_seat.errors}" unless occupied_seat.save
      end
    end

    @occupied_seats = area_name.occupied_seats
    resp = {return_code: 1, error_msg: "", occupied_seats: @occupied_seats}
  rescue Exception => e
    @occupied_seats = area_name.occupied_seats
    resp = {return_code: 0, error_msg: e.message, occupied_seats: @occupied_seats}
  ensure
    render json: MultiJson.dump(resp)
  end

  def clear_all_seat_api
    area_name = AreaName.find_by_permalink(params[:area_name])
    raise "Cannot find Area Name" if area_name.nil?
    occupied_seats = OccupiedSeat.where("area_name_id = #{area_name.id}")
    notice = occupied_seats.delete_all ? "All Seat successfully clear" : "Failed clear all seat"
    resp = {return_code: 1, error_msg: notice}
  rescue Exception => e
    resp = {return_code: 0, error_msg: e.message}
  ensure
    render json: MultiJson.dump(resp)
  end

  private

    def occupied_seat_params
      params.require(:occupied_seat).permit(:area_name_id, :column_name, :seat_coordinate, :status)
    end

    def find_occupied_seat
      @occupied_seat = OccupiedSeat.find_by_id(params[:id])
      if @occupied_seat.nil?
        flash[:notice] = "Cannot find the RoomType with id '#{params[:id]}'"
        redirect_to occupied_seats_path
     end
    end

end
