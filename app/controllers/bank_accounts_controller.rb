class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[ show edit update destroy ]
  before_action :set_client, only: %i[ show edit update destroy ]
  before_action :authorize, expect: %i[show]

  # GET /bank_accounts or /bank_accounts.json
  def index
    client = Client.find(session[:client_id]) if session[:client_id]
      if client.role == 'admin'
        @bank_accounts = BankAccount.all
      else
        @bank_accounts = BankAccount.kept
      end
  end

  # GET /bank_accounts/1 or /bank_accounts/1.json
  def show
    @bank_account = BankAccount.find(params[:id])
  end

  # GET /bank_accounts/new
  def new
    @bank_account = BankAccount.new
  end

  # GET /bank_accounts/1/edit
  def edit
  end

  # POST /bank_accounts or /bank_accounts.json
  def create
    client = Client.find(session[:client_id]) if session[:client_id]
    if client.role == 'admin'
      @bank_account = BankAccount.new(bank_account_params)
    else
      @bank_account = BankAccount.new(client_id: client.id)
    end
      if @bank_account.save
        redirect_to bank_account_url(@bank_account), notice: 'Bank account was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
  end

  # PATCH/PUT /bank_accounts/1 or /bank_accounts/1.json
  def update
      if @bank_account.update(bank_account_edit_params)
       redirect_to bank_account_url(@bank_account), notice: 'Bank account was successfully updated.'
      else
        render :edit, status: :unprocessable_entity
      end
  end

  # DELETE /bank_accounts/1 or /bank_accounts/1.json
  def destroy
    @bank_account.discard
      redirect_to bank_accounts_url, notice: 'Bank account was successfully archived.'
  end

  private

  def set_client
    if params[:client_id]
      @client = Client.find(params[:client_id])
    else
      @client = Client.all
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_bank_account
    @bank_account = BankAccount.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def bank_account_params
    params.require(:bank_account).permit(:client_id, :balance, :account_number)
  end

  def bank_account_edit_params
    params.permit(:client_id, :balance, :account_number)
  end
end
