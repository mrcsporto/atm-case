class ClientsController < ApplicationController
  before_action :authorize, only: %i[show edit update destroy]

  def new
    @client = Client.new
  end

  def index
    @clients = Client.all
  end

  def show
    @client = Client.find(session[:id]) if session[:id]
  end

  def create
    @client = Client.new(client_params)
    if @client.save
      session[:client_id] = @client.id
      redirect_to root_url, notice: "Thank you for signing up"
    else
      render "new"
    end
  end

  private
  def client_params
    params.require(:client).permit(:full_name, :cpf, :password, :password_confirmation, :role)
  end
end
