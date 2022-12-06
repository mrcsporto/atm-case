class BankAccountsController < ApplicationController
  before_action :set_bank_account, only: %i[show edit update destroy]
  before_action :current_user, only: %i[index show create edit update destroy]
  before_action :create_new_account, only: %i[create]
  before_action :accounts_list, only: %i[index]
  before_action :authorize, expect: %i[show]

  def index
  end

  def show
    @bank_account = BankAccount.find(params[:id])
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
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
  def accounts_list
    @bank_accounts = BankAccount.all.order(created_at: :desc).page params[:page] if @current_user.role == 'admin'
    @bank_accounts = BankAccount.kept.order(created_at: :desc).page params[:page] if @current_user.role == 'client'
  end

  def create_new_account
    @bank_account = BankAccount.new(bank_account_params) if @current_user.role == 'admin'
    @bank_account = BankAccount.new(client_id: @current_user.id) if @current_user.role == 'client'
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
