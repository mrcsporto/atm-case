class ClientsController < ApplicationController
  before_action :authorize, only: [:show, :edit, :update, :destroy]

  def new
    @client = Client.new
  end

  def home
    @clients = Client.all
  end

  
  def create
    @client = Client.new(clients_params)
    if @client.save
      session[:client_id] = @client.id
      redirect_to root_url, notice: "Thank you for signing up"
    else
      render "new"
    end
  end

  private
  def clients_params
    params.require(:client).permit(:full_name, :cpf, :password, :password_confirmation, :role)
  end
end
