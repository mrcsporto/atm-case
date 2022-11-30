class AccountTransactionsController < ApplicationController
  before_action :set_account_transaction, only: %i[show edit update destroy]

  def index
    @account_transactions = AccountTransaction.all
    @search = AccountTransactionSearch.new(params[:search])
    @account_transactions = @search.scope
    @account_transactions = AccountTransaction.order(created_at: :desc).page params[:page]
  end

  def new
    @account_transaction = AccountTransaction.new
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
  
  # Use callbacks to share common setup or constraints between actions.
  def set_account_transaction
    @account_transaction = AccountTransaction.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def account_transaction_params
    params.require(:account_transaction).permit(:transaction_type, :bank_account_id, :amount, :receiver_id)
  end
end
