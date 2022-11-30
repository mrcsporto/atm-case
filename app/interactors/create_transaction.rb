class CreateTransaction
  include Interactor

  def call
    account = context.params[:bank_account_id].to_i
    amount = context.params[:amount].to_f
    transaction_type = context.params[:transaction_type]
    balance = BankAccount.find(account).balance.to_f
    bank_account = BankAccount.find(account).id

    discardaaa
    context.account_transaction = AccountTransaction.create(context.params)

    BankAccount.update(bank_account, balance: balance - amount) if transaction_type.to_s == 'Withdraw'
    BankAccount.update(bank_account, balance: balance + amount) if transaction_type.to_s == 'Deposit'


  end
end
