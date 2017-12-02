class SeatManagementsController < ApplicationController
  before_action :authenticate_user!
#  before_filter :find_area_name

  def show
    puts "-------"
    puts current_user
    @user = current_user
    @area_names = @user.area_names
    find_area_name
    @seats = @area_name.occupied_seats.where("status = 1").map{|x| "#{x.seat_row}#{x.seat_number.to_i.to_s26}"}
  end

  def delete_all
    OccupiedSeat.delete_all
    flash[:notice] = "All seat successfully deleted"
    redirect_to seat_managements_path
  end

  private
  
    def find_area_name
      @area_name = @area_names.find_by_permalink(params[:id])
      if @area_name.nil?
        flash[:error] = "Cannot find the Area '#{params[:id]}'"
        redirect_to seat_managements_path
      end
    end

end
