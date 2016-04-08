class Users::PaymentConfirmationsController < Users::ApplicationController

  def new
    @payment_confirmation = PaymentConfirmation.new()
  end

  def create
    @user = current_user
    @payment_confirmation = PaymentConfirmation.new(payment_confirmation_params)
    @payment_confirmation.user = @user
    if @payment_confirmation.save
      PaymentConfirmationMailer.payment_confirmation_for_user(@user, the_domain).deliver_now
      flash[:notice] = 'Payment Confirmation successfully create.'
      redirect_to users_path
    else
      flash[:error] = "Payment Confirmation failed to create"
      render :action => :new
    end
  end

  private

    def payment_confirmation_params
      params.require(:payment_confirmation).permit(:payment_method, :sender_name, :amount,
                                                   :payment_date, :user_id )
    end
end
