class ApplicationController < ActionController::Base
  auto_session_timeout 120.seconds

  private

  helper_method :current_user

  def current_user
    @current_user ||= Client.find(session[:client_id]) if session[:client_id]
  end

  def authorize
    redirect_to login_url, alert: 'Not authorized' if current_user.nil?
  end
end
