class AccountTransactionsController < ApplicationController
  before_action :set_account_transaction, only: %i[show edit update destroy]

  def index
    @search = AccountTransactionSearch.new(params[:search])
    @account_transactions = @search.scope.order(created_at: :desc).page params[:page]
  end

  def new
    @account_transaction = AccountTransaction.new
  end

  def create
    result = CreateTransaction.call(params: account_transaction_params)
    if result.success?
      redirect_to result.account_transaction, notice: 'Transaction was successfully completed.'
    else
      @account_transaction = result.account_transaction
      redirect_to new_account_transaction_url, alert: "Not enouth funds"
    end
  end

  def show
    @account_transaction = AccountTransaction.find(params[:id])
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
