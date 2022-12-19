class ApplicationController < ActionController::Base
  # auto_session_timeout 120.seconds

  private

  helper_method :current_user
  helper_method :transfer_accounts
  helper_method :current_user_accounts

  def current_user
    @current_user ||= Client.find(session[:client_id]) if session[:client_id]
  end

  def authorize
    redirect_to login_url, alert: 'Not authorized' if current_user.nil?
  end

  def current_user_accounts
    @current_user.bank_accounts.where(discarded_at: nil).pluck(:account_number, :id).sort
  end

  def transfer_accounts
    all_bank_accounts = BankAccount.where(discarded_at: nil).pluck(:account_number, :id).sort
    current_user_accounts = @current_user.bank_accounts.pluck(:account_number, :id)
    receiver_account = all_bank_accounts - current_user_accounts
  end
end
