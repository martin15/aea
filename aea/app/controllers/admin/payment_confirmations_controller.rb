class Admin::PaymentConfirmationsController < Admin::ApplicationController
  before_filter :find_payment_confirmation, :only => [:confirm, :save_confirmed]

  def index
    @payment_confirmations = PaymentConfirmation.all.page(params[:page]).per(20)
    @no = paging(10)
  end

  def confirm
  end

  def save_confirmed
    unless @user.country.name.downcase == 'indonesia'
      flash[:error] = "Your are not indonesian you must upload the ticket to confirm your account"
      redirect_to admin_payment_confirmations_path
      return
    end

    @user.status = "Approved"
    @user.registration_number = @user.get_registration_number
    @user.approved_at = DateTime.now.to_s(:db)
    if @user.save
      ApproveRegistrationMailer.approve_registration_for_user(@user, the_domain).deliver_now
      ApproveRegistrationMailer.approve_registration_for_admin(@user, the_domain).deliver_now
      flash[:notice] = 'User was successfully Confirmed.'
      redirect_to admin_payment_confirmations_path
    else
      flash[:error] = "User failed to Confirmed"
      render :action => :confirm
    end
  end

  private

    def payment_confirmation_params
      params.require(:payment_confirmation).permit(:name, :pick_up_date, :pick_up_time, :airport_name, :note)
    end

    def find_payment_confirmation
      @payment_confirmation = PaymentConfirmation.find_by_id(params[:id])
      if @payment_confirmation.nil?
        flash[:notice] = "Cannot find the PaymentConfirmation with id '#{params[:id]}'"
        redirect_to admin_payment_confirmations_path
        return
      end
      @user = @payment_confirmation.user
      if @user.nil?
        flash[:notice] = "Cannot find the User"
        redirect_to admin_payment_confirmations_path
      end
    end
end
