class Api::SeatManagementsController < Api::BaseController

  def get_occupied_seats_json
    puts params.inspect
    @user = current_user
    area_names = @user.area_names.map{|x| "#{x.permalink}"}
    area_name = AreaName.find_by_permalink(params[:selected_area])
    raise "Cannot find Area Name" if area_name.nil?
    @occupied_seats = area_name.occupied_seats.map{|x| [x.seat_row, x.seat_number, x.status]}
    resp = {return_code: 1, error_msg: "",
            list_area: area_names,
            selected_area: area_name.permalink,
            selected_seats: @occupied_seats}
  rescue Exception => e
    resp = {return_code: 0, error_msg: e.message}

  ensure
    render json: MultiJson.dump(resp)
  end

  def update_occupied_seat_json
    puts params.inspect
    area_name = AreaName.find_by_permalink(params[:selected_area])
    raise "Cannot find Area Name" if area_name.nil?
    params[:selected_seat] = JSON.parse(params[:selected_seat])
    seat_row = params[:selected_seat][0]
    seat_number = params[:selected_seat][1]
    status = params[:selected_seat][2]
    occupied_seat = OccupiedSeat.where("seat_row = '#{seat_row}' AND
                                        seat_number = '#{seat_number}' AND
                                        area_name_id = #{area_name.id} ").first
    if occupied_seat.nil?
      occupied_seat = OccupiedSeat.new(:seat_row => seat_row, :seat_number => seat_number,
                                       :area_name_id => area_name.id, :status => status)
    else
      occupied_seat.status = status
    end

    raise "Cannot Save Seat with location '#{location}' \n #{occupied_seat.errors}" unless occupied_seat.save

    resp = {return_code: 1, error_msg: ""}
  rescue Exception => e
    resp = {return_code: 0, error_msg: e.message}

  ensure
    render json: MultiJson.dump(resp)
  end
end
