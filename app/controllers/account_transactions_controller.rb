class AccountTransactionsController < ApplicationController
  before_action :set_account_transaction, only: %i[show edit update destroy]
  before_action :set_bank_account, only: %i[show edit update destroy]

  def index
    @bank_accounts = BankAccount.all
    @account_transactions = AccountTransaction.all
  end

  def new
    @account_transaction = AccountTransaction.new
  end

  def show
    @account_transaction = AccountTransaction.find(account_transaction_params[:id])
    @bank_account = BankAccount.find(account_transaction_params[:bank_account_id])
  end

  def create
    result = CreateTransaction.call(params: account_transaction_params)
    if result.success?
      redirect_to transactions_path, notice: 'Transaction was successfully completed.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_bank_account
    if params[:bank_account_id]
      BankAccount.find(params[:bank_account_id])
    else
      BankAccount.all
    end
  end
  
  # Use callbacks to share common setup or constraints between actions.
  def set_account_transaction
    @account_transaction = AccountTransaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_transaction_params
    params.require(:account_transaction).permit(:transaction_type, :bank_account_id, :amount, :receipt_id)
  end
end
