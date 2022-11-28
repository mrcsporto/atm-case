class ApplicationController < ActionController::Base
  private 
    helper_method :current_client

    def current_client
      @current_client ||= Client.find(session[:client_id]) if session[:client_id]
    end

    def authorize
      redirect_to login_url, alert: "Not authorized" if current_client.nil?
    end
end
