class SessionsController < ApplicationController
  auto_session_timeout_actions

  def active
    render_session_status
  end

  def timeout
    render_session_timeout
  end

  def new
  end

  def create
    client = Client.find_by_cpf(params[:cpf])
    if client && client.authenticate(params[:password])
      session[:client_id] = client.id
      redirect_to root_url, notice: "Logged in!"
    else
      flash.now.alert = "CPF or password is invalid"
      render "new"
    end
  end

  def destroy
    session[:client_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end

end
