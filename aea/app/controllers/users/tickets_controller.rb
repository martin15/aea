class Users::TicketsController < Users::ApplicationController
  before_filter :check_authority

  def edit
    @user = current_user
    @ticket = Ticket.where("id = #{params[:id]} AND user_id = #{@user.id}").first
    @ticket = Ticket.new() if @ticket.nil?
  end

  def update
    @user = current_user
    @ticket = Ticket.where("id  = #{params[:id]} AND user_id = #{@user.id}").first
    @ticket = Ticket.new() if @ticket.nil?
    @ticket.user = @user
    if @ticket.update_attributes(ticket_params)
      # kirim email ke admin
      flash[:notice] = 'Ticket successfully upload.'
      redirect_to edit_users_ticket_path(@ticket.id)
    else
      flash[:error] = "Ticket failed to upload"
      render :action => :edit
    end
  end

  private

    def ticket_params
      params.require(:ticket).permit(:filename, :user_id )
    end

    def check_authority
      if current_user.payment_method_is_transfer_bank?
        flash[:error] = "You don't have authority to access this page"
        redirect_to users_path
      end
    end
end
