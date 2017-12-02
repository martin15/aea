class OccupiedSeatsController < ApplicationController
  before_filter :find_occupied_seat, :only => [:edit, :update, :update_from_api, :destroy, :delete]

  def index
    @area_names = AreaName.all
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

  def update_seat
    puts "===="
    puts params.inspect
    puts "====----"
    @area_name = AreaName.find_by_permalink(params[:id])
    puts @area_name.inspect
    if @area_name.nil?
    redirect_to seat_management_path(current_user.area_names.first.permalink)
      redirect_to seat_management_path(params[:id])
    end

    @seat = OccupiedSeat.where("seat_row = #{params[:seat_row]} AND seat_number = #{params[:seat_number]} AND
                                area_name_id = #{@area_name.id}").first
    if params[:type].downcase == "create"
      puts "-------create"
      if @seat.nil?
        @seat = OccupiedSeat.create(:seat_row => params[:seat_row], :seat_number => params[:seat_number],
                                    :area_name_id => @area_name.id, :status => "1")
      else
        @seat.update_attribute(:status, "1")
      end
    elsif params[:type].downcase == "delete"
      unless @seat.nil?
        @seat.update_attribute(:status, "0")
      end
    end
puts "last"
puts @seat.inspect
    respond_to do |format|
      format.js
      format.html
    end
  end

  def book_seats
    puts "===="
    puts params.inspect
    puts "====----"
    @area_name = AreaName.find_by_permalink(params[:id])
    if @area_name.nil?
    redirect_to seat_management_path(current_user.area_names.first.permalink)
      redirect_to seat_management_path(params[:id])
    end

    respond_to do |format|
      format.html
      format.js
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

#  :seat_coordinate => [
#    {:id => 1, :status => 1, :name => "a1"},
#    {:id => 2, :status => 1, :name => "a1"},
#    {:id => 1, :status => 1, :name => "a1"},
#    {:id => 1, :status => 1, :name => "a1"},
#    {:id => 1, :status => 1, :name => "a1"},
#    }]
#
#  :seat_coordinate => "b1 b2 b3 a5 a6"


  #{:area_name => "front", :column_name => "I", :seat_coordinate => ['0-0-1', '0-2-1','0-3-0', '0-4-1']}
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

  def send_image
    resp = {user_email: 'martin.me15@yahoo.com', user_token: 'oGsLmVBCQ3XfpzzczgBL', doc_ids: [11,12,13,14]}
    folder_hash = {}
    base64_images = []
    address = "/Users/martin/Downloads/aaa.jpeg"
    base64_images << "data:image/png;base64,#{Base64.encode64(File.open(address, "rb").read)}"
    base64_images << "data:image/png;base64,#{Base64.encode64(File.open(address, "rb").read)}"
    base64_images = ''#"data:image/png;base64,#{Base64.encode64(File.open(address, "rb").read)}"
    folder_hash = folder_hash.merge(id: 1)
    folder_hash = folder_hash.merge("file_name" => base64_images)
    resp = resp.merge(folder_hash)
    response = HTTParty.delete("http://localhost:4001/api/users/sign_out", {body: resp})
    data = JSON.parse(response.body)
    zip_data = File.read(data["url"])
    send_data(zip_data, :type => 'application/zip', :filename => "archive_#{Time.now.to_s(:db)}.zip")
    #render :nothing => true, :status => 200, :content_type => 'text/html'
  rescue Exception => e
    resp = {return_code: 0, error_msg: e.message}
    render :nothing => true, :status => 200, :content_type => 'text/html'
#  ensure
#    render json: MultiJson.dump(resp)
  end

  def login_with_api
    params = {user_login: {email: 'martin.me15@yahoo.com', password: '111111', user_token: '_bKyAgs_twyxU7JSKh7k'},user_email: 'martin.me15@yahoo.com', user_token: '_bKyAgs_twyxU7JSKh7k'}
    response = HTTParty.delete("http://localhost:4001/api/users/sign_out", {body: params})
    puts "----------11"
    puts response.body.inspect
    puts "----------22"
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  def verify_with_api
    params = {user_email: 'martin.me15@yahoo.com', user_token: 'XyLwLm9cQWPwWkmB9y6p'}
    response = HTTParty.get("http://localhost:4001/api/api_folders", {body: params})
    puts "----------11"
    puts response.body.inspect
    puts "----------22"
    @result = JSON.parse(response.body)["folders"]
    #render :nothing => true, :status => 200, :content_type => 'text/html'
  end

  private

    def occupied_seat_params
      params.require(:occupied_seat).permit(:area_name_id, :seat_number, :seat_row, :status, :updated_by)
    end

    def find_occupied_seat
      @occupied_seat = OccupiedSeat.find_by_id(params[:id])
      if @occupied_seat.nil?
        flash[:notice] = "Cannot find the RoomType with id '#{params[:id]}'"
        redirect_to occupied_seats_path
     end
    end

end
