class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[show edit update destroy]
  before_action :set_client, only: %i[show edit update destroy]
  before_action :authorize, expect: %i[show]

  def index
    client = Client.find(session[:client_id]) if session[:client_id]
    @bank_accounts = BankAccount.all if client.role == 'admin'
    @bank_accounts = BankAccount.kept if client.role == 'client'
  end

  def show
    @bank_account = BankAccount.find(params[:id])
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    client = Client.find(session[:client_id]) if session[:client_id]
    @bank_account = BankAccount.new(bank_account_params) if client.role == 'admin'
    @bank_account = BankAccount.new(client_id: client.id) if client.role == 'client'
    if @bank_account.save
      redirect_to bank_account_url(@bank_account), notice: 'Bank account was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @bank_account.update(bank_account_edit_params)
      redirect_to bank_account_url(@bank_account), notice: 'Bank account was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @bank_account.discard
    redirect_to bank_accounts_url, notice: 'Bank account was successfully archived.'
  end

  private

  def set_client
    if params[:client_id]
      Client.find(params[:client_id])
    else
      Client.all
    end
  end

  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:client_id, :balance, :account_number)
  end

  def bank_account_edit_params
    params.permit(:client_id, :balance, :account_number)
  end
end
